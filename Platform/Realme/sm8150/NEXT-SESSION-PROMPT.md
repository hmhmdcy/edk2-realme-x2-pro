继续无人全硬件目标。先读NEXT-SESSION.md、sessions/83与reference/kernel83，再读82/81/80/79/76/77/78。
本轮session83依据用户确认的Android11底包，定位官方Android R与cyborgdc2000内核/设备树。
官方4.14.190与cyborg 4.14.356-openela-rc1固定快照的电量计/短路保护源码完全相同。
两套19781板的14项选定充电策略原始值均与本机Android归档一致，QUP1/5c、QUP15/55/58对应。
cyborg的oppo DT前缀与oplus OF表不同，但I2C名称后缀可命中id_table，不能据此前缀认定未绑定。
MP2650初始化不同，且两套都会关闭硬件安全计时器；禁止直接运行写配置初始化。
旧4.14.83占位保护只作历史参考；主要依据改为Android R、用户作者固定源码及本机存档。
尚未证明备份对应精确构建提交，2719身份/保护阈值、热敏补偿、USB预算及失联安全待核实。
本轮无设备访问；最新实机记录仍82的5598秒taint0、8.639V/99%/30.8°C，MP保持、显示超时2。
充电控制未验收，权限足够；不解封/NVM/OTP/FET/OTG/MCU试探，全硬件目标保持active。
详见sessions/83-androidr-and-cyborg-charging-source-comparison.md、reference/kernel83。

保留82温控负幅值/包电压单位与错误路径测试、Android回滚备份来源纠正及USB100mA声明依据。
普通温控removed/cold为−19/−2°C；双串最高单节电压与主线包电压µV不能直接套阈值。
显示77首次接管失败和80两次超时继续开放；准备保留既有修复的FTRACE诊断。

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
