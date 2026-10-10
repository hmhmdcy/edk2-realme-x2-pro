继续无人硬件接入目标。先读NEXT-SESSION.md、sessions/78和reference/kernel78。
当前保留session77 boot、#76 Image/logdump；BQ28Z610标准只读监测保持。
session77两次首次启动DSI下溢，session78同镜像三次错误0、600双缓冲翻转/CRC通过，
未开关屏。一次旧帧停滞也正常，间歇性根因未定，不能宣布修复或归因gauge。
故障重现时先保存kms/state/clk_summary及完整日志再恢复，必要时受限FIFO原始位诊断。
实际PHY是7nm-8150/V4.0，10nm关闭；源码HEAD是本地EUD提交，实时核对，不能重置。
保留0011/0012/0013与电量计NVM关闭，不解封、不绑定MP2650原厂写配置probe。
确认温控、输入预算、终止、超时、失联后再接入充电；Charging/Good不是安全验收。
保留EUD/TOP_CFG0x11/整帧/RX53/F1/两终端、触摸/CPU/UFS/NCM SSH和init/身份。
实际源码/initramfs在WSL，不运行旧build-image.sh，DT必须进入实际UEFI。
仅boot/logdump且PARTNAME核对，保留Android/数据/GPT，固件/镜像/密钥不发布，只推fork/master。
全硬件目标active；未新取得光学/GPU压力/90Hz/休眠/充电及其它硬件验收。
