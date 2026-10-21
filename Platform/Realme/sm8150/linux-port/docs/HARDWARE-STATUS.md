421当前：IPA2候选真实同SOF观测/最终回执通过，修复同步IPA期间过早判统计缺失，主摄修复后12/12观测配对；真实缺统计及乱序提交分开处理。候选未安装，正式420 r31/r26及419驱动保持，当前239direct错误/取消0。自动非零IPE数值及完整校准继续。[421证据](../../reference/kernel421/README.md)。以下为历史。

400当前：固定CST/CV+CC组合NV12/NV21各八模式实像素通过，单位/零/半幅/通道交换/有符号偏移及格式等价已验证；随后恢复正式395/393四摄48、资源释放。399候选未永久装，完整Gamma/LTM与自动/光学校准继续。[400证据](../../reference/kernel400/README.md)。以下为历史。

399当前：原厂CST/CV完整模式树与实际native字段顺序已恢复，内核类型化CST/CC/CV逐帧链及同IQ页所有权已构建；参数/生命周期/原FW整命令检查通过。399离线，转换组合实像素尚待验证，正式设备最后证据397的395/393四摄48。完整目标active。[399证据](../../reference/kernel399/README.md)。以下为历史。

398当前：纠正未部署IPE候选的实际HAL分支及11位偏移；原厂737叶与合成参数、完整参数页及构建通过，CST/CV契约已核对。398离线未动手机；实机最后证据仍397正式395/393四摄48。完整ISP/多摄目标active。[398证据](../../reference/kernel398/README.md)。以下为历史。

397当前：驱动管理逐帧CC同页参数/程序已接入，固定单位/零/半幅矩阵实像素通过；临时模块已卸，正式395/393四摄48恢复通过。RGB颜色转换域仍待补，不能直接启原厂RGB矩阵；完整IQ/多摄校准active。[397证据](../../reference/kernel397/README.md)。以下为历史。

396当前：原厂CCM计算/固定CDM编码1121组及12组固件准备/路由通过，ARM64核心候选构建通过；尚未接逐帧运行接口或安装，CC像素待验。正式仍395，目标active，完整IQ/多摄校准继续。[396证据](../../reference/kernel396/README.md)。以下为历史。

395当前：A5强制复位改为脉冲并读回CPU停机，双会话真实ACK丢失恢复通过，无重启；正式core395部署、四摄48帧及资源回收通过。第一次计数断言失败/回退和394重启失败分别保留。guard仍394，完整IQ/光学/多摄校准仍active。[395证据](../../reference/kernel395/README.md)。以下为历史。

394当前：一次真实帧ACK丢失触发超时，导入引用保留及IPE复位ACK3,3实测，但完整退映射前设备重启，故障恢复失败保留。正常393核心已在新启动核对，四摄48帧及资源回收通过；guard改394。需先修全局复位/退映射边界，完整IQ/多摄校准仍未完成。[394证据](../../reference/kernel394/README.md)。以下为历史。

361收尾：已安装r27/r22与CAMSS338/k298；四摄基础取流沿用360，候选十线程上下文274帧请求通过，隔离队列仍失败；新候选未安装。ICP/IPE、完整光学与多摄校准未完成。 [361交接](../../reference/kernel361/README.md)。以下为历史。

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

280当前：原厂SM8150实际选VFE175/CSID175；共用vfe_ops_170符号不能代表硅型号。175 IPP传输/IRQ/halt及错误返回候选7f81d76ee通过ARM64对象W=1/-Werror和ASan/UBSan，未部署；VFE175完整PIX/统计输出/IPA仍缺。现机保持boot276/Image183、776模块/961包、r24/r19单次AF；只读版本及120帧记录失败/恢复保留，最终50载荷/模块/原服务/PM通过。[280证据](../../reference/kernel280/README.md)。

279：优先检索并固定IFE/OPE/libcamera/同平台方案；公共ISP输出/参数/统计源码候选30b0daa8c通过ARM64对象W=1/-Werror及参数ASan/UBSan，未部署。现机仍boot276/Image183、776模块/961包、r24/r19单次AF；完整链接、硬件ISP、连续AF/标定、画质/GUI录像仍待做。[279证据](../../reference/kernel279/README.md)。

278：boot276/Image183保持，libcamera r24/config-r19已部署标准单次Auto AF和帧统计/镜头回执。原生触发/取消/重触发/停流及AE下AF通过，四摄232帧回归。配对测量AF约9–12秒需加速；连续AF/距离标定、画质、GUI录像、Spectra和完整统一构建仍未完成。[278证据](../../reference/kernel278/README.md)。以下按历史阶段阅读。

277当前：boot276/Image183、776模块/961包，libcamera r23/config-r18。公共RAW空间统计及标准FocusFoM已部署；主摄固定曝光失焦/返回、同request RAW与元数据一致、四摄241帧回归通过。AF搜索/标定、画质、GUI/录像、Spectra与完整统一构建仍未完成。[277证据](../../reference/kernel277/README.md)。以下按历史阶段阅读。

276当前：boot276/Image183、776模块/961包、libcamera r22/config-r17。标准镜头/流生命周期及公共CCI共享I/O供电已部署；标准手动对焦光学响应、前＋三后摄238帧回归与资源回收通过。默认SSC/桌面正常启动，物理旋转待重测、旧EPERM根因未明。AF算法、画质、四摄GUI/录像、Spectra和完整统一构建仍待完成。[276实际状态](../../reference/kernel276/README.md)、[原厂调校依据](../../reference/kernel276/OEM-TUNING.md)。以下按各历史阶段阅读。

274：主摄原厂镜头命令已产生真实光学响应；标准V4L2 lens/静态DT/独占VAF候选0798ee688已编译并通过13个回调主机用例，尚未部署，须先配套Simple lens生命周期。相同96组控制两轮通过但旧失败根因未明；现机仍273/r21，SSC失败及Spectra未接通保持。[274证据与分层](../../reference/kernel274/README.md)。以下按各历史阶段阅读。

# RMX1931 Linux 硬件状态与未完成项目

273：GW1主摄已实机C-PHY RAW/RGB取流，前摄＋三后摄238帧交替通过、主摄600帧实景JPEG；boot273/Image183、775模块/961包、r21/r16。手动控制测试在4倍阶段失败、AF/画质/GUI/Spectra未完成。新启动SSC/FastRPC attach失败，自动旋转不可用，桌面仅临时nodeps恢复；不能用旧SSC通过覆盖本次失败。[273证据与当前限制](../../reference/kernel273/README.md)。

271（2026-10-18）：boot270/Image183保持；S5K3M5原生细分增益模块与libcamera r20/config-r15已配套原生部署。96组RAW/RGB验证1/32倍物理响应，360组AE及600帧普通预览已有明亮实景；首次AE慢、画质/AF未完成。三摄14段193帧交替/正常中断/重开通过，最终PM/六rails/三MCLK回收，fault0/taint0。主摄GW1、GUI三摄/录像/GPU/Spectra及旧modem watchdog仍开放。[271证据](../../reference/kernel271/README.md)。以下旧版本按阶段解释。

270实景补测：用户调整正常照明、无遮挡场景后，IMX319与S5K3M5各36帧/JPEG通过，私人原图均有可辨认真实场景。长焦明显欠曝、噪点重，画质/AF仍未完成；旧暗场不是本次新场景结果。资源回收、fault0/taint0保持。[实景证据](../../reference/kernel270/scene-r2-optical-review.json)、[分层与升级依赖审计](../../reference/kernel270/LAYERING-AUDIT.md)。

270续作（2026-10-18）：boot270/Image183，774模块/961包。新增S5K3M5长焦公共资源驱动及静态设备树已上机，标准cam真实枚举前摄/IMX319后摄/S5K3M5长焦；RAW/RGB各12帧、三摄14段192帧交替/正常中断/重开通过，六rails/三MCLK回收及fault0/taint0。两后摄各36帧并生成JPEG，但**长焦真实样本仍近乎暗场，尚非可用光学成像**；S5K3M5自身彩条正确，2ms/32ms配对RAW仍近黑电平。主摄GW1两家模组数据交叉核对完成，未上电；新三摄GUI、AF/更多模式/录像/画质/长稳、Spectra硬件ISP与GPU仍未完成。旧Snapshot/modem watchdog不因本次正常启动而算修复。[270证据](../../reference/kernel270/README.md)、[当前检查点](../../NEXT-SESSION.md)。以下269及更早部署和模块数均按阶段解释。


269收尾（2026-10-18）：[板级旋转与完整构建](../../reference/kernel269/README.md)。标准udev安装矩阵修复整屏方向，用户确认自动旋转正常；桌面依赖SensorProxy的启动顺序已更新但跨启动待验。新Image和773模块构建成功、未部署，完整rootfs待办。用户打开Snapshot卡死重启，pstore末尾modem watchdog；补测未出帧，稳定性问题未解决。现机仍267固件/Image183、r19/r14/PW r3，新的269guard替代旧启动身份。最后只读健康正常不覆盖上一启动故障；本轮按用户要求收尾，完整适配未完成。下述阶段结果与健康值按对应时间解释。

267/268相机阶段结果（2026-10-18）：boot267/Image183，双PM8008已走公共MFD/regulator，实验供电和板级reset模块/配置已撤，IMX319标准OF/Selection及DT方向已部署。libcamera r19/config-r14修复跨进程link缓存；PW/SPA/Gst r3保持。标准cam72＋交替36帧、系统预览1097帧/1081次保留前缀检查、9张后台JPEG，以及未改Snapshot实际前后摄预览、界面切换与两次快门通过；三张GUI JPEG成功解码。773ko/961包，最终PM/rails/MCLK恢复、新增fault0/taint0，临时解锁配置恢复。维护内核源已同步并独立编译五个目标，DTB逐字匹配现机。默认GPU/Cairo回退、低照度/画质/方向校准、其它后摄/录像/长稳及完整新Image/rootfs仍开放。[267内核](../../reference/kernel267/README.md)、[268结果、失败与范围](../../reference/kernel268/README.md)。下述265及更早版本、PID和待办属于历史。

265相机（2026-10-18）：公共core/SPA/Gst 1.6.9-r3原生组合修复；同260启动/961包，boot235/Image183与r15/r10保持。系统2972次保留前缀检查0变化/回收错误，前后摄6张照片、六轮关闭、崩溃/并用/全池恢复通过；Snapshot前摄777缓冲/766渲染及1920×1080 JPEG解码。33个上下文全终态，PM/MCLK恢复、新增fault0/taint0。后摄低照度、内核元数据、GUI切换、其它后摄/录像及GPU仍待办。[265边界](../../reference/kernel265/README.md)、[源配方](../packages/pipewire-common/README.md)。

2026-10-18用户态维护：现有仓库full upgrade完成，55包升级、3依赖新增，当前961包；Phoc仍0.57。未重启，同260启动，USB/Wi-Fi、桌面服务及taint0检查通过，Mesa/相机/GNSS关键文件保持。本轮没有追加完整硬件验收，下面958包是升级前测试记录。[升级收据](../../reference/full-upgrade-20261018/README.md)。

用途：当前硬件验收清单。260已部署GeoClue2.8.2-r1及GNSS辅助服务2-r1，并通过普通桌面GNSS室外定位：300秒280次更新，其中262次严格校验、时间戳新鲜且随更新变化，GPS去重9颗TRACK/46.7dB-Hz。停止后自动LOW_POWER并恢复设置。无线SSH仍不稳定，与本地定位结果分别验收。[260](../../reference/kernel260/README.md)、[室外回收](../../reference/kernel260/outdoor-validation.json)

258原生Linux同位置室外/拔USB持续定位通过：287份SATELLITE坐标连续286秒、最大间隔1.012秒，GPS去重最多12颗TRACK/44.4dB-Hz、PGA全+2；256原厂302份、GPS去重最多10颗/45.5dB-Hz、PGA全+2。两端原生可定位不等于桌面已验收或初始化相同。[258与原厂对照](../../reference/kernel258/README.md)。boot235/Image183、958包保持，MM仍203版本，旧启动guard已失效。249其它新用户态候选未上机，248完整备份保留。[249](../../reference/kernel249/README.md)、[247 MEMSHARE差异](../../reference/kernel247/README.md)。其余功能仍按240及各专题：libcamera r15/config-r10、Snapshot CPU前摄预览及实际快门、265公共缓冲组合修复所测场景通过，切换/后摄/画质仍开放，默认Vulkan480条fault未修。全机适配未完成。[交接](../../reference/kernel240/HANDOFF.md)、[检查点](../../NEXT-SESSION.md)、[边界](../../WORKING-BOUNDARIES.md)

**149已复现的A640 CCU故障修复保持；240新增Snapshot默认Vulkan负载的GPU fault，需独立继续定位。** 147修复旧式GLES地址对齐，149修复Vulkan自动VM_BIND地址对齐。149完成185次像素读回零差异、36次Settings面板打开及PM、稀疏重绑定、旧地址重放、Vulkan/GLES并发验收。151同启动六次被动观察中无新增fault，taint0，桌面保持。150无Mesa补丁的降级候选未部署；它的验证不能混入149系统驱动的验收。

211新增相机GPU ISP退出时的`__arm_lpae_unmap`告警，保存日志可见349条、taint512；它不属于此前CCU像素读回验收。212默认CPU ISP跨启动取流没有新增告警，最终taint/fault0；GPU路径仍未修复。这个结论限定此前已复现故障和已测负载。所有Vulkan扩展、长时间压力及跨启动GPU回归仍需验收；显示交接白屏/花屏及已测开关屏已通过本轮验收，冷启动、休眠和长期显示稳定性仍开放。普通Mesa包更新可能覆盖本地修复，旧rootfs132镜像不含该库更新。

## 当前功能与待办

“未完成”包括仍有真实缺陷、功能尚未接入，以及仅做过部分验收；不能将这三类都写成完全不能用。

| 功能组 | 已证明的能力 | 尚未修复或验收 |
| --- | --- | --- |
| GPU | 149已复现GLES/Vulkan CCU修复及原像素回归保持；240停止故障Snapshot后及CPU mmap两轮新增fault0/taint0 | 240 Snapshot默认Vulkan新增GPUfault480/VK_ERROR_DEVICE_LOST，CPU回退未修GPU根因。211 GPU ISP退出IOMMU WARN另案保留；Mesa可复现包/rootfs、完整扩展和长稳待完成 |
| 原生显示 | 用户实屏确认EDK2之后无白屏/花屏，黑屏等待后显示命令行；反馈后新boot显示关键计数0；此前165的DPMS/首帧门控/稳态软件验收通过，身份与测量所属启动见[检查点](../../NEXT-SESSION.md) | 黑屏等待时长未测；冷启动、休眠、更长期稳定性开放。164首启音频WARN及157重启原因仍未知 |
| 音频 | 171人工双组滴声；183识别离线传输并清理WCD流，活跃双工合成crash原客户端恢复、2旧FD EIO、18项0，匹配左右相关0.9119/0.9312。两次s2idle实际45.33/87.04秒、success2/fail0、PM callbacks全err0；醒后原生/桌面左右通过。1473秒taint0、20项全boot0，PCM关、功放23/23与22/22静音、16控件恢复、五consumer各1/两map/一MCLK | 耳机/耳麦/按钮、实际watchdog、跨启动/更长可靠性和音质/瞬态/保护开放，用户暂无耳机。新发现181活跃STOP −107/ASoC3及旧178/180失败、183首轮脚本mute假设错误均保留，不改成通过 |
| 电池与充电 | BQ28Z610电量/温度和MP2650输入观测已接入；已有健康Good、接线ONLINE1/Full观测 | 正常充电控制、USB输入预算、温度/保护/失联链及持续充电闭环；输入预算候选未纳入已验收组合 |
| 摄像头 | 267公共PM8008/IMX319与设备树、268公共libcamera r19/config-r14/PW r3；此前标准cam72帧、交替36帧、1097帧预览/1081次前缀检查、9后台JPEG和未改Snapshot前后界面切换/快门/JPEG解码通过；269统一Image/773模块构建成功但未部署 | 269用户打开Snapshot卡死重启，末尾modem watchdog，原因未解决；补测0实际帧，不能视为通过。低照度/颜色/相机图像方向、其它后摄、录像、GPU、长稳、完整rootfs和新内核上机仍待办；既有Cairo回退保持 |
| 其它传感器 | 204第二boot自动真实readiness及三个DSP/SensorProxy三Has通过，首轮文件服务就绪失败清理offline仍保留；200新boot三项Has与标准Claim/Release通过，早期门控后SLPI running；187 A.11实际三轴204/202/197及五种CLI通过；230真正树内2abde新启动taint0，实测保活1→2→1、五流67/44/9/10/1与活动Wayland用户Claim；189 FastRPC freezer等待修复与自动服务已部署，连续三轮驻留45.2至45.3秒、success3/fail0/RTC3，醒后四种CLI与原daemon身份保持；三轮后真实active Wayland UID10000 Claim/Release通过 | 188原PM崩溃保留；普通信号重试/freezer竞态、共享池stop/start/reclaim−22及SSR仍未解决。269板级安装矩阵及桌面重新发现传感器后，用户确认整屏自动旋转正常；首次整机启动顺序、3D安装/精度及更广运动回归仍待验。亮暗响应与绝对精度、接近日常、跨boot/冷启动/长稳开放；平放undefined/被动lux0至8不等于这些验收 |
| 蜂窝通话与数据 | MPSS、QRTR/QMI、ModemManager/IPA基础接入；207两次普通启动modem running，原厂MCFG目录自动复制且mdtime可读；PDC活动平台/软件存在、无pending、1平台/25软件列表通过；用户确认未插SIM，当前Power1、failed/原因2与条件一致 | 269保存到一次modem watchdog并伴随整机意外重启，原因和与Snapshot的关联未明。mcfg.tmp仍零字节，整体配置初始化与真实SIM注册/数据/通话/SMS/UIM仍待验；221再次只读得到两槽no-atr/absent/active，与191相同，该历史结果不作为插卡故障证据，真实业务待有卡；电源策略/SSR/冷启/休眠开放 |
| GNSS定位 | [260](../../reference/kernel260/README.md) 普通桌面GNSS-only室外300秒280次更新，其中262次严格校验、时间戳新鲜且随更新变化，默认LOW、无额外HIGH客户端；GPS去重最多9颗TRACK/46.7dB-Hz，自动上线/LOW_POWER回收与设置恢复。[258](../../reference/kernel258/README.md) 原生287份SATELLITE坐标/286秒、去重12颗TRACK/44.4dB-Hz/PGA+2；原厂256去重10颗/45.5dB-Hz/PGA+2。GeoClue10项/电源14项回归及实机四轮开停通过 | 旧采集器拒绝Accuracy=0，18次余下更新未分类，不能直接计丢星或实测精度；本轮PGA未观测。259在OFFLINE下失败不能作ONLINE对照。完整5MiB连续内存/SCM provider、室内PGA/RF根因、冷启/PM/长稳/绝对精度仍开放。位置/启动/辅助未单变量控制，初始化未证明相同 |
| 指纹 | 尚无功能验收 | 本机传感器/SPI/供电、安全环境及用户态认证链 |
| NFC | NCI控制器初始化、上电查询、关闭和重复通过 | RF读卡/标签、时钟请求及eSE业务，尚无真实读卡验收 |
| 振动 | AW8697驱动与电气检查通过 | 物理振动和桌面反馈未确认；按用户边界不新增脉冲 |
| 蓝牙 | 234实际RTS模型三变体16/2、16/0、16/2及H4回放8例通过；暂时诊断取得2个完整phase5回包/UART对应/1301事件无丢失，未复现错误。扫描因预上电属性Not Powered未完成，已恢复原185模块/config/helper/keys/787文件、最终健康0；裸RTS模型不满足真实锁契约，未部署功能补丁。[234](../../reference/kernel234/README.md)。205两次普通启动/8轮上下电/4次重注册未复现phase5，206已恢复原185模块/helper/BlueZ并核对keys；这不是phase5修复。204 RX wake/sleep已部署；首轮前9/45.14秒RTC PM后13、错误增量0，第二boot启动重组0，外部BT事件唤醒未验；首轮phase5仍1。200新boot startup及8秒只扫描发现10设备、退出恢复、重组增量0；185功率脉冲前导NUL及短写/flow修复保持；当时原扫描错误1/候选0、3模式响应及开启状态s2idle/延后扫描通过；189三个传感器PM窗内重组增量0、密钥保持 | 189旧boot出现phase5/3.2Mbps/chunk13/partial0/firstff重组1，区别于旧phase2前导00，需继续修复。配对/连接/音频、冷启动及长稳未验收，按边界只扫描；原Wi-Fi组合失败保留 |
| Wi-Fi | 200新boot自动connected，早期管理端点超时保留；2.4/5GHz通信已有回归；189三轮传感器PM的第1/3轮观察约5.33/0.53秒关联5180，最终5180，未手工重绑驱动 | 第2轮35秒窗内仍未关联，之后又执行第3轮PM，不能称第2轮自行恢复；185立即醒后2秒检查失败仍保留。冷启动、完整休眠通信恢复及长稳开放 |
| 普通USB与OTG | 200新boot新peer/原严格公钥SSH/SCP、约6MB归档及逐成员核对通过；USB 2.0 Type-C；历史NCM/SSH/SCP与EUD共存；203大SCP停顿后严格原密钥Wi-Fi同boot取得完整候选，最终USB/Wi-Fi小命令响应，无reset/unbind/reboot | 190 USB归档尾部中断、双向IPv6探测不通，单次gadget重绑后恢复无正向证据；Windows网卡复位拒绝访问。213再次1MiB分块截断、后续USB小SSH超时，原密钥Wi-Fi两次同boot可达后也无法完成归档/最终健康复查，未盲目复位；214重新发现同地址USB邻居后严格密钥连回同启动，64KiB完成213全部227成员和214全部167成员归档核对，当前连接恢复；根因和大传输稳定性仍未证明修复；NCM稳定性、OTG/角色切换/冷启/PM及EUD接收/退出路径待验收；USB3不是本机目标 |
| 触摸 | 用户确认可解锁、操作应用，原生驱动工作 | 边缘/方向/多触点与休眠后恢复、长稳 |

已有基础还包括UFS访问、CPU调频表、PMIC温度与按键/EUD。CPU高频压力、UFS持续负载、整机功耗、冷启动及系统休眠唤醒仍需跨功能验收；不能以驱动注册或短窗口健康代替日用完成。

USB规格更正：用户指出此前误列USB3；[X2 Pro规格](https://www.gsmarena.com/realme_x2_pro-9904.php)标注USB Type-C 2.0。[厂商规格](https://www.realme.com/in/realme-x2-pro/specs)只标注Type-C接口，没有声明USB3；SoC具备更高速度控制器不代表整机接口支持该速度。

## 下一阶段顺序

显示交接白屏/花屏与已测开关屏已有验收证据；音频发声/拾音、停止、规定规模重绑及短时s2idle恢复也已通过。后续补音频SSR/重复长时PM、耳机和音质，同时推进充电控制保护、完整传感器、实体摄像头、蜂窝业务与GNSS冷启/PM/长稳；GNSS原生258及桌面260室外定位已通过。指纹、NFC读卡和外围设备功能保持待办。Wi-Fi/USB独立休眠告警保留，和触摸一起补稳定性；蓝牙继续区分已验收的扫描与尚未验收的连接/音频，整机冷启动和长期可靠性仍需验证。

参考证据：[显示140至145](../../sessions/145-dsi-deployment-and-session-closeout.md)、[SLIMbus139](../../sessions/139-slimbus-unsubmitted-tx-unwind-and-live-boot.md)、[DMIC104](../../sessions/104-native-digital-microphones-and-first-boot-radio-failure.md)、[充电132](../../sessions/132-persistent-mp2650-real-boot-and-complete-rootfs.md)、[充电138](../../sessions/138-readonly-charger-recharge-threshold.md)、[实体camera前的TPG126](../../sessions/126-tpg-dma-guards-full-rootfs-and-real-deployment.md)、[传感器112](../../sessions/112-startup-sensor-registry-and-reboot.md)、[Wi-Fi128](../../sessions/128-wcn3990-pairwise-key-delete-and-5ghz.md)、[蓝牙130](../../sessions/130-standard-bluez-discovery-and-startup-integration.md)。

阶段151以前的完整状态记录已经移入[历史快照](../../archive/HARDWARE-STATUS-through150-2026-10-13.md)，不再把旧136 GPU故障或145设备状态写作当前待办。
