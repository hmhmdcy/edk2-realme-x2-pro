# RMX1931 Linux 硬件状态与未完成项目

用途：当前硬件验收清单。最后核对：2026-10-14，阶段165软件复测及后续用户交接白屏/花屏实屏反馈已通过。已部署内核163、software132加Mesa149本地库。文档整理：2026-10-14，未新增实机验收。以[本轮显示证据](../../reference/kernel165/README.md)、[GPU验收](../../reference/kernel149/README.md)和下列各功能证据为准；操作规则见[WORKING-BOUNDARIES](../../WORKING-BOUNDARIES.md)。

**已复现的A640 CCU GPU故障已修复并部署，可以结束本轮GPU故障定位。** 147修复旧式GLES地址对齐，149修复Vulkan自动VM_BIND地址对齐。149完成185次像素读回零差异、36次Settings面板打开及PM、稀疏重绑定、旧地址重放、Vulkan/GLES并发验收。151同启动六次被动观察中无新增fault，taint0，桌面保持。150无Mesa补丁的降级候选未部署；它的验证不能混入149系统驱动的验收。

这个结论限定当前已复现故障和已测负载。所有Vulkan扩展、长时间压力及跨启动GPU回归仍需验收；显示交接白屏/花屏及已测开关屏已通过本轮验收，冷启动、休眠和长期显示稳定性仍开放。普通Mesa包更新可能覆盖本地修复，旧rootfs132镜像不含该库更新。

## 当前功能与待办

“未完成”包括仍有真实缺陷、功能尚未接入，以及仅做过部分验收；不能将这三类都写成完全不能用。

| 功能组 | 已证明的能力 | 尚未修复或验收 |
| --- | --- | --- |
| GPU | 当前可复现GLES/Vulkan CCU故障已修复并部署，硬件渲染回归通过 | 将Mesa补丁纳入可复现软件包和新rootfs；完整扩展、长期及跨启动回归 |
| 原生显示 | 用户实屏确认EDK2之后无白屏/花屏，黑屏等待后显示命令行；反馈后新boot显示关键计数0；此前165的DPMS/首帧门控/稳态软件验收通过，身份与测量所属启动见[检查点](../../NEXT-SESSION.md) | 黑屏等待时长未测；冷启动、休眠、更长期稳定性开放。164首启音频WARN及157重启原因仍未知 |
| 音频 | 原生声卡、双MAX98937和WCD934x；有限PCM播放成功，DMIC0/1/2有非零样本；165及用户反馈后新boot音频DMA prepare/WARN计数0 | 164首次曾WARN1/DMA prepare917，原因未闭环；SLIMbus首次DMA准备失败和停止生命周期；实际扬声器声音、拾音质量、耳机、声学保护与休眠未完整验收 |
| 电池与充电 | BQ28Z610电量/温度和MP2650输入观测已接入；已有健康Good、接线ONLINE1/Full观测 | 正常充电控制、USB输入预算、温度/保护/失联链及持续充电闭环；输入预算候选未纳入已验收组合 |
| 摄像头 | 内部TPG真实DMA/IRQ/raw10三帧通过，原厂传感器来源已核对 | 实体传感器到C-PHY/CAMSS的出图、PM8008供电、libcamera或等效用户态及多模式图像验证 |
| 其它传感器 | 历史接近/磁力计独立样本及SLPI服务证据保留；完整功能尚未在当前组合验收 | 加速度、陀螺仪、完整磁力计/lux、自动旋转与接近日常功能；不能合并不同启动的局部成功 |
| 蜂窝通话与数据 | MPSS、QRTR/QMI、ModemManager/IPA基础已接入，本轮modem running | SIM注册、真实移动数据、通话/SMS及SSR、冷启动、休眠；历史sim-missing不算业务验收 |
| GNSS定位 | LOC start/stop、位置/NMEA/SV事件链通过 | 真实有效定位fix、持续定位与桌面定位服务；此前55次位置报告仍为in-progress |
| 指纹 | 尚无功能验收 | 本机传感器/SPI/供电、安全环境及用户态认证链 |
| NFC | NCI控制器初始化、上电查询、关闭和重复通过 | RF读卡/标签、时钟请求及eSE业务，尚无真实读卡验收 |
| 振动 | AW8697驱动与电气检查通过 | 物理振动和桌面反馈未确认；按用户边界不新增脉冲 |
| 蓝牙 | 原生BlueZ自动服务及LE/BR/EDR/混合扫描通过，本轮服务started | 历史UART重组错误未闭环；配对/数据/音频、冷启动/休眠长稳未验收，当前只扫描不连接 |
| Wi-Fi | 2.4/5GHz已有实际通信回归，本轮关联5180MHz | 物理冷启动、休眠恢复与长稳；历史连接故障不能仅凭当前关联判定全部解决 |
| 普通USB与OTG | USB 2.0 Type-C；NCM网络、SSH/SCP及与EUD共存可用 | OTG/角色切换、冷启动/休眠及长期稳定；EUD部分宿主接收/退出路径仍有独立验收待办。USB3不是本机修复或验收目标 |
| 触摸 | 用户确认可解锁、操作应用，原生驱动工作 | 边缘/方向/多触点与休眠后恢复、长稳 |

已有基础还包括UFS访问、CPU调频表、PMIC温度与按键/EUD。CPU高频压力、UFS持续负载、整机功耗、冷启动及系统休眠唤醒仍需跨功能验收；不能以驱动注册或短窗口健康代替日用完成。

USB规格更正：用户指出此前误列USB3；[X2 Pro规格](https://www.gsmarena.com/realme_x2_pro-9904.php)标注USB Type-C 2.0。[厂商规格](https://www.realme.com/in/realme-x2-pro/specs)只标注Type-C接口，没有声明USB3；SoC具备更高速度控制器不代表整机接口支持该速度。

## 下一阶段顺序

显示交接白屏/花屏与已测开关屏本轮已验收。后续优先推进充电控制保护及音频首次DMA问题，再处理完整传感器、实体摄像头、蜂窝业务与GNSS真实fix；指纹、NFC读卡和外围设备功能保持待办。Wi-Fi、USB和触摸补稳定性，蓝牙继续区分已验收的扫描与尚未验收的连接/音频；整机冷启动、休眠与长期可靠性仍需验证。

参考证据：[显示140至145](../../sessions/145-dsi-deployment-and-session-closeout.md)、[SLIMbus139](../../sessions/139-slimbus-unsubmitted-tx-unwind-and-live-boot.md)、[DMIC104](../../sessions/104-native-digital-microphones-and-first-boot-radio-failure.md)、[充电132](../../sessions/132-persistent-mp2650-real-boot-and-complete-rootfs.md)、[充电138](../../sessions/138-readonly-charger-recharge-threshold.md)、[实体camera前的TPG126](../../sessions/126-tpg-dma-guards-full-rootfs-and-real-deployment.md)、[传感器112](../../sessions/112-startup-sensor-registry-and-reboot.md)、[Wi-Fi128](../../sessions/128-wcn3990-pairwise-key-delete-and-5ghz.md)、[蓝牙130](../../sessions/130-standard-bluez-discovery-and-startup-integration.md)。

阶段151以前的完整状态记录已经移入[历史快照](../../archive/HARDWARE-STATUS-through150-2026-10-13.md)，不再把旧136 GPU故障或145设备状态写作当前待办。
