413当前：本机TMC11直方图/膝点/系数/百分比/对比度生成通过，142份完整数值链路LUT共72704字节零差；动态触发树/运行时版本/实机接入继续，最后实机仍406。[413证据](../../reference/kernel413/README.md)。以下为历史。

400当前：固定CST/CV+CC组合NV12/NV21各八模式实像素通过，单位/零/半幅/通道交换/有符号偏移及格式等价已验证；随后恢复正式395/393四摄48、资源释放。399候选未永久装，完整Gamma/LTM与自动/光学校准继续。[400证据](../../reference/kernel400/README.md)。以下为历史。

399当前：原厂CST/CV完整模式树与实际native字段顺序已恢复，内核类型化CST/CC/CV逐帧链及同IQ页所有权已构建；参数/生命周期/原FW整命令检查通过。399离线，转换组合实像素尚待验证，正式设备最后证据397的395/393四摄48。完整目标active。[399证据](../../reference/kernel399/README.md)。以下为历史。

398当前：纠正未部署IPE候选的实际HAL分支及11位偏移；原厂737叶与合成参数、完整参数页及构建通过，CST/CV契约已核对。398离线未动手机；实机最后证据仍397正式395/393四摄48。完整ISP/多摄目标active。[398证据](../../reference/kernel398/README.md)。以下为历史。

397当前：驱动管理逐帧CC同页参数/程序已接入，固定单位/零/半幅矩阵实像素通过；临时模块已卸，正式395/393四摄48恢复通过。RGB颜色转换域仍待补，不能直接启原厂RGB矩阵；完整IQ/多摄校准active。[397证据](../../reference/kernel397/README.md)。以下为历史。

396当前：原厂CCM计算/固定CDM编码1121组及12组固件准备/路由通过，ARM64核心候选构建通过；尚未接逐帧运行接口或安装，CC像素待验。正式仍395，目标active，完整IQ/多摄校准继续。[396证据](../../reference/kernel396/README.md)。以下为历史。

395当前：A5强制复位改为脉冲并读回CPU停机，双会话真实ACK丢失恢复通过，无重启；正式core395部署、四摄48帧及资源回收通过。第一次计数断言失败/回退和394重启失败分别保留。guard仍394，完整IQ/光学/多摄校准仍active。[395证据](../../reference/kernel395/README.md)。以下为历史。

394当前：一次真实帧ACK丢失触发超时，导入引用保留及IPE复位ACK3,3实测，但完整退映射前设备重启，故障恢复失败保留。正常393核心已在新启动核对，四摄48帧及资源回收通过；guard改394。需先修全局复位/退映射边界，完整IQ/多摄校准仍未完成。[394证据](../../reference/kernel394/README.md)。以下为历史。

361收尾：四摄五模式十原厂线程上下文完成r28曝光／频闪／Gamma请求274帧；隔离模式仍有CAMSS队列重入错误。公共分发器修复ARM64回归通过，未打新包／未安装；设备已恢复r27/r22、338/k298及服务，taint0、资源休眠。 [361交接](../../reference/kernel361/README.md)。以下为历史。

360当前：Gamma与原厂曝光已合并、r28/r23完整包构建签名及组合检查通过，未装；手机已恢复原密钥USB SSH，原r27/338四摄各4帧正常、taint0。新候选实机及完整ICP/IPE等继续。[360详情](../../reference/kernel360/README.md)。以下为历史。

359当前：原厂曝光程序与手动防频闪已接入实际CAMSS IPA候选，ARM64 DSO及公共AGC回归通过，未安装；当前v1隔离IPC和实机画质仍待验证，手机最后仍9008。[359详情](../../reference/kernel359/README.md)。以下为历史。

358当前：原厂防频闪曝光分配数学已在主机/ARM对照通过，参数按正确模式根整理；尚未接IPA或安装，设备恢复状态沿用357。[358详情](../../reference/kernel358/README.md)。以下为历史。

357当前：公共IOMMU引用泄漏修正已构建、未安装；手机CPU停滞后的远程恢复停在9008，现场强制重启请求待回应。[357详情](../../reference/kernel357/README.md)。以下为历史。

356当前：实现A5固件传输候选，纠正板级固件内存地址；实机启动失败，R5进程状态未知／SSH无响应，修正候选未发送。[356详情](../../reference/kernel356/README.md)。以下为历史。

355当前：A5/BPS/双IPE资源后端已完成真实上电、A5版本读取与释放；继续原厂固件HFI启动，默认未改。[355详情](../../reference/kernel355/README.md)。以下为历史。

354当前：ICP DMA内存后端与IOVA0..5MiB真实SMMU探测通过，1280页全部撤销释放；继续A5平台资源与启动，默认未改。[354详情](../../reference/kernel354/README.md)。以下为历史。

353当前：A5/HFI队列与ELF内核核心已构建并完成主机/ARM对照；继续实现IOVA映射和硬件启动，手机默认未改。[353详情](../../reference/kernel353/README.md)。以下为历史。

352当前：LTM逆Gamma可移植实现通过主机/ARM对照，原厂ICP固件及实际队列ABI已恢复，继续补A5硬件后端；默认未改。[352详情](../../reference/kernel352/README.md)。以下为历史。

351当前：原厂LTM/后级CCM完整树及实际HAL逆Gamma默认开关已恢复，识别前摄25组后级矩阵；继续处理后级输出域，默认未改。[351详情](../../reference/kernel351/README.md)。以下为历史。

350当前：原厂IPE Gamma完整树、原HAL插值/编码已核对；LTM逆Gamma及静态覆盖影响最终色调，继续提取。没有改手机默认。[350详情](../../reference/kernel350/README.md)。以下为历史。

349当前：IFE Gamma候选IPA与348内核组合实测通过，尚未安装；原厂后级IPE Gamma已发现，继续核对最终色调链后再更新默认。[349详情](../../reference/kernel349/README.md)。以下为历史。

348当前：原厂Gamma已通过新增原生IFE参数在VFE175实机生效，四摄取流兼容；尚未接入默认IPA，实验后恢复338。下一步用户空间配置与组合部署。[348详情](../../reference/kernel348/README.md)。以下为历史。

347当前：原厂IFE Gamma全部提取，模式对应和两架构编码通过，尚未接入硬件；346 EV/FPS活动表数学也已完成。344默认四摄私有WB/LSC/CCM保持。[347详情](../../reference/kernel347/README.md)。以下为历史。

345当前：新增原厂曝光表分配与FPS knee通用数学，两架构对照通过；尚未接IPA，344默认四摄私有校准保持。[345详情](../../reference/kernel345/README.md)。以下为历史。

344当前：本机四份私有调校已通过标准/etc路径成为默认；五模式229帧动态参数、默认GStreamer/PipeWire通过，正常光学校准仍未完成。框架r27/config-r22、CAMSS338保持。[344详情](../../reference/kernel344/README.md)。以下为历史。

343当前：恢复原厂模式树与普通持续取流table0选择；五BIN3584项核对通过，生成按明确模式/用途选择的私有校准配置，尚未启用为默认。现机仍342 r27/r22。[343详情](../../reference/kernel343/README.md)。以下为历史。

342当前：已安装r27/r22，包含个体WB/CCT、实时lux驱动CCM与动态LSC；四摄已安装版本通过显式配置测试，默认个体校准仍未开启。模式曝光表绑定及正式光学等继续。[342详情](../../reference/kernel342/README.md)。以下为历史记录。

341当前：候选IPA的动态LSC已与WB/CCM统一排队；四摄工厂/个体配置最终369帧通过，前摄原厂CCM禁用保持。候选未安装，模式/供应商绑定及发布继续。[341详情](../../reference/kernel341/README.md)。以下为历史记录。

340当前：候选IPA已联动实时AEC/CCT与CCM，四摄222帧矩阵按实际内核SOF与模型一致，曝光/增益改变后图像随矩阵改变。已部署CAMSS338，IPA候选未装；动态LSC与模式绑定继续。[340详情](../../reference/kernel340/README.md)。以下为历史记录。

339当前：候选IPA已计算逐帧曝光/亮度/lux index，四摄内部图案与原厂指令核对通过；已安装CAMSS338，IPA仍r26。物理模式绑定及lux动态LSC/CCM待继续。[339详情](../../reference/kernel339/README.md)。以下为历史记录。

338当前：已部署CAMSS32×16统计网格及CCM硬件后端，四摄真实统计、AWB收敛与安装后Gst/PW取流通过；实时lux与动态调校IPA仍待接入。[338详情](../../reference/kernel338/README.md)。以下为历史记录。

337当前：普通Bayer统计到原厂16×16亮度/lux路径在主机与ARM各1523组一致；发现32×24网格不兼容，下一步底层统计网格适配。尚未接入实时IPA或更改手机。[337亮度链](../../reference/kernel337/README.md)。以下为历史记录。

336当前：原厂AEC曝光索引/lux数学在主机及ARM各2554组逐字节一致，五份曝光表与关键lux字段完成解码；实时Bayer亮度转换/模式绑定尚未完成，未改手机。[336曝光触发语义](../../reference/kernel336/README.md)。以下为历史记录。

335当前：手动矩阵/色温/通道增益/自动WB与硬件CCM已联动，20项ARM IPA检查与四摄五配置六阶段通过；候选临时运行后恢复，尚未安装，非CCT触发仍为诊断值。[335联动](../../reference/kernel335/README.md)。以下为历史记录。

334当前：VFE175颜色矩阵后端通过Werror、主机/ARM寄存器测试和实机8阶段/四摄Gst验证；临时模块已恢复，尚未安装或联动332 CCT。下一步IPA矩阵控制和色温联动。[334硬件支持](../../reference/kernel334/README.md)。以下为历史记录。

333当前：原厂CCM完整28根/567区与XML对应，通用插值/编码主机和ARM各2866例通过。确认现机VFE175仍拒绝矩阵参数，下一步补SoC后端再联动CCT。[333数据与实现](../../reference/kernel333/README.md)。以下为历史记录。

332当前：候选IPA已支持个体参考点驱动的手动/自动增益色温估计，15项AArch64及四摄153帧对照通过；仅临时加载，系统部署不变。CCM和动态LSC/lux继续。[332实现](../../reference/kernel332/README.md)。以下为历史记录。

331当前：已提取个体refPt校准、反向CCT/距离/分类通用数学，每架构10450组查询与原厂指令一致；尚未接入IPA自动估计。330手动色温候选和系统部署保持。[331实现](../../reference/kernel331/README.md)。以下为历史记录。

330当前：可选个体WB和启动/运行中色温控制已接入候选IPA，四摄内部图与13项AArch64测试通过；临时加载，系统部署及默认配置未变。自动CCT/CCM/动态校正继续。[330实现与验证](../../reference/kernel330/README.md)。以下为历史记录。

329当前：新增通用WB校准、MWB比值转换与正向CCT查表，主机/ARM各3118值与本机原厂指令仿真完全一致；尚未接入IPA或安装，动态CCT/完整校准继续。四摄unit LSC及现有部署保持。[329数学实现](../../reference/kernel329/README.md)。以下为历史记录。

328当前：327四摄unit LSC证据保持；四摄及两主摄分支43个AWB参考/golden/MWB根完成解码、个体WB格式与HAL色温传递确认，原厂AWB/AEC算法只读取回并定位。动态CCT/lux和个体WB尚未接入，部署不变。[328来源与语义](../../reference/kernel328/README.md)。以下为历史记录。

327当前：r26/config-r21与325 GW1/318 CAMSS部署保持；主/前/长焦个体LSC主表已通过临时配置实际应用，加上322广角，四摄链路齐全。14份IPA网格与独立模型完全一致，7组成对图像显示补偿效果；默认及动态调校、正常光照/几何同步校准仍未完成。[327实测](../../reference/kernel327/README.md)。以下为历史记录。

315（2026-10-19）：libcamera候选接入RAW-only、NV12-only及RAW＋硬件NV12同请求；六模式默认AE/AWB、四摄RAW-only、主摄双流／RAW-only AF和取消、一次缓冲暂停恢复通过。902请求／1405应用缓冲，868次SOF事件时间关联均匹配。RAW直接DMA，RAW-only暂保留内部PIX；事件时间不是曝光时间或硬件帧ID。仅临时候选，已恢复309，产品仍RAW＋CPU ISP，完整校准与产品接入未完成。[315实现与实测](../../reference/kernel315/README.md)。以下按历史阅读。

314（2026-10-19）：公共CAMSS接入共享CSI streams API，四颗摄像头各自通过RAW＋硬件NV12并行、独立停流／重开及连续换摄，共259路输出帧。修复IPP退出超时与RDI过早回收DMA；仅临时模块，现已恢复309。SDK仍313，产品仍RAW＋CPU ISP；libcamera双流请求／物理帧关联、产品接入和完整校准未完成。[314实现与实测](../../reference/kernel314/README.md)。以下按历史阅读。

305（2026-10-19）：USB恢复，启动ID变化后重新建立#298基线。仅长焦模块更新，标准几何及产品四摄348帧回归通过，taint/fault0；产品仍RAW＋CPU ISP，完整校准目标active、未完成。[305当前事实](../../reference/kernel305/README.md)。以下按历史阅读。

304／303（2026-10-19）：已核同一#298，使用原密钥Wi‑Fi，USB端口重置错误未修。候选联合控制480帧、硬件AE隔离／线程960帧及81响应域同帧核对通过；当前低照度上限正确、目标收敛未验。304纠正旧EEPROM XML错位并独立解码WB／LSC，未过完整校验、未应用。产品RAW＋CPU ISP不变，目标active、未完成。[303实机](../../reference/kernel303/README.md)、[304解码](../../reference/kernel304/README.md)。以下按历史阅读。

303（2026-10-19）：目标恢复active。手机不可达、当前启动未复核，最后实机记录#298／产品RAW＋CPU ISP；候选复用通用AGC，真实DSO及线程各720帧合成模型通过，未上机。QEMU clone3 ENOSYS，独立IPC未验收；联合锁存、硬件AE实景、AWB及多摄完整校准待办。[303源码与边界](../../reference/kernel303/README.md)。以下按历史阅读。

2026-10-19交接：适配目标已暂停，实际#298／候选302及未验收范围保持；本轮仅文档与旧编译产物清理。[交接、保留产物与重建方法](../../reference/maintenance-2026-10-19/README.md)。以下实验结论按当时记录阅读。

302（2026-10-19）：实际仍#298／产品RAW＋CPU ISP。候选复用SensorHelper／DelayedControls，标准Manual曝光增益及有效SOF元数据接入；隔离／签名线程共960帧、36控制变化、144图像分区响应通过，均从真实写入SOF＋2变化。媒体图／控制恢复，资源自然休眠；AE／AWB、多摄及完整校准未完成。[302证据](../../reference/kernel302/README.md)。以下旧阶段按历史阅读。

301（2026-10-19）：实际内核仍#298，产品RAW＋CPU ISP不变；IMX319本模式240图像／统计配对、233个SOF事件、9次曝光／增益写入均在SOF＋2观察到BHIST响应。原图／控制恢复、资源自然休眠；未接DelayedControls或AE／AWB，未证明跨模式延迟或完整校准。[301证据](../../reference/kernel301/README.md)。以下旧阶段按历史阅读。

298（2026-10-19）：现机#298／778模块，公共WB减偏移映射BLS，长焦11阶段最大通道误差<1.337、六次图像生效帧对应。广角RAW场景估计64 DN及临时WB／gain改善暗绿；非遮光标定、未安装调校。两个硬件探针252图像／222统计，RAW18帧，四摄18段233帧通过。正式校准与硬件pipeline／IPA仍未完成。[298证据](../../reference/kernel298/README.md)。以下旧阶段按历史阅读。

300（2026-10-19）：实际内核仍#298、产品RAW＋CPU ISP；IMX319标准手动硬件IPA候选接通。签名线程／独立进程各三轮24帧，共144图像／统计／SOF／ColourGains元数据通过；修复重复init线程归属与测试图恢复顺序，原图／资源恢复。候选未安装，自动算法／多摄完整校准／逐帧控制与EEPROM校验仍未完成。[300证据](../../reference/kernel300/README.md)。以下旧阶段按历史阅读。

299（2026-10-19）：实际内核仍#298；原厂IMX319 BLS全部16模式／288区域交叉解码与实机对照通过，本机EEPROM双读12287字节一致，完整布局和校验未通过、未应用。真实libipa编码器已验证；在线libcamera handler仅隔离候选，构建／实机状态见299记录，未接正式IPA，产品仍RAW＋CPU ISP。[299证据](../../reference/kernel299/README.md)。以下旧阶段按历史阅读。

297（2026-10-19）：现机#297／778模块，图像／统计共享CAMIF SOF，126图像／111统计／128事件通过，110组配对、断粮恢复保留7帧间隔；5次ROI／6次WB生效帧对应。广角18／18有效，四摄18段232帧通过。固定BLS12协议资料，BLC／偏色／硬件pipeline／IPA仍待完成。[297证据](../../reference/kernel297/README.md)。以下旧阶段按历史阅读。

296（2026-10-19）：现机#296/778模块，SoC驱动补BHIST SRAM初始化；216硬件图像/198统计、7个启动/重开/晚启动首包通过，含晚启前改最小ROI。无丢弃首包或用户空间MMIO写入；四摄RAW＋CPU ISP18段244帧通过。统计SOF关联、BLC/IPA、主/前摄硬件路径和完整画质仍未完成，目标active。[296当前证据](../../reference/kernel296/README.md)。以下旧阶段按历史阅读。

295（2026-10-19）：现机#295/778模块，BHIST稳定帧全/半/最小ROI通过，广角实景统计随曝光变化；启动/图像重开首个统计包仍异常，统计完整验收未通过，暂不交AE/IPA。WB99帧、四摄RAW＋CPU ISP18段237帧通过；当前SSC/桌面默认成功，293偶发失败根因未关闭，BLC/IPA/完整画质未完成。[295当前证据](../../reference/kernel295/README.md)。以下旧阶段按历史阅读。

293（2026-10-19）：实际#293/778模块，标准WB参数81帧/10非法包/7完成/九阶段色彩及五次帧号对照通过；广角实景18帧可辨结构，四摄RAW＋CPU ISP 18段232帧通过。SSC默认FastRPC attach EPERM/exit4、SLPI offline，已一次临时nodeps恢复桌面，自动旋转不可用；统计/BLC/IPA及完整画质未完成。[293当前证据](../../reference/kernel293/README.md)。以下旧阶段按历史阅读。

291（2026-10-19）：现机仍#290/778模块，广角RGGB与长焦GRBG已经真实CSI→CSID175 IPP→VFE175 FULL取得硬件NV12；传感器内部图案分别对照独立RDI RAW，红蓝及色彩转换通过。六组共108帧，结束后四摄18段229帧回归通过。广角实景RAW近黑电平，正常实景/黑电平校正/统计参数/IPA与完整画质仍未完成。[291证据](../../reference/kernel291/README.md)。以下按各历史阶段阅读。

290（2026-10-19）：#290完整Image/独立778模块已部署，原厂协议确认并修复VFE175 FULL后处理门控，带入TPG历史隔离和Gamma时钟修复。四摄RAW＋CPU ISP 235帧；标准接口TPG硬件NV12三帧、黑白中性通过，无用户态MMIO。实体硬件ISP/独立红蓝/统计与IPA/完整画质仍待做。[290证据](../../reference/kernel290/README.md)。以下旧阶段按当时状态阅读。

289（2026-10-19）：现机为288完整Image/778模块，四摄RAW＋CPU ISP回归234帧；本轮定位内部TPG继承C-PHY及Gamma SRAM上传缺时钟，修复候选ff8d2e9fc完整构建通过、未部署。临时硬件对照192个LUT字精确读回，黑白亮度恢复但色度仍错误，CST/统计/IPA继续；根部署锁已更新。[289证据](../../reference/kernel289/README.md)。

287（2026-10-19）：Demux/MNDS16候选6ddf1ba4c通过ASan/UBSan、39组件Werror及完整Image/778ko。未部署仍3RDI，输入域/DMI/硬件图像/统计/IPA待验；现机276/r24/r19保持。[287来源与分层](../../reference/kernel287/README.md)。

286（2026-10-19）：FULL输出位深/Gamma16候选209d1ea0f通过主机ASan/UBSan、37组件Werror及完整Image/778ko。DMI/物理颜色、Demux/MNDS/统计/IPA仍待硬件验证，未部署、仍3RDI；现机276/r24/r19载荷/模块/服务/PM保持。[286证据](../../reference/kernel286/README.md)。

285（2026-10-19）：CST12/601-709 full-limited内部矩阵及生命周期候选d1a5f8440通过ASan/UBSan、35组件Werror及完整Image/778ko；未部署、仍3RDI，硬件色序/位深/Gamma/统计/IPA未验收。现机276/r24/r19的载荷/模块/服务/PM保持。[285证据](../../reference/kernel285/README.md)。

284（2026-10-19）：原厂mask2确认Demosaic36，新候选af9e2a023通过34组件Werror/ASan/UBSan及完整Image/778实际ko；全部构建终态，未部署，仍3RDI。CST/位深/缩放/统计/IPA及完整硬件成像未完成；现机boot276/Image183/r24/r19保持。[284证据](../../reference/kernel284/README.md)。

283（2026-10-19）：VFE175 WB/Q7及首帧typed参数队列候选97a4c5638通过33组件Werror/ASan/UBSan，独立index保存、未checkout/部署；仍3RDI，硬件成像/统计/IPA未完成。282 r3完整构建仍读固定18b源码，r2因C盘满/IO错误终态1，E盘构建卷已恢复。现机boot276/Image183/r24/r19保持。[283证据](../../reference/kernel283/README.md)。

282（2026-10-19）：公共多流修复2985ef200及175 FULL双平面输出候选18b489397已通过32组件编译和实际函数ASan/UBSan；未部署，硬件成像/统计/IPA仍未完成。完整构建首次漏长焦配置受控终止，仅补S5K3M5=m后r2已启动、结果待核。现机boot276/Image183/r24/r19及50载荷/776模块/原服务/PM保持。目标按用户要求继续直至适配完成。[282证据](../../reference/kernel282/README.md)。

281：只读原厂HAL静态符号/寄存器交叉依据，新增VFE175 CAMIF/PIX更新IRQ及prepare错误返回候选21facb9a7；31组件W=1/-Werror与实际函数ASan/UBSan通过，未部署，PIX/硬件成像仍未开放。现机保持boot276/Image183/r24/r19，50载荷/776模块、原服务/PM及vendor卸载复核通过；处理/输出/统计/IPA、画质与GUI录像仍待完成。[281证据](../../reference/kernel281/README.md)。

280当前：原厂SM8150选择VFE175/CSID175，已纠正将共用vfe_ops_170名称当实际硅型号的说法。175 IPP解码/IRQ/halt及错误返回源码候选7f81d76ee编译/主机测试通过，未部署，VFE175处理/输出及硬件成像仍缺。现机保持boot276/Image183、r24/r19单次AF、50载荷/776模块；版本读取及采集收尾失败/恢复如实保留，最终资源健康。[280证据](../../reference/kernel280/README.md)。

279：优先复用现有仓库/方案，已保存并编译公共CAMSS ISP输出/参数/统计独立候选30b0daa8c，修复共用VFE17x迁移和参数边界；未部署。现机保持278的boot276/Image183、libcamera r24/config-r19和标准单次AF；50载荷/776模块及资源健康复核通过。[279方案、源码与边界](../../reference/kernel279/README.md)。

278：boot276/Image183保持，libcamera r24/config-r19已部署标准单次Auto AF和帧统计/镜头回执。原生触发/取消/重触发/停流及AE下AF通过，四摄232帧回归。配对测量AF约9–12秒需加速；连续AF/距离标定、画质、GUI录像、Spectra和完整统一构建仍未完成。[278证据](../../reference/kernel278/README.md)。以下按历史阶段阅读。

277当前：boot276/Image183、776模块/961包，libcamera r23/config-r18。公共RAW空间统计及标准FocusFoM已部署；主摄固定曝光失焦/返回、同request RAW与元数据一致、四摄241帧回归通过。AF搜索/标定、画质、GUI/录像、Spectra与完整统一构建仍未完成。[277证据](../../reference/kernel277/README.md)。以下按历史阶段阅读。

276当前：boot276/Image183、776模块/961包、libcamera r22/config-r17。标准镜头/流生命周期及公共CCI共享I/O供电已部署；标准手动对焦光学响应、前＋三后摄238帧回归与资源回收通过。默认SSC/桌面正常启动，物理旋转待重测、旧EPERM根因未明。AF算法、画质、四摄GUI/录像、Spectra和完整统一构建仍待完成。[276实际状态](../../reference/kernel276/README.md)、[原厂调校依据](../../reference/kernel276/OEM-TUNING.md)。以下按各历史阶段阅读。

274：主摄原厂镜头命令已产生真实光学响应；标准V4L2 lens/静态DT/独占VAF候选0798ee688已编译并通过13个回调主机用例，尚未部署，须先配套Simple lens生命周期。相同96组控制两轮通过但旧失败根因未明；现机仍273/r21，SSC失败及Spectra未接通保持。[274证据与分层](../../reference/kernel274/README.md)。以下按各历史阶段阅读。

273已部署：GW1主摄已实机绑定并经C-PHY取得RAW/RGB和实景JPEG，前摄＋三后摄238帧交替通过。当前boot273/Image183、775ko/961包、libcamera r21/config-r16；完整控制切换仍失败，AF/画质/GUI/Spectra及SSC开机问题未完成。[实际状态](../../reference/kernel273/README.md)。以下272及更早内容按当时状态解释。

272未部署候选：新增GW1标准驱动、静态DT/binding和libcamera helper，编译/主机故障注入通过；现机仍为下述271，主摄出帧/AF/Spectra未完成。[候选与证据](../../reference/kernel272/README.md)。

271（2026-10-18）：当前S5K3M5原生32…512增益码与libcamera r20/config-r15已配套部署；前摄/两后摄原生回归通过，长焦持续预览已有明亮实景，首次AE慢、画质/AF/主摄/Spectra仍待完成。当前身份与源码见[271](../../reference/kernel271/README.md)。下文旧阶段按历史解释。

# Realme X2 Pro 相机接入

270当前：boot270/Image183，774模块/961包；新增S5K3M5长焦完成公共供电/标准DT、chip-ID、RAW/RGB和彩条验证，前摄及两后摄192帧交替回归通过。两后摄可生成JPEG，但长焦真实样本近黑电平，光学成像仍未完成；GW1主摄仅数据解析交叉核对完成，新三摄GUI、AF、录像、画质、GPU/Spectra仍开放。[270](../../reference/kernel270/README.md)、[检查点](../../NEXT-SESSION.md)。旧部署锁记录只覆盖旧组合，尚未将新增长焦整合为完整rootfs/APK发行。


2026-10-18最新：[269收尾](../../reference/kernel269/README.md)。整屏旋转使用RMX1931板级标准udev安装矩阵，用户确认恢复正常；桌面服务依赖已修，首次整机启动顺序待验。统一Image/773模块/DTB已构建，未刷入；手机仍267固件/Image183、r19/r14、PW r3，意外重启后改用269guard。用户打开Snapshot发生卡死重启，pstore末尾modem watchdog，原因未解决；本轮补测没有出帧，不能视为通过。完整rootfs、画质/其它镜头/GPU/录像/长稳仍未完成。本轮按用户要求收尾；以下各阶段的active、健康和构建待办只对应其历史窗口。

267/268阶段历史结果：[267](../../reference/kernel267/README.md)已部署双PM8008公共MFD/regulator、标准IMX319和RMX1931设备树，撤掉lab供电与板级reset模块；[268](../../reference/kernel268/README.md)公共libcamera r19/config-r14修复跨进程链路缓存，保持PW/SPA/Gst r3。标准cam、跨框架交替及未改Snapshot前后预览、界面切换、拍照和JPEG解码通过。现boot267/Image183、773ko/961包。主线维护分支已同步实测源，设备树/供电由内核标准接口管理，应用无需机型补丁；本地扩展尚未上游接收，Cairo启动回退、画质/其它后摄/GPU/录像和完整Image/rootfs仍开放。当前版本与证据见[部署锁](deployment-lock.json)。下文240版本与进程均为历史记录，不作为当前操作身份。

240交接时完整适配目标为paused、未完成；267/268继续推进，269按用户要求收尾。以下保留240历史实测，续作建议、脚本风险及回退入口见[240交接](../../reference/kernel240/HANDOFF.md)，当前规则仅见[操作边界](../../WORKING-BOUNDARIES.md)。

当前236启动/boot235、前摄e49/IMX319176f/CAMSSff9和libcamera r15/config-r10保持。240补桌面接入：Megapixels缺本机配置且不走libcamera；Snapshot原默认Vulkan出现GPU故障，现使用仅该应用的Cairo＋线性DMA-BUF CPU映射回退。[问题、失败与修复证据](../../reference/kernel240/README.md)、[部署锁](deployment-lock.json)。

桌面“相机（Snapshot）”及实际D-Bus激活均继承GSK_RENDERER=cairo、GDK_DISABLE=gl,vulkan,offload。用户级desktop/service覆盖，原签名包文件不变，不改Phosh全局环境；新服务目录创建后已ReloadConfig并实测。原生签名安装只新增14包至958，r15/r10的49载荷和原944包记录不变。完整rootfs仍须纳入这些应用/启动配置；用户覆盖不是新rootfs镜像。

前摄16秒及用户要求的30秒重试分别取得765/1436个递增PTS、324/600次1920×1080 XR24:0 CPU mmap，0paintable Bus Error、无应用GPU设备FD/新增内核fault；关闭后图/格式/控制/rail/PM/MCLK恢复。历史480条默认Vulkan故障保留。163/301次缓冲未回收错误、帧积压仍待修，不能称完整拍照或光学验收。当轮未触发快门、保存或转移场景像素；普通拍照、本地样本分析和补光可按任务安排。前摄纯色测试按用户延期。

IMX319竖放同request RAW/RGB24组均非零，32ms仍92.35% RAW≤80；非零/曝光响应不代表正常光学。S5K3M5的917初始化＋模式3表和PM候选已源审，尚未编译部署；本机P L2/L6共享lease未实现。其它后摄、颜色/方向、GPU ISP、性能/长稳和完整kernel/rootfs开放。[近机型参考](../../reference/kernel239/RELATED-LINUX-SOLUTIONS.md)。

r15首参数修复与两次start验收、r15→r13/r8七包模拟回退及实际旧包保留见[239](../../reference/kernel239/README.md)。canonical在240核对时仍after228，复用旧产物时按当前模块/板源核对；卸载lab/MFD前先停流、释放并移除消费者。

当前已部署的[desktop副本](snapshot-launcher/org.gnome.Snapshot.desktop)和[D-Bus service副本](snapshot-launcher/org.gnome.Snapshot.service)按原生事务hash保存，供后续rootfs打包；不是已生成的新rootfs。回退时用事务manifest识别两项用户覆盖并保留用户后续修改；驱动或应用补丁按任务需要修改、打包。
