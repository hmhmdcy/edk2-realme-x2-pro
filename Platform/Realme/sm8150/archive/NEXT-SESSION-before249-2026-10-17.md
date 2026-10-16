# Realme X2 Pro 当前检查点

2026-10-17：248返回备份及PC恢复检查通过；用户手动刷Android，尚未刷。当前RAM环境，21分区/GPT与完整userdata已核，源码按请求推送。[248进行中](reference/kernel248/STATUS.md)。验收沿用240。

先读[交接步骤](reference/kernel240/HANDOFF.md)、[操作边界](WORKING-BOUNDARIES.md)和[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。[240完整记录](reference/kernel240/README.md)、[240收尾原文](archive/NEXT-SESSION-through240-2026-10-16.md)、[239依据](archive/NEXT-SESSION-through239-2026-10-16.md)保留历史；归档中的active不代表现在已恢复。

## 最后已验证部署

当前248 RAM恢复环境，仍boot235/Image183；guard `/run/k248-rescue-boot-id-private.txt`，247及更早失效。运输`reference/kernel248/rescue-host.py`严格固定内置密钥。原Linux userdata完整、标记已恢复，现已卸载并设块设备RO。21分区及GPT私有备份已核；完整userdata clean-r6已备份并在PC恢复检查通过。Android未刷，见248。

libcamera/IPA/tools/GStreamer/V4L2为`99990.7.2-r15`，config/stack为`0.1.0-r10`，49个载荷不变。Snapshot `51.0-r0`经主机HTTPS中继、手机原可信钥验签及原生离线apk安装，只增14包至958，原944记录不变，world只增版本钉住；卸载模拟恰好14项。相机持久仓库仍239的r15索引，新增包候选索引和事务见交接文档。

“相机（Snapshot）”使用用户级desktop/service覆盖：`GSK_RENDERER=cairo`、`GDK_DISABLE=gl,vulkan,offload`，保留线性DMA-BUF和默认PipeWire bufferpool。desktop直接Exec；新服务目录创建后已ReloadConfig，真实D-Bus激活已验CPU环境。会话bus地址从Phosh实际环境读，不猜不存在的`/run/user/10000/bus`。原签名包文件及Phosh全局GPU/schema未改，尚未集成完整rootfs。[部署锁及两文件副本](linux-port/camera/README.md)。

240核对（247未全机重验）：775ko/789项模块及加载note匹配237清单；两sensor/CCI/CAMSS suspended、四camera rails OFF/users0、MCLK1/2关；三DSP、SensorProxy三Has、Wi-Fi/chrony正常。BT powered=true/discovering=false、既有1连接仅观察；GNSS idle0/rate30/signals=false/watch idle/timeprepared/dataworker0；MM状态−1/reason2/power1，用户无SIM。240无新GNSS SET/搜星、刷写或重启。

## 源码、产物与回退依据

模块权威清单为设备`k237-camss-install/module-inventory-after-private.json`。boot/DTB/模块完整hash、大小及回退见239归档和240最后健康收据；不能按目录名或内核release认定构建。

canonical `/home/cy122/pmos-samurai-kernel136/kernel`在240核对时等于after228，本次文档未重新遍历；240未编译/部署新内核，旧相机输出需按当前模块/板源核对后复用。SDK `/home/cy122/x2pro-linux/libcamera214-root`保留`/work/libcamera239-r15-built`源/对象；原214的2254项已恢复、r14缓存保持。r15首参同步和两次start验收保持，旧严格零帧失败未改写。

r15→r13/config-r8用225实际七包和239事务前world/repos/配置，原生降级模拟通过，未完整往返。Snapshot包与启动覆盖是独立两层回退：恢复覆盖时保留用户后续修改；卸载按当前包库求解，旧模拟仅作参考。普通应用回退不要求刷boot或热卸MFD。

S5K3M5候选`reference/kernel240/s5k3m5.c` SHA `9e97813c…`、表头`6a746dc4…`、power include `040ae270…`已源审，**未编译/部署**。917init＋模式3的53写、WRITE8流控/30ms停流、PM引用/残留rail回收和selection高度修正保留。准备脚本可复用，处理一次性备份及重复include追加。

本机S5K资源：19.2MHz、CCI1/master0/0x2d、reset23/MCLK3/CSIPHY3；2104×1560、LLP9648/FLL1663，pixel481930000为OEM元数据，link723.2MHz未实测，gain细步长开放。P现lab mask9且有IMX319消费者；新0x2b union及固定9/0x22子组共享lease设计未实现。需VIO pm8150l_l1、VANA P L6 2.8V、VDIG P L2量化1.056V；VIN/AF L3接线待核，父驱动卸载需先释放并移除消费者。锁、账本及回收契约见240归档；可推进构建、真实C回调故障注入及供电实现。

## 续作与已知风险

Snapshot缓冲回收和降帧待续，当前优先GNSS。16秒765递增PTS/324次CPU mmap，用户要求的30秒重试1436递增PTS/600次mmap，实际1920×1080 XR24:0、Cairo已记、无应用GPU设备FD、0paintable Bus Error、完整释放恢复。mmap或sink调用不等于实际显示帧数，空V4L2 trace不能推导无帧。实屏画面/颜色反馈仍待；纯色测试按用户延期，普通拍照和本地样本分析按适配需要推进。

仍分别163/301次`was not recycled`，是PW交付/GStreamer持有账本不一致，不当普通慢帧忽略，也未证明越界；pending队列告警属于有界合并。PW1.6.8相机set_format未设FrameDurationLimits，caps30不保证源降帧；Snapshot无用户FPS开关。`use-bufferpool=false`未部署；试验该路径时核对上游锁顺序死锁修复`30ff8da`。

Megapixels缺本机配置，UVC fallback只认uvcvideo、不走r15；无pipeline方向回调可exit1，空相机切换缺保护。会话有`no pipeline`，但无对应操作/栈，不能认定每次闪退触发。受控窗口活12秒，−2是主动收尾，SSH claim被拒未覆盖活动桌面路径。

Snapshot默认Vulkan出现VK_ERROR_DEVICE_LOST；5秒观察新增10GPUfault，240最后保留480条历史GPUfault/taint0。停止故障会话后及两轮CPU路径无新增，**不代表GPU根因修好，不能写240全程fault0**。与旧CCU修复和211 GPU ISP退出WARN分开。

IMX319竖放24组RAW/RGB均非零；32ms RAWmean69.864/std10.211/max387，92.35%≤80，RGBmean41.97/max153。曝光响应未完成正常光学/颜色验收。S5K3M5、GW1/人像及其它后摄仍待适配。

GNSS见[247](reference/kernel247/README.md)：启动前发布52并回读，416.82秒仅收client1大小查询；OEM板源5MiB/启动分配，当前回INVALID_ID，尚未完整复现。GPS请求0不能排除该依赖。大小候选重发公告30秒0请求，未再搜星；下一步验证启动期client1配置及自有内存/SCM provider，不搬用其它SoC地址。1240份日志/2586个原始C/No全0，ClkFreqUnc1500→94仍无fix。Clock174/PRX722全字段、LNA接线待核；ADC/谱推断不证明物理链路。装机完整，Android定位基线未知。
