继续无人硬件接入目标。先读NEXT-SESSION.md、sessions/74和reference/kernel74/README.md。
当前#68显示接管已在两次启动与18次显示电源循环验证，无SMMU/DSI/vblank警告、taint0；
原生60Hz DSC/CRC、NCM SSH169.254.42.1、触摸/CPU/UFS/EUD保持。接下来接入本机
Adreno640/GMU并验证实际渲染；GPU仍disabled，renderD128不能当成功证据。
本地kernel73/gpu-firmware-stock.tar与kernel74/gpu-loader-validation.json已核对七固件哈希、
ELF分段/metadata及4KiB LOAD符合8KiB carveout，但PAS/GMU/渲染仍待真机验证。
保留0010显示接管补丁、真实WSL Linux/initramfs/init/USB hook与本地SSH身份，
不用其它板签名blob，不发布专有固件，不运行旧build-image.sh。REFGEN内建/defer60秒保留。
DT变更需进入实际UEFI固件，按PARTNAME核对分区；只写boot/logdump，保留Android/全部
数据/GPT、TOP_CFG0x11/整帧/RX53/F1/两终端，owner finally释放，只推fork/master。
GPU后电池/充电、无线/音频等；90Hz/休眠/光学与亮度读回及其它硬件仍待验。
