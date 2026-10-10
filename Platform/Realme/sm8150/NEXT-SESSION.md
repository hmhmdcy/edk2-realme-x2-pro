# 下一阶段交接：Adreno640/GMU（2026-10-10，session74）

当前#68，boot_id=2412cbe2-9f1d-4ea4-9c0b-8a19d4ff6568、taint0。两次自动启动无SMMU context fault、
DSI错误、vblank WARNING；每次三组A/B/A CRC和九次显示电源循环通过，合计18次。
SOFEF03F 1080×2400@60 DSC、面板0x9c、120/256/400亮度写入保持。
最终dmesg 56978字节/facts 5493字节，设备SHA/gzip CRC/长度均通过。
这只证明已捕获的启动和显示测试；冷断电、90Hz、休眠、光学图像、亮度硬件读回未验。

0010增量补丁实现IOMMU换域前停止INTF1自动刷新、按旧vdisplay等候帧结束（最多50ms）、
关闭TE，清空旧CTL0的LM/INTF/DSC，刷新/提交后再复位，取消等待TE的空kickoff。
仅sm8150-dpu执行。#65启动成功但暖重启vblank失败，#66无start产生iova0 fault，
#67停TE/解除输出后仍有DSI下溢；均保留完整日志，不是成功基线。
#68两次自动启动成功，不要回退为那些中间候选。实际Linux源保留已有EUD/RMI/RPMh补丁。

下一项GPU/GMU。DTS仍disabled，renderD128来自MSM注册，不表示GPU成功。
本机vendor曾以ro,noload挂载提取固件并卸载，本地
E:\edk2-samurai-out\kernel73\gpu-firmware-stock.tar，SHA83df98ec…；专有blob不入Git。
reference/kernel73/gpu-firmware-manifest.json与kernel74/gpu-loader-validation.json
已核对七文件哈希、ELF/分段/metadata相等、可重定位LOAD需4KiB，gpu_mem
0x99515000+0x2000足够。可以保留全ELF内容按板级firmware-name命名，但PAS认证、
GMU启动和实际渲染必须真机验证。不要使用其它板的签名zap固件。
主线a640.1使用a630_sqe.fw/a640_gmu.bin，优先核对板级供电/OPP/内建依赖后接入。

SSH用reference/kernel72/usb-ssh.ps1，169.254.42.1/16；SCP用scp-usb.ps1（-O）。
本地客户端私钥/known_hosts在kernel72，手机主机身份跨重启保留；别改默认路由。
Windows系统UsbNcm自动APIPA；服务以实际密钥认证为准。重启后先eudtool com-up，
再用新F1前缀与有界fastboot枚举确认；最终COM14在Windows Shared/未Attached、
相关五PnP节点OK，所有任务连接owner已释放。

实际内核/home/cy122/x2pro-linux/linux；真实initramfs在/home/cy122/x2pro-linux/initramfs，
保留init/USB hook/SSH身份，别运行旧build-image.sh。保留REFGEN=y/defer60秒。
本轮未改DTS、面板、配置、UEFI或boot，只四次logdump部署；同镜像复测只reboot。
已部署kernel74/logdump-k74-drain.img：8e43d13658a1d332c441f68a6008e7ebb855177b59fbeb447a196195239f1ee5。
boot仍kernel73/boot-k73-display.img：57508887131ae55cf9465fa1a44280fa45b507a3439345ffe635dc7544eaa999。
实际分区哈希在final-facts；按PARTNAME查找，本机logdump=/dev/sde32、boot=/dev/sde11。
立即回退只刷kernel74/logdump-before.img（c7778d45…），保留当前boot。
仅boot/logdump、保留Android/全部数据/GPT、TOP_CFG0x11/整帧/RX53/F1/两终端，
单owner/finally释放，只推fork/master。全硬件目标仍active，GPU后推进电池/充电等。
