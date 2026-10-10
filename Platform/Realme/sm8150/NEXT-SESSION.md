# 下一阶段：Wi-Fi硬件适配（session87阶段收尾）

先读sessions/87、reference/kernel87，再81无线固件/供电与86现场；充电记录查83/85/86。

session87按用户要求收尾充电阶段，下一项硬件优先Wi-Fi，不继续重复充电查询。
手机仍#86，boot ID=32bf2d8f-8dde-47dc-9b88-e87db9e95198；2140.55秒taint0、超时2/下溢0。
display实例on0/count=0，首次真实故障快照摘要与86一致；未清空、重武装、开关屏或重启。
花屏在75非连续DSI时钟修正后得到光学确认；后续显示超时仍开放，无本轮新光学验收。
宿主#88显示timer候选编译通过，旧函数回归失败/候选六场景通过；未部署或实机验证。
原trace在日志/快照之后，86的timeout时间不是回调开始时间；根因不能由此前时间差确定。
既有dirty修复、30源文件模式、14个initramfs文件/308链接及config/CPIO保留，仅两DPU源改动。
电量等标准属性可读；86 MP ONLINE/Full成功但ADC导致空uevent，完整接口失败。
MP修正版#87未部署，手机没有MP客户端/持久DT节点；控制、保护、输入预算等仍在待办。
此前99%/8.636V/31.5°C/平均0mA属于近满电观测，不能判慢充；原厂继承配置不视为安全验收。
Wi-Fi当前WLAN关闭，QRTR/QMI/PAS/PD等为模块，宿主initramfs/实机无/lib/modules。
最小诊断片段已实际Kconfig解析通过，27符号变化；该Wi-Fi配置尚未构建Image或部署。
35项本机私人固件重新校验；四路供电已继承，Wi-Fi/MPSS仍禁用，实际QMI chip/board ID未知。
本轮无分区写/充电配置/NVM/OTP/FET/OTG/GPIO/MCU操作；不启动modem/rmtfs。
现场/构建/回归/边界见sessions/87-stage-wrap-up-and-wifi-prerequisites.md及reference/kernel87。

1. 先继续Wi-Fi适配：读87的wifi-prerequisites.config/prepare-wifi-profile.py/audit和81固件/供电。
   WLAN/SNOC及QRTR/GLINK/QMI/PAS/SYSMON/PD候选内建；RFKILL与SYSMON原模块依赖已处理。
   先构建隔离的诊断依赖镜像并审查固件服务；现有#88不含Wi-Fi配置，不能直接称无线候选。
   复用原始init/USB hook/SSH身份、全部现有修复和本机供电/保留区，不使用旧build-image.sh。
2. 验证本机WLFW/PD/TFTP链和chip/board ID，再选精确板数据、无线接口/扫描/连接及流量。
   不从35个bdwlan文件任挑默认，不混用他机mdsp；SNOC firmware-name当前用于板名。
   tqftpserv原实现支持WRQ/存储写，必须审阅并准备明确拒绝写的服务；当前未构建/运行。
   MPSS节点仍disabled且PAS默认auto_boot=false；不要自动启动未审阅的rmtfs等存储服务。
3. 显示与充电保留为待办，不再作为无线前置验收；全硬件目标继续，然后蓝牙/音频等。
   显示#88只是候选，真正timer/IRQ/idle根因未定；同一故障快照保持，重启前先保存现场。
   不清空/重武装/自动开关屏。Native#86完整uevent失败，MP #87同样未部署/验收。
   后续仍需ADC事件、持久DT、实际USB预算、热敏校准、2719/短路保护及失联安全。

Linux源码/home/cy122/x2pro-linux/linux，initramfs/home/cy122/x2pro-linux/initramfs。
手机仍#86，宿主Image#88未部署，私人wifi-candidate.config尚未构建；务必区分三者。
先SSH确认boot ID、完整dmesg、encoder和display实例。EUD TOP_CFG0x11、整帧/RX53/F1/
两终端保持，必要时既有com-up只恢复COM/VBUS，不写CHGR。未来只用新会话的新守卫；
kernel86/flash-final.ps1的停止保护保持，不复用旧OUT序列，逐项检查原生命令退出码。
只允许已授权boot/logdump部署；按PARTNAME/大小/序列/哈希核对，保留Android/数据/GPT。
当前logdump最近实测sha=cf11644e32a138ff1319fe9e44529f1ef7b2a1907c1f8876c597f970a526d286；
原#85回退kernel86/logdump-before.img sha=60e183a6780945885a738ac1bd0c7e23ed41515bca662cb50a831ede3b57302b。
这些分区摘要在86采集，本轮未重新读整分区。boot前缀摘要/大小见86，不把宿主候选当部署证据。
二进制/镜像/完整配置/源码/生成头、Android DT/固件/身份留私人目录；只发布fork/master。
无审批阻挡，权限足够。充电不写配置/解封/NVM/OTP/FET/OTG/GPIO/MCU，不运行OEM charger probe，
不读0051/0053/0072或故障REG14，不使用I2C_FORCE。历史85/86封存保持。
