# Realme X2 Pro 当前检查点

最后核对：2026-10-15，阶段193，完整外设goal active。前摄实体IMX471已通过CCI读到0x0471；真实图像仍未取得。r2独立诊断因MCLK电源域关闭产生一次WARN，当前taint512；r3持有CCI父设备PM引用后读取成功且无新增故障。诊断资源已撤销。规则见[边界](WORKING-BOUNDARIES.md)，用户暂无耳机。

## 当前部署与实机依据

| 项目 | 最后核对 |
| --- | --- |
| 组合 | kernel183/logdump183、boot/DTB172；modules132覆盖hci_uart185/fastrpc189，Mesa149/UCM173 |
| 相机193 | CCI1临时注册两master；GPIO29/12、VIO1.8V、Q L5=2.8/L2=1.056V、19.2MHz，两个VREG_READY后真实ID0x0471；PMIC采样/GPIO恢复，正式驱动与MIPI未接入 |
| 最新11872.27秒 | 同189第二新boot，taint512/WARN1来自r2时钟；三个DSP running、MM191/PowerState3/GPS0、SensorProxy三个Has true。全boot BT重组1，Oops/GPU/SLPI fatal0 |
| GPS191 | 50406字节50片标准MM注入约0.801秒，49片完成先于ACK；有效期0→168小时，XTRA/3服务器。300秒303条NMEA仍无fix/CNR，电源online后另90秒仍无fix |
| 189传感器PM | 45.2784/45.2053/45.2838秒，success3/fail0/RTC3、7266 callbacks err0；醒后四CLI及Wayland UID10000 Claim/Release通过 |

依据：[193实体前摄](reference/kernel193/README.md)、[原生三轮](reference/kernel193/front-native-validation.json)、[最终健康](reference/kernel193/native-health-validation.json)、[191 GPS](reference/kernel191/README.md)。[192逐字快照](archive/NEXT-SESSION-through192-2026-10-15.md)保存上一完整检查点与旧源/回退索引，相对链接按根目录解释。

## 源码、产物与回退依据

- 193只新增开发helper：drivers/of/Kconfig/Makefile和samurai-cci-bringup.c、samurai-front-identify.c，默认禁用。[完整补丁](reference/kernel193/samurai-camera-bringup.patch)；前摄源47ec57a2…/模块c9856835…，CCI模块d3b4610d…。树内Kbuild、W=1告警0/符号匹配；16/49实际C函数场景与ASan/UBSan通过。不是正式IMX471驱动修复或实体出图。
- 当前临时模块全部卸载，CCI1恢复disabled，i2c-6/7与Q PMIC临时客户端移除。S8C保持1.352V/用户3，另ldo1a0.752V/用户1；相机VIO1.8V/用户0现明确disabled（此前unknown）。GPIO12/15/29恢复输入低，MCLK pin_CTL整值恢复。r2 WARN/taint512未清除；原始失败均保留。
- WSL内核/home/cy122/pmos-samurai-kernel136/kernel，193前14源保持：183的12源+hci_qca185+fastrpc189。新增2个tracked构建文件/2个新C；Image/DTB/config保持，config SHA55f1f0a3…，Module.symvers16793行/modules.order770恢复。FastRPC源41c8db5c…/模块88553112…，hci_uart f6c5ed35…；原件回退在189，不强卸载运行模块。
- MM固定提交7f0bf17ab518cd78925cf7e53cc0d5c42f88b41a；190能力发现+191四条LOC异步顺序/独立引用/提前完成/分片关联/回退清理补丁。257场景/4原版失败/3破坏变体通过；原生XTRA回退成功，Predicted成功仅模拟。当前程序b350c55ba334b7d23564136fe3ce19bf37f95db0d374f63cc89351341d9b9ddc，源949132f3…。
- MM native190源已更新191，隔离签名SDK复用；190程序fbc40848…在k191-mm-deploy/ModemManager.original及主机kernel191/ModemManager.before191；发行版4d5a8258…在190。激活/INFO已恢复，APK DB未改；正式入包仍待办，APK更新会覆盖。
- SSC固定1902…文件服务、184独立libssc、每boot一次门控；303来源/24固件只复制私人RAM。A.11路径/lib/firmware/qcom/sm8150/realme/samurai-a11-r187，原00121保留。共享池−22未解决，持续服务不盲目stop/start。
- 当前启动身份手机k189r2-reboot-runtime/boot-id-private.txt，193基线另保存；host193沿用190私人Wi-Fi端点和原HostKeyAlias/公钥。USB190双向IPv6未恢复，一次gadget重绑无正向证据，Windows网卡复位拒绝访问。下一boot先读新身份/端点，不沿用旧PID或启动标识。
- 193私人归档936fe956…/67文件、192归档322bfbce…/23文件均逐成员验证；191主843c4d47…/42与radio b6628078…/23保留。BDS164/固件172/FdtBlob129及183/181回退和NV/校准备份保持。

## 续作与已知风险

1. 优先正式接入前摄IMX471：OF/三路电源/选择GPIO/PM关系、CCI1 master1、DPHY2/CAMSS及取帧。当前VIO DT节点无phandle且ldo1重名，诊断名称查找校验1.8V只是临时方法，正式DT必须明确供电引用。主线驱动仅ACPI/vana，尚未修改。192原厂六BIN前缀已独立核对，只有前摄身份本轮实体确认；其它候选不能当实装。
2. P@0x08/09复位GPIO1原低，临时释放可识别后已恢复；Q@0x04/05、GPIO4保持，SID2/1、全局使能均1。OEM请求1.05/1.10V实际编程1.056/1.104V已核。Q L5当前可达ready不证明四组PLDO父供电网络；冷地址/复位、其它相机、完整模式/用户态及长稳仍开放。内部TPG三帧不是实体出图。
3. DMS已只开启一次，保持online/PowerState3，不重复重启。GPS辅助/UTC完整注入通过，仍无有效fix/CNR，16条SV事件无列表；接收条件与RF/平台原因未区分。继续GNSS-only GeoClue/自动辅助加载和本机RF/时钟核对，保留正常授权，不冒用Phosh或伪造坐标；168小时不证明跨基带重启保留。
4. 两UIM卡位no-atr-received/Slot absent-active，MM仍sim-missing/bearer0；不等于已确认物理插卡状态。卡槽、注册、数据、通话/SMS待验。BT phase5/3.2Mbps/chunk13/partial0/firstff重组1与185旧phase2前导00不同，继续只扫描。
5. FastRPC普通信号/freezer、共享池stop/start/reclaim−22/SSR及传感器运动/方向/亮暗/精度/冷启/长稳开放；失败SCM原型不当修复，不试遍未知owner。Wi-Fi189第二轮35秒未关联，第三轮PM后才恢复，不称自行恢复；USB独立链路问题仍待解。其它见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。

导航：[会话索引](sessions/INDEX.md)、[文档索引](DOCS-INDEX.md)。
