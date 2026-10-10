继续无人全硬件目标。先读NEXT-SESSION.md、sessions/85和reference/kernel85，再84/83/82/81/80/79/77。

session85沿用session84的#85诊断Image，未改内核/DT/initramfs、重启、开关屏或写分区。
boot ID=f02d218a-cc7d-4b92-8858-c8eeaeab5777，末次2477.32秒taint0、显示超时0/下溢0。
display实例on1、nop/mono、2051KiB/CPU、snapshot:count=1待真实故障；77/80故障仍开放。
QUP15/58的唯一身份00读返回ENXIO，未继续02/03；不等于器件不存在或保护正常/失效。
精确FFA5/2719/FW守卫后的原厂004b返回LION，0054位28为0，响应echo/长度/checksum通过。
官方Android R/cyborg两套头文件定义FFA5；温补布尔属性在两套节点及本机Android最终归档均缺省。
该归档没有选择OPLUS均衡温补分支，不能据此推广所有板型或确认热敏校准。
原厂short OTP检查在未就绪/不存在时返回true，不能把该容错当独立保护通过。
三次MP2650十二固定值与84基线一致；末次99%/8.638V/31.2°C/平均0mA/Not charging。
电量可读、充电状态仅电量计侧、满电读数不能证明充电慢；Linux充电控制/保护仍未验收。
MP继承CHG_EN1、NTC/watchdog关闭、终止/12小时安全计时器开启，不是推荐参数。
没有配置数据写、解封/NVM/OTP/FET/OTG/MCU操作；固定查询含I2C选择/MAC请求写帧。
boot前缀6682624字节sha08edf9bcc1c55977169b0a8fd9f963805ba98d0423929e09e17bb9f811ca7405，
logdump完整64MiB sha60e183a6780945885a738ac1bd0c7e23ed41515bca662cb50a831ede3b57302b保持。
回退kernel84/logdump-before.img sha607fc6b4b0caba8ca5c7ea6677fd8259c81a216f91b2d6de7603e3f56d9881d0。
详见sessions/85-oem-chemistry-and-short-ic-observations.md、reference/kernel85；全硬件目标active。

1. 先通过169.254.42.1密钥SSH读uptime、完整dmesg、encoder状态与display实例trigger。
   若新增故障先停止实例并保存trace/snapshot、kms/state/clk_summary和原始日志，保留快照，
   不自动开关屏或重复刷写。当前on1、snapshot:count=1；长空闲可自然覆盖旧环形事件。
   运行时2051KiB/CPU不持久，重启仍513KiB/CPU；84首次跟踪/两次600翻页证据有效。
2. 继续充电输入预算、热敏校准、2719保护/短路IC通信和主控失联语义核实，逐项接入主线。
   58首次ENXIO不盲目改地址/协议或重试；不直接绑定会复位/写配置/关闭计时器的OEM驱动。
   电量计14平均和原厂0c瞬时语义有差别；本轮未改寄存器表，不能凭近满电0mA判断速率。
3. 同时推进无线WLFW/PD/TFTP和本机板数据；Wi-Fi/MPSS禁用、35项固件仍只私人归档。
   再完成音频/蜂窝/摄像头等，并独立验收90Hz、休眠、GPU各频点、触摸校准与OTG/USB3。

Linux源码/home/cy122/x2pro-linux/linux，initramfs/home/cy122/x2pro-linux/initramfs。
保留全部dirty修复、init/USB hook/SSH身份及0011/0012/0013/0014，不运行旧build-image.sh。
EUD TOP_CFG0x11、整帧/RX53/F1/两终端保持；必要时只用既有com-up恢复COM/NCM，
其写COM/VBUS而不写CHGR位，F1回执后设备离开EIO不重复F1。仅boot/logdump可按既有
PARTNAME/大小/序列/哈希规则部署，保留Android/全部数据/GPT；只发布fork/master。
MP QUP1=/dev/i2c-0、gauge QUP15=/dev/i2c-2、2-0055、触摸1-0020，按of_node守卫。
二进制、镜像、完整配置/源码、Android DT/固件归档和身份密钥留在私人目录。
权限足够、gh可用，没有审批阻挡；精确历史Android构建提交和完整充电保护仍未验证。
