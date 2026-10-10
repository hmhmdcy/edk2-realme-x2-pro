# 下一阶段：显示超时与本机充电保护链（session81）

先读sessions/81-stock-gauge-state-temperature-and-display-timeouts.md和reference/kernel81。
用户确认电池从未更换；不从扩展2719推断真伪/替代型号。手机仍session79 boot、#76内核。
本轮只做有依据的查询及固件只读提取，没有分区写、重启、充电配置或开关屏。
原厂0054 payload386封存位=3，0057 payload18计量启用位=1；回显/长度/checksum均通过。
先用旧式FFA5、扩展2719及精确FW指纹守卫，再限于这两个原厂R请求；80完整status
门槛未放宽，0051/0053/0072未查询。固定MAC请求含I2C写帧，不是配置/NVM写。
标准06温度3037(约30.6°C)、28内部3025(约29.4°C)，不能据此认定TS1/保护已验收。
MP2650十二字段与79/80一致；3608秒taint0、8.639V/99%/30.6°C/平均0、Not charging。

重要纠正：80原始日志已有1545.683499/1775.069790秒两次frame done timeout，先前
DSI等模式检查漏掉这类DRM错误；历史文件不改。encoder的frame_done_cnt实际累计超时。
81保存当前kms/state/clk_summary后600事件/CRC通过、1199行全对应已知缓冲，20.044934秒；
超时计数前后2、underrun0，无显式disable/开关屏。没有新光学/GPU验收，故障仍开放。
优先跟踪空闲/控制台更新后的kickoff/IRQ/电源恢复；当前FTRACE关闭，可准备诊断内核。
不要把持续刷新通过当成根因已修复，也不要把后续快照当成故障瞬间寄存器。

无线：本机四项供电由MTP正确继承；保留区9b000000+180000、原厂MSA请求100000。
从本机modem vfat ro提取wlanmdsp和34项bdwlan，35项仅私人归档，未安装/加载。
vendor ro,noload和modem ro的前后整分区哈希一致且已卸载。当前wifi/MPSS仍禁用，
ath10k未启用；PD mapper有modem/wlan_pd，PAS auto_boot=false，远端加载链仍要实测。
没有运行tqftpserv/rmtfs或开启无线；只能在受限方案下继续，不能写Android存储/校准数据。
权限足够，保护链/温度选择/校准/USB预算和失联仍需依据；不通过提高授权绕过验证。

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
