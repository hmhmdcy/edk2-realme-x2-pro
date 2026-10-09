# 临时 EUD 终端：先继续 Linux 移植

> session 41 已找到原生 FIFO 推进方法（SM8150 TOP_CFG=0x11），并验证原生多字节
> shell 执行；此终端继续按单字节发送，兼容 rx33 和 RX41 驱动。
> 原生帧长度 2 仍保留 F1，发送长命令时不能用长度 2 的 tty 分片。
> 新证据与最终镜像见 [session 41](../../sessions/41-rx-ahb2phy-wait-state-fix.md)。
> 下表的多字节故障描述针对 rx33 基线，保留作历史。

2026-10-09，适用于当前 `logdump-rx33-console.img` 内核。源码与测量见
`../../sessions/33-rx-access-and-production-policy.md`、
[session 34](../../sessions/34-temporary-eud-terminal.md)。

## TX 和 RX 的状态

方向以手机为准：

| 方向 | 当前状态 | 临时终端的处理 |
|---|---|---|
| 手机 TX → PC | 内核每帧发送最多 4 个 payload 字节，长输出拆成多帧；限速后可用 | 持续读取、解帧、显示，并保存日志 |
| PC → 手机 RX | 单字符可用，原生一帧多字符仍重复首字节或读到 90 | 输入排队，每次只发 `[90][01][char]`，等该字符受理后继续 |

TX 以前有小 FIFO 溢出、双 console writer 等问题，当前采用 200 μs/寄存器写与
2 ms/帧的节奏。它不是 RX 的“读不出下一字节”现象；也不保证任意帧长或绝无丢失。
0 stray 仅表示重组无需跳过字节，不是无损证明。

## 启动

先关闭其他 EUD 抓包/串口程序。Windows PowerShell 自带运行环境，不需要 pyserial。

```powershell
& 'E:\eud-host\eud-terminal.cmd' -Reconnect
```

项目内同一份入口：`linux-port/scripts/eud-terminal.cmd`，也可直接双击。
不指定端口时，从当前 EUD 9505 设备自动找 COM；需要时可加 `-Port COM14`。
`-Reconnect` 在开串口前调用已有 eudtool 的 com-off/com-up；需要手机已启动 EUD。
它不等于修复 resource-in-use：遇到端口钉死仍需换 USB 口或重启主机。
未加此参数且找不到 COM 时，工具会尝试一次 com-up。

终端始终排空输出；退出和异常路径都在 finally 中 Close/Dispose 串口。
只输入 ASCII，适合 shell 命令、路径和驱动诊断；可粘贴整条命令，发送较慢属于正常。
不用手工拼 EUD 帧。

| 按键 | 含义 |
|---|---|
| Enter | 发送换行执行 |
| Backspace | 发送 DEL 删除字符 |
| Ctrl-C | 清除主机未发送队列，向手机发送中断字符 |
| Ctrl-U | 清除主机未发送队列，向手机发送清行字符 |
| Ctrl-] | 本地退出并关闭串口 |

这是简易字符终端，尚不支持方向键历史、全屏应用或 Unicode 输入。若需要 Ctrl-]
之外的方法退出，应等工具正常结束，不要强杀正在持有串口的进程。
完整的 `eud: tty byte=..` 受理行默认只保留在日志中；`-ShowAcks` 可显示它们。
破损的诊断行可能仍显示出来。
远端 shell 的 `ESC[6n` 光标查询只在显示端过滤，避免 Windows 终端自动回复后
被 ReadKey 当作键盘输入转回手机；原始日志仍保留查询。

## 一次发送一条命令

```powershell
& 'E:\eud-host\eud-terminal.cmd' -Reconnect -Command 'uname -r'
& 'E:\eud-host\eud-terminal.cmd' -Reconnect -Command 'dmesg | tail -n 60'
```

命令模式先发送 Ctrl-U 清理旧的半行，再发送命令和换行；最后继续排空输出，默认
静默 3 s 后退出。可用 `-TailSeconds 10` 延长静默等待。
不要同时运行交互终端和命令模式。
退出码表示桥接是否完成，不是远端 shell 命令的退出码；远端结果要查看输出。

单字符重试基准默认 500 ms，另加 0..399 ms 扰动；最多发送 10 次，收到回执即停。
成功字符之间再留 200..299 ms。该较短节奏已用于临时单字符路径实测，F1 的单步
探针脚本仍保留原来的秒级命令间隔。需要保守节奏可加 `-RetryMs 2200`。
某字节用尽重试次数仍无回执，工具停止剩余输入、报错并关闭端口，不自动重跑整条命令。
若换行已经受理但回执丢失，命令可能已经执行；先看输出，再决定是否重输。

现有内核回执仅含字符值，没有序号/去重。因此 ACK 丢失时仍有重复字符的可能；
临时桥接不承诺 exactly-once，也不是原生多字节 RX 修复或二进制传输通道。

## 日志与后续工作

默认日志在 Windows `%TEMP%\eud-terminal-时间戳.*`，启动时打印完整路径。
可用 `-LogBase 'E:\edk2-samurai-out\my-driver-test'` 指定文件名前缀：

* `.raw`：EUD 原始输入帧；
* `.txt`：未过滤的设备输出，保留受理日志；
* `.events.txt`：每字节发送、重试与受理时间。

退出时打印 ACK 数、重试数、收到的帧数、最大 payload、stray 和残留字节数。
原始日志仍可用 `decode-eud-capture.py` 重组。

现在可通过此终端查看 dmesg、设备节点和 sysfs，继续定位具体驱动。
内核镜像仍走 `FLYWHEEL.md` 的 `[90][02] → fastboot → 只刷 logdump → reboot` 流程。
发 F1 前先用 Ctrl-] 关闭终端，让单步工具独占端口。此终端不会自动刷分区。
