继续无人全硬件目标。先读NEXT-SESSION.md、sessions/82与reference/kernel82，再读81/80/79/76/77/78。
本轮session82核对充电保护链，手机仍79 boot、#76，没有分区写/重启/充电参数改变。
5598秒taint0、8.639V/99%/30.8°C/平均0，MP十二字段保持；显示超时仍2、underrun0。
Android存档温控普通分支的removed/cold原始值190/20实际为−19/−2°C；各字段为0.1°C。
原厂双串策略以最高单节电压判断，主线接口报告包总电压µV，不能直接套用阈值。
离线原函数故障/25边界测试通过；旧温度首错回缓存、次错−40°C，主线TEMP直接传播errno。
USB gadget实际声明100mA，供电预算未核实；Type-C类为空、power_supply仅电量计。
重要来源纠正：boot_stock_RMX1931.img的同一历史SHA内嵌DroidSpaces/KernelSU第三方内核，
只能称Android回滚备份，不能凭文件名称OEM出厂镜像。其OPLUS保护选项启用，旧OPPO选项关闭。
早期官方短路源码是占位；同机型维护OPLUS有完整实现及均衡温度补偿，精确映射/硬件待核实。
未读0x58、未改保护/电量计NVM/FET/OTG/MCU。充电控制未验收；全硬件目标继续active。
下一步保持显示超时诊断优先，并核对OPLUS本机保护链、温度来源/补偿、USB预算和失联行为。
详见sessions/82-charging-policy-units-and-android-backup-provenance.md、reference/kernel82。

保留81原厂0054/57和标准温度依据，完整80status门槛不放宽；未知2719/FW不能推断真伪。
77首次接管失败和80两次帧超时继续开放；81复测600事件/CRC通过，计数2未增加。
FTRACE目前关闭，可准备诊断内核；不要自动开关屏掩盖故障，不把CRC当光学验收。
Wi-Fi四轨已继承，35项固件只读私人归档，MPSS/wifi禁用；远端服务/板数据未验收。
不要绑定会写配置的MP2650或OPLUS保护初始化；不解封/NVM/OTP/FET/OTG/MCU试探。
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
