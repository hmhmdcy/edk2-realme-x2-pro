# Realme X2 Pro 当前检查点

2026-10-16 GNSS续作242：ROM内7个关键ELF/gps.conf匹配本机；34个modem及173个MCFG源文件匹配原Android备份。Linux90秒仍946有效SNR全0，无正CNR/fix；根因未定。[242分析](reference/kernel242/README.md)、[专项健康](reference/kernel242/clock-session-validation.json)。保持236启动，未刷写重启，三DSP/taint0；其它功能沿用240。

先读[交接步骤](reference/kernel240/HANDOFF.md)、[操作边界](WORKING-BOUNDARIES.md)和[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。[240完整记录](reference/kernel240/README.md)、[240收尾原文](archive/NEXT-SESSION-through240-2026-10-16.md)、[239依据](archive/NEXT-SESSION-through239-2026-10-16.md)保留历史；归档中的active不代表现在已恢复。

## 最后已验证部署

236启动/boot235，guard `/var/lib/samurai/k236-runtime/boot-id-private.txt`，233及更早无效。运输`reference/kernel240/host.py`，私人状态`E:/edk2-samurai-out/kernel240/current-work-private.json`。240收尾时构建/worker/导出全部结束，无切换待决；266项原生证据已私有导出并逐成员核验，三个授权只读代理已完成。当前没有安排新手机操作。

libcamera/IPA/tools/GStreamer/V4L2为`99990.7.2-r15`，config/stack为`0.1.0-r10`，49个载荷不变。Snapshot `51.0-r0`经主机HTTPS中继、手机原可信钥验签及原生离线apk安装，只增14包至958，原944记录不变，world只增版本钉住；卸载模拟恰好14项。相机持久仓库仍239的r15索引，新增包候选索引和事务见交接文档。

“相机（Snapshot）”使用用户级desktop/service覆盖：`GSK_RENDERER=cairo`、`GDK_DISABLE=gl,vulkan,offload`，保留线性DMA-BUF和默认PipeWire bufferpool。desktop直接Exec；新服务目录创建后已ReloadConfig，真实D-Bus激活已验CPU环境。会话bus地址从Phosh实际环境读，不猜不存在的`/run/user/10000/bus`。原签名包文件及Phosh全局GPU/schema未改，尚未集成完整rootfs。[部署锁及两文件副本](linux-port/camera/README.md)。

最后核对：775ko/789项模块及加载note匹配237清单；两sensor/CCI/CAMSS suspended、四camera rails OFF/users0、MCLK1/2关；三DSP、SensorProxy三Has、Wi-Fi/chrony正常。BT powered=true/discovering=false、既有1连接仅观察；GNSS idle0/rate30/signals=false/watch idle/timeprepared/dataworker0；MM状态−1/reason2/power1，用户无SIM。240无新GNSS SET/搜星、刷写或重启。

## 源码、产物与回退依据

模块权威清单为设备`k237-camss-install/module-inventory-after-private.json`。boot/DTB/模块完整hash、大小及回退见239归档和240最后健康收据；不能按目录名或内核release认定构建。

canonical `/home/cy122/pmos-samurai-kernel136/kernel`在240核对时等于after228，本次文档未重新遍历；240未编译/部署新内核，旧相机输出需按当前模块/板源核对后复用。SDK `/home/cy122/x2pro-linux/libcamera214-root`保留`/work/libcamera239-r15-built`源/对象；原214的2254项已恢复、r14缓存保持。r15首参同步和两次start验收保持，旧严格零帧失败未改写。

r15→r13/config-r8用225实际七包和239事务前world/repos/配置，原生降级模拟通过，未完整往返。Snapshot包与启动覆盖是独立两层回退：恢复覆盖时保留用户后续修改；卸载按当前包库求解，旧模拟仅作参考。普通应用回退不要求刷boot或热卸MFD。

S5K3M5候选`reference/kernel240/s5k3m5.c` SHA `9e97813c…`、表头`6a746dc4…`、power include `040ae270…`已源审，**未编译/部署**。917init＋模式3的53写、WRITE8流控/30ms停流、PM引用/残留rail回收和selection高度修正保留。准备脚本可复用，处理一次性备份及重复include追加。

本机S5K资源：19.2MHz、CCI1/master0/0x2d、reset23/MCLK3/CSIPHY3；2104×1560、LLP9648/FLL1663，pixel481930000为OEM元数据，link723.2MHz未实测，gain细步长开放。P现lab mask9且有IMX319消费者；新0x2b union及固定9/0x22子组共享lease设计未实现。需VIO pm8150l_l1、VANA P L6 2.8V、VDIG P L2量化1.056V；VIN/AF L3接线待核，父驱动卸载需先释放并移除消费者。锁、账本及回收契约见240归档；可推进构建、真实C回调故障注入及供电实现。

## 续作与已知风险

建议优先处理Snapshot缓冲所有权和降帧，拍照、切换及长稳可按诊断需要安排。16秒765递增PTS/324次CPU mmap，用户要求的30秒重试1436递增PTS/600次mmap，实际1920×1080 XR24:0、Cairo已记、无应用GPU设备FD、0paintable Bus Error、完整释放恢复。mmap或sink调用不等于实际显示帧数，空V4L2 trace不能推导无帧。实屏画面/颜色反馈仍待；纯色测试按用户延期，普通拍照和本地样本分析按适配需要推进。

仍分别163/301次`was not recycled`，是PW交付/GStreamer持有账本不一致，不当普通慢帧忽略，也未证明越界；pending队列告警属于有界合并。PW1.6.8相机set_format未设FrameDurationLimits，caps30不保证源降帧；Snapshot无用户FPS开关。`use-bufferpool=false`未部署；试验该路径时核对上游锁顺序死锁修复`30ff8da`。

Megapixels缺本机配置，UVC fallback只认uvcvideo、不走r15；无pipeline方向回调可exit1，空相机切换缺保护。会话有`no pipeline`，但无对应操作/栈，不能认定每次闪退触发。受控窗口活12秒，−2是主动收尾，SSH claim被拒未覆盖活动桌面路径。

Snapshot默认Vulkan出现VK_ERROR_DEVICE_LOST；5秒观察新增10GPUfault，240最后保留480条历史GPUfault/taint0。停止故障会话后及两轮CPU路径无新增，**不代表GPU根因修好，不能写240全程fault0**。与旧CCU修复和211 GPU ISP退出WARN分开。

IMX319竖放24组RAW/RGB均非零；32ms RAWmean69.864/std10.211/max387，92.35%≤80，RGBmean41.97/max153。曝光响应未完成正常光学/颜色验收。S5K3M5、GW1/人像及其它后摄仍待适配。

GNSS见[242](reference/kernel242/README.md)及[241](reference/kernel241/README.md)：HAL/AFW/master未恢复接收，D0被拒；缺SV数组不计0。242取得90条PQWM1，RF数值变化非LNA正常证据；RPMH的Y为显示回退，非硬件测量。仍室内窗边/无SIM，可保留Linux继续诊断与室外对照。ROM访问物理userdata，未准备隔离Android，未抓Android运行报文。其它待办保持。
