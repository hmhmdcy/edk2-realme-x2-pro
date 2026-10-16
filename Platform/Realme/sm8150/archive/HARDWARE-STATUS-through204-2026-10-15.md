# RMX1931 Linux 硬件状态与未完成项目

用途：当前硬件验收清单。最后核对2026-10-15，阶段204。蓝牙UART RX wake/sleep已部署，首轮45.14秒RTC PM及前后扫描通过，但phase5启动错误仍复现。首轮SSC启动失败，第二普通启动自动恢复，最后610.72秒taint0/fault0；GNSS空窗口自动刷新与首次桌面NMEA时间通过，仍无fix/正CNR。完整goal active。[204报告](../../reference/kernel204/README.md)、[检查点](../../NEXT-SESSION.md)、[边界](../../WORKING-BOUNDARIES.md)。

**已复现的A640 CCU GPU故障已修复并部署，可以结束本轮GPU故障定位。** 147修复旧式GLES地址对齐，149修复Vulkan自动VM_BIND地址对齐。149完成185次像素读回零差异、36次Settings面板打开及PM、稀疏重绑定、旧地址重放、Vulkan/GLES并发验收。151同启动六次被动观察中无新增fault，taint0，桌面保持。150无Mesa补丁的降级候选未部署；它的验证不能混入149系统驱动的验收。

这个结论限定当前已复现故障和已测负载。所有Vulkan扩展、长时间压力及跨启动GPU回归仍需验收；显示交接白屏/花屏及已测开关屏已通过本轮验收，冷启动、休眠和长期显示稳定性仍开放。普通Mesa包更新可能覆盖本地修复，旧rootfs132镜像不含该库更新。

## 当前功能与待办

“未完成”包括仍有真实缺陷、功能尚未接入，以及仅做过部分验收；不能将这三类都写成完全不能用。

| 功能组 | 已证明的能力 | 尚未修复或验收 |
| --- | --- | --- |
| GPU | 当前可复现GLES/Vulkan CCU故障已修复并部署，硬件渲染回归通过 | 将Mesa补丁纳入可复现软件包和新rootfs；完整扩展、长期及跨启动回归 |
| 原生显示 | 用户实屏确认EDK2之后无白屏/花屏，黑屏等待后显示命令行；反馈后新boot显示关键计数0；此前165的DPMS/首帧门控/稳态软件验收通过，身份与测量所属启动见[检查点](../../NEXT-SESSION.md) | 黑屏等待时长未测；冷启动、休眠、更长期稳定性开放。164首启音频WARN及157重启原因仍未知 |
| 音频 | 171人工双组滴声；183识别离线传输并清理WCD流，活跃双工合成crash原客户端恢复、2旧FD EIO、18项0，匹配左右相关0.9119/0.9312。两次s2idle实际45.33/87.04秒、success2/fail0、PM callbacks全err0；醒后原生/桌面左右通过。1473秒taint0、20项全boot0，PCM关、功放23/23与22/22静音、16控件恢复、五consumer各1/两map/一MCLK | 耳机/耳麦/按钮、实际watchdog、跨启动/更长可靠性和音质/瞬态/保护开放，用户暂无耳机。新发现181活跃STOP −107/ASoC3及旧178/180失败、183首轮脚本mute假设错误均保留，不改成通过 |
| 电池与充电 | BQ28Z610电量/温度和MP2650输入观测已接入；已有健康Good、接线ONLINE1/Full观测 | 正常充电控制、USB输入预算、温度/保护/失联链及持续充电闭环；输入预算候选未纳入已验收组合 |
| 摄像头 | 204第二boot CAMSS四域自动加载绑定，无新增帧；200静态MMCX四域DT/配套CAMSS成对启动，新boot四轮IMX471 RAW10共12帧，VFE约847/CSID600MHz、自身384→0；无外部helper/限频，最终三脚/PMIC恢复、taint0/告警0；MCLK sleep下拉修复通过 | sensor/PMIC/CCI仍为开发overlay接入，正常启动尚无实体camera图；四路PLDO输入/双PMICcold/其它模式镜头/曝光色彩方向/用户态/持续帧率与长稳待验；第一清理失败与单次原值恢复保留 |
| 其它传感器 | 204第二boot自动真实readiness及三个DSP/SensorProxy三Has通过，首轮文件服务就绪失败清理offline仍保留；200新boot三项Has与标准Claim/Release通过，早期门控后SLPI running；187 A.11实际三轴204/202/197及五种CLI通过；189 FastRPC freezer等待修复与自动服务已部署，连续三轮驻留45.2至45.3秒、success3/fail0/RTC3，醒后四种CLI与原daemon身份保持；三轮后真实active Wayland UID10000 Claim/Release通过 | 188原PM崩溃保留；普通信号重试/freezer竞态、共享池stop/start/reclaim−22及SSR仍未解决。人工运动/方向/自动旋转、亮暗响应与绝对精度、接近日常、跨boot/冷启动/长稳开放；平放undefined/被动lux0至8不等于这些验收 |
| 蜂窝通话与数据 | MPSS、QRTR/QMI、ModemManager/IPA基础接入，202两次重启modem running；当前MM Power1、failed/原因2、bearer0，202无电源/reset操作 | 201 Power3/online属于旧boot；两卡位历史no-atr/slot absent，当前仍sim-missing，不证明物理未插卡；实际SIM注册/数据/通话/SMS、UIM、电源策略/SSR/断电冷启/休眠仍待验 |
| GNSS定位 | 204第二boot首次182秒188条NMEA/176推进时间，自动1下载/1注入从0到168小时并独立复核，仍无fix/正CNR。202空闲UTC准备后再重启，首次182秒185条NMEA/176推进时间，6条GSV；真实UID10000 GNSS-only GeoClue启停通过；服务自动把0小时窗口下载/注入/读回为当前168小时，最终独立复核，保持Power1 | 仍无有效fix/正CNR/位置事件；RF/LNA/真实接收条件/电源策略、首次请求抢先/SSR、断电冷启/精度长稳待验；非零过期窗口原生场景未造出，201受控旧注入Core.Aborted保留；helper/MM签名APK已落地并复测；新完整rootfs整合待做 |
| 指纹 | 尚无功能验收 | 本机传感器/SPI/供电、安全环境及用户态认证链 |
| NFC | NCI控制器初始化、上电查询、关闭和重复通过 | RF读卡/标签、时钟请求及eSE业务，尚无真实读卡验收 |
| 振动 | AW8697驱动与电气检查通过 | 物理振动和桌面反馈未确认；按用户边界不新增脉冲 |
| 蓝牙 | 204 RX wake/sleep已部署；首轮前9/45.14秒RTC PM后13、错误增量0，第二boot启动重组0，外部BT事件唤醒未验；首轮phase5仍1。200新boot startup及8秒只扫描发现10设备、退出恢复、重组增量0；185功率脉冲前导NUL及短写/flow修复保持；当时原扫描错误1/候选0、3模式响应及开启状态s2idle/延后扫描通过；189三个传感器PM窗内重组增量0、密钥保持 | 189旧boot出现phase5/3.2Mbps/chunk13/partial0/firstff重组1，区别于旧phase2前导00，需继续修复。配对/连接/音频、冷启动及长稳未验收，按边界只扫描；原Wi-Fi组合失败保留 |
| Wi-Fi | 200新boot自动connected，早期管理端点超时保留；2.4/5GHz通信已有回归；189三轮传感器PM的第1/3轮观察约5.33/0.53秒关联5180，最终5180，未手工重绑驱动 | 第2轮35秒窗内仍未关联，之后又执行第3轮PM，不能称第2轮自行恢复；185立即醒后2秒检查失败仍保留。冷启动、完整休眠通信恢复及长稳开放 |
| 普通USB与OTG | 200新boot新peer/原严格公钥SSH/SCP、约6MB归档及逐成员核对通过；USB 2.0 Type-C；历史NCM/SSH/SCP与EUD共存；203大SCP停顿后严格原密钥Wi-Fi同boot取得完整候选，最终USB/Wi-Fi小命令响应，无reset/unbind/reboot | 190 USB归档尾部中断、双向IPv6探测不通，单次gadget重绑后恢复无正向证据；Windows网卡复位拒绝访问。203 USB大传输稳定性仍未修复；NCM稳定性、OTG/角色切换/冷启/PM及EUD接收/退出路径待验收；USB3不是本机目标 |
| 触摸 | 用户确认可解锁、操作应用，原生驱动工作 | 边缘/方向/多触点与休眠后恢复、长稳 |

已有基础还包括UFS访问、CPU调频表、PMIC温度与按键/EUD。CPU高频压力、UFS持续负载、整机功耗、冷启动及系统休眠唤醒仍需跨功能验收；不能以驱动注册或短窗口健康代替日用完成。

USB规格更正：用户指出此前误列USB3；[X2 Pro规格](https://www.gsmarena.com/realme_x2_pro-9904.php)标注USB Type-C 2.0。[厂商规格](https://www.realme.com/in/realme-x2-pro/specs)只标注Type-C接口，没有声明USB3；SoC具备更高速度控制器不代表整机接口支持该速度。

## 下一阶段顺序

显示交接白屏/花屏与已测开关屏已有验收证据；音频发声/拾音、停止、规定规模重绑及短时s2idle恢复也已通过。后续补音频SSR/重复长时PM、耳机和音质，同时推进充电控制保护、完整传感器、实体摄像头、蜂窝业务与GNSS真实fix；指纹、NFC读卡和外围设备功能保持待办。Wi-Fi/USB独立休眠告警保留，和触摸一起补稳定性；蓝牙继续区分已验收的扫描与尚未验收的连接/音频，整机冷启动和长期可靠性仍需验证。

参考证据：[显示140至145](../../sessions/145-dsi-deployment-and-session-closeout.md)、[SLIMbus139](../../sessions/139-slimbus-unsubmitted-tx-unwind-and-live-boot.md)、[DMIC104](../../sessions/104-native-digital-microphones-and-first-boot-radio-failure.md)、[充电132](../../sessions/132-persistent-mp2650-real-boot-and-complete-rootfs.md)、[充电138](../../sessions/138-readonly-charger-recharge-threshold.md)、[实体camera前的TPG126](../../sessions/126-tpg-dma-guards-full-rootfs-and-real-deployment.md)、[传感器112](../../sessions/112-startup-sensor-registry-and-reboot.md)、[Wi-Fi128](../../sessions/128-wcn3990-pairwise-key-delete-and-5ghz.md)、[蓝牙130](../../sessions/130-standard-bluez-discovery-and-startup-integration.md)。

阶段151以前的完整状态记录已经移入[历史快照](../../archive/HARDWARE-STATUS-through150-2026-10-13.md)，不再把旧136 GPU故障或145设备状态写作当前待办。
