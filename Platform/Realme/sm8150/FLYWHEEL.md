# 免按键测试飞轮：Linux → fastboot → 刷机 → 再启动

> 2026-10-08 建立（F1 核心已在真机验证）。用途：把「改代码 → 上机验证」从
> 5–10 分钟的人肉操作（断电 15 s + Vol-Down + Power + 手刷），压到 **1–4 分钟、
> 无人值守**的一轮。
> 关联：`HANDOVER-NEXT.md` §1/§7、`RX-CONSOLE.md`（RX 协议细节）、
> `linux-port/docs/28-flywheel.md`（原始设计：PON reboot-mode + EUD RX + fastboot flash）。

## 0. 一句话

2026-10-09 session 38 只刷 logdump 做 UEFI 对照并恢复 rx33-console：Linux 运行之前 ABC/DEFG
仍读为 AAA/DDDD；合法满包/ZLP 也未改善。原生多字节 RX 仍未修复。
F1 两次确认 fastboot，基线 Linux/COM14 Ctrl-U 回执正常、端口已关闭；9505 detach 回 Windows。
实际 HS PHY 是 SNPS femto-v2，接管仍涉及 reset；来源与下一步见 `sessions/38-rx-pre-linux-and-usb-boundaries.md`。

手机能从 Linux **自己**重启进 fastboot。主机通过 EUD COM 发一帧 `[0x90][0x02]`，
驱动打印 `eud: reboot2 bootloader requested`，先写 `CSR_EUD_EN(0x1014)=0` 把 USB PHY
交还常规通道，再 `kernel_restart("bootloader")`；PMIC PON 的 magic 由 reboot-mode
notifier 写入，ABL 读到后进 fastboot。

实测（2026-10-08）：

    主机 TX [90][02]
    phone  [  70.662708] eud: rx id=90 len=02 s1=07070707
    phone  [  70.702349] eud: reboot2 bootloader requested
    主机   COM 口立刻断开（"The port is closed"）
    PC     fastboot devices -> 62bc28a1 fastboot      ← 无任何按键

## 1. 命令通道：用「长度」字段当命令码

`id` 恒为 `0x90`（= 上游 `kernel/msm` 的 `UART_ID`）。**单字符 payload 已验证，多字节仍未解**
（§6），但 `0x0c`/`0x10` 两个闩锁（id / len）是**精确可靠**的，所以把命令编进
长度字段，完全不依赖 payload：

| 主机发 | 含义 | 状态 |
|---|---|---|
| `[90][01][字符]` | tty 输入一个字符 | 已有真实字符回显；受理后停止重发，见 session 32 |
| `[90][02]` | `reboot bootloader` → fastboot | **真机已验证** |
| `[90][3..14][payload]` | payload 探针：每 poll 读 1 字节，按 len 有界采样，全部结束后打印 | 已跑；多字节推进仍未解，不向 tty 注入 |

设计约束：**收到头部即可判定命令**。驱动曾经等 payload 收齐才分发，结果
`len=02` 的帧在第 1 个字节后门控清零就被放弃，命令永远到不了——所以命令分支
必须在读到头部时立即执行（`EUD_F1_EARLY`）。

## 2. 一轮的完整流程

| # | 谁 | 动作 | 耗时 |
|---|---|---|---|
| 1 | PC/WSL | 改内核，`make -j12 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image` | 增量 ~45 s |
| 2 | PC | 把 Image 打进 logdump 模板（原地） | ~1 s |
| 3 | PC | `fastboot flash logdump logdump-<tag>.img` | 1.9 s |
| 4 | PC | `fastboot reboot`（手机自动进 EDK2 → Linux） | — |
| 5 | phone | 固件 → Linux，EUD 控制台起来 | ~40 s |
| 6 | PC | 等 9501 → `eudtool com-up` → 找 COM → 开端口抓包 | ~10 s |
| 7 | PC | 发实验帧（每条重发 3–5 次，见 §5 投递率） | ~10 s |
| 8 | PC | 发 `[90][02]` → 手机自己回 fastboot | ~10 s |
| 9 | — | 回到第 3 步 | — |

只改主机脚本的实验：跳过 1–4，**一轮 < 1 分钟**。

## 3. 构建与打包

内核（WSL）：

    cd /home/cy122/x2pro-linux/linux
    make -j12 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image        # ~45 s 增量
    make -j12 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- qcom/sm8150-samurai.dtb

`make Image` **不会**重建 DTB，改了 DTS 必须单独跑上面第二条。

logdump 打包（Windows，`E:\edk2-samurai-out\patch-logdump.py`）：

    Image 在 FAT 里的固定位置：offset 90112，长度恒为 30116352 B（原地替换）
    FAT 里的 \samurai.dtb：     offset 30208000，长度 94739 B（原地替换，尺寸没变）
    模板：logdump-intrx2.img；产出 64 MiB 的 logdump-<tag>.img

DTB 的两条路径都要照顾（否则猜不准哪条生效）：

1. **固件**：`Platform/Realme/sm8150/FdtBlob/samurai/sm8150-realme-samurai.dtb`
   ← 权威路径，EFI stub 从固件配置表取 DTB。改完要重编固件（`./build.sh -d samurai
   --toolchain GCC5`，产物 `boot-samurai.img`）并 `fastboot flash boot`。
2. **FAT 副本**：logdump 里的 `\samurai.dtb`（见上表），一并换掉。

> PON reboot-mode 的两个属性来自 DTS：
> `&pon { mode-bootloader = <0x02>; mode-recovery = <0x01>; };`
> 配置项 `POWER_RESET_QCOM_PON=y`、`REBOOT_MODE=y` 已开。
> **不需要 reboot2 小工具**：驱动是内建的，直接 `kernel_restart("bootloader")`，
> notifier 会写 magic（文档 28.1 设想的 userspace helper 用不上）。

## 4. 主机侧脚本

| 脚本 | 用途 |
|---|---|
| `eud-f1-flash.ps1` | 刷 boot（新固件）+ logdump，然后 reboot |
| `eud-f1-cmd.ps1` | 等 CTL → com-up → 找 COM → 开端口 → 发 `[90][02]` → 等 fastboot |
| `eud-A.ps1` / `eud-B.ps1` / `eud-C.ps1` | 抓包 + 按节奏发帧的实验脚本（历史） |
| `parse-eud.ps1` | 把 `eud-*.log` 里的 `[id][len][payload]` 帧**重组成可读文本**（原始日志每 4 字节就被 `..` 打断，直接 grep 没用） |
| `linux-port/scripts/eud-step.ps1` | session 32 的单步发送/抓包；finally 关端口，tty 字符可用 -Ack 在受理后停重发并继续排空 2 s |
| `linux-port/scripts/decode-eud-capture.py` | 重组上述 .raw 抓包并保存 .txt；报告 frames / stray bytes |
| `linux-port/scripts/eud-terminal.cmd` / `.ps1` | 临时交互终端，ASCII 输入逐字受理重试、TX 多字节帧重组；Ctrl-] 关闭端口后再发 F1。用法见 linux-port/docs/EUD-TERMINAL.md |

`eudtool.exe` 命令：`list|dump|probe|ctlin|ctlout|attach|detach|com-up|com-off|swd-up|swd-gpio|swd-off|jtag-up|jtag-off|dbg-up|dbg-off|raw HEX...|rst|set|clr`

## 5. 硬约束与坑（每条都真实卡过一次）

1. **主机 COM 口会被卡死**。中断的抓包脚本会让 Windows 的 qcser 驱动把端口钉在
   "resource in use"，此后 `com-off`/`com-up`、`detach`、`rst(CTL 0x09 PERIPH_RST)`、
   杀进程、子进程打开、**手机重启**…… 全部无效。
   只有 **换 USB 口（换设备节点）** 或 **重启主机** 能解。
   → 飞轮脚本必须：`try/finally { Close(); Dispose() }`、一次只让一个进程开端口、
   每轮实验用新进程，绝不在常驻会话里裸开端口。
2. **投递率只有约 1/3**。主机每次 `Write()` 不一定被设备暂存（实测 15 帧只有 7 帧
   在闩锁里出现；另一轮 3 帧中 1 帧）。→ **每条命令必须重发 3–5 次**，间隔 ≥2 s。
3. **抓包必须先起**。设备 TX FIFO 只有几格，没人排空就会丢日志；而且"EUD 哑了"
   常常是主机侧没读。
4. **普通 warm reboot 可能保留 EUD 状态**：EUD 开着时 USB 被占（fastboot/UMS
   都看不到）。飞轮 handler 已先关闭 EUD 再 reboot；完整断电是其失效后的兜底。
5. `-OnlyLogdump` 这类 **switch 参数不能用 `[bool]` 强转**（PS 5.1 下恒为 `true`，
   会导致"静默跳过刷 boot"）——用 `.IsPresent`。
6. 抓包脚本里 `fastboot devices` 在**常驻会话**里可能挂死；放进 `Start-Job` 就正常。
7. 只刷 boot / logdump；U 盘模式下绝不让 PC 初始化/格式化 UFS 分区。
8. 长命令容易被工具链截断/挂起：写 .py/.ps1 文件再执行，比内联长命令可靠。

## 6. 待解：`0x14` 到底给的是什么

**2026-10-09 session 39 更新：** 只刷诊断 logdump 的 UEFI 紧轮询对照仍为 AAA/DDDD，
详见 `sessions/39-rx-tight-arrival-poll.md`。Windows 无回执后 libusb 加 PORT_RESET 恢复，
F1 有新回执且另确认 62bc28a1 fastboot，随后只刷回 rx33-console；Linux/tty/shell 被动
启动抓包与 Windows Ctrl-U 首次受理均正常，COM14 已关闭，6-5 Shared、未 Attached。
EIO 断开本身不是 F1 成功证明；没有回执的 Windows OUT 不算受理。原生多字节仍未修复。

**2026-10-09 session 36 更新：** 未刷机，仍用 rx33-console；F1 本轮未重新触发。
实机 OUT 为 0x02 / max packet 16；旧 WDM qcusbser 与 SM8150 握手源码的新审查见
`sessions/36-rx-usb-descriptors-and-legacy-qcusbser.md`。libusb/WSL 完整 ABC、DEFG
均成功提交并被受理，仍只读到首字节随后 90，qcusbser 不是必要触发条件。
新单步工具已设备验证，正常释放资源；detach 后一次 COM 重连恢复 Windows 回执，
手机仍为 Linux。不要把没有受理回执的轮次当有效 payload 失败。

**2026-10-09 session 33 更新：** 当前镜像为 `logdump-rx33-console.img`，单字符与
F1 均再次验证。整帧禁止 TX、MMIO 属性/屏障、数据先于头部等实验仍未解决多字节；
门控并非每次首次读后立即清零，量产权限假设也尚无 COM 专属证据。完整记录见
`sessions/33-rx-access-and-production-policy.md`。当前 RX 状态、头部和首次 DAT
读取共用 TX 锁。只改内核时只刷 logdump。

**2026-10-08 session 32 更新：** 以下为 F1 阶段的旧观测。原探针实际是
`90 90`；去掉读取前的 printk 后首字节能读到真正 payload（ABC → 41，DEFG →
44），不支持跳过 2 字节。单字符输入已修正，多字节仍不前进：连续读为重复首
字节，200 μs / readb 未改善，20 ms 缓存后打印为 `41 90 90`。当前版本把
长度 3..14 留作诊断，具体证据、跨机型参考与产物见
`sessions/32-rx-printk-interference.md`；不要再把下面「尚未跑」当当前状态。

事实（2026-10-08 实测）：

* 收到头部时 `INT_STATUS_1(0x44)` = `0x07`（BIT(0)=`EUD_INT_RX` 置位）；
  读一次 `0x14` 之后变 `0x06`（置位被清）。
* 读回的第 1 个字节**永远是 `0x90`（id 本身）**，而不是 payload：
  `len=01` 时 `byte[1/1]=90`，`len=03` 时 `byte[1/3]=90`。
* 读到的字节确实被送去 tty：设备回显了一帧 `90 01 3F`（`?`）。

参考实现（上游）**全是"消息级门控 + 帧内 burst 读"**，没有谁做逐字节门控：

* `kernel/msm` tty 驱动：RX 中断（`EUD_INT_RX`）→ 读 `RX_ID` → 读 `RX_LEN` →
  burst 读 `len` 次 `0x14`，中间不再查状态位；`MAX_FIFO_SIZE 14`。
* QUIC 官方主机库规范（`E:\eud-host\quic-eud\src\com_api.cpp`）：
  *"poll device for data. if you get data, byte 0 is Exec Env ID. byte 1 is how many
  bytes data. remaining bytes are data."* —— 门控只到"有没有数据"这一层。

**逐字节门控是本项目为绕开"burst 读会卡死 COM 块"而发明的偏离。**

主假设（未证）：这台机器的 `0x14` 装的是**整帧原始字节** `[id][len][payload…]`，
所以第 1 个字节 = `0x90`、第 2 个 = len、第 3 个才是 payload；门控位在第一次读后
被清，所以上游"读 len 次"在这台机器上只能读到头部。
→ 探针 `[90][len≥3]`（读 `len-1` 字节、逐个打印、门控清零也不放弃）就是为判定它
而写的，**尚未跑**（被 §5.1 的端口卡死挡住）。

已知的另一条线索：COM 口是**命令帧与数据帧共用**的（`com_eud.h`）：
`0`=NOP、`1`=TX_TMOUT、`2`=RX_TMOUT、`3`=PORT_RESET，形态是
`{opcode,0xFF,0xFF,0x00,0x00}`（见 `E:\eud-host\comtool.cpp`）；
数据帧首字节才是 `0x90`。设备侧按首字节分派（<4 当命令、`0x90` 当数据）。

## 7. F2 守护进程（未做）

把 §2 的 3→9 步串成无人值守循环：等 CTL → com-up → 开端口（新进程）→ 抓包 →
发帧（重发 N 次）→ 发 `[90][02]` → 等 fastboot → 刷下一个镜像 → 循环；
一轮一个日志文件。必须满足 §5.1 的端口约束，并给每一步加超时与重试。
