# 下一阶段：间歇性显示首次接管与充电安全（session78）

先读sessions/78-first-boot-display-controls-and-pageflips.md、reference/kernel78/README.md，
再看session77两次失败、电量计接入及session76充电研究；session75是光学/GPU回退基线。

本轮未部署内核/固件或写分区，保留session77 boot和#76 Image/config/logdump。
相同镜像三次首次启动DSI错误0；第三次600双缓冲翻转/事件/CRC通过，未请求开关屏。
一次旧帧停滞也能正常刷新，根因未定，不能认定gauge为原因或宣布间歇性故障修复。
需要失败时恢复前的kms/state/clk_summary及完整日志，必要时受限FIFO原始位诊断。

当前boot_id=e1a36cea-f401-41f2-bd1a-1eedf1282e96，taint0；约669秒时DSI0、
panel enable日志1；电池包8.645V、SOC100%、29.7°C、电流0、Not charging。
未新做光学、GPU压力、90Hz、休眠或充电测试；只读gauge与其它验收边界保持。

实际PHY为qcom,dsi-phy-7nm-8150、7nm/V4.0，10nm关闭。实际源码HEAD
e42788eafb0bb9d8dfce319c71ca54c5207b2295是本地EUD提交，不是可直接引用的
Torvalds上游SHA；重要修复仍未提交在该树。实时核对源码，不重置，不沿用未核对
的摘要SHA。保留0011/0012/0013；跨启动寄存器差异不等于故障原因。

kms-pageflip使用两固定缓冲区与完成事件，无显式CRTC disable；DIRTYFB活动
缓冲区重写有过渡混合CRC，不能替代双缓冲验收。所有新日志SHA已与设备端对应。

充电控制未接入。BQ28Z610在&i2c15/100kHz/0x55，实际1-0055，NVM更新关闭。
不解封、不添加monitored-battery/充电器/保护编程，不绑定原厂MP2650写配置probe。
先审查本机温控、输入预算、终止、超时、失联及故障行为；Charging/Good不是安全验收。

当前boot sha3fbbd0eecf7e793f97920d55bd9ec2a30329d6e53edb307200160a23e1de923e，
logdump sha607fc6b4b0caba8ca5c7ea6677fd8259c81a216f91b2d6de7603e3f56d9881d0，
已重新设备端回读。回退boot=kernel77/boot-before.img，sha
43ddcba2444e1672cd95205f6984c761eaeb59c83162cffdffb371c50a29c37b，logdump不变。

实际Linux/home/cy122/x2pro-linux/linux、initramfs/home/cy122/x2pro-linux/initramfs，
Git/home/cy122/edk2-samurai/repo。不运行旧build-image.sh，保留init/USB hook/SSH身份。
EUD/TOP_CFG0x11/整帧/RX53/F1/两终端保持；SSH/SCP工具reference/kernel72。
只写boot/logdump且按PARTNAME核对；Android/数据/GPT保留，固件/镜像/密钥不发布。
COM/USB owner finally释放，本轮helper均退出，无WSL附着；只推fork/master。
全硬件目标active；无线、音频、蜂窝、摄像头/传感器及长期验收仍未完成。
