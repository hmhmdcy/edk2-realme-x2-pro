# Realme X2 Pro 当前检查点

2026-10-16，240为progress，完整适配goal active。已定位Megapixels后端/配置缺口，Snapshot前摄CPU预览两轮跑通并持久保存启动环境；缓冲回收、拍照/切换/颜色及GNSSfix仍开放。[240证据](reference/kernel240/README.md)、[239完整依据](archive/NEXT-SESSION-through239-2026-10-16.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与状态

仍236启动/boot235，guard /var/lib/samurai/k236-runtime/boot-id-private.txt，233及更早无效。运输reference/kernel240/host.py，私人240/current-work-private.json。无活动构建/worker/传输或切换待决；原生266成员私有归档逐一核对。三授权只读代理已完成，手机串行操作；不得开启新未授权代理。

默认libcamera/IPA/tools/GStreamer/V4L2=99990.7.2-r15，config/stack=0.1.0-r10，49载荷不变。Snapshot51.0-r0签名发行包经主机HTTPS中继/手机原可信钥验签/原生离线apk安装，只增14至958，原944记录逐字不变，world仅新增snapshot版本钉住；移除模拟恰好14项。持久相机仓库仍239 r15索引；Snapshot安装候选k240-snapshot-host-packages/apks/packages.adb，事务k240-snapshot-app-transaction。

桌面“相机（Snapshot）”：用户.local/share/applications/org.gnome.Snapshot.desktop与dbus-1/services/org.gnome.Snapshot.service两覆盖，GSK_RENDERER=cairo / GDK_DISABLE=gl,vulkan,offload。desktop DBusActivatable=false直接exec；真实session bus从Phosh环境读，不猜/run/user/10000/bus（不存在）。新建服务目录后曾命中旧缓存，ReloadConfig后实际StartService已验CPU环境，自己的无窗口服务已TERM。原签名desktop/service及Phosh全局GPU/schema未改。事务k240-snapshot-launcher-transaction有两文件hash/owner/mode；回退先核hash再移除两覆盖。仅用户级部署，完整rootfs集成仍未完成。

最终789项默认模块/加载note/49相机载荷/958包匹配；两sensor/CCI/CAMSS suspended、四camera rails OFF/users0、MCLK1/2关，三DSP/SensorProxy三Has/Wi-Fi/chrony正常。BT poweredtrue/discoverfalse/既有1连接只观察；GNSS idle0/rate30/signalsfalse/watch idle/timeprepared/dataworker0；MM−1/reason2/power1、用户无SIM。没有新GNSS SET/搜星、刷写或重启。

## 源码、产物与回退依据

boot235 44c6a215…/100663296B、DTB469e1456…、Image183 bfa72dd9…、logdump183 e73754c7…保持。MFD6021a359…、lab5198e2bd…、provider2223f337…、IMX319176f68d7…、前摄e49dab26…、CAMSSff9fdfa3…、FastRPC2abde0ea…、BT185f6c5ed35…保持；775ko/789文件权威k237-camss-install/module-inventory-after-private.json。r15→r13/r8七包模拟回退及225实际七包、239事务/world/repos保留，未完整往返。旧236用户态hash含r13，不盲套；240 final-health核新49载荷和原其余hash。

r15源/对象libcamera214-root/work/libcamera239-r15-built；原2142254文件恢复、r14缓存保留。0022首参同步修复/初始矩阵/实际处理身份已验；旧零帧严格失败仍保留。canonical精确after228，240没有编译/部署新内核，旧相机输出不能整刷。

S5K3M5源码reference/kernel240/s5k3m5.c SHA9e97813c…，表头6a746dc4…、power include040ae270…，917init+模式3的53写、WRITE8流控/30ms停流、PM引用/残留rail回收和selection高度修正已源审；未编译/部署。19.2MHz/CCI1master0 0x2d/reset23/MCLK3/CSIPHY3，模式2104x1560/LLP9648/FLL1663、pixel481930000为OEM元数据，link723.2MHz未实测；gain1..16整数，细步长开放。准备脚本有一次性备份和include追加操作，重跑前审幂等性，不能盲跑。

P现lab mask9 L1/L4且有IMX319消费者，不热卸有children的MFD或lab。S5K需VIO pm8150l_l1、VANA P L6 2.8V、VDIG P L2量化1.056V；新0x2b union固定子组9/0x22共享lease设计尚未实现。所有mutating/is_enabled同锁，跨组busy无写/无fault；注册readyfalse且EN0返回0；VSET先于enable也须lease护栏；仅账本0+七EN0+global原值一致可释放，复位失败保留fault/lease；不猜VIN、不接AF L3。IMX319首P EBUSY需干净回滚后可重试。后续先做真实C回调故障注入/编译，需新boot部署而非热卸。

## 续作与已知风险

Megapixels2.1/libmegapixels0.2.3缺samurai配置→UVC fallback只认uvcvideo，不走r15。无pipeline方向回调可exit1、空切换缺保护；session出现no pipeline，但没对应栈/操作，不能断定每次闪退触发。受控窗口活12s，-2为主动收尾；SSH claim被拒不覆盖活动桌面路径。

用户打开的Snapshot默认Vulkan出现VK_ERROR_DEVICE_LOST；5s观察新增10GPUfault，精确停止后无新增。内核历史共480GPUfault/taint0，绝不能写240全程fault0；也不能混同旧CCU和211 GPU ISP WARN。Cairo且禁dmabuf首轮挂起0帧；用户解锁后r2收18缓冲但8paintable Bus Error，不能只禁DMA。

GTK4.24.1支持线性DMA CPU mmap，保留默认PW bufferpool和dmabuf、禁gl/vulkan/offload后16秒765递增PTS/324mmap、用户要求30秒重试1436递增PTS/600mmap，实际1920x1080 XR24:0、Cairo已记、无/dri FD/新增fault0/完整恢复，0paintable Bus Error。不把sink调用当实际显示帧数，空V4L2 trace不作无帧证据。仍分别163/301次was not recycled，这是PW交付/Gst账本不一致而非普通慢帧；pending队列警告为有界合并。PW1.6.8相机set_format未设FrameDurationLimits，caps30不保证源降帧；Snapshot无FPS开关。先保留此CPU工作回退，后续修buffer所有权/帧率与拍照、切换、长稳，不部署use-bufferpool=false（上游另有锁顺序死锁修复30ff8da）。用户30秒重试已做，实际画面文字反馈仍待；不再索取纯色或截图。

用户手机竖放，IMX319配对24request均非零；稳定2ms RAWmean64.290/std0.756/max85，32ms69.864/std10.211/max387/92.35%≤80，RGBmean41.97/max153。曝光响应不等于正常光学/颜色；无场景图片保存/展示/传输、无加光。其它后摄/颜色仍开放。

GNSS实际ODM gps.conf与社区固定源相同；HAL实际库固定vendor路径无ODM fallback，device.mk安装ODM但ZIP未见bind/overlay采用链。HAL binder配置setter可达不代表运行采用，需匹配Android运行映射/日志；不以RF_LOSS报告逻辑猜LNA，不重跑已覆盖同CID/GSV/辅助矩阵。室内窗边无SIM，不据此代替正CNR/fix证明。蜂窝有卡业务、传感器/蓝牙长稳与全机kernel/rootfs继续待办。
