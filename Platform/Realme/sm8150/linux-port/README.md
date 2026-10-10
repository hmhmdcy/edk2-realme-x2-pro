# Linux 移植工作区（Realme X2 Pro / RMX1931 / samurai）

当前内核入口：[session67](../sessions/67-usb-provider-and-dtb-activation.md)。
`kernel67-builtins.config` 只有 SM8150 HS PHY 的 m->y：#60 已绑定 PHY/dwc3、有 UDC，
当前 deferred 为空，实际 USB 通信尚待验证；完整 53788 字节 dmesg 哈希/CRC 通过，
taint=0。CPU7 OPP 候选在本 DTS 和 `patches/0006-sm8150-ac-cpu7-opp-candidate.patch`，
编译/FAT 抽取已核对，但 live DT 没有新节点：EFI stub 当前取固件 DTB，不能称修复。
Windows DTS 的 EUD/PON/bootargs 已从原实际树同步，不是本轮新增硬件改动。
COM14 已释放给 Windows；不运行旧 build-image.sh，真实 initramfs 与 EUD 修复保留。

前次已验证内核修复：[session66](../sessions/66-verified-kernel-logs-and-builtins.md)。
校验完整日志后依次内建 OSM L3、ADC5/VADC_COMMON，修正 earlycon CSR 的临时映射。
真机 #59 已有 CPU policy0/4/7 和三路 PMIC 温度，taint=0，完整 dmesg 的设备哈希/CRC
通过；CPU7 2956800 kHz OPP 与 USB deferred 仍待查。配置增量是
`kernel66-builtins.config`，映射补丁 `patches/0005-eud-early-csr-mapping.patch` 针对实际
earlycon 基线 SHA `f0de320d4028d180099d0251b115371ca68bc84b51757910e6b0cdf94a9ddd53`，
不直接 git am 到旧 0001。实测前后源码与构建脚本见 `../reference/kernel66`；不要
运行旧 build-image.sh 或用落后的 Windows initramfs 覆盖实际 WSL initramfs。
rootfs 保留 Android/全部数据的结论见 [ROOTFS-PRESERVE-ANDROID](docs/ROOTFS-PRESERVE-ANDROID.md)。

> 2026-10-09 session 41：`eud.c` 接入实际 SM8150 SOUTH AHB2PHY TOP_CFG=0x11
> 并验证回读，在 TX 锁内一次读取整帧，读完才记录回执/投递 tty。UEFI 跨重启和 Linux
> 的 ABC/DEFG 均正确；原生多字节 shell 赋值已执行。len=2 保留 F1，len=1、3..14 为 tty。
> 源码、实测、镜像与输出限制见 [session 41](../sessions/41-rx-ahb2phy-wait-state-fix.md)。
> patches/0004 是针对已验证 rx33 eud.c 的增量；此前 patches/0003 不是当前完整驱动。
> 0004 为零上下文补丁，先核对 session 41 的基线源码 SHA256，再用 `git apply --unidiff-zero`
> 或 `patch -p1`；本轮已对原源码做 dry-run。

终端 `scripts/eud-terminal.cmd`（副本 E:\eud-host\）默认按单字节回执发送，
兼容当前驱动；`-Native` 启动先 Ctrl-U 同步，持续打开串口，发送最多 14 字节原生帧，
两字节尾片拆成 1+1，命令帧不重试。交互与重启验证见
[session 47](../sessions/47-native-terminal-session-boundary.md)。原生帧也可用 `scripts/eud-step.ps1` 单步测试，finally 关闭串口；
`-RetryJitterMs 800` 仅改变有界重试时间，不保证所有 OUT 都受理。
不要使用旧 build-image.sh 重建 initramfs；本轮保留真实 WSL initramfs 和原 DTB。

历史交接见 [session 49](../sessions/49-usb-in-and-partial-timeout-audit.md)。当轮不改内核、
未刷机或重启手机；持续 libusb 的 CRC 发送记录与全部 IN/raw 对应，部分取消数据
实测保留，但未重现旧缺字或触发宽限。Windows 原生终端已恢复、COM14 关闭。
诊断变更见 [session 48](../sessions/48-irq-grace-and-tx-journal.md)。本 eud.c 为 RX48 B
诊断：保留 SPI 492/hwirq 524、RX-only 掩码、整帧 IRQ 缓存、工作上下文 tty/F1 和
TOP_CFG=0x11；watchdog 首次 pending 留给 IRQ 服务，100 ms 持续未受理才退回轮询。
只读 irq_watch/irq_state 与带 CRC 的 binary tx_journal 提供新证据边界。实测 512 个
已发 TX 记录全部匹配 raw，30 行输出/兼容/F1/重启正常，但 waits=0，宽限分支未验证。
兼容 startup 仍需一次重试，RX47 的真实缺字/退回及更早缺回执不作撤回。
稳定性仍未解决；立即回退为 RX46 B，更早回退为 RX44。仅刷 logdump，init/DTB 不变。
`scripts/eud-etw-step.ps1` 用内置 USB ETW 对照主机 OUT/完成，需管理员权限；
语法核对和实际抓包结果见 session 46；RX47-49 没有新管理员 ETW 抓包。
端点 reset 的目标事件另存 reference/rx47，物理 DATA0/1 未测。所有设备 ETL 保留本地，不直接入库。
RX45 已排除仅掩码方案；不要原样重复。

计数边界见 [session 44](../sessions/44-rx-receipt-counters.md)。当时 eud.c 在 RX41
硬件方法上增加只读 sysfs 接收计数，Ctrl-U 回执也含计数；没有改动 FIFO 顺序、20 ms
轮询或正常原生帧回执。诊断镜像仅更新 logdump；失败输入没有增加 pending/坏帧头/tty
计数，成功 echo 的帧/字节准确。根因仍未定位，不能把诊断称为稳定性修复。

上一轮审查看 [session 43](../sessions/43-native-terminal-evidence-audit.md)。
payload 推进的修复使用真实整帧，不依赖临时终端逐字发送。RX41 数次“缺输出”经
原始抓取核对撤回；Windows/libusb 的新原生命令也返回了完整输出。偶发缺回执仍未解，
已核对其在 RX 日志之前的边界，下一步需要 USB/EUD/STATUS1 的新受理证据。

全新开始，不使用 `E:\Realme X2 Pro移植主线Linux`（旧工程已废弃；它的准确性核实
结论见 [docs/OLD-PROJECT-VERIFICATION.md](docs/OLD-PROJECT-VERIFICATION.md)，
里面有 3 处**必须丢弃**的错误写法）。

## 位置

- WSL 源码树：`/home/cy122/x2pro-linux/linux`（git 基线 + 改动，无 remote）
- WSL 补丁：`/home/cy122/x2pro-linux/patches/`
- 本目录：设备树源码、补丁、脚本与可复核产物（`dts/ patches/ artifacts/ scripts/ docs/`）

## 源码来源（可独立校验）

- Linux v7.3-rc6, commit `a90ee4305c4a5df72c11b31dacfdc76e00fcf78a`
- sha256 `0ee910353dee732a3f1517750dc58cbd6ba8026d6e4e1c5ae7e2a4a2d2829766`
- 基线提交：`baseline: Linux v7.3-rc6 pristine`

## 已完成

### 1. EUD earlycon —— 提交 `e4858b30a`

`drivers/tty/serial/eud_earlycon.c`（100 行），Kconfig / Makefile 已注册。
编译通过；`checkpatch --strict`：0 errors / 0 warnings / 0 checks。
补丁：`patches/0001-tty-serial-add-Qualcomm-EUD-COM-early-console.patch`。

内核命令行：

    earlycon=eud,mmio,0x88e0000

PC 侧：`eudtool.exe com-up` 让 9505 COM 枚举，再用 `comlog.exe` 之类帧重组工具读取。

**为什么必须自己写**

- 主线 `drivers/usb/misc/qcom_eud.c` 只是 USB 角色切换驱动，不提供 console。
- 厂商 4.14 的 `drivers/soc/qcom/eud.c` 注册 `ttyEUD` 可当 console，但要驱动模型
  probe，只能在内核后期出日志，正好错过黑屏最常见的早期阶段。
- earlycon 在 `parse_early_param` 阶段工作，早于驱动模型，所以必须自写。

**设计要点**

- EUD COM 是寄存器 FIFO（TX_ID / TX_LEN / TX_DAT），非 8250 兼容，故组
  `[0x90][LEN][DATA]` 帧。
- 帧长 6 字节，逐帧轮询 `INT_STATUS_1` bit1（原厂 `eud_tx_empty` 用的同一位）流控；
  轮询有上限。
- 定时器未校准，不能用 `udelay`，只能有界轮询。
- setup 写 `CSR_EUD_EN`（幂等）：EDK2 路径固件已开，Android 引导链完全不开。
- 故意不写 `INT1_EN_MASK`，避免在中断控制器就位前武装中断源。

### 2. samurai 主线设备树 —— 提交 `31491583b`

源码：`dts/sm8150-samurai.dts`（进树路径
`arch/arm64/boot/dts/qcom/sm8150-samurai.dts`），补丁
`patches/0002-arm64-dts-qcom-add-realme-samurai-X2-Pro-bring-up-description.patch`。

- 以 `sm8150-mtp.dts` 为底板：本机原厂基础 DTB 自称
  `Qualcomm Technologies, Inc. SM8150 v2 SoC` + MTP board-id，本身就是 MTP 派生，
  PM8150 稳压器拓扑可以直接用。
- 按实机重写 reserved-memory：21 个保留区，逐项对齐运行中 `/proc/device-tree`
  与原厂 DTBO，核对表见 `artifacts/reserved-memory.txt`。
- 音量键按实机：`&pm8150_gpios` 6/7、active-low、`bias-disable`、`power-source = <1>`、
  115/114、15 ms；禁用 MTP 的 `&pon_resin`。
- UFS 保持 MTP 的 `vccq2 = &vreg_s4a_1p8`（实机 DTBO 写的也是 `pm8150_s4`；
  旧工程改成的 L7A 是错的）。
- ramoops 地址沿用实机的 `0xb7e00000`，几何按 bring-up 用途重写（去掉主线不支持的
  `devinfo-size`）。
- GPU / WiFi / 四个 remoteproc / uart2 一律 `disabled`，等能验证时再说。
- binding：`qcom.yaml` 增加 `realme,samurai`，`vendor-prefixes.yaml` 增加 `realme`。

构建与产物：

    make -s ARCH=arm64 qcom/sm8150-samurai.dtb
    # artifacts/sm8150-samurai.dtb
    # 94623 字节, sha256 1c760ec9cf74389c246e1b64a032c52910f6437dab29772371a506ead5d67b81

`dtbs_check` 没跑（WSL 里没有 dtschema）；`qcom,msm-id` / `qcom,board-id` /
`oppo,dtsi_no` 是有意保留的厂商属性（走 Android 启动链时 ABL 需要），它们会产生
schema 警告。

## 重要发现：EDK2 现在给内核的 DTB 是小米 9 的

`Platform/Realme/sm8150/FdtBlob/samurai/sm8150-realme-samurai.dtb`
（91012 字节，sha256 `7755cd89…`）反编译出来是：

    model = "Xiaomi Mi 9";
    compatible = "xiaomi,cepheus", "qcom,sm8150";

还带着 cepheus 的 `simple-framebuffer@9c000000` 和 `stdout-path`。也就是说
"DTB passed ✅" 这一项目前是把**别的机器的设备树**交给 Linux。新 DTB 应当替换它
（替换属于 EDK2 侧改动，需要重建 boot.img 并刷机，尚未执行）。

## 建议用 EDK2 启动该内核

固件在 BDS 已开 EUD，主机可在固件菜单界面提前打开 COM14，消除"内核已崩而主机
尚未 attach"的竞态；内核做成 EFI stub 由 EDK2 加载。

## 进度与下一步

**第 1 步（诊断内核）已完成**：配置以旧工程的 `bringup.config` 为基线（它本身
**没有** `CONFIG_EFI`/`CONFIG_EFI_STUB`），另加 EFI stub、EFI 配置表 DTB 支持
（`EFI_ARMSTUB_DTB_LOADER`）、EFI GOP 帧缓冲控制台（`SYSFB_SIMPLEFB + DRM_SIMPLEDRM +
FRAMEBUFFER_CONSOLE`，让内核日志能直接上手机屏）、`SERIAL_EUD_EARLYCON=y`、
`PSTORE_RAM=y`，并内置一个诊断 initramfs（busybox，只打印 CPU/内存/块设备/UFS/
帧缓冲然后挂起）。GPU/WiFi/remoteproc 继续关闭。产物：

    Image  30,116,352 字节  sha256 3d5665abcf53b1b97ee5b2c32b4aaaee45265a4c45af99463b4d3c2b35427ba3
    kernelrelease = 7.3.0-rc6-rmx1931-samurai+

**第 2 步（换 DTB + 把内核装进固件）已完成**，详见
[docs/EDK2-KERNEL-EMBED.md](docs/EDK2-KERNEL-EMBED.md)（EDK2 仓库提交 `47c3efb`）：

    boot-samurai-linux-cmdline.img  15,185,920 字节  sha256 0d1ec54656fed0550a90ac8453918a8d589d93ed890914959ffba31f2b0a3439
    （E:\edk2-samurai-out\，另有裸 FD 与 Image）

⚠️ EDK2 仓库里的 `Platform/Realme/sm8150/LinuxKernel/Image` 是**构建产物、未入 git**。
全新 clone 后要先把它拷回去（[artifacts/Image-rmx1931-samurai](artifacts/Image-rmx1931-samurai)
或 `E:\edk2-samurai-out\Image-rmx1931-samurai`，sha256 `3d5665ab…`），或按
[scripts/build-image.sh](scripts/build-image.sh) 重编，否则 `./build.sh -d samurai` 会失败。

**第 3 步（真机验证）待办**：手机当前未连接。步骤：

```powershell
# 1) 主机先备好 EUD 日志通道（重启后 9501 出现时执行）
E:\eud-host\eudtool.exe com-up
E:\eud-host\comlog.exe COM14 600 E:\eud-host\samurai-linux.log
# 2) 刷入并重启
fastboot flash boot E:\edk2-samurai-out\boot-samurai-linux-cmdline.img
fastboot reboot
# 3) 屏幕出现 UEFI 菜单后，用音量键选到 "Linux (mainline samurai)"，电源键确认
# 4) 看 comlog 里是否出现 "Booting Linux on physical CPU …" 等早期日志
# 回滚（EUD 开着时 USB 被占用，必须先长按电源 15 s 彻底断电）
fastboot flash boot E:\edk2-samurai-out\backup\boot_stock_RMX1931.img
```

验收标准：comlog 里出现内核 earlycon 输出（8 核、内存、UFS、initramfs 横幅），
而不只是 EDK2 菜单或黑屏。

其余未做：panel（SOFEF03F_M，已拿到下游 806 行 init 序列）、触控（S3706，接线已
拿到）、WCN3990、充电、持久变量、SWD/JTAG。

## Android 设备树参考（refs/19781/）

本机是 OPPO/realme 的"项目号 19781"，官方 AndroidR 内核里
`arch/arm64/boot/dts/19781/` 就是它的设备树源码，其中 `sm8150-mtp.dtsi` 是板级文件。
这份源码（旧工程留下的 187 MB 浅克隆，可离线读取）已挑出关键文件放进
[refs/19781/](refs/19781/)：按键/UFS 用它复核过（与主线 DTS 一致），触控与面板的
接线、时序从里面拿到了。评估、映射表和坑见
[docs/ANDROID-DT-REFERENCE.md](docs/ANDROID-DT-REFERENCE.md)。

## scripts/

| 脚本 | 用途 |
|---|---|
| `install-samurai-dts.sh` | 把 `dts/sm8150-samurai.dts` 装进 WSL 树、注册 binding、编译、提交、生成补丁 |
| `verify-samurai-dtb.sh` | 反编译新 DTB、导出 reserved-memory 核对表、识别 EDK2 现有占位 DTB |
| `test-old-dts.sh` | 核实旧工程：应用旧补丁并复现它的 DTB（应得 `f0c3a820…`） |
| `dump-live-dt.sh` | 解包实机 `/proc/device-tree` 转储，导出 ramoops / reserved-memory 真值 |
| `collect-artifacts.sh` | 整理补丁编号、把补丁/DTB/核对表复制回本目录 |
| `patch-bootmanager-cmdline.py` | 把内核命令行做成 boot option 的 LoadOptions（HANDOVER-NEXT.md §19） |
| `build-cmdline-firmware.sh` | WSL 里重编 samurai 固件 |
| `verify-cmdline-firmware.py` | 离线核对 LoadOptions / 启动项 / FD / boot.img |
| `archive-cmdline-firmware.sh` | 归档产物到 `E:\edk2-samurai-out\` 并提交 |

## 2026-10-07（下午）：内核命令行进了 LoadOptions

`boot-samurai-linux.img` 之后多了一个超集 **`boot-samurai-linux-cmdline.img`**
（sha256 `b9fb2064…`）：启动项 "Linux (mainline samurai)" 现在把与设备树逐字相同的
内核命令行作为 LoadOptions 一起传进去，设备树万一没带 bootargs 也不会黑屏静默。
改动、证据与真机步骤见 `HANDOVER-NEXT.md` §19（EDK2 提交 `c2a3697`）。

**第 3 步真机验证仍未做**：本轮手机没有连接（`adb devices` 为空、Windows 上没有
`VID_05C6`），所以只做了离线加固与验证。手机接上后刷的是
`boot-samurai-linux-cmdline.img`，步骤同上面第 3 步。
