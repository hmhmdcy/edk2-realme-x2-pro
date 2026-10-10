# 下一阶段交接：显示接管与GPU（2026-10-10，session73）

手机#64，boot_id=fc4fe164-1e90-402a-b841-ce870ba9ddfb、taint0。SOFEF03F原生
1080×2400@60 DSC已自动接管；两次启动各完成彩条—白屏—彩条硬件CRC、三次显示
关闭/开启及60次vblank等待（约0.99秒）。面板DCS状态0x9c，120/256/400亮度写入
通过；亮度硬件读回/实际光学图像没有验收，90Hz/休眠与GPU渲染也未验收。
最终59284字节dmesg、5492字节facts均按设备SHA/gzip CRC/长度通过。

显示接管时有10条SMMU context fault，地址在旧splash 0x9dxxxxxx、SID0x800/0xc20，
后续KMS/电源循环未再记录故障。先排查旧DPU/CTL路径与IOMMU映射切换。维护者2022
讨论的CTL_FETCH_ACTIVE方案对应较新DPU，不能不核对就套SM8150 DPU5。
原生驱动/DSC输出工作不等于启动交接已修好；完整失败/限制见sessions/73。

GPU/GMU DT仍disabled，renderD128不能当GPU成功证据。已从本机vendor只读ro,noload
复制a640_gmu.bin、a630_sqe.fw和a640_zap ELF/mdt/b00..02，随后卸载vendor。
本地E:\edk2-samurai-out\kernel73\gpu-firmware-stock.tar（SHA83df98ec…），固件
未入Git；reference/kernel73/gpu-firmware-manifest.json有全部哈希/ELF header。
zap.elf是完整ELF32，LOAD offset0x3000、paddr0x5000、memsz1968、reloc标记；
须核对主线PIL/MDT loader和本机gpu_mem0x99515000+0x2000再打包，不猜其它板的固件。
GPU后推进电池/充电、无线/音频等14组功能；保留各项验收边界。

SSH用reference/kernel72/usb-ssh.ps1，169.254.42.1/16；SCP用scp-usb.ps1（-O）。
本地私钥/known_hosts在E:\edk2-samurai-out\kernel72，手机独有主机身份跨重启保留。
Windows系统UsbNcm自动APIPA，别改默认路由；真实SSH认证才代表服务就绪。
COM14最后Windows/Shared/未Attached，五个相关PnP节点OK，终端与USB owner均释放。
重启后原生命令K73_REBOOT_EUD_OK通过（两帧ACK，无重试），前三次F1回执也保留。

实际内核/home/cy122/x2pro-linux/linux，v7.3-rc6+a90ee430；实际initramfs在
/home/cy122/x2pro-linux/initramfs，保留EUD/USB hook/本地SSH身份，别覆盖为旧快照。
native代码增量linux-port/patches/0009、kernel73-builtins.config及dts源码；
面板binding dt-doc-validate/目标dtbs_check、checkpatch和两次Image构建通过。
CONFIG_REGULATOR_QCOM_REFGEN=y、defer60秒不可遗漏；显示时钟用SM8250共享驱动，
不存在SM_DISPCC_8150选项。#63手动reprobe仅用于定位；#64必须自动绑定。

已部署boot-k73-display.img（57508887131ae55cf9465fa1a44280fa45b507a3439345ffe635dc7544eaa999）
和logdump-k73-display-deps.img（c7778d45c336b35cf75c2842c083b513343f59a0a1864fe52ad2105d3d55e6c7）。
两者实际分区哈希见final-facts；旧cycled-facts的/dev/sde9是dsp，不能当logdump证据。
save-facts.sh已改按PARTNAME查找（本轮logdump=/dev/sde32，boot=/dev/sde11）。
立即回退成对刷kernel73/boot-before.img与logdump-before.img；不混用旧DTB/新Image。
一共一次boot、两次logdump写入；同镜像复测只reboot。Android/全部数据/GPT保留。
仅允许部署boot/logdump，只推fork/master，保留TOP_CFG0x11/整帧/RX53/F1/两终端。
