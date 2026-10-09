# Bounded pre-Linux EUD RX comparison

SM8150 samurai 的诊断应用。sessions 38/39 均实测 ABC→AAA、DEFG→DDDD，**不是原生 RX 修复**。
当前为 RX39 紧轮询版本，受理前检测间隔约 625/572 ns 仍失败。RX38 的 1 ms 版本见提交 703469c。
该间隔是相邻循环入口计数之差，不是 USB 到达至首次 DAT 的端到端延迟。
不链接 SerialPortLib，在高 TPL 屏蔽已知固件 TX 定时器，整帧缓存后才输出；每阶段等候最多 25 秒，
然后启动预先加载的原 `\Kernel`。保留 BDS LoadOptions 和现有 DTB 配置表，不改 PHY/时钟/中断寄存器。

在既有 WSL 仓库镜像本目录，运行 `bash .../uefi-rx-probe/build.sh`。
`package.sh` 针对本机路径：检查基线哈希，只创建新的 logdump-rx39-uefi.img，
把原 Image 重命名为 Kernel，再添加应用为 Image；内核、DTB、应用均逐字节校验。
输出文件已存在时拒绝覆盖。构建不触碰 boot 固件或 Linux/initramfs。

手动 F1 → 确认 fastboot → 只刷诊断 logdump；先起 `wait-capture.ps1 -Out <新前缀> -StartAbc`，
再单步 reboot。脚本等 CTL、com-up、找 COM，打开后先发 ABC，收到 DEFG ready 再发 DEFG，
各最多 3 次、间隔 3 秒；100 秒后 finally 关闭。第一次 ready 可在打开端口前丢失。
省略 StartAbc 时只响应实际收到的 UEFI ready，普通 Linux 下可作被动抓包。

结束后单独 F1、核实 fastboot，刷回原 logdump-rx33-console.img，再启动并核实 console。
记录、限制和哈希见 [session 38](../../sessions/38-rx-pre-linux-and-usb-boundaries.md) 和
[session 39](../../sessions/39-rx-tight-arrival-poll.md)。不再原样重复这两项失败对照。
