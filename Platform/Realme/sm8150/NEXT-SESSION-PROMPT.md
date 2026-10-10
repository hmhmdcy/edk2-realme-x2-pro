继续无人全硬件目标。先读NEXT-SESSION.md、sessions/84与reference/kernel84，再83/82/81/80/79/77。
session84已部署保留现有硬件修复的#85诊断Image，仅两次写logdump；boot保持session79。
当前boot ID=f02d218a-cc7d-4b92-8858-c8eeaeab5777，404.09秒完整采集、513.90秒复查均taint0、
显示超时0/underrun0。首次65.28秒跟踪21409事件、无缓冲丢失，snapshot:count=1实际安装。
两个600翻页/CRC均通过；第一次跟踪覆盖6055事件，运行时扩为2051KiB/CPU后第二次无损。
display事件实例已重新开启，一次性快照待真实超时验证；77首次接管/80两次超时仍开放。
#84缺HIST_TRIGGERS/DRM通配失败、EUD等待过短及一次SCP中断均保留，不自动开关屏。
源码/DTS/initramfs CPIO/SSH身份保留；FUNCTION_TRACER关闭，当前FTRACE事件跟踪已启用。
boot前缀sha08edf9bcc1c55977169b0a8fd9f963805ba98d0423929e09e17bb9f811ca7405（6682624字节），
当前64MiB logdump sha60e183a6780945885a738ac1bd0c7e23ed41515bca662cb50a831ede3b57302b。
回退kernel84/logdump-before.img sha607fc6b4b0caba8ca5c7ea6677fd8259c81a216f91b2d6de7603e3f56d9881d0。
充电控制未启用；404.09秒8.638V/99%/31.4°C/0mA，MP2650十二个固定值与部署前相同。
session83官方Android R/cyborg及Android11底包对照有效；2719/短路保护、温度补偿、USB预算
和失联安全仍未验收。未更换电池不用于推断器件真伪；不解封/NVM/OTP/FET/OTG/MCU试探。
详见sessions/84-display-boot-tracing-and-timeout-snapshots.md、reference/kernel84；全硬件目标active。

1. 先通过169.254.42.1密钥SSH读取uptime、完整dmesg、encoder状态和display实例trigger。
   如出现超时/首次接管故障，先停止实例并保存trace/snapshot、kms/state/clk_summary和原始日志，
   保留快照，不自动开关屏、不重跑历史刷写脚本。当前on1，snapshot:count=1；空闲环形缓冲
   允许自然覆盖旧事件。运行时2051KiB/CPU不持久，重启仍513KiB/CPU。
2. 没有新增故障则继续Android R/cyborg保护链、热敏/均衡温补/USB预算与失联语义核实，
   再推进无线WLFW/PD/TFTP和本机板数据。Wi-Fi/MPSS仍禁用，35项本机固件仅私人归档。
   不直接绑定会复位/写配置/关闭安全计时器的MP2650或OPLUS保护初始化。
3. 独立完成90Hz、休眠、GPU各频点压力、触摸校准及OTG/USB3，再音频/蜂窝/摄像头等。

实际Linux源码/home/cy122/x2pro-linux/linux，initramfs/home/cy122/x2pro-linux/initramfs。
不运行旧build-image.sh；保留全部dirty修复、init/USB hook/SSH身份及0011/0012/0013/0014。
EUD TOP_CFG0x11/整帧/RX53/F1/两终端保持；COM/NCM重启可能需既有com-up恢复。
该流程只写COM/VBUS控制位，不写CHGR_EN/INT；F1回执后设备离开EIO不应重复F1。
只写boot/logdump且按PARTNAME/大小/序列/哈希核对，保留Android/全部数据/GPT，仅fork/master。
当前MP2650 QUP1=/dev/i2c-0、gauge QUP15=/dev/i2c-2、2-0055、触摸1-0020；按of_node守卫。
镜像、完整配置、initramfs身份清单、固件、二进制工具和密钥留在私人目录。
