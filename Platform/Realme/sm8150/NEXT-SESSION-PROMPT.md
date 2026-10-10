继续无人硬件接入目标。先读NEXT-SESSION.md、sessions/75和reference/kernel75/README.md。
当前#76已启用A640/GMU，本机签名固件、Turnip真实渲染/读回与fence累计39096次通过。
物理花屏已通过非连续DSI时钟/清继承位修正；用户确认全白及fresh-boot首次彩条正常，
最终两启动日志无DSI/SMMU/Oops、taint0，12次混合显示电源循环通过。保留0011/0012、
EUD/TOP_CFG0x11/整帧/RX53/F1/两终端、触摸/CPU/UFS/NCM SSH及本地SSH身份。
下一项查本机电量计和MP2650原厂资料/主线支持，再无线/音频；不套其它板电压。
实际WSL源码/initramfs，别运行旧build-image.sh；DT变更必须进实际UEFI；仅boot/logdump、
PARTNAME核对，保留Android/数据/GPT，专有固件/镜像/密钥不发布，只推fork/master。
冷断电、90Hz、休眠、GPU各频点压力、OTG/USB3仍待验。全硬件目标active。
