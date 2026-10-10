继续无人硬件接入目标。先读NEXT-SESSION.md、sessions/77和reference/kernel77。
当前#76 Image/logdump未改；BQ28Z610已上机，两启动45个标准读数与sysfs对应，只刷boot。
两次首次启动重现DSI FIFO/MDP FIFO下溢，开关屏后停止；优先定位首次接管回归，
不得用自动开关屏隐藏。新GPU12次读回/fence通过，既有39096次/光学验收见session75。
NVM关闭、不解封，不绑定MP2650原厂probe，不改快充/OTG/电池保护参数。
温度、输入预算、终止、超时、失联行为核实后再接入充电控制；Charging/Good不是安全验收。
保留EUD/TOP_CFG0x11/整帧/RX53/F1/两终端、触摸/CPU/UFS/NCM SSH和init/身份。
实际源码/initramfs在WSL；不运行旧build-image.sh，DT必须进入实际UEFI。
仅boot/logdump且PARTNAME核对，保留Android/数据/GPT；专有固件/镜像/密钥不发布，只推fork/master。
全硬件目标active。无线、音频、蜂窝、摄像头/传感器等与90Hz/休眠/压力仍未验收。
