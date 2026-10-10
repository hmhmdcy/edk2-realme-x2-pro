继续无人硬件接入目标。先读NEXT-SESSION.md、sessions/80和reference/kernel80，再读79/76/77/78。
session80未刷写/重启：原厂电芯接口4321+4321=8642mV，与标准总电压一致。
旧式DeviceType为FFA5，扩展2719有效但未映射到确切芯片/固件；TI官方型号2610。
FW有效负载2719000400060003850200未解码，005x/0072未查询；不可绕过status身份门槛。
优先核实兼容性、独立温度和保护链；不预设电池更换/真伪，不提高权限跳过硬件依据。
权限足够。可继续有依据的固定原厂测量，禁止解封/NVM/OTP/FET/OTG/MCU试探。
最终1772.71秒taint0/DSI错误0，MP寄存器与79一致；没有新光学/GPU/pageflip测试。
当前boot为session79仅总线候选，Image/config/logdump仍#76。MP2650 QUP1=/dev/i2c-0，
gauge QUP15=/dev/i2c-2、2-0055，触摸1-0020；按of_node找总线，旧硬编码脚本不能直接运行。
MP2650三次36组合读成功，当前NTC/watchdog关闭、终止/12小时安全计时器开启。
未写配置数据、REG14/ADC/复位/喂狗/GPIO未操作，没有充电控制验收。
优先核实本机温控/双串保护/SMB5输入预算/故障语义/默认来源/终止超时及失联状态。
权限足够、gh API已成功；不绑定原厂写配置probe，不解封/NVM/OTP或快充MCU编程。
保留0011/0012/0013/0014、gauge NVM关闭，以及实际树的重要dirty修复。
session79 DSI0/600双缓冲事件CRC通过，session77间歇性失败仍开放；故障先挂debugfs采样再恢复。
实际PHY7nm-8150/V4.0、10nm关闭，源码HEAD为本地EUD提交，实时核对，不重置。
保留EUD/TOP_CFG0x11/整帧/RX53/F1/两终端、触摸/CPU/UFS/NCM SSH/init与身份。
实际源码/initramfs在WSL，不运行旧build-image.sh，DT必须进入实际UEFI。
仅boot/logdump且PARTNAME核对，保留Android/数据/GPT，固件/镜像/密钥不发布，仅fork/master。
全硬件目标active；尚无新光学/GPU压力/90Hz/休眠/充电验收及其它硬件完成证据。
