# 下一会话交接：原生显示/GPU（2026-10-10，session72结束）

手机运行#62，boot_id=5ecfab9e-fa56-4ead-acf8-a5147904980e、taint=0。本轮实现并部署普通USB
CDC NCM/自动公钥SSH/SCP，Windows系统UsbNcm工作且EUD共存，设备协商high-speed。
部署前后双向各4MiB随机文件通过SHA，错误0；独立同镜像重启无需host com-up也可
认证SSH。完整53594字节dmesg、2285字节facts已按设备SHA/gzip CRC/长度校验。
只刷一次logdump，boot仍为session71触摸固件，Android/所有数据/GPT保留。

手机USB地址169.254.42.1/16，电脑自动APIPA；无需改主机默认路由或换驱动。
本地专用SSH私钥：E:\edk2-samurai-out\kernel72\id_ed25519；known_hosts同目录。
日常命令用reference/kernel72/usb-ssh.ps1，SCP用scp-usb.ps1（显式-O）。
手机主机身份跨重启保留，私钥只在本地实际initramfs/构建目录；两份私钥都未入Git。
COM14最后Windows/Shared/未Attached，9501/9500/9505及NCM节点OK，无host连接owner。
第一次在NCM枚举刚出现时SSH未就绪，之后认证成功；等真实回执，不能以PnP等同服务就绪。

下一项推进本机SOFEF03F原生面板/DSI/DSC及GPU/GMU。首先通过新的SSH通道保存完整
日志和显示/固件状态，检索Realme 19781本机源码及主线维护者实现，然后完成板级
供电/时钟/固件/数据流的实现、构建、boot/logdump部署与验收。之后电池/充电、
无线/音频等。当前屏幕仍是UEFI帧缓冲诊断控制台，未安装完整GUI/rootfs。
触摸保留S3706A基本点按/移动/释放/多点证据；精度/方向/严格触点数/休眠尚未验。
USB本轮证明设备模式/NCM/SSH，OTG/USB3/休眠恢复尚未验。不要声称全硬件已完成。

实际内核/home/cy122/x2pro-linux/linux；实际initramfs/home/cy122/x2pro-linux/initramfs。
真实init仅增加configfs后的异步samurai-usb hook，其余EUD逻辑逐字保留；不要运行
旧build-image.sh。内核配置只改INITRAMFS_ROOT_UID/GID=1000以打包root权限。
EUD/earlycon/RMI I²C/DTS/DTB哈希不变。代码：linux-port/scripts/samurai-usb.sh及
build-dropbear-usb.sh；实测/源码/打包核对在sessions/72与reference/kernel72。
logdump-k72-ncm-ssh.img的SHA为13a8263dac6c75f909b6fa8dc89520949c7009ddcb9de2b2a5f6125e26d4292b。
立即回退是E:\edk2-samurai-out\kernel71\logdump-k71-touch.img；boot不用回退。
logdump仍只有约34.35MiB空闲，未确定安全的大持久rootfs位置。

执行边界：保留Android/所有数据，只部署boot/logdump；保留TOP_CFG0x11/整帧/RX53/
F1/两终端，接口单owner并finally释放，只推fork/master。Windows单次F1无回执仍有
记录，既有WSL方法有新F1回执/独立fastboot确认；不恢复旧EUD参数实验。
本輪日期解析/过早枚举查询的失败记录保留并明确废弃错误elapsed字段。
