# 下一阶段：真实显示故障与MP2650观测接口（session86）

先读sessions/86和reference/kernel86，再85/84/83/82/81/80/79/77。

session86沿用Android R/cyborg固定来源，纠正MP2650输入有效位解释，读取输入ADC并接入观测驱动。
当前#86，boot ID=32bf2d8f-8dde-47dc-9b88-e87db9e95198；末次515.97秒taint0、显示超时2/下溢0。
display已停止on0、2051KiB/CPU、snapshot:count=0，首次真实超时快照已保存且后续逐字节一致。
快照显示done callback、进入idle关IRQ、随后timeout；根因未定，没有新光学确认。
MP软件绑定曾测得ONLINE1/Full，各5次成功；ADC变化导致EAGAIN、3份空uevent，完整接口失败。
修正版#87最多3次一致性尝试、无ADC数据返回ENODATA，已编译但未部署/实机验收。
当前MP客户端已释放、无持久DT节点；11个配置值保持，REG13曾0f/1f/0f，状态变化不是配置写入。
电量99%、包8.636V、31.5°C、平均0mA；不能证明充电慢，控制/保护/USB输入预算仍未验收。
原厂头文件VIN有效宏与MPS手册反向，未证明Android运行时受其影响；PDF仅有索引文字，未下载/视觉验证。
无充电配置/NVM/OTP/FET/OTG/GPIO/MCU操作；只读I2C仍含寄存器选择写帧。
当前logdump完整64MiB sha=cf11644e32a138ff1319fe9e44529f1ef7b2a1907c1f8876c597f970a526d286。
原#85回退kernel86/logdump-before.img sha=60e183a6780945885a738ac1bd0c7e23ed41515bca662cb50a831ede3b57302b。
boot前缀6682624字节sha=08edf9bcc1c55977169b0a8fd9f963805ba98d0423929e09e17bb9f811ca7405保持。
第二次F1序列在OUT前中断，没重启/第二次刷写；已显式detach，flash-final.ps1已设置停止保护。
完整证据见sessions/86-mp2650-input-status-and-real-display-timeout-snapshot.md与reference/kernel86。

1. 先通过169.254.42.1密钥SSH确认当前boot ID、完整dmesg、encoder状态和display实例。
   当前超时2、snapshot:count=0、on0；不得清空/重新武装/自动开关屏或重复刷写。
   先读86首次真实故障的prefinal/fault trace/snapshot、kms/state/clk和results-audit.json。
   核对完成中断与timer/忙标志/idle关IRQ并发，pp_tx_done的new_count是布尔返回而非计数。
   两份快照字节一致；快照历史有环形覆盖，不能称全程完整。77/80/86显示故障均开放。
2. 显示故障审阅后，用新会话的新守卫验证#87观测修正版；当前候选未部署，旧守卫不能复用。
   不运行flash-final.ps1绕过其停止保护。先保存新故障，独立检查原生命令退出码后才进入下一步。
   Native#86完整uevent失败；ONLINE/Full个别成功不等于完整接口可用。MP当前无0-005c客户端，
   QUP1=/dev/i2c-0，gauge QUP15=/dev/i2c-2、2-0055；所有工具按of_node/所有权守卫，不用FORCE。
   #87不写硬件配置，后续还需持久DT、实际输入预算、热敏校准、2719保护/短路通信及失联安全。
   OEM驱动probe会复位/关闭安全计时器，不直接运行。58首次ENXIO不盲目重试/扫描。
3. 继续无线WLFW/PD/TFTP和本机板数据，再音频/蜂窝/相机等14组硬件；Wi-Fi/MPSS禁用，
   35项固件仍私人归档。90Hz、休眠、GPU频点/压力、触摸校准、OTG/USB3仍需独立验收。

Linux源码/home/cy122/x2pro-linux/linux，initramfs/home/cy122/x2pro-linux/initramfs。
保留全部dirty修复、init/USB hook/SSH身份及0011/0012/0013/0014，不运行旧build-image.sh。
源码Image当前是未部署#87，手机仍#86，不能把宿主产物当实机状态。EUD TOP_CFG0x11、
整帧/RX53/F1/两终端保持，必要时既有com-up只恢复COM/VBUS，不写CHGR；只允许已授权
boot/logdump部署，按PARTNAME/大小/序列/哈希规则；保留Android/数据/GPT。只发布fork/master。
二进制/镜像/全配置/完整源码、Android DT/固件和身份密钥保留私人目录。权限足够、gh可用；
没有审批阻挡。原厂NTC/watchdog继承关闭等不是推荐设置，近满电平均0mA不是充电速率验收。
