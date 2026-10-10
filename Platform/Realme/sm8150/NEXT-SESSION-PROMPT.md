继续无人硬件接入目标。先读NEXT-SESSION.md、sessions/73和reference/kernel73/README.md。
当前#64原生SOFEF03F 1080×2400@60 DSC/硬件CRC/两次启动各三次显示电源循环通过，
NCM SSH169.254.42.1、触摸/CPU/UFS/EUD保留，taint0。先用新完整日志排查首次接管
SMMU fault（旧splash0x9dxxxxxx，SID0x800/0xc20），再接入本机Adreno640/GMU并验证
真实渲染，随后电池/充电、无线/音频等。GPU仍disabled，renderD128不能当成功证据。
本机GPU固件只读提取保留在kernel73/gpu-firmware-stock.tar，manifest有哈希/ELF几何；
不发布专有blob。实际WSL Linux/initramfs保留，不运行旧build-image.sh。DSI REFGEN
内建/defer60秒保留，DT变更要进入实际UEFI固件；按PARTNAME核对分区，别猜sde号。
只写boot/logdump，保留Android/全部数据、TOP_CFG0x11/整帧/RX53/F1/两终端，owner
finally释放，只推fork/master。90Hz/休眠/光学图像、亮度硬件读回及其它硬件仍待验。
