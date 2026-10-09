# EUD RX side: registers, framing and the console driver

> Split out of EUD.md on 2026-10-08; verbatim from there.  The TX side and the firmware
> log ring are in EUD.md.

> **2026-10-09 session 41：找到有效原生多字节 RX 方法。** 原厂 SM8150 DAL 映射确认
> SOUTH SWMAN=0x088ee000；同机型源码的 TOP_CFG +0x10、值 0x11，经实际读回验证。
> 配置 0x088ee010=0x11 后，UEFI 两次重启与 Linux 均读到完整 ABC/DEFG，Linux 也读对 LEN=14。
> 驱动在 TX 锁内收完整帧后才打印/投递 tty，保留 len=2 的 F1；tty 允许长度为 1、3..14。
> 原生 X=ok\n 已在 shell 执行。整帧偶发没有回执仍需有界重试，不是无损保证。
> 证据、输出验证及最终镜像状态见 [session 41](sessions/41-rx-ahb2phy-wait-state-fix.md)、reference/rx41。
> 以下 session 32-40 的“未修复”结论保留为当时的历史观测。

> **当前入口：[session 54](sessions/54-console-rx-regression-and-host-counter-audit.md)。**
> 未改 RX53 候选/安装终端、未刷机；9 次手动长日志 overlap 均 via=console 并执行，
> 全部变量读回、每条 990 个零，IRQ active=1/fault=0，6 次空 IRQ 正确计入 console
> credit；并未诱发连续 8 次空 IRQ。完整 USB IN/raw、512 帧快照直接匹配。
> 一次长日志期间的 header-only F1 明确 via=console 并进入独立核实的 fastboot；
> 同候选 reboot 恢复 TOP_CFG=0x11/tty/IRQ、原生新回执/输出，finally 关闭/detach。
> RX53 的 seq 7287 TX 缺前缀仍开放。本轮实装驱动审查找到只读累计接收计数
> SerialGetStats；下一步在现有 owner 的 overlapped handle 有界读取，与 raw/journal/
> queue/errors 对照。尚未实测 GET_STATS，不把接收缓冲计数当物理 USB ACK。
>
> **历史上一轮：[session 53](sessions/53-console-boundary-rx-service.md)。**
> 当前仅刷 logdump-rx53-console-rx：在 console 完整 TX 帧边界收完整 RX，回执/tty/F1
> 留在工作线程，单独记录 via=console 与 console_frames，最多 credit 一次消费后空 IRQ。
> 同样长日志/7 字节输入在 USB、Windows 都受理并执行，各 512 TX 帧直接匹配、990 个
> 零完整；验证了明确 RX 触发的改善。TOP_CFG=0x11、TX 节奏、F1/兼容终端保留。
> 但重启后安装终端仍缺状态前缀 `[   `：seq 7287 有软件记录、raw 对应位置无它，
> 其余 511/512 跨三段抓取直接匹配。整体稳定性仍开放，不能把 RX 成功称为 TX 修复。
> IRQ F1/同候选重启成功，owner finally 关闭/detach、三节点 OK；console 来源 F1、
> 多次 overlap 跨空 IRQ 门槛，以及精确 TX 缺口是下一项，不再重复普通成功命令。
>
> **历史上一轮：[session 52](sessions/52-same-owner-usb-overlap-and-continuous-in.md)。**
> 两次持续 libusb owner 中，长日志期间一次 7 字节输入均有完整 OUT 完成，却没有
> 回执或 RX/tty 字节；同一 owner 一次 Ctrl-U 恢复，均多一个 empty IRQ，没有捕获期
> 控制传输，因此这次失败不需要 qcusbser/reopen。持续读 IN 与保存/显示分开后，
> 最大请求空窗 8423→854 us，TX 快照 510→512/512 帧，RX 仍失败。只是一组对照，
> 不宣称全部旧 TX 故障同因/已修复；首样本缺 8 个零，具体重复帧序号有歧义。
> 完整目标 IN/raw 逐字节相等；未刷机/重启/新 Windows 管理员抓包，保留 RX48 B、
> TOP_CFG=0x11/F1/兼容终端，USB finally 释放/detach，三节点 OK、COM14 关闭。
> 下一项针对长 console 锁/外层 IRQ 关闭时 RX 服务；候选尚未实现，IRQ 延迟未实测。
>
> **历史上一轮：[session 51](sessions/51-console-overlap-and-issued-frame-loss.md)。**
> 长日志接收期间一次提交的 7 字节原生输入没有回执、未进入 RX/tty；恢复连接时
> 不可变 512 帧 TX 快照有一个完整 4 字节 console 帧 `[ 58` 缺于 Windows raw，
> 其余 511 帧跨两个 owner 直接匹配。本轮真实异常已复现，但 console 锁/物理 OUT/
> USB/Windows 接收的根因仍未定。未刷机或换安装终端，TOP_CFG=0x11/F1/兼容保留；
> 串口 finally 关闭，恢复状态完整、IRQ active=1/fault=0，grace waits=0 尚未验证。
> 下一步只对照这个明确触发条件的目标 IN/OUT，不重复正常命令当稳定性证据。
>
> **历史上一轮：[session 50](sessions/50-windows-receive-and-driver-buffer-audit.md)。**
> 当前连接正常，旧缺回执/缺字未重现；未改手机镜像或安装终端。独立 Windows 诊断
> 记录接收队列/错误/读取时序，完整状态输出与重叠的 287 个已发帧匹配，最大队列
> 150 字节、无观察到的串口错误。实际程序集与精确匹配 PDB 说明原查询会清错误
> 而旧终端未记录；这补齐诊断，不证明溢出是根因。串口 finally 关闭，正常使用现有
> 终端；长期稳定性仍开放，不再重复已成功样本当进展。
>
> **历史上一轮：[session 49](sessions/49-usb-in-and-partial-timeout-audit.md)。**
> 未改 RX48 B、未刷机或重启手机。7 组旧 IN/raw 离线逐字节匹配；持续 libusb owner
> 的 60 行输出、CRC 有效 512 帧记录及全部 11,066 字节 IN/raw 也匹配。一次取消 IN
> 仍返回 6 字节，安装的 PyUSB 正确保留，不能把所有 timeout 都当丢失。它只定位到
> WSL 虚拟 HCD，不是物理 ACK 或 qcusbser 证明；旧缺字未重现、wait 分支未触发。
> USB finally 关闭/detach 后 Windows 原生 echo 正常，COM14 关闭；稳定性仍开放。
>
> **历史上一轮：[session 48](sessions/48-irq-grace-and-tx-journal.md)。**
> 当前 logdump-rx48-tx-journal.img 保留 TOP_CFG=0x11/整帧 RX、console/F1、TX 节奏。
> watchdog 首次 pending 只记录，100 ms 未受理才退回；waits=0，相关分支尚未实测。
> 新只读 TX 软件快照 CRC 有效，512 个已发 MMIO 帧全部与同一 owner 的 raw 匹配；
> 本样本没重现旧缺字，不能宣布根因/稳定性已解决。30 行输出、兼容、IRQ F1、重启
> 与最终原生 echo 成功，兼容启动重试一次。仅刷 logdump，无新管理员抓包。
>
> **历史上一轮：[session 47](sessions/47-native-terminal-session-boundary.md)。**
> 现有 ETW 显示串口会话边界有 IN/OUT 端点清 halt/pipe reset；微软文档提供数据翻转
> 不同步丢包的依据，物理 DATA0/1 尚未测到，不能称根因已证明。持续打开的原生帧
> 成功，重开后的命令和首个 Ctrl-U 没有设备 RX；原生终端现有 `-Native` 启动同步。
> 默认兼容输入保留。本轮重启后长状态输出有真实缺字，并首次测到 watchdog=1/fault=4
> 退回轮询；输入和轮询 F1 仍成功。未刷机，保留 IRQ B；稳定性仍未彻底解决。
>
> **上一轮：[session 46](sessions/46-rx-irq-and-host-trace-boundary.md)。**
> 真实 SPI 492/hwirq 524 IRQ 接收、整帧缓存和工作上下文 tty/F1 已实测。
> Windows 一次失败原生命令仍未增加 IRQ/pending/帧/tty；同次启动 libusb 小样本全成功，
> 不能据此认定仅 Windows 故障。当前保留 IRQ B 诊断镜像，仍未解决长期稳定性。
> 原生完整输出、F1、重启和 Ctrl-U 保留；下一步对照原始主机 OUT/完成与设备计数。
> RX45 已排除仅掩码方案，勿重复；Windows USB ETW 权限与抓包结果见 session 46。
>
> **计数边界：[session 44](sessions/44-rx-receipt-counters.md)。**
> 只读接收计数显示，失败的原生命令没有增加 pending、坏帧头或 tty 字节；
> 成功原生 echo 则增加准确的一帧/10 字节并返回输出。当时诊断镜像 rx44-rx-stats-ctrl-u
> 保留 RX41 硬件方法，未修复偶发缺回执；后续 RX46 增加实际 IRQ 计数，区分
> 主机交付与缺接收通知；不把 IRQ/超时假设当作根因。计数可读 sysfs 或 Ctrl-U 回执。
>
> **上一轮审查：[session 43](sessions/43-native-terminal-evidence-audit.md)。**
> RX41 原生 id/echo/console 的“缺输出”经未改动的原始抓取核对撤回；解码 stdout
> 过滤曾隐藏已有响应。本轮 Windows/libusb 及重启后的原生命令有完整响应。
> 偶发缺回执仍存在，失败 Windows echo 在后续设备 RX 日志中也不存在；
> USB/EUD 交付与 STATUS1/头部门控尚未区分。保持 TOP_CFG=0x11 与原整帧锁方法。
>
> **历史交接（session 42，仅文档更新，其缺输出样本已由 session 43 更正）：**
> [原生终端交接](sessions/42-native-terminal-next-session-handoff.md)。
> 已修复并复测的是受理整帧后重复读取首字节的故障；使用真实多字节帧，未拆字节绕过。
> 当时提出缺回执/缺输出两个问题；其中原生 id/echo/console 的缺输出已撤回，见 session 43。
> 下一轮区分主机提交、完整 RX、tty 投递、shell 执行与可见 TX，不把任何一层证据扩大到全链路。

> **截至 session 40 的历史核对（非当前镜像）：单字符 RX 可用，多字节仍未解。** 原探针实际读到
> `90 90`。去掉读取前的 printk 后，`ABC` 的首字节能读到 `41`，`DEFG` 的首字节
> 能读到 `44`；因此不能按「整帧在 FIFO，payload 偏移 2」修改驱动。当前
> `[90][01][字符]` 已有真实 tty 回显，`[90][02]` 仍是 fastboot，`len>=3` 保留
> 有界诊断、不向 tty 注入未验证的多字节。下文旧节保留为历史观测，最新证据与
> 跨机型源码对照见 [session 32](sessions/32-rx-printk-interference.md)；帧内禁止 TX、
> MMIO 属性、读序、上下游及量产权限排查见
> [session 33](sessions/33-rx-access-and-production-policy.md)。当时恢复版是
> `logdump-rx33-console.img`；RX 状态、头部与首次 DAT 读取共用 TX 锁。

> **临时交互入口（2026-10-09）：** `linux-port/scripts/eud-terminal.cmd`，工具副本
> 在 `E:\eud-host\`。手机 TX 用每帧 4 字节组成输出；默认主机输入仍拆成长度 1。
> 加 `-Native` 则先 Ctrl-U 同步，再持续发送最多 14 字节原生帧，命令帧不重试。
> 见 [终端指南](linux-port/docs/EUD-TERMINAL.md)。TOP_CFG=0x11 的真实整帧修复仍保留；
> 不把可用小样本或零 stray 当作无损稳定性证明。

> **session 36 新证据：** 实机 9505 为 bulk IN `0x81` / OUT `0x02`，最大包长 16，
> 配置仅 32 字节、无 MDLM extras。旧 WDM qcusbser 有条件字节填充的描述符门槛
> 不满足；源码版本仍与实装不同，不能代替 OUT 抓包。SM8150 时钟/PM/PHY 变更未
> 给出额外 RX advance。完成 libusb/WSL 对照：完整短帧成功提交且设备受理，ABC
> 仍为 `41 90 90`、DEFG 为 `44 90 90 90`；qcusbser 不是触发故障的必要条件。
> 本轮未刷机，COM14 已恢复回执，原生多字节仍未修复。
> 证据和下一步见 [session 36](sessions/36-rx-usb-descriptors-and-legacy-qcusbser.md)，
> 已排除实验见 [session 35](sessions/35-rx-next-session-handoff.md)。

---

> **session 37 源码搜索：** 同机型原厂代码和较新厂商树没有提供新的 DAT 推进握手。
> 2026-09-29 PHY v9 系列提供 EUD 独立管理 PHY 的依据，但未改 COM RX；本机旧启动
> 记录也有 USB/PHY probe 延迟，下一步先核实当前资源链和接管状态。更正旧记录：
> QUIC COM timeout 调用正确的两参数 WriteCommand，不受三参数覆盖 opcode 的 bug 影响。
> 本轮无串口操作、无刷机，仍未修复原生多字节；详见
> [session 37](sessions/37-rx-source-search-and-phy-lifecycle.md)。

## RX side: registers, framing and the console driver (2026-10-08)

> **session 38 新对照：** 独立 UEFI 程序在 Linux 运行之前、屏蔽已知固件 TX 定时器、整帧缓存后输出，
> 新受理 ABC/DEFG 仍为 AAA/DDDD。合法 LEN=14 满 16 字节 OUT，及另附 ZLP，均仍为首字节后全 90。
> PORT_RESET 后 ABC 也未改善；timeout 无回执不能算有效失败。已只刷 logdump 恢复 rx33-console，
> Linux/COM14 Ctrl-U 新回执正常、端口关闭。实际 HS PHY 匹配 SNPS femto-v2，修正此前 QUSB2 参考归属。
> 详见 [session 38](sessions/38-rx-pre-linux-and-usb-boundaries.md) 和 reference/rx38；原生多字节仍未修复。

> **session 39 新对照：** UEFI 去掉 1 ms 等待、紧轮询的相邻循环入口差为 625/572 ns，
> 新受理 ABC/DEFG 仍为 AAA/DDDD；这个数值不是 USB 到达延迟。不要原样重跑更快轮询。
> libusb 加 PORT_RESET 恢复单字节/F1 回执后，另证实 fastboot，已只刷回 rx33-console；
> 原 Linux/tty/shell 启动、Windows Ctrl-U 首次受理，COM14 关闭。新搜到的 boot HWIO 定义
> 属于其他 SoC 或经过过滤，没有给出 SM8150 COM advance 修法。完整证据和限制见
> [session 39](sessions/39-rx-tight-arrival-poll.md)、reference/rx39。

> **session 40 源码审查：** 完整旧一代 DSP 寄存器表列出 EUD_ACORE/flags，仍没有 DAT 读副作用规格；
> 原厂 RMX1931 SM8150 UsbConfigDxe 检查 EUD enable 并避开 PHY reset，没有提供 COM RX 推进代码。
> 未刷机、未重跑多字节，基线 Windows Ctrl-U 第 2 次 OUT 有新回执并 finally 关闭。
> 原生 RX 仍未修复；固定来源、证据边界见 [session 40](sessions/40-rx-register-map-and-stock-firmware-audit.md)。

本节至「命令通道打通」是同日较早阶段的历史记录；当前实测结论见文首及末节。
其中「每读一次必定弹出后续 payload」和 offset-2 都不能当作本机已验证事实。

Earlier sections describe the transmit direction.  This one is the receive
direction, measured on this unit.

Registers inside the 0x2000 window (every readback replicates the low byte into
the four lanes, so mask with 0xff):

| offset | meaning |
|---|---|
| 0x0c | RX_ID - latch holding the id of the last message the host wrote |
| 0x10 | RX_LEN - latch holding that message's length |
| 0x14 | RX_DAT - downstream treats this as a FIFO read port; advancing after the first payload byte is unverified on this unit |
| 0x40 | INT_STATUS_0 - 0x00 idle, 0x02 while RX data is pending |
| 0x44 | INT_STATUS_1 - 0x06 idle, 0x07 while RX data is pending (BIT(0)) |
| 0x20 | INT0_EN_MASK - reads 0; writing 0xff reads back 0x1f (five bits) |
| 0x60 | reads 0x0b0b0b0b, undocumented |

Protocol: the host writes [id][len][payload...] as one transfer; the device
reads id from 0x0c, len from 0x10 and then reads 0x14 `len` times for the
payload.  Unframed writes are dropped by the device entirely.  The status bits
are not reliable enough to gate on (they can read idle while data is pending),
so new data is detected by watching the 0x0c/0x10 latch pair change.

Ids used by this port: 0x82 = tty input (the payload goes to /dev/ttyEUD0),
0x81 = command channel (payload[0] is the command code: 0x01 ping, 0x02 register
dump, 0x03 status).  0x90 is the id the device uses when it transmits.

The kernel driver is drivers/tty/serial/eud.c: a uart driver ("ttyEUD") with a
workqueue transmit path paced at 200 us per register write and 2 ms per frame, a
20 ms RX poll, and a console that registers only when the command line contains
"console=eud" - otherwise the early console is a second writer on the same seven
entry FIFO and the two interleave byte by byte.

Caveat: reading 0x14 too eagerly wedges the EUD COM block.  The console goes
silent (the 9501 control device and the COM port stay up) until a full power
cycle.  Only read it once a complete payload is certain.


## Payload read attempts (2026-10-08 evening): what works, what does not

Three kernel builds were tried after the register map above was established.

1. `logdump-payload.img` - read 0x14 up to `len` times whenever the header
   changed or INT_STATUS_1 BIT(0) looked set.  The device went silent, console
   included, right after the first host frames; a full power cycle cleared it.
   Hammering 0x14 is what wedges the block.

2. `logdump-safe.img` (direction A) - trigger only on the 0x0c/0x10 latch
   changing, read at most ONE 0x14 byte per 20 ms poll, validate `len` 1..16,
   and let the host alternate ids 0x82/0x83 so that two identical characters in
   a row still change the latch.  Result: the device did not wedge immediately -
   the shell echoed all 18 characters of "echo SHELL-LL-TEST" - but most payload
   bytes came back as 0x3F ('?') and only a few were the characters actually
   sent.  0x3F looks like the value an empty 0x14 read returns, i.e. the payload
   is not in the FIFO yet when it is read immediately after the header latch
   changes.  After about two minutes of host traffic the device went silent
   again.

3. `logdump-payloaddiag.img` - prints "eud: msg id=.. len=.. s0=.. s1=.." and
   then "eud: payload[n/m] = xx s0=.. s1=.. polls=.." for every byte read, so a
   known host frame ([0x90][0x03]"ABC") shows exactly what comes back and when.
   On its boot the console produced almost no output at all, so those
   diagnostics have not been collected yet.

Open questions, in the order they should be answered next session:

* Is the silence a device-side wedge or a host-side stall of the qcser/USB read
  path?  `eudtool com-off` followed by `com-up` once delivered six leftover bytes
  ("[  1") and then nothing, which points at the host side at least once.  Test
  by attaching the host capture BEFORE the kernel boots and draining
  continuously so the FIFO never overflows, and by re-enumerating the COM
  function while the device is known to be logging.
* When exactly does a payload byte become readable in 0x14 after the host's
  write?  Candidates: one poll (20 ms) later; only while INT_STATUS_0 has BIT(1)
  or INT_STATUS_1 has BIT(0); or only after the header latches have been read.
  The diagnostic build answers this once it runs with a continuous capture.
* Until then the verified-stable RX is the header-only protocol in
  logdump-tty6.img: [0x81][cmd] commands (reliable) and [0x82][char] typing
  (works, characters can be lost).

Hardware note that cost several cycles: a silent EUD does not always mean a
crashed kernel.  The EUD block keeps state across warm reboots, and a full power
cycle (hold Power about 15 s) is the only reliable way to clear a stuck COM
block.  Always try that before concluding the image is broken.


## External reference found (2026-10-08): EUD_INT_RX lives in INT_STATUS_1

A web search turned up the downstream Qualcomm driver `drivers/soc/qcom/eud.c`
(AOSP kernel/msm; the same driver ships in realme sdm710 and motorola sm6375
trees).  Its RX interrupt plumbing is:

    static void eud_stop_rx(struct uart_port *port)
    {
            /* Disable Rx interrupt */
            writel_relaxed(~EUD_INT_RX, port->membase + EUD_REG_INT_STATUS_1);
            /* Ensure Register Writes Complete */
            wmb();
    }

so `EUD_INT_RX` is a bit in `EUD_REG_INT_STATUS_1` (0x44).  On this unit that
register reads 0x06060606 when idle and 0x07070707 while payload bytes are
pending, which pins `EUD_INT_RX = BIT(0)`.  The same driver's uart_ops has
`eud_tx_empty`, `eud_stop_tx`, `eud_start_tx`, `eud_stop_rx`, `eud_startup` and
`eud_shutdown`, i.e. it is a tty driver of exactly the shape ours has.

Consequence for our driver: gate every read of 0x14 on `INT_STATUS_1 BIT(0)`
and read only one payload byte per poll.  `logdump-intrx.img` implements that
and is the current candidate.


## The downstream RX function itself (found 2026-10-08 by searching)

The receive side of the Qualcomm driver was finally extracted from AOSP
kernel/msm (`drivers/soc/qcom/eud.c`).  The search that worked was a
quoted-string probe of the googlesource page through Exa.

    static void eud_uart_rx(struct eud_chip *chip)
    {
            struct uart_port *port = &chip->port;
            u32 reg;
            unsigned int len;
            unsigned char ch, flag;
            int i;

            reg = readl_relaxed(chip->eud_reg_base + EUD_REG_COM_RX_ID);
            if (reg != UART_ID)
                    ...                 /* not our message: drop the whole thing */

and the status bits are

    #define EUD_INT_RX          BIT(0)
    #define EUD_INT_TX          BIT(1)
    #define EUD_INT_VBUS        BIT(2)
    #define EUD_INT_CHGR        BIT(3)
    #define EUD_INT_SAFE_MODE   BIT(4)
    #define EUD_INT_ALL         (EUD_INT_RX | EUD_INT_TX | EUD_INT_VBUS | \
                                 EUD_INT_CHGR | EUD_INT_SAFE_MODE)

with

    static void eud_stop_rx(struct uart_port *port)
    {
            /* Disable Rx interrupt */
            writel_relaxed(~EUD_INT_RX, port->membase + EUD_REG_INT_STATUS_1);
            wmb();
    }

So the reference sequence is exactly: read the id latch (0x0c), filter on
`UART_ID`, read the length (0x10), then read `len` payload bytes from the FIFO
port (0x14), with `EUD_INT_RX` (BIT(0) of INT_STATUS_1) as the data-available
gate.  On this unit INT_STATUS_1 reads 0x06 when idle and 0x07 while payload
bytes are pending - BIT(0) = RX, BIT(1) = TX - which confirms the mapping.

What is still unknown: the value of `UART_ID`.  The device itself transmits with
id 0x90, while the QUIC host library writes [exec-env id][len][payload] with the
id in 0x80..0x88 (0x81 = APPS).  The candidates are therefore 0x90 and 0x81, and
picking the right one is the first thing to settle next session.

How our driver compares:

| step | downstream reference | our driver (logdump-intrx2.img) |
|---|---|---|
| detect a message | RX interrupt, then read the id latch | read the id latch every 20 ms |
| filter | `if (reg != UART_ID) drop` | none yet |
| length | RX_LEN latch | RX_LEN latch, validated 1..16 |
| payload | read `len` bytes from 0x14 inside the ISR | ONE byte per 20 ms poll |
| gate | EUD_INT_RX in INT_STATUS_1 | EUD_INT_RX in INT_STATUS_1 |

The one-byte-per-poll deviation is deliberate: a burst of 0x14 reads while the
FIFO is empty wedges the COM block on this unit (the console dies until a full
power cycle), while one read per poll is the pattern that survived a 175 s
hardware probe.

---

## 命令通道打通，payload 仍未解（2026-10-08 晚，真机验证）

结论：**`0x14` 的 payload 读取仍未解**，但**命令通道已经能用**，手机能从 Linux
自己重启进 fastboot（使用手册 `FLYWHEEL.md`，实验记录 `sessions/31-flywheel-f1-verified.md`）。

1. **id `0x90` 是唯一被受理的**：A 轮用 `0x81`/`0x82`/`0x83` 发的 22 帧，闩锁完全没有
   变化；只有 `[90][03]"ABC"` 进了闩锁。`0x90` = 上游 `UART_ID`（两处 kernel/msm 镜像确认）。
2. **命令编码进长度字段**：`0x0c`/`0x10` 两个闩锁精确可靠 → `len=1` = tty 字符、
   `len=2` = reboot bootloader、`len>=3` = payload 探针。实测 `[90][02]` →
   `eud: reboot2 bootloader requested` → 写 `CSR_EUD_EN=0` → `kernel_restart("bootloader")`
   → fastboot，**全程无按键**。
3. **门控语义（实测）**：收到头部时 `0x44` 读 `0x07`（BIT(0) 置位）；读一次 `0x14`
   之后读 `0x06` —— **门控在第一次读之后就被清掉**。
4. **读回的字节永远是 `0x90`（id 本身）**：`len=1` → `byte[1/1]=90`，`len=3` →
   `byte[1/3]=90`。读到的字节确实进了 tty（设备回显了一帧 `90 01 3F`，即 `?`）。
5. **上游全是"消息级门控 + 帧内 burst"**：`kernel/msm` 用 RX 中断门控后一次读 `len` 次；
   QUIC 官方主机库规范："byte 0 is Exec Env ID, byte 1 is how many bytes data, remaining
   bytes are data"。**逐字节门控是本项目的偏离**（为绕开"burst 读会卡死 COM 块"）。
6. **主假设（未证）**：这台机器的 `0x14` 装的是整帧 `[id][len][payload…]`，payload 在
   偏移 2。探针 `[90][len>=3]`（读 `len-1` 字节、逐个打印、门控清零也不放弃）就是为
   判定它而写的，尚未跑。
7. **COM 口的命令帧**（`com_eud.h`）：`0`=NOP、`1`=TX_TMOUT、`2`=RX_TMOUT、
   `3`=PORT_RESET，形态 `{opcode,0xFF,0xFF,0x00,0x00}`；数据帧首字节才是 `0x90`。
   设备侧按首字节分派。
8. **主机投递率约 1/3**：实测 15 帧只有 7 帧被设备暂存。→ 每条命令发 3–5 次。
9. **主机 COM 口会卡死**：被中断的脚本能让 qcser 把端口钉在 "resource in use"，
   `com-off`/`com-up`/`detach`/`rst(0x09 PERIPH_RST)`/杀进程/重启手机都无效，
   只有换 USB 口（换设备节点）或重启主机能解。飞轮脚本必须 `try/finally` 关端口。

## 单字符 RX 修正与多字节探针的新结果（2026-10-08，session 32）

`drivers/tty/serial/eud.c` 现在先读 RX_DAT、存入内存，再打印诊断或向 tty 推送。
RX_DAT 不跳过头部。长度 1 的字符真实进入 tty，并更新 RX 计数；长度 2 在头部
立即请求 bootloader；长度 3..14 只按声明长度采样，读完才打印缓存，不因门控位
中途清零而提前终止，不分发 recovery，不向 tty 注入探针结果。
tty TX、console 与单次 RX 数据操作使用同一 port lock。

已经排除「只要忽略逐字节门控，直接多读两字节就行」这个修法。无前置打印的
连续 readl 得到 `41 41 41`；200 μs 读间延时和 readb 也未改善；20 ms 间隔并
推迟所有打印得到 `41 90 90`。首字节成功与整帧成功必须分开报告。
前置 printk 改变读回值有真机证据，具体硬件机制仍未证明。

复测用 `linux-port/scripts/eud-step.ps1`，每次只操作一帧，独立进程、持续排空、
Write 后 Flush、最多 5 次重发、finally 关闭并 Dispose。对于 tty 输入用
`-Ack 'tty byte=69'` 这类已受理诊断停止重发，再排空 2 s，避免一个字符被
重复键入；不能对整条 shell 字符串不看回显就盲发 5 遍。

当前源码的可复现副本是 `linux-port/eud.c`；镜像、原始抓包、哈希和后续未决
问题统一记录在 [session 32](sessions/32-rx-printk-interference.md)。

最终单字符版真机按 `i`、`d`、回车逐个发送并等受理诊断，shell 返回完整
`uid=0 gid=0` 和 `~ #` 提示符。对应 `rx32-final-i/d/enter.raw` 帧重组均为
0 stray bytes；同版 `ABC` 探针三次受理均为 `41 90 90`。

## 访问路径与量产权限复查（2026-10-09，session 33）

帧内完全禁止 TX，200 μs/2 ms 连读仍重复首字节；20 ms 仍可出现 `41 90 90`。
数据先于 ID/LEN 读取、实际验证为 Device-nGnRnE 的映射，以及临时改变 IRQ mask
均未取得连续 payload。SCM 读取返回 -22，不能作为有效数据或具体熔丝状态的证明。
RX 位也不是每次首次读后立即清零：短间隔读完可能仍为 07，较长间隔可能变 06。
因此，前置 printk 是已证实的干扰因素，不能独自解释后续字节失败。

核对同 SM8150 厂商树和当前上游后，未找到适用的 FIFO advance 修复；源码中未发现
第二个 RX 消费者。QUIC 主机库有一个覆盖 opcode 的 WriteCommand 重载错误，
但本项目的原始帧发送不经过它，不能归为本次根因。已安装 qcusbser 与公开 WDF
驱动版本不同，尚缺 USB OUT 抓包，主机这一层仍未完全排除。

量产调试权限可受熔丝和 OEM 签名策略限制，但未找到 COM 限为单字节的公开证据；
此前 SWD/DAP 受限也不能直接证明 COM FIFO 同样受限。详细来源、有效/无效样本、
哈希与下一步见 [session 33](sessions/33-rx-access-and-production-policy.md)。
最终版再次以单字符输入执行 id，返回 `uid=0 gid=0`，F1 再次进入 fastboot；
同版 ABC 仍为 `41 90 90`。只保留头部/首次 DAT 持锁与 mapbase 修正。
