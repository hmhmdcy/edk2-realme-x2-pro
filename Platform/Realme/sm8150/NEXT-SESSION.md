# 下一阶段：显示超时与 OPLUS 本机保护链（session82）

先读sessions/82-charging-policy-units-and-android-backup-provenance.md、reference/kernel82，
再读81的显示/Wi-Fi证据和80/79/76。当前状态与边界：

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

81确认原厂封存/计量位，电池与内部温度不同，但温度选择/校准/独立保护仍未验收。
77间歇性首次接管问题和80两次frame-done timeout仍开放，81的600翻转通过不等于根因修复。
下一步可准备保留既有修复的FTRACE诊断内核；当前FTRACE关闭，不能自动开关屏掩盖故障。
Wi-Fi四轨已继承，本机35项固件私人归档、未装载；远端WLFW/PD/TFTP和板数据仍需受限实测。
全硬件目标active，显示/充电/无线及音频、蜂窝、摄像头等尚未全部完成。

先读sessions/79-mp2650-read-only-bus-and-current-settings.md、reference/kernel79/README.md，
再看session76充电来源、session77电量计/失败及session78显示对照。

已部署仅四项总线属性的boot：GPI0/QUP0/I2C1启用，400kHz，没有充电器子节点。
Image/config/logdump和既有显示/GPU/EUD/init/USB身份代码未变。
MP2650/0x5c三次共36组合读成功、配置一致；工具验证QUP1 of_node，固定12个寄存器，
没有配置数据写、故障REG14读、ADC启用、复位、喂狗、GPIO/OTG/BATTFET操作。
当前NTC检查关闭、看门狗关闭，终止及12小时安全计时器开启；CHG_EN1是继承值。
设置为300mA、每节4362.5mV；标称输入900mA假定10mΩ，实际电阻/USB预算尚未验证。
不得把当前配置当成推荐参数，不能认定OTP来源或充电安全可用。

当前boot_id=87753933-4992-45d2-aaf5-d9db9c11d1a3，taint0，约196秒DSI0、panel enable1。
600双缓冲翻转/完成事件及CRC通过；没有新光学观察、GPU压力、90Hz、休眠或充电验收。
电池包8.643V、SOC99%、约30°C，读数0mA且sysfs偶见-2mA，未做校准放电验收。
新的实际总线：MP2650 QUP1=/dev/i2c-0；触摸1-0020；BQ28Z610 QUP15=/dev/i2c-2、2-0055。
每次按of_node定位，禁止照用session77硬编码/dev/i2c-1的gauge脚本。

下一步核实热敏电阻接线与gauge温度可信度、双串保护/均衡、PM8150b/SMB5输入路径、
USB供电识别及预算，查明当前/默认参数来源、故障读后语义、终止/超时和失联状态。
软件轮询不能自动替代独立温控，watchdog恢复默认不等于关闭充电。
不绑定原厂写配置probe，不解封gauge，不更新NVM/OTP，不刷快充MCU；普通受限供电先行。
权限足够，gh API已成功，本轮没有权限/自动审批阻挡；问题是本机保护链适配与验证。

显示首次接管间歇故障仍开放，session77失败未因后续成功而失效。
故障时先挂debugfs保存kms/state/clk_summary和完整日志，再恢复；不自动开关屏掩盖。
实际PHY7nm-8150/V4.0、10nm关闭，实际源码HEAD e42788eafb0bb9d8dfce319c71ca54c5207b2295
是本地EUD提交，不能当上游SHA。保留0011/0012/0013/0014和所有重要dirty修复。

当前boot sha08edf9bcc1c55977169b0a8fd9f963805ba98d0423929e09e17bb9f811ca7405，6682624字节，
logdump sha607fc6b4b0caba8ca5c7ea6677fd8259c81a216f91b2d6de7603e3f56d9881d0，设备端回读通过。
回退boot=kernel79/boot-before.img，sha3fbbd0eecf7e793f97920d55bd9ec2a30329d6e53edb307200160a23e1de923e，
logdump不变；session75光学/GPU基线仍可回退，见此前记录。

实际Linux/home/cy122/x2pro-linux/linux、initramfs/home/cy122/x2pro-linux/initramfs，
Git/home/cy122/edk2-samurai/repo。不运行旧build-image.sh，保留init/USB hook/SSH身份。
EUD/TOP_CFG0x11/整帧/RX53/F1/两终端保持；SSH/SCP工具reference/kernel72。
仅boot/logdump且按PARTNAME核对；保留Android/数据/GPT，固件/镜像/密钥不发布，仅fork/master。
COM和WSL USB owner已释放；全硬件目标active，无线/音频/蜂窝/摄像头等仍未完成。
