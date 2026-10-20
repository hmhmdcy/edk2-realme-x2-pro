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
