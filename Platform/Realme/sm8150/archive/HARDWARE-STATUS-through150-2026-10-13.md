历史快照：阶段151收尾更新前的文档，仅保留历史证据；当前状态以NEXT-SESSION.md及linux-port/docs/HARDWARE-STATUS.md为准。

# RMX1931 Linux 硬件接入清单（2026-10-13，阶段149 GPU修复）

最新 GPU 状态：147旧式 VM/GLES 对齐修复保持，149已复现并修复 Vulkan 自动 VM_BIND CCU 翻译故障，手机为 #147/software132 加 Mesa149 补丁。185 次像素读回、36 次 Settings 面板打开、PM/稀疏/重放/并发通过，部署后新增 fault0、taint0、物理桌面保持。当前本地库可能被 Mesa 包更新覆盖，后续构建须加入公开0015补丁。详见 [149验收](../sessions/149-vulkan-ccu-alignment-fix-and-deployment.md)和 [验证限制](../reference/kernel149/README.md)。其它功能待办保持；以下旧阶段和表格中的旧GPU待办为历史记录。

当前操作规则：[WORKING-BOUNDARIES](../WORKING-BOUNDARIES.md)。用户已撤销其余临时禁令；下方历史中的GPU禁测、固定时序、只读、禁复用及禁提交推送等条款不再适用。硬件状态和既有失败记录仍保留。

当前阶段145收尾：阶段145已只刷logdump并实际启动，系统/模块仍为132；boot/logdump回读、实际设备树、770模块、GPT18、persist及NV/原厂来源校验通过。Phosh/Phoc存在、taint0，累计DPU0/DSI0/GPU0/WARN0/TXprepare9，显示空闲，未做GPU专项负载。启动追踪未取得结果，未确认启动链根因；失败证据已封存，本轮临时开机服务已移除，k145-startup实例不存在。显示、GPU和充电均未新增验收成功。本轮按用户要求收尾并交接，完整适配目标仍未完成。

详见[实际部署与收尾](../sessions/145-dsi-deployment-and-session-closeout.md)。以下为按时间保留的历史记录，旧版本状态不能作为当前操作依据。

最新阶段144：阶段144：确认143重启路径把F1日志入队后立即关闭EUD，实际函数宿主模型复现未发送回执和关闭后TTY写硬件两项回归。新补丁26项测试在普通编译及ASAN/UBSAN下通过，驱动W=1编译无警告；完整镜像链接中断，工作盘约120MiB可用，未产出144镜像、未部署。构建树源码144，残留Image仍为拒收143；手机仍为回退140/software132。140/143亮屏快照五项关键时钟相同，但143有171条status=c欠载记录，动态带宽/触发时序未证明。显示、136迟发CCU GPU、充电控制保护均未验收，goal active。

详见[阶段144](../sessions/144-eud-reboot-handoff-and-display-clock-review.md)。以下为此前历史。

最新阶段143：阶段143线程化EUD候选已编译并实测：16项实际函数宿主测试通过，77字节日志调用0.540ms（旧140为73.346ms），异步发送期间CPU0有36次中断、最大事件空档6.417ms。97.563秒无丢失启动追踪DPU0，却有持续DSI FIFO/MDP欠载；恢复到启动管理器时F1确认回执缺失，候选拒收。已只刷logdump回退#140/software132，boot/logdump/liveDT/GPT18/persist/770模块及来源全通过；临时服务和自建trace已移除。回退后28.690秒8次观察桌面PID、taint0与计数不变，累计DPU0/DSI0/GPU0/WARN0/TXprepare9。显示、136迟发CCU GPU和充电控制保护仍未验收，goal active。

详见[阶段143](../sessions/143-threaded-console-live-regression-and-rollback.md)。以下为此前历史。

最新阶段142：阶段142仍为#140/software132，同内核重启一次、未写分区。96.948秒启动追踪无丢失，一个完整显示超时窗口的PP回调95.652ms、CPU0事件空档69.943ms；另一次超时早于新增追踪。空档与Q6 ready日志吻合，EUD同步日志A/B实测73.346ms对0.211ms，CPU0最大空档73.307ms对0.431ms，两条记录均保留在dmesg，配置已恢复、无新增错误。已确认控制台长延迟，原始显示故障完整因果仍待驱动修复验证。boot/logdump/liveDT/GPT18/persist/770模块及来源均通过；临时服务和两个自建追踪实例已移除。随后28.641秒8次被动观察PID/taint/计数不变，累计DPU2/DSI0/GPU0/WARN0/TXDMA0。显示、136迟发CCU GPU故障、充电控制保护及完整系统目标仍未验收。

详见[阶段142](../sessions/142-startup-irq-gap-and-eud-console-latency.md)。以下为此前历史。

最新阶段141：阶段141实际仍为#140/software132，普通亮屏53.835秒观察无新增错误；同一内核受控重启一次、未写分区。新启动86.699秒追踪保留两次显示超时完整窗口、无丢失，帧完成回调在91.018/95.291ms到达，83ms看门狗保持。桌面1869次GPU提交/刷新/退休对应、无fault，不能替代136专项迟发CCU故障的验收。首次TX诊断确认state=DOWN且channel为空，前有PDR监听超时和SSR唤醒失败；BAM分配失败/挂起拒绝诊断未出现。实际boot/logdump/liveDT/GPT18/persist/770模块及来源全通过；随后28.564秒8次观察桌面PID、taint0及计数不变，累计DPU3/DSI0/GPU0/WARN0/TXprepare9。显示、GPU、充电与完整系统目标仍active。

详见[阶段141](../sessions/141-normal-wake-and-loss-free-startup-display-trace.md)。以下为此前历史。

最新阶段140：当前实际#140/software132：保留139未提交TX回收，只增加首次NULL/BAM分配失败/挂起拒绝诊断，没有修改挂起顺序或GFP策略。139实际函数注入12项通过，100次失败后仍可发送，较早在途槽位与TID/PM回收保持。140四件套、770模块/DTB原字节和实际boot/logdump/liveDT/GPT18/persist/NV来源校验全通过，只刷logdump。140本次无TX DMA失败，三条诊断均未触发，不能证明根因已修。启动观察DPU1→4、桌面自主恢复；随后28.622秒8次被动观察，计数/PID稳定=True，累计DPU4/DSI0/GPU0/WARN0/DMA0，taint0。显示、GPU延迟CCU和充电控制保护仍未验收，完整系统goal active。

详见[阶段140](../sessions/140-first-dma-diagnostics-and-display-startup-timeouts.md)。以下为此前历史。

最新阶段139：阶段139实际加载#139/software132，NGD未提交DMA失败的槽位/completion/TID与PM回收已修；从132只改两SLIMbus文件，136/137增量撤出候选。实际函数宿主注入12项通过：原31次失败耗尽，修复后100次失败仍可继续有效发送；较早在途槽位与直接user所有权保持。770模块/DTB原字节、四件套及实际boot/liveDT/GPT18/persist/NV来源全部通过，只刷logdump。桌面自主恢复，28.692秒8次PID/taint0/错误计数不变；累计DPU2/DSI0/GPU0/WARN0/TX prepare70，仍不是无报错或整机验收。70次启动期prepare失败后codec再完成探测、未出现队列满/发送超时，但首NULL原因未证明。当前rootfs132936包/770模块不变，无134 USB额度驱动；GPU延迟CCU/显示启动timeout/充电控制保护仍待办。完整系统goal active。

详见[阶段139](../sessions/139-slimbus-unsubmitted-tx-unwind-and-live-boot.md)。以下保留此前历史。

当前阶段138/实际内核132：已逐项验核137回退，Phosh/Phoc自主恢复、taint0，28.692秒计数保持DPU3/DSI0/GPU0。136故障映射证据与137拒绝候选详见最新session；以下功能历史不能扩展为本轮验收。充电实际恢复阈值8.525V已只读核对，完整控制仍未验收。

阶段135完成MDSS reset候选的909节点单属性静态/schema验证、UEFI仅DT替换及真实双分区部署；实际新boot虽无原CTL/KMS失败，却WCD934x告警、DSI两处clock告警、682次codec ENOSPC、taint512且无Phosh，候选拒绝，根因未证明。已自动回退#132并逐项验核boot/logdump/live DT/GPT18/persist/770模块/11来源；原配置Phosh/Phoc与BlueZ/5180MHz自主恢复、taint0，无需面板重绑或greetd标记恢复。42.512秒8次被动守卫同PID/供电0/BlueZ/Wi-Fi及故障计数保持，boot累计DPU2/UART4/GPU0；CRTC active0，持续显示和GPU131迟发fault仍未验收。当前匹配完整镜像为rootfs132；最新候选rootfs134及770模块原字节复用/四件套重新完整hash和encoded UID10000读写通过，候选135不能作为稳定基线，userdata未全量刷入。134 USB额度驱动在当前132回退内核暂不存在，历史CDP1.5A证据保留；MP2650只读观测仍自动注册，实际充电控制继续待办。找到当前缺失的上游WCD934x regmap/irqchip清理补丁，下一项独立源码补丁/构建/实际部署，不能据此宣称efuse/ENOSPC根因已证实。15组硬件与完整系统goal active。

[阶段135](../sessions/135-mdss-reset-candidate-rejected-and-stable132-rollback.md)。旧轮次是历史，当前以132回退与135候选失败为准。

阶段134已实际刷入boot/logdump及770匹配模块，新内建只读USB supply自动注册：42.113秒8份标准事件均ONLINE1/CDP/CURRENT_MAX1500000，属性0444。首次启动却发生继承INTF停帧及CTL reset -22，KMS失败/无DRM；失败现场保留，一次原生panel bind恢复card0/renderD128，保存当前greetd初次会话标记后原配置Phosh/Phoc恢复，不能宣称永久显示修复。恢复后taint0/BlueZ/5180MHz及11来源保持，42秒无新增故障；新boot累计DPU timeout1、UART2、GPU0仅无专项负载窗口，GPU131迟发CCU故障仍未修。完整rootfs134为936包/770模块/21,137条目反向内容metadata零差异、双fsck、encoded UID10000读写及四件套通过，完整userdata未全量刷入。实际清理120/121旧对象1.78GiB、旧129/130 exports与冗余132 raw7.14GiB内部占用，134卷零区原生稀疏回收E盘2.30GiB，稳定源码/镜像和原WSL VHD保持。15组功能边界、完整充电控制及完整系统goal仍开放。

[阶段134](../sessions/134-usb-input-budget-real-boot-and-display-startup-failure.md)。其余条目保留原证据，不扩大为本轮验收。

阶段132已实际刷入boot与logdump，内核#132/770匹配模块及UEFI内嵌设备树通过，MP2650在QUP1/0x5c启动自动注册只读标准power_supply。42.13秒8份事件全部非空/ONLINE1/Charging，电压8/8为4.400–4.475V，输入电流7/8为400.00–418.75mA，另1份ENODATA；桌面PID/taint0/BlueZ/5180MHz与11来源保持，窗口无新增故障。新boot仍DPU超时4、BT UART重组错误2，GPU0仅此无负载启动窗口，131迟发CCU故障未修。完整rootfs132含936包/770模块/21,136条目反向metadata与内容零差异、双fsck、encoded UID10000读写及匹配四件套；完整userdata未全量刷入。两份可由稳定130 sparse完整重建的冗余raw删除3.63GiB，130 sparse/source/export和C128/129稳定源码/Image保持。15组功能边界和完整系统goal active。

[阶段132](../sessions/132-persistent-mp2650-real-boot-and-complete-rootfs.md)。其余条目的旧轮次证据保留，不能扩大为本轮硬件验收。

阶段131已证明旧glmark离屏尺寸错误：同一FD640/Mesa26.2.4场景在1080×2259失败、固定实际FBO800×600按原阈值通过；随后1.993/2.737秒出现两次不同IOVA的CCU READ TRANSLATION，GPU整体仍失败。新转储/7BO离线解码及59+21成员SHA验证完成，停止GPU负载，无GPU重置/桌面重启/刷机。转充电观测：当前129已含87 ADC重试/ENODATA修正，临时绑定8份标准uevent均非空、ONLINE1/Full；ADC电压5/8、电流4/8，其余ENODATA，11配置读数保持，测试后客户端移除。当前内核仍#129、最新完整rootfs130，15组功能边界/稳定回退保持，完整系统goal active。

[阶段131](../sessions/131-fixed-size-pixel-validation-and-delayed-gpu-fault.md)。

15组硬件保持。 阶段130补齐标准BlueZ5.87服务的本机DMS地址供应和default自动启动，实际两组LE/BR/EDR/混合扫描及HCI/MGMT发现事件通过；正常暖重启后无需手动服务/地址/网络激活，BlueZ运行且控制器默认关闭，5180MHz/网关/HTTPS/50.24秒窗口通过。当前内核仍#129，boot/logdump/770模块保持；完整rootfs130含936包、21,135条目反向内容与metadata零差异、双fsck/稀疏重建/encoded UID10000实际读写和四件套通过，服务/config/runlevel已增量部署，完整userdata未全量刷入。当前taint0/DPU0/GPU0/CRTC active1仅为本次启动窗口，旧GPU像素故障及持续显示未证明修复；BT启动UART错误累计2，配对/传输/冷启动/休眠与其余硬件边界保留，goal active。

[阶段130](../sessions/130-standard-bluez-discovery-and-startup-integration.md)、[阶段129](../sessions/129-initial-console-node-and-real-boot-verification.md)、[阶段119](../sessions/119-k118-deployment-and-real-gpu-pixel-failure.md)、[阶段118](../sessions/118-final-reset-read-build-and-host-space-recovery.md)、[阶段117](../sessions/117-parser-boundaries-and-same-boot-desktop-recovery.md)，[继续检查点](../NEXT-SESSION.md)。

阶段119已只刷logdump部署#118，boot/DTB/764模块及userdata保持。新启动自动恢复DRM/card1、Phosh/Phoc和FD640，0 CTL reset失败/0 KMS bind失败/0 RCU stall、taint0；启动DPU2次超时，300秒空闲窗口0新增，最后CRTC停用，不能代表持续绘制。签名glmark2非root真实像素验证33项仅2成功/25失败/6未知，退出0后发生1次CCU READ TRANSLATION GPU fault，2.2MiB devcoredump已私有保存；桌面进程仍存活、taint0，GPU功能验收失败。NV6/source4/vendor/persist/GPT及音频空闲保持，goal继续active。 Mesa26.2.4官方源码离线crashdec已成功：51 BO不包含fault IOVA、TTBR一致、1个零页表项，估算停止在CP_WAIT_FOR_ME/CP_SET_BIN_DATA5附近；无VM历史，根因未证明，先转摄像头资源核对。

| 功能组 | 当前可证明的状态 | 接下来必须完成的工作 |
|---|---|---|
| 触摸 | 用户确认113供电试验后Phosh解锁及应用正常 | 方向/边缘/休眠/长稳 |
| 原生显示面板 | 当前145/132系统，Phosh/Phoc存在、taint0，DPU0/DSI0但CRTC inactive；DSI三追踪事件已注册，启动trace未采集 | 首次接管、持续绘制、花屏/开关屏/休眠及长稳未验收；优先修复采集启动链 |
| GPU | 136固定800×600像素通过后两次迟发CCU翻译fault；上次145未做专项负载，根因未解决 | GPU禁测已撤销，可用负载、映射诊断、完整用例及驱动修改继续定位；是否修复以实际结果记录 |
| 普通USB与OTG | 当前145新boot的USB SSH/SCP、boot132/logdump145/GPT/persist回读通过；本次F1来自旧140 | 145内EUD144退出修复的真实F1/panic未验收；OTG/USB3/休眠/冷启动/长稳待办 |
| Wi-Fi | 当前145已关联无线网络、MPSS运行；130历史暖启动5180MHz/网关/HTTPS通过 | 本轮未重新验数据流量；物理冷启动/休眠/长稳及历史reason7仍开放，原profile/固件/校准保持 |
| 蓝牙 | 当前145 BlueZ服务已启动；历史LE/BR/EDR/混合扫描通过，本轮未配对或扫描 | 历史UART重组错误仍未解决；配对/传输、物理冷启动/休眠/长稳待办 |
| NFC | I2C9 / GPIO36 VEN / GPIO47 IRQ / GPIO48 FW；NCI初始化、上电查询、关闭及重复通过 | GPIO113时钟请求、RF/读卡/标签/eSE；当前无标签，仅控制器验证 |
| 音频 | 当前145累计TX prepare9、无codec ENOSPC/kernel WARN；旧140停止流程70次失败已独立封存，139未提交槽回收保持 | 首次NULL/DMA准备失败与停止生命周期仍未解决；不能将封存过渡故障视为修复，音质/耳机/休眠待办 |
| 电池与充电 | 145继承132 MP2650只读观测；138目标/恢复阈值证据保留，控制及保护尚未验收 | 永久只读限制已撤销，可推进正常充电控制、输入额度与保护链修复，保留电池安全边界 |
| 蜂窝网络/数据 | 当前145 MPSS运行、132的IPA模块和770模块树核验通过；历史ModemManager sim-missing边界保留 | 本轮未验移动数据或通话，clock/ICC压力、SSR/冷启动/休眠/长稳待办 |
| 摄像头 | 历史126内部TPG3帧真实DMA/IRQ/raw10/电源恢复通过；当前145的132设备树与770模块保持，物理camera未验收 | 外部PHY/sensor/PM8008/HAL及物理stream、颜色/位深/多模式与应用待办 |
| 其它传感器 | 早期STK3331/MMC5603X独立样本证据保留；当前145 SLPI offline，传感器vdd/vddio=0 | 历史两版功能不能合并认定；磁力计矩阵/准确度、加速度/陀螺仪、lux和日常功能待办 |
| 指纹 | 未验收 | 本机传感器、SPI/供电及TEE/用户态依赖；不能以触摸F12替代 |
| 振动 | AW8697历史电气验收保留；本轮无新脉冲，桌面feedbackd设silent/max-haptic-strength0 | 用户暂缓机械确认；静态分析和日志，保持唯一OF身份 |
| GNSS定位 | LOC控制与同客户端连续报告/NMEA/SV事件通过；55次位置报告均in-progress，start/stop回执通过 | GNSS实际定位、持续事件、定位服务与桌面集成 |

已有基础能力：进入initramfs用户态、六个UFS LUN、CPU三个调频policy及CPU7最高
2956800kHz表、三路PMIC温度、原生60Hz显示输出、EUD交互和F1。Linux按键输入设备已
注册，UEFI三侧键已实测；CPU高频压力、UFS持续读写、Linux按键事件等仍有验收边界。

剩余warning不等于剩余硬件数：PM8009无已发现DT消费者，P3；RPMh读回-95是固件
能力限制证据；QMP/aux_bridge与实际USB/显示功能需分别验证。不能用删除warning
代替接入硬件。详见sessions/70、71和reference/kernel70、71的校验日志。

匹配#121完整软件rootfs及启动/模块产物已完成并通过21,134条目反向验收，未部署；下一项推进CAMSS数据通路；PM8008无IRQ离线支持已完成，输入/冷启动地址/全芯片enable留档后继续有界核实。#118 GPU离线转储已经解码，根因尚未证明。完整传感器、GNSS真实fix、充电、指纹、休眠等仍开放。每步区分构建、部署、限定功能验收；不用删除warning代替硬件接入。userdata增量保持，GPT/NV/persist及离线来源保持。

阶段122：936包/770模块完整rootfs匹配候选121，device-fixed镜像4f39f409382d87c5524fbf610fa0d262b3e58629a0f7f1fbee6afc62af5f1933；双fsck和21,134条目反向验收通过，尚未上机。C/WSL经验证清理四raw实际7.26GiB，稀疏基线/源/回退保持。现运行118及15组功能边界不因软件打包通过而改变。

阶段123：本机CAMSS八MMIO/IRQ/SMMU匹配，disabled DT+DMA31bit上界/4ICC/HF bridge隔离候选构建验收完成，硬件摄像头仍未stream。供电模型本机L3 1.2V与借用SDM845双路模型不一致待修；C-PHY/QoS/IOVA下界保持开放。最新完整rootfs122仍匹配121，当前手机118未变。

阶段124：本机active camera_8150三相表与参考3项不同，native0x24保持；共享L3模型经actual DT与DSI核对，C lifecycle故障host测试保持DSI引用；均非电气/图像验收。供电双路错位已离线修正，C-PHY时序/CPAS/QoS/IOVA/Sensor仍开放，当前118 GPU1未修复。


阶段125：CPAS表和完整IOVA离线合同已验证，实际buffer DMA/图像未验收；IOVA回调是策略并非实际allocator cookie检查，GPU1仍未修复。下一转有回退的真实TPG测量，15组不因离线build降级开放项。

阶段126：当前运行内嵌126 DTB的#126，最新boot有限窗口taint0/DPU1/GPU0，但旧GPU像素失败和最终CRTC inactive不能因未重跑测试判为修复。126完整rootfs home属主缺口由127继续，未擦除userdata。

阶段127：最新完整软件rootfs127匹配已运行126，home/sys-resource owner修正及21131条目/encoded降权访问通过。实机85项metadata增量验收，userdata未擦除；不把软件镜像验收等同物理camera/GPU/显示/休眠全系统可用。

阶段128：阶段128已实际刷入#128，WCN3990/SNOC单播密钥删除的3.2秒超时实测降至0.018–0.027毫秒，四次安装确认保持；5GHz认证/DHCP/HTTPS/软件索引及NetworkManager服务重启自动连接通过。双频持久配置已增量上机，936包/770模块完整rootfs128已生成，21,132条目反向内容与metadata零差异、双fsck/稀疏重建/encoded UID10000实际读写及四件套通过；完整userdata镜像未全量部署。当前桌面/radio/hci0/5GHz/taint0，DPU累计1且最终CRTC inactive，旧GPU像素失败未修复，物理camera及其余硬件验收边界保留，goal active。 初始console warning1留档，下一轮推进可自动验证的initramfs节点修复。

阶段129：阶段129已实际刷入#129，initramfs增加root:root/0600字符5:1的console节点，实际启动warning由1变0。保留128单播密钥删除等待修复，新启动自主连接5180MHz，网关/HTTPS/6034包索引与50.44秒窗口通过；936包/770匹配模块完整rootfs129、21,133条目反向内容与metadata零差异、双fsck/稀疏重建/encoded UID10000实际读写和四件套验收完成。完整userdata镜像未全量部署。最终Phosh/Phoc/radio/hci0/5GHz/taint0，DPU累计3、CRTC inactive，物理camera、GPU像素及持续显示仍未通过，goal active。 下一轮推进蓝牙自动扫描/停止回归。

阶段130：阶段130补齐标准BlueZ5.87服务的本机DMS地址供应和default自动启动，实际两组LE/BR/EDR/混合扫描及HCI/MGMT发现事件通过；正常暖重启后无需手动服务/地址/网络激活，BlueZ运行且控制器默认关闭，5180MHz/网关/HTTPS/50.24秒窗口通过。当前内核仍#129，boot/logdump/770模块保持；完整rootfs130含936包、21,135条目反向内容与metadata零差异、双fsck/稀疏重建/encoded UID10000实际读写和四件套通过，服务/config/runlevel已增量部署，完整userdata未全量刷入。当前taint0/DPU0/GPU0/CRTC active1仅为本次启动窗口，旧GPU像素故障及持续显示未证明修复；BT启动UART错误累计2，配对/传输/冷启动/休眠与其余硬件边界保留，goal active。 下一轮优先本次新暖启动的有界真实GPU像素回归；旧25失败不能因未重跑判通过。
