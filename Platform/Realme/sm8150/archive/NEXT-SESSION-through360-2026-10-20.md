# 当前检查点：360

2026-10-20，完整多摄/骁龙 ISP goal active。用户已起床开灯，没有色卡，要求继续反编译原厂刷机包获取校准数据；正常照明光学、几何同步、连续AF及完整系统目标仍未完成。遵循 WORKING-BOUNDARIES.md，复用未改组件结果。

360当前：349 Gamma与359曝光合并为E ext4 libcamera360-combined-r28-built/src/libcamera-v0.7.2，r28/config-r23候选完整包已构建签名、未安装。三方共同基线342；camss.cpp/公共Meson自动合并，camss源数组人工合并新增cpp。Gamma/曝光算法源与父阶段相同。0037 Gamma+0038曝光从r27零fuzz顺序应用，23文件逐字一致；全量差分combined-r28-against-r27.patch59753bytes，source-state有哈希。生产werror=false沿用；核心签名IPA/worker构建177.45s，全框架包294.85s/config8.44s。

私有8完整Preview/Video profile已有5物理模式/10用途上下文同时带Gamma和原厂曝光，未知前摄裁剪generic保留，高分辨率缺完整IQ未造。实际ARM64 DSO合成合同12路径：10factory、主摄线程、IMX319非对称RGB；72次原指令曝光分配逐位比较、108次完整776byte Gamma块核对，以及EV/flicker历史、延迟stats、合并WB ACK、开流重传、legacy复位等通过。Gamma后续不重传。公共AGC/量化源未改，复用359 480帧零差。完整13APK保持全部消费包/6IPA/py/qcam/Gst/V4L2，七运行包签名forward及r27/r22 rollback仓库在private360/runtime-repository。剥离后的打包IPA+core又过main/非对称RGB两组，IPA签名用打包core核过；公共默认YAML无factory/unit表，canonical配方r27/r22没改。候选recipes在reference360/recipes，尚无安装实测或新v1隔离IPC证明，QEMU clone3限制沿用。

重要手机状态已更新：收尾Pnp发现9008消失/NCM出现，原严格密钥USB169.254.42.1 SSH成功，观察boot3501...是新启动。k298、CAMSS338 note0227...、八核在线/taint0，17ICP/BPS/IPE clocks refs0，CAMSS suspended，无ICP core/test或临时DT节点。启动时已约72min；未确认9008退出触发方式，不把恢复归因本轮主机操作。pstore为空，CPU5精确PC仍未知。旧R5state存在/terminalfalse/phase load-boot-test，worker无；原state不改成成功。仅删lib/firmware/qcom/sm8150/samurai-icp356.elf这个专用孤儿副本，先比352原件与R5保留firmware.elf全哈希相同；保留R5backup和旧失败状态。新360guard /var/lib/samurai/k360-recovered/boot-id-private.txt，host360.ssh使用它/原guard305/356保留，P360 recovered-boot-adoption-private.json保存当前boot。此时无需再请用户强制重启。

已读实际installed七包仍r27/r22，cam --list四颗物理相机与342 hardware_cameras4一致（不要与四PipeWire节点相加变8；本轮初始夹具期望误用8已依据342改正，复用原观察没重跑）。再以当前实际ID每摄cam capture4、不写文件，请求640x480 NV12共16帧/退出0/帧错0，相关新故障0、taint0、CAMSS/两CCI suspended。仅为原r27/338重启后基础取流，不能写成新r28/光学校准成功。private360 recovered-inventory-secret-private.json、recovered-pstore-secret-private、current-dmesg等及旧private357认证日志可能含秘密，不能原样输出/镜像。所有主机build/测试终态/SDK binds释放，无活动capture。

下一步361优先用新boot和host360新guard准备r28+348参数ABI临时组合实测；不要重放349/356旧事务，准备新目录，核当前core338和service实际状态后复用已测348 SoC Gamma模块/当前r28载荷，保持单次失败也可收敛恢复。旧338不能启动带Gamma profile，349已有ENOSPC负对照。先证明新EV/flicker请求/真实sensor delay/同包Gamma等；完整ISP仍需正确9ab00000内存后的ICP/HFI/真实IPE会话IO/IQ和350/351/352后级Gamma/LTM/CCM，不能把IFE线性曲线当原厂显示色调。静态frame预算/无自动频率/数字gain约束继续，动态FrameDuration/更多mode/光学/同步/连续AF与统一kernel Image仍在完整goal内。Kernel source354路径branch357 ba61...，356修正build7未发机，本轮没有再触发ICP启动。

359当前：实际CAMSS IPA曝光程序已接入342 r27完整候选，源在E ext4的libcamera359-exposure-built/src/libcamera-v0.7.2。345/346 table/FPS/EV +358 antibanding进入libipa/HardwareAgc；公共AgcMeanLuminance新增拆分前滤波目标接口，旧calculateNewEv继续原分配器。使用真实V4L2曝光/gain范围、默认VBLANK帧预算和原传感器helper行/增益量化。标准ExposureValue[-8,8]、FlickerOff/Manual和period微秒；无自动频率检测/数字gain/动态FrameDurationLimits。table knee不是硬件上限，最终限幅可能破坏严格周期对齐，不能宣称消除实机频闪。

核心库、签名IPA和worker实际构建通过（最后build5 81.42s；生产Meson werror=false，不冒充全库Werror）。applyIspControls新增firstSof，CAMSS pipeline版本1，核心/IPA/worker须配套。按SOF保留EV/flicker策略，延迟统计及正常统计/缺统计恢复两条元数据路径均取历史；当前策略无需每帧重建表。AE独立请求不增加ISP版本，WB合并仍按参数ACK生效。常规合成统计需ROI面积/4总数，线程参数ACK异步，测试使用后续stats回执确认，不把发送当完成。

8份私有Preview/Video完整IQ配置保留WB/CCM/LSC/lux，已有5个物理模式/10用途上下文新增选定原厂曝光程序。4个更高分辨率上下文没有完整IQ暂不拼造，未知前摄裁剪模式保留generic。原指令组合60组/47086指令；真实ARM64 DSO四颗sensor10上下文全部60组raw分配逐位一致，主摄线程代理再6组；控制历史/延迟统计/类型与范围原子拒绝/convert不提交/AE不改ISP版本/WB合并ACK/重启复位等通过。V4L2和统计来自合成夹具，范围依据当前driver源码，未访问手机。公共AGC baseline342/new359各自匹配头/库独立构建，10上下文480帧15360bytes零差；原quantizer和sensor helper源相同。独立进程proxy因QEMU clone3 ENOSYS未启动，明确失败待真机，不用线程成功替代IPC。补丁43981bytes/15files，source-state哈希，未安装/未改运行默认配置。

主机重复首次挂载竞态曾使同一E构建镜像双loop挂载；两调用都在修改前assert退出，确认无工作进程后卸载，storage284发现/挂载段增加flock串行化，之后真实构建/测试正常。不能并发绑定同一个SDK /work/libcamera；同一运行句柄yield后继续poll，勿重启。不要重放prepare/adjust脚本到已完成候选，复现可用最终patch对342基线。

手机本轮没有新操作，最后USB查询仍9008/COM16、USB SSH不可连/WiFi超时；现场强制重启请求pending。已向用户如实解释356错误通用物理地址8b700000（板级应9ab00000）、CPU5 stall、357一次EUD硬件reset后进9008及一次Sahara reset有ACK未恢复。无programmer/分区/NV/boot替换。private357认证采集和后续pstore可能含秘密字节，勿打印/镜像。Kernel source354路径仍branch357 commitba61...，356正确内存区build7未发机。恢复先boot/pstore/R5state与资源，不重复复位脚本。

下一步继续完整目标：先把349 Gamma候选与359曝光收敛到同一实际IPA/软件包；推进动态帧长预算、缺完整IQ的模式及原厂参数。设备恢复后再验当前v1隔离IPC/曝光时序与画质，完成修正后的ICP/HFI启动、IPE会话/IO/IQ及350/351/352 Gamma/LTM/CCM接入、统一kernel Image，继续光学/几何同步/连续AF。全目标active，不用本轮软件通过替代完整ISP与实机校准。

358当前：原厂CArbitrator::processAntibandingAdjust完整2a438..2a79c已恢复，新增reference/kernel358/libipa/aec_antibanding.cpp/h，复用346 exposure allocation头。原库SHA3f8d12e8...，9407次原函数815558条指令，仅日志/strrchr桩，无算术桩；主机/ARM各9419项188380bytes0diff（另12非法输入只验新API拒绝）。224原厂表按threshold/method/blanking去重19政策，50/60周期及三FPS策略边界等距均测。SDK临时bind释放，本轮无手机操作。

算法阈值float32严格大于才启；上下整周期候选按mingain和min/max时长可用性，最近者、等距选UPPER。Legacy0/Maximize2允许max+minVblank，Strict1不加；Max2选后若超过原max则夹max，gain先乘后除（普通候选先除后乘），因此不保证最终周期整数倍。没有maxGain/传感器行帧限幅；API不复现超32bit周期计数/uint64溢出。无候选保持输入，禁用/短帧同原厂。index保留。

已沿DataMgr vtable160 RELR到getArbTuning1dfc8，模块+72指针、CArb模块+64的+8匹配；param+128为FPS政策、+56为minVblank，与336兼容旧schema核对（未找到原完整C++头）。原ApplyActiveTableEVFPSKnees片段2d508..2d584实际把所选table+24 threshold复制到CExpTable+32=CArb+48，3种原厂比例逐位一致，仅memcpy桩。已整理7物理模式14Preview/Video上下文私有mode-exposure-programs-private.json，完整knee、EV开关、cap和防频闪三字段来自343正确Arb根/Streaming表0。没有启用IPA或改YAML；frequency和真实sensor limits必须运行时提供，不能从table knee当硬件范围。

下一步359直接接入曝光程序与真实sensor行/帧/增益预算，不停在表库存：基于342 r27完整源（可参考349 Gamma候选但未装），345/346/358共同进入libipa/HardwareAgc；mean-luminance目标/滤波和原厂分配政策分层，取得拆分前的目标曝光值，不能先按generic mode拆完再倒推。提供标准手动flicker能力，不冒充自动频率检测；未知前摄裁剪模式保留原行为。候选先实际DSO构建/相关合同，手机357最后仍9008，现场强制重启请求pending，恢复后先查实际状态和R5/boot/pstore。勿重复EUD/Sahara reset marker；private357认证日志/后续pstore可能含敏感输入，不打印。full ICP/IPE/libcamera调校、光学/更多模式/同步/连续AF等全目标active。

357当前：公共of_iommu_get_resv_regions节点引用泄漏已修。将循环np改__free(device_node)=NULL，正常/zero-length continue/alloc失败均自动put。原/新实际完整函数9场景，旧泄漏409、新0；ARM64 of_iommu.o W1Werror 12.72sec通过/27736bytes，未装、需未来统一Image。source354目录当前branch samurai-iommu-node-lifetime357 commitba61a62293e0f6bc5838c06f2e85e033e3d702a8，父3563a485310...，一行/459bytepatch/clean。

重要设备状态已变化：EUD成功接收924帧，直接看到CPU5 RCU stall/NMI无响应，sshd-auth.pam等待kick_all_cpus_sync/BPF/seccomp；CPU5实际PC未知。EUD CtrlU/换行各新回执、真实ttyEUD0登录提示；用既有私存凭据登录一次无shell/无明确拒绝。private357/login-auth-secret-*及后续pstore可能含密码输入的debug十六进制，严禁原样输出/镜像。

为恢复按主机已有Qualcomm eud_msm_reset bit0低/100ms/高发一次硬件复位，旧Linux退出/NCM消失，主USB进入9008 COM16；读HELLO48bytes v2 mode0。按bkerler原cmd_reset发一次Sahara命令7，得命令8长度8确认，但随后仍9008，无Linux/fastboot。没有programmer上传、分区/NV操作或改boot。已com-off/detach，9505消失，USBIP已释放，9501和9008保留。不可重复reset-eud-msm.ps1/reset-sahara.ps1；已有一次操作marker，先查状态。旧R5进程不在当前Sahara环境运行，仍无它的正常终态/清理报告。

用户不在现场，已异步请回现场后按realme官方方法电源+音量上>10秒，启动画面后松开/保持USB再告知。现场请求pending期间继续主机原厂固件适配；不能宣称设备已恢复或goal完成。恢复后先读boot/pstore/R5state+临时module/fw/DT，原guard保留；356修正9ab00000/5M命名memory-region候选build7从未发机，尚无SYS_INIT/PING/PC_ACK或IPE图像。357文档/脱敏证据镜像，原件/secret/raw logs仅私存。完整goal含实际ICP/IPE/libcamera、原厂Gamma/LTM/前CCM、AE防频闪/模式/光学/同步/连续AF继续active。

356当前：A5 boot/IRQ/HFI/SYS_INIT/PING/PC_PREP/stop候选已实现，实机尚无完整握手。R1权限fault后自动重启，R2复位时序导致AHB WARN/taint512，R3读fwversion但无ACK，R4取指5MiB边界fault/500ms timer触发并清理。R5 worker7780 /var/lib/samurai/k356-boot-r5状态未知，USB/WiFi SSH banner超时，不能因观察失败重启事务。修正后第7构建未发送手机。

重要板级修正：原R5误用generic SM8150 0x8b700000（落入86200000大块no-map区）。匹配Realme官方19781源码23172a157...及当前k298 DTB实际为独立camera_mem 0x9ab00000/5MiB。已改memory-region-names firmware精确引用该节点，拒绝任意大区包含判断；离线DT合并解析通过，选择函数12项、内存host/ARM各51项、timer/PM9项通过。core229000/test66824 W1Werror构建通过。source354目录branch samurai-icp-a5-bootstrap356 commit3a485310daa7baed7d1f0d1798ded15cc85ad1ab，7文件clean，privateheader不入源。没有SYS_INIT/PING/PC_ACK/IPE图像成功。

当前不能声称设备相机仍正常或临时模块已移除。observe-boot.py r5只读观察既有事务，private356/latest-r5-observation-private.json保留失败；恢复后先读boot ID、R5 state/proc/pstore，再决定清理/实验，原305guard仍保留，新恢复356guard用于R2-R5。原始ELF/反汇编/日志/private物理数据不镜像。另发现主线drivers/iommu/of_iommu.c查询iommu-addresses时of_find_node_by_phandle缺of_node_put，动态DT有OF refcount ERROR；旧故障计数漏该项，当前worker已统计，需底层修正。完整目标含IPE会话/IOIQ/libcamera+原厂Gamma/LTM/前摄CCM、AE防频闪/模式/光学/同步/连续AF仍active。

355最新：实现SM8150 A5/BPS/IPE0/IPE1平台资源后端，实际上电/读取A5版本/释放通过。原厂ICPmgr确认顺序A5→BPS→IPE0→IPE1，退出反序；HFI/CPU/IRQ实际传入A5_SIERRA_BASE 0x0ac10000 size8000，不是旁边CSR2 0x0ac18000。353/354未写A5寄存器，不存在已写错地址。355原厂GPL提交9668fcdc...提取7files200795bytes，索引在reference/kernel355，原始源码private355/oem；复用private352/oem。

355 camss-icp-a5-resources.c/.h采用qcom,camss phandle supplier runtimePM link，复用现有CAMSS338 CPAS/MMCX/公共clock/ICC，不重复CPAS所有权。独管19clock refs/3PD，NO_DEV_LINK手动按次序PDget+clockbulk，逆序释放/部分失败rollback。原厂SVS fastAHB200M、ICP400M、BPS400M、IPE475M（共源）；四组bitmask15/PD7。生命周期由owner串行且停A5后才断电。16项实际resume/suspend体hostmock测试过，4rate失败/4bulk失败/3PDget失败/3PDput错误/顺序/忙/invalid，未改353/354复用其证据。

355沿用 /mnt/samurai-full282/source354 目录新branch samurai-icp-a5-resources355；354旧提交仍在。父ea71fa4...，本轮commit 0a23a25f34723a9d6fddb3a7c4e94080d0e92b7c，5filesclean/patch12364bytes。Kconfig Makefile及generic资源/测试C提交；privateoverlayheader仅BUILD。W1/Werror实际in-tree构建13.66sec无诊断，core155312 SHA85f212be67b273ca9270337ebd86fd41b2a9229a6509ea6ca87a8e9ebae36a38，test65904 SHA2957ccfb129cbb017e41991cf57ec5602af1674a2960c6fb158b43b219fb9484，intreeY/currentvermagic。构建后只补Kconfig OF/PM_GENERIC_DOMAINS依赖，当前配置均已启用，未变module对象。共享camera/config关键输出恢复，hosttools准备可能刷新。

355手机strictkeyUSB正常，bootguardmatch，实测CAMSSphandle38/CAMCC206/SMMU44。测试临时node /soc@0/samurai-icp355-power@ac10000，19clockrefs对应ICP/BPS/IPE17实际objects（IPE共源，fastAHB另计）。R1 worker5761 preflight对象数误18而实测17，终止于insmod前，模块/节点全无，无上电，失败保留。辅助脚本修17，不改kernel/gate。

355 R2 /var/lib/samurai/k355-power-r2 worker5811终态passed/PID不存在。全部4groups/3PD启，A5version0x10010000/control0x3000（ENbit9=0）/status0x200，ICP400M/BPS400M/IPE475000048Hz，已读19rates。随后groups0/domains0/consumer suspended；test/core卸载/临时node移除，17objects enable0，CAMSS suspended，taint0→0/fault0。未写控制/复位/启动FW、未DMA或IPE处理验证；已门控时钟rate设置保留，不声称寄存器全还原。不停PW/WP/不换已安装module/不重启/NV。无活动worker/build/bind。

355通用源与脱敏报告已镜像。下一步356实现同一ICP设备上354memory+355resources+IRQ/HFI固件boot/SYS_INIT/响应/停止。352 private原ELF3630392bytes SHAa22bc8ad...59e63，3LOAD span384000，需要0..5MiBalias。原厂HFI固定shared07400000len09600000，secondaryheap10a00000len00100000（实际allocator取DT1MiB，不是header2MiB），SFRalloc8KiB，QDSS10b00000len1MiB→phys16790000，IO10c00000len0xcf300000。需接共享/heap内存及QDSS条件。原厂enableCPU/control200+nsecreset10再拷贝ELF，HFIinitcontrol1210+qtbl/sfr/shared/heap/qdss/IO/initreq1后pollresp1，IRQenable3，再SYS_INIT。应先保证内存完整并核实reset语义，别盲启；stop原厂先PC_PREP/WFI，再clearEN|WAKE/read-write nsecreset/initreq0/irq0，关clock后才unmap/free。actualHFIqueue体/ELF/IOVA memory已经完成，继续boot不可倒回纯inventory。full goal IPE IO/IQ/libcamera m2m、AE防频闪/模式/光学/同步/连续AF等仍未完成。

354最新：新增实际A5 memory backend（reference/kernel354/kernel/camss-icp-a5-memory.c/.h）alloc/map/unmap/free四API。需要defaultDMA域+0..5MiB明确RESV_RESERVED，coherentRAM原DMAIOVA在窗口外且32bit，逐页iommu_iova_to_phys→alias0，不假定PA连续/32bit。已有外来映射拒绝覆盖；map失败rollback前缀，unmap倒序保留准确prefix，失败不free、可重试；domain切换拒绝。host/ARM各25场景PAGES1280，离散PA>4GiB/cache属性/错误resv和domain/坏DMA/分配map失败/缺失PA/外来map/unmap失败保RAM+retry/domain change均过。初测试工具stdio变量/缩进和桩生命周期问题已修，kernelbackend未改弱。353未改的HFI/ELF检查复用。

354真实内核集成source /mnt/samurai-full282/source354，branch samurai-icp-a5-core354，parent34830086bae...，commit ea71fa4fd8375502d73231dfb749cbd3a23920eb，8文件trackedclean，patch26039bytes。coreHFI/fw/memory+hiddenKconfig/Makefile+memorytest C，privateDTBO头仅build未提交。in-tree W1/Werror r2 13.85sec无诊断，core122976 SHA9ee2275a6e984011c0c3c10b0c71d2b755254fd8961e913ee6f8698015b64f33（R1相同），test73464 SHA764b3299461908c8b1222c1642f81cccf234829db682b784f6656c573b12b216，Kbuild intreeY/vermagic匹配。shared camera目录+config/关键gen files恢复，hosttools/vdso等prepare输出可能刷新，不称全部build字节不变。没有改/重编旧CAMSS/Image/sensor或安装。

354实际prereq bootguardmatch/7.3rc6-k298，OF_OVERLAY/DYNAMIC y，SMMU /soc@0/iommu@15000000 phandle44/iommucells2，ICPclk/ICPahb enable0。内存诊断临时overlay /reserved-memory/samurai-icp354-fw-iova（无physicalreg, iommu-addresses指新dev 0..5MiB）+/soc@0/samurai-icp354-memory（SID2222 mask0+memory-region），probe group只有自身才DMAallocate，未A5 MMIO/clockFWboot。

354 R1 /var/lib/samurai/k354-memory-r1 worker4528终态failed：core加载成功但test覆盖EINVAL，日志“symbols in overlay, but not in live tree”；基础DT无__symbols__，-@多导出符号导致，未映射；模块/节点清理taint0/fault0。failed报告与private logs保留。修fixture为plugin不带-@，无__symbols__/__fixups__而保留__local_fixups__，外部SMMU用实测phandle；944→778byteDTBO。只重建本次相关两个模块，core bytes相同，没改内存逻辑或gate。

354 R2 /var/lib/samurai/k354-memory-r2 worker4723终态passed/PID不存在。真SMMU group1，5MiB1280pages alias与原DMA PA逐页一致/CPU模式匹配，alias存在时额外DMA分配避窗口；全部1280页撤销确认，mapped0/backingfalse。临时core/test模块和两DT节点全移除，taint0→0/新相关fault0，未停PW/WP或改persistentDT/安装module/重启/NV。private354 runtime observation含DMA地址，public已去除。不是A5取指/DMA/cache一致性/固件boot证明。无活动build/probe/SDKbind。

354所有通用源/脱敏证据已镜像，vendor/blob/原始logs/模块私存。下一步355结合原厂A5+ICPmgr核对BPS/IPE资源上电顺序，实现platform power/clock/IRQ/HFI握手，再实际启动firmware。纯IOVA运行时overlay验证不等于永久DT schema/早期扫描已完成。kernel core内存路径已实机，完整IPE会话/IOIQ/libcamera m2m及350～352LTM/CCM/Gamma默认仍待。当前deployed仍349最后观察338+r27/r22+344etc；AE防频闪/模式/光学/同步/连续AF等全目标active未完成。

353最新：实际新增kernel/camss-icp-a5-{hfi,fw,core}.c/.h+externalMakefile，导出qtable_init/ring_init/write/read/fw_inspect/load核心库，无platformprobe/MMIO/IOMMU/固件boot/V4L2。真实内核W=1/-Werror r2成功1.98sec/无诊断，qcom-camss-icp-a5-core.ko88408bytes SHA d6ccd241513a718d88a3d460ba7ea468b7312d712e8d896071f02cdcb6b3cf8f，release7.3.0-rc6-rmx1931-samurai-k298+。外部工作/mnt/samurai-full282/icp353-core，build/source实际/home/cy122/x2pro-linux/camera305-sensor-kernel；未改已有Image/CAMSS/sourcebranch/安装。早r1可编译但table语义修正前，不作最终通过。

353核心合同：qhdr956，liveword前pad60、尾pad60；table预留4slots/active3，total3848。初按3slot2892被原厂Cstruct sizeof比较拒绝，core-r1-failure记录；352原固件lookup只证明24header/956stride，controlled3-slotfixture不等于原host完整qtblsize。INTR_MODE初始化full3848bytes与原hfi.c原代码一致，DbgTxWatermark1024。host writes1584组与编译原hfi_write_cmd完整buffer+header0diff，每arch16single-read与原hfi_read_message0diff。新read按packetlength保留后续包，short/incomplete/invalid不推进；原readbulk不直接照搬。2producer+1consumer2000packets各host/ARM通过，仅hostmutex模型非真实fwconcurrency。coherentRAM/dma_rmb/wmb/mb，实际kernelobj 5个dmb oshld/oshst/osh；DBG原fw可能overwrite，尽力日志非MSG guarantee。

353ELF loader先全部header/PTLOAD检查再zero span/copy，ARM32LE/entry0原固件，BSS+gaps与独立Python5MiBexpected逐字节一致，guard/span外unchanged。17malformed ELF每arch拒绝且RAM/layout不改。host/ARM Cgnu11/O2/WallWextraWerror actualfunctionbodies+pthread，source oracle仅privately compiled GPL hfi functions/init，非HAL binaryoracle。publiccore-validation passed。tests E ext4 /mnt/samurai-full282/icp353-tests，SDK/private/camss353-core临时bind已卸载，避免C拷大数据；private353含日志/模块/ASM，不镜像厂商表/固件/参考代码。

353 IOMMU规划实查：of_iommu.c无物理reg时iommu-addresses对应RESV_RESERVED；get_resv(core ops)->ARM_SMMU get_resv->iommu_dma_get_resv->OF；DMA iova_reserve_iommu_regions reserve所有非SW_MSI，包括纯IOVA。可在DT memory-region引用无reg的纯IOVA窗口0..5MiB，先预留防DMAallocator碰撞，别处分配coherentRAM，再用domain页面PA映射alias0给A5，不强依赖固定physical camera carveout。还没DT/实际domain/group/map验证，不直接启动。iommu_get_dma_domain未模块导出，需iommu_get_domain_for_dev（已export）并checkDMA type；map/unmap/iova_to_phys/get/put_resv已export。iommu-planning-evidence含5源码hash/确切调用链/exports。一次无mount读symvers失败已修，后续脚本都284 mounted_build先挂E镜像。

353源码与脱敏证据已镜像，无活动build/SDKbind/phoneworker，无手机操作，仍349最后观察338+r27/r22+344etc。下一步354实际实现一致性RAM+保留IOVA确认+逐页alias/失败回滚/释放，随后A5 platformresource/boot HFI握手和IPE IOIQ/libcamera m2m。不能把本轮corelibrary当整hardwarebackend已完成。全goalactive，Gamma候选348/349未装、LTM核心/frontCCM/ADRC、AE防频闪/模式/光学/多摄几何同步/连续AF等仍待。

352最新：移植libipa/ltm_inverse_gamma.{h,cpp}，64IFE greenbase10→LTM64段base14/delta14，独立结果类型。预重建4096forward、65inverse earliesttie，portable无负数右移。host/ARM各31cases8060bytes与私有编译原source InverseGamma/PackHLUT/utility0diff，缓存命中未命中核对；尚非原HAL指令oracle。首版非单调/突变625bytes差因负delta显式signbit（<-8192不等于简单wrap），已修forward/inverse pack，R1failed报告与旧输出保留。SDK/private/camss352-math小工具，无bind/phoneworker。

352优先搜索找到BOD ICP/BPS/IPE原型ebd1e440...（qcom-laptops-v6.18-rc4-camss-icp-bps-ipe-icp-boots+stats-b4，GoogleGitiles）。只取9file67434bytes，Makefile引用camss-icp-hfi.c/camss-bps-cmd.c同tree缺失，IPE没列Makefile，所取c缺icp_get/ctxcreate/submit/destroy/abort定义。分支heads中仅一个名称含ICP/BPS/IPE；不能把此prototype当readydriver。upstream-sources/icp-reuse-assessment保留限定证据，不宣称所有仓库无实现。

352复用Realme原kernel git9668fcdc...（281同repo），定点10DT/A5/HFI文件131227bytes私存oem。SM8150 A5 ELF32加载，不是X1E MDT/PAS；5项CSRoffset不同：oldFW44/INIT48/RESP4c/SHMEM50/QTBL58 vsnew24/28/2c/30/38，doorbell旧30与新CIRQ124也不同。仅source契约，不盲写新SoC寄存器。

352手机只读vendor定点提取firmware/CAMERA_ICP.elf，3630392bytes SHAa22bc8adbb4ae97e4f8d728eecb1fd19c1bf866250b0bb7e668951c41c159e63。private352/CAMERA_ICP.elf-private，ELF32 LE ARM ETEXEC entry0，3LOAD VA0/140000/340000，runtime span3686400，fits5MiBfirmwareIOVA窗口0..500000；要zeroBSS。当前DT camera/icp命名reserved-memory无节点，不等于动态分配不可能。ro/noload/noexec后已卸载/run/k352-icp-fw-ro，无NV/OTP/EEPROM/persist访问/安装文件变化/模块变化/重启/手机固件启动；原始数据只private。icp-firmware-collection passed。

352固件保留11688行symbols；arm-linux-gnueabi-objdump可用（不是aarch64objdump），ARM32 Thumb。完整HFI_QueueGetQHdr1a971..1aa10用privatek329venv Unicorn ARM/THUMB执行，30calls/1758instructions，三队列6排列*IDs0,1,2,3,255。表头24、qhdr956（字段每64byte间距前置60，尾padding60），start124/type188/qsize252/read828/write892；type低byte查找、fixedstride956，qsizeword*4后决定映射page4k/64k/1M。fakeCSR0xe0010058指QTBL；48tryMemMapping和30assert_loop成功桩，不实际IOMMU/固件boot。原firmware函数完整验证ABI，非图像处理已通。asm/symbols/cases只private，public firmware-queue-validation passed。

352无hostbuild/SDKbind/phonecamera worker；numerical工具/提取/ABI分析均保存镜像，353优先实际A5 HFI队列+ELF加载/映射后端，而非继续把不完整prototype当成可用驱动。随后IPE会话/IO+IQ/libcamera m2m，LTM核心/ADRC+frontCCM+Gamma，不能缩成CPU近似并当full完成。当前部署仍349最后观察338+r27/r22+344etc，348/349Gamma候选仍未安装，正常光学/AE防频闪/其它模式/多摄几何同步/连续AF等全目标未完成，goalactive。

351最新：5原BIN完整解LTM13_IPE149roots/2135regions、CC13_IPE43roots/737regions，与OEM parser全部树/控制轴/开关/reserve/数值一致；private351，parser E ext4 /mnt/samurai-full282/parser351。LTM root872/reserve88+768，DRC/HDR/AEC3层；核心4数组schema int但tool_hint float，首版int解析XML不匹配已修，首份unmatched私存。CCroot144/CCTleaf72，同形状不等于同处理级。factory-colour-chain-validation passed。

351沿用349 physical contexts：7模式*Preview/Video14context，28 LTM/CCM查询与原manager0diff，完整选根private351/mode-profiles-private.json。LTM均uid42，module/ltm/igamma/data_collect/img_process=1，CCM均enable1/q0；main mode2CCM47/mode4CCM176，其余47。preview/video完整profiles相同。main/wide/tele所选CCM均identity；front28regions/25nonidentity matrices，offset0，说明front原IFE CCMdisabled与后级CCM安排相吻合，不能盲启IFE原配置。各所选LTM有nonzero strength/scale，不能当直通。mode/selected-profile报告已记录。

351实际HAL staticflags：执行HwInitializeDefaultSettings3c2720..3c2764，zero/ff输入低22bits=0x33c91；constructor片段35e450..35e468读manager+15632 bit18/19→LTM+620/624，logW6/W7原format确认ignoreChromatixRGammaFlag/useHardcodedGamma，各compileddefaultFALSE。完整HwLoadOverrideSettings3c2770..3c3090执行，仅virtualsettingreader桩（44reads/call），恢复keys821ea2c2/a6abb46e，四组合构造读取通过，31601原指令。原HAL未native运行，未证明Androidproperties覆盖后值。参考titan17xsettings.xml已取固定9f17f1b源码仅对照，数据来源原HAL。static-flags-validation passed。

351手机只为找fileoverride执行ro/noload/noexec vendor挂载，etc/camera与etc无camx名，两明确候选camxoverridesettings.txt/camxsettings.xml均不存在；已卸载/移除/run/k351-vendor-settings-ro，缓存private351/vendor-settings-private.json，未读NV/OTP/EEPROM/persist、未改安装文件/模块、未重启。文件缺失不证明所有override不存在。其余手机状态继续引用349最后观察，未重测未改组件。一次gitgrep过宽在无输出后中断；之后只ls-tree目录名和gitshow三个所需源，无活动git/sourcefetch。

351无构建/采集/SDKbindworker，通用代码与脱敏报告已镜像，所有table/XML/vendor/asm私存。下一步352优先LTM inverseGamma/核心数学与front IPE CCM13输出域，评估真实IPE硬件或明确近似后级方案，不能Gamma15∘Gamma16/强挪CCM冒充OEMfinal。348kernel与349GammaIPA已测未安装，deployed仍338+r27/r22+344etc。完整goalactive，AE/防频闪/sensorlimits/其它模式/光学/同步/连续AF等仍待。

342已部署 libcamera99990.7.2-r27、config/stack0.1.0-r22。内核保持 Image298/S5K3M5 305/GW1 325/CAMSS338；PW/SPA/Gst1.6.9-r3。新包包含330～341个体WB/CCT、完整树CCM、实时lux/AEC以及动态LSC，LSC/WB/CCM按同一revision冻结并随内核确认SOF生效。公共四摄YAML未改；344已在/etc/libcamera/ipa/camss-vfe安装四份私有Preview基线，五个已对应模式默认启用个体WB/CCT、动态LSC和CCM（前CCM仍禁用）。真实光学校准未完成。MemFd，非端到端zero-copy。四摄HW NV12/AE/AWB、RAW/双流、主摄单次AF/取消旧实现保持。

正式源 /mnt/samurai-full282/libcamera342-r27-built/src/libcamera-v0.7.2，配方 linux-port/packages/libcamera/APKBUILD、samurai-camera-config/APKBUILD。0031～0036已从r26顺序零fuzz应用，32个相关源码与341实测源完全一致；完整签名包/六IPA/Python/qcam/GStreamer/V4L2保留。安装事务 /var/lib/samurai/k342-install-r1，七运行包r26/r21离线回退与world/repo备份在同目录。只能观察已有事务，不能重放旧版本前置的安装脚本。无需重编未改内核。

342安装后默认4HW/4PW节点、Gst/PW取流通过；已安装core/IPA以四个显式unit profile完成4相位取流，共183帧、80个LSC应用状态、5040字节CCM元数据核对，四摄AWB锁定、前摄原厂CCM禁用保留。前/广用既有PN9，不把随机图差异当校准精度。独立原厂函数模型对LSC诊断追踪与CCM全矩阵匹配，实际kernel SOF配对。动态算法的全包字节与factory/unit图像对继续复用341已有结果，未重复完整采集。详细数据 reference/kernel342/README.md。

当前主摄lens-focus phandle→LC898219XI/0x72，结合274实际光学响应及已匹配326源hash的两份原厂描述，在保留Sunny/Qtech清单内对应Sunny方案。Qtech描述用BU64253/0x0c。证据 reference/kernel342/module-variant-validation.json；这是库存范围内的执行器对应，manufacturer EEPROM ID仍未认证，不自动宣称所有模组或曝光表已识别。本轮main显式Sunny测试，不再把Qtech诊断参数当本机供应商证明。

343已完成普通上下文模式选择：从保留ParameterParser的ELF数据指针恢复12个通用模板（私有），编译未改的模式读取/GetModule，平台头/字符串shim及Generic模块只保存name/UID/mode、不解析全部IQ。独立mode_tree.py直接读v1.1 mode节点与symbol entry真实ModeId，5份BIN全部节点上下文+实际模式3584项/7类根与原管理器0差；无v2link覆盖，不冒充target Android HAL运行metadata。公开源固定CamxChi 9f17f1b...CHI enum/FillTuningModeData，来源reference/kernel343/primary-sources.json。主摄Sunny普通mode2 Arb110、mode4 Arb190；前mode1 Meter139，Preview Arb144、Video Arb441；广mode0/2和长焦0/3默认106/110。7个已有几何/register依据的模式*Preview/Video明确context，无附加Feature/Scene/Effect。LSC25/CCM37/MWB117/ref79/cal97均与已测配置相同。

343原厂AEC UtilGetExpTableID(operation)完整0x27c30..27e78用329venv Unicorn执行，真实table count/nonempty knee、virtual custom query stub。14个normal Streaming返回table0，customoverride诊断返回100；没有宣称Flash/Fast/Aggressive/Snapshot分支完成。前摄所选根/SCF与Default不同，但anchor相同且lux灵敏度补偿disabled，变化字段不被读取；已有10模式/用途实际参与计算配置全部等价，没有重复手机采集。full Arbitration表/knee不同，后续完整曝光编程须选正确根。报告reference/kernel343/streaming-table-validation.json。

343已生成私有kernel343/profiles八份（四摄*Preview/Video），从r22默认YAML只合并已测WB/AEC/CCM/LSC等字段，实际match对应5模式*2用途=10。front1928x1088无stock对应保留generic；wide3264/tele4208虽模式树已选择但没有已有完整IQ mode profile，本轮未新增。无alias，现有activeLux等价。profile-bindings-private.json含选择依据；bound-mode-configs-private.json含完整table，勿公开。343当时未安装这些profile；344已部署Preview四份，现机包仍342r27/r22，当前PW/WP28486/28492。主机失败只是最初无elftools与模板长度断言，已改stdlib/删除任意长度；fullsize无旧profile时明确None，没有伪称比较通过。

344已部署本机private baseline：/etc/libcamera/ipa/camss-vfe/{s5kgw1,imx471,imx319,s5k3m5}.yaml，来自343 Preview profiles。IPA_CONFIG_DIR已核/etc/libcamera/ipa:/usr/share/libcamera/ipa，原无四份文件、服务LIBCAMERA env无覆盖。事务/var/lib/samurai/k344-calibration-r1成功终态，backup-state.json和backup保留，过程中失败会自动撤回；不能重放已执行事务。未换APK/Image/模块/DT/写工厂存储。未知前1928crop保留generic，wide/tele fullsize未新增IQ profile。公共包不放个体数据。

344默认无profile环境变量实际5模式（main2/4，front1，wide2，tele3）各4phase通过，47+47+43+42+50=229帧/20TPG图；102LSC应用状态追踪匹配原函数+独立重采样，186帧CCM矩阵6696bytes零差，实际内核SOF配对，5组AWB锁定、前factoryCCM禁用保持。路径日志确认/etc；default-iq-validation.json。默认4HW/4PWnodes，Gstwide640x480 NV12、PWwide各12帧通过。相机SPA实际由WirePlumber承载，最终maps系统/usr/lib/libcamera.so.0.7.2、ipa_camss_vfe.so、libspa-libcamera.so，WP启动日志确认etc路径，LD_LIBRARY_PATH无override。初collector错以为SPA在pipewire而false，修成按实际SPA宿主，复用同一次maps观察，没有重启/重采；service-host-assumption-r1.json保留原错判。两服务uid10000、PID28486/28492，故障delta0、taint0、CAMSS/2CCI suspended、9rails disabled/users0。无本轮worker/host build/SDK bind。343 Video备用尚未安装；活跃Lux配置等价不代表完整knee表编程完成。

345已新增独立通用math reference/kernel345/libipa/aec_exposure_table.{h,cpp}，尚未进342完整源/IPA。完整原厂CExpTable::ExpTableEntryLookUp0x2d9a0..2dbd8与UpdateFPSKnee0x2d178..2d350已恢复。224tables去重42knee程序；lookup主机/ARM各1314case26280bytes零差，267项原始/active入口相同；FPS helper+嵌套lookup各905case21720bytes零差。均C++17/O2/Wall/Wextra/Werror，SDK仅小工具，无work bind。原函数Unicorn执行，powf host libm float桩、log10 host double桩、日志桩，无Android loader或原厂服务。新函数非法配置/未表示uint64溢出拒绝，负增量按FCVTZU→0。lookup首末夹取按原厂fcsel含负0，upper_bound等值取最后knee；1.03f^delta，Gain优先与非零(Time/Maximum)分支，exact uint64 base + trunc(float增量)，不能整体float时间相乘。FPS helper先首个time>=cap前段，Gain时加nextGain/baseGain的index偏移，再cap/baseNs偏移，最后原lookup，priorityGain。scale精确77.898529052734375。复用输出的rounding观察：904有效中90低于表firstTime；其余203超过cap，最大48ns，不能替代真实sensor行/帧限幅。报告reference/kernel345/README.md与math/FPS JSON。345没有手机状态切换、配置/包/驱动/内核改动；手机仍344私有默认基线，r27/r22+298/305/325/338，最近服务28486/28492 uid10000/待机/故障0/taint0复用344；无本轮活动build/worker/SDK bind。

346已完成UpdateEVKnee与ApplyActiveTableEVFPSKnees，reference/kernel346/libipa/aec_exposure_table.{h,cpp}。224来源表去重59 table/policy context，主机/ARM各2515case368836bytes与完整原FPS/EV/active指令零差，含全部活动knee数组、FPS/EVknee、EVindex偏移。OnExposureCompChange经DataManager虚表+264、RELR原槽位证明额外flag是getHDR3Enable@1e300。EV表开关由caller决定；普通正EV可放gain，HDR3保留FPSgain；负EV不简单截短活动表，FPS截短后还可能追加原最大gain。math用host powf/log10/exp2、memcpy/log桩，非Android服务；尚未接IPA/antibanding/真实sensor limits。SetParamFPSRange原厂预算1e9f/fps取uint64，blanking严格小于duration才减，尚未封装。私有kernel346，SDK/private/camss346-math无work bind。README346和两报告已保存。

347按用户无色卡指示继续原厂调校包。复用333索引对应的五BIN（来源kernel299/323/324，以index为准），只新取固定CamxChi commit9f17f1b...的Gamma schema/interpolation/setting/header/titan17x五文件。decode-gamma.py独立读取IFE全部17roots/51channelcurves*65节点，与保留原厂ParameterParser XML全部树/开关/控制轴一致。分析副本只改非选根versionmetadata，载荷和模式树未动；曲线/源/XML私存kernel347及/home/cy122/x2pro-linux/parser-k347-*-gamma-r1。二进制leaf每channel272bytes（typeQ+65f+padding），root136bytes17Q：enable0/control11,12/LEDfloat13,14/count15,ref16，树DRC/HDR/LED/AEC/CCT/channel，不能按XSD int字样把曲线float字节解成int。

347Gamma tag复用343 stock-selection-manager，511上下文与独立ModeTree0diff；七模式*Preview/Video14context全部UID36/enabled1。未知front1928未绑定，实际mainSunny沿用342。所有五BIN的51条Gamma跨通道/触发完全相同，可先静态配置，不需虚构动态算法；不代表BPS/IPE全部tonechain等价。通用libipa/gamma_curve.{h,cpp}将0..1024有限float65点→原生64uint32，base10bit/delta signed10，末端可1024，roundf/clamp；非法输入拒绝。私有编译原GenerateGammaLUT+原round/clamp函数作参考，非HAL指令oracle；主机/ARM各41case10660bytes0diff，51条相同factorycurve去重只测一次。SDK/private/camss347-math小工具，无work bind/电话worker，现机344基线保持，没有安装或手机操作。

348已补原生Gamma typed params并实机通过，尚未安装。源/mnt/samurai-full282/source348，从338 e3aa81b...创建，提交见reference/kernel348/source-state.json，tracked clean。七文件：UAPI、175gamma.c/h、pixel.c/h、LSC注释、17x容量；无板级/传感器/主线框架改动。新CAMSS_PARAMS_IFE_GAMMA=7，776bytes，header8+RGB各64段，每段u16base0..1023/s16delta-512..511；不要求段间连续，不把旧OPE256 type4重解释。enable上传开启、flags0上传保留enable、header-onlydisable不读payload；开流standard初始化并gamma_enabled=true，stopfalse。非活动bank/DMI/CGC保存恢复沿Gamma旧helper抽公共upload，output_lock与LSC串行，正常paramsqueue发PIX RUP，不私有ioctl。params_max_payload改IFE_GAMMA_MAX，类型数组8。公共代码无原厂曲线。

348函数测试主机/ARM各24场景，八bank/576fields越界拒绝/flags/header guard/标准初始化/两个Gamma-LSC交错顺序通过。最初测试缺挂载和LSC声明已修；prepare首次注释匹配失败前无文件改动，复用干净worktree；checkpatch屏障注释补齐，最终0error0warning。构建r1/r2成功，r2仅补屏障注释后的最终源，29.84sec/无诊断，依赖闭包和共享build输出恢复。模块private/kernel348/qcom-camss-gamma348-r2.ko，proof/runtime JSON；无活动hostbuild或SDKbind。

348实机/var/lib/samurai/k348-gamma-r1 worker30625终态成功，临时348模块，原338note已恢复，安装文件不改。mainShadeTPG2十phase28frames：709/linear/Rhalf/factory/off/uploadfactorywhileoff/factoryenable/+unityLSC/+1.5LSC/709LSCoff。稳定条件图像>=paramsackfirstSof且连续hash同，不固定帧配额，不额外+2。10NV12图在privatekernel348/pattern-r1；QBUF后mutate触内核snapshot，四无效pack拒绝。factory3=6=7、linear1=off4=updateoff5、7090=9均逐字相同，Rhalf/factory/非unityLSC有变化。独立linearNV12逆RGB+sourceGamma64段近似：factorymean.333/p991.419，LSC1.5mean.504/p992.378，非光学精度。实际格式colorspace8/xfer2/ycbcr1/quant1，测试显式曲线不按广告sRGB反推。10图SOF>=对应firstSOF，参数与图像报告见348两个pattern-r1 JSON。

临时348下现r27/r22四摄Gst各12帧全部通过并恢复图，76totalframes；相关faultdelta0/taint0/CAMSS和2CCI suspended/9rails disabled users0。最终服务PW30772/WP30836 uid10000，四摄344etc私有WB/LSC/CCM（frontCCMdisabled）保持。preflight第一简易shell因PowerShell展开$?和busybox ps uid失败，不作为身份依据；已用独立inspect-phone.py Python观察证明bootguard/338note/服务/taint/idle。正式worker再次guard并vermagic/loadednote核对。此类普通观察不重复全量hash或NV读取。

349已完成IFE Gamma候选IPA集成并组合实测，但未安装。源/mnt/samurai-full282/libcamera349-gamma-built/src/libcamera-v0.7.2，baseline342正式r27源。0037-camss-static-ife-gamma.patch有11个源文件，generic gamma_curve沿用347，ipa gamma_profile读取optional gamma{mode:static,curves:RGB3*65有限0..1024}，enabledfalse/absent保留formatcurve。Native type7 encoder尾部追加776block；初始revision0与WB/BHIST/LSC/CCM一起上传，之后immutable不重传，ParameterContext gammaEnabled随ack/SOF历史，重开流重传/切回legacy清旧state；无IPC签名改动，核心只因header/version重链接。启动栈最大2664，mapped最低WB/BHIST+Gamma832，实际完整包按buffer容量检查。无内核/DT/sensor改动，使用348模块临时组合。

349build128.35sec成功，核心保持baseline werror=false，合同/设备工具Werror。真实AArch64 DSO15cases（5factorymode+RGBasym+disabled+absent+7bad）通过，12Gamma blocks9312bytes与347/348原参考对应；WB revision无Gamma、restart重传、reconfigurelegacy清状态、shortmap拒绝、ACK前metadata验证。首轮profile跨main两mode复用列表造成YAMLalias，实际解析失败；deepcopy per mode并assert无alias后通过，失败log保留。首次分析venv无yaml已加/usr/lib/python3/dist-packages，不重建算法。

349runtime/private-k349：四份model-factory.yaml从343当前Preview profiles只给既有五匹配模式加Gamma，front1928不加，frontCCMdisabled保留。两个main-linear/main-rgb(R.5,G.75,B.25)诊断文件。R1/var/lib/samurai/k349-gamma-r1 worker31564终态pass，temporary348+candidatecore/signedIPA，7组*4phase323frames/28images，Gamma每组仅revision0ACK，7AWBlock。旧338先negative maincurvefullprofile启动-ENOSPC(-28)，无GammaACK/图像且fixture恢复，无故障；不是静默绕过。libcamera/probe/IPA/config都私有前缀，不改系统文件。最初phase0RGB模型mean18/p9967被保留gamma-image-r1-validation.json为failed，不算通过。

R1异常是旧capture只看图片相同、不要求CCM状态稳定，启动矩阵变化时可能过早保存。R2仅mainfactory0/mainlinear/mainrgb，probe新加previousMatrix稳定条件和startup逐帧私有图，不改生产IPA/内核，复用旧kernelnegative。/var/lib/samurai/k349-gamma-r2 worker32258终态pass，54+53+48=155frames/12phase图+13startup图；其它四组复用R1。相同seq0..3 startup RGB模型p99 .986..1.207/255，证明Gamma启动通道响应一致；不据此声称所有硬件模块锁存时序已证。startup-boundary-validation.json。Pimages-r1/r2、probe-observations、phase-signatures/selected-runs私存，startup-comparison-private.png仅TPG。

analyze-runtime.py r1,r2生成明确derived_not_worker_observation的probe-r1-r2-combined私有观察，并记录selected_case_run/source_runs，不伪称单一worker。选定337frames/151LSC states trace对应原函数+独立重采样，294CCMframes10584bytes零差；总实际观察478frames，七AWBlock/frontCCMfalse。Gamma每组仅一个initialACK，所有已应用revision gamma1，按actual Pair/Recovered SOF关联。gamma-image最终只比相同前Gamma状态：phase0/1 RGBmean.448/.455,p99 1.207/1.116；factorymean.401/.357,p99 2.000/1.790，最大6.46近似NV12逆RGB非RAW精度。phase2状态不同明确skip，PN9不跨时刻比较。runtime-iq/gamma-image/startup-boundary都pass；旧R1差异保留。

349最终恢复338note，现机仍344etcprivate五模式+r27/r22+Image298/sensor305/325/CAMSS338，未安装Gamma。PW32441/WP32475各uid10000，相机/2CCI suspended、9railsdisabled/users0，相关faultdelta0/taint0，两个worker终态，无hostbuild/SDKbind。source349候选+patch/state保存并镜像通用代码/脱敏报告，private factory/unit/图像/vendor不镜像。

新发现决定下一步350：原厂包还存在后级gamma15_ipe，不能把本轮IFE曲线冒充最终显示tonecurve。349 inspect-ipe-gamma.py从原BIN独立遍历，固定schema gamma_1_5_0（gitshow9f17f1b...，私有kernel349/gamma_1_5_0-reference-private.xsd），root136/17Q，treeDRC32/HDR64/LED24/AEC48/CCT32，channel1040(typeQ+257f+pad)，所选channels=3表示commonRGB，并非R/G/B各三。14actualmode/usecase对stock genericmanager零差，全部UID55/enabled1；main根6curves、front3、wide/tele8，各都非线性。完整模块根/树/curve XML核对和IFE→IPE域/顺序仍待。公开downstream-gamma-inventory是inventory不是完整解码证明。不要现在直接安装IFE曲线为最终默认。

350已完成原厂IPE Gamma完整提取与数值复现，详见reference/kernel350/README.md。五BIN177roots/898curves*257，与原厂parser全部树/开关/控制轴一致，global75unique。parser新目录E ext4 /mnt/samurai-full282/parser350，各work以1000运行；原始payload/mode树保持，完整数据只privatekernel350。14mode/usecase所选根私存mode-profiles-private.json，绑定复用349。

350通用gamma_segments.h模板64/256区分：host/ARM各64段41cases10660bytes，256段101cases103828bytes零差。实际原HAL正常编码片段355148..35528c，97有效curves99328bytes/460071instructions零差，无math/log桩。完整Gamma15 DoInterpolation483c58..4841dc：412calls（375factory/18RGB排列/12mixed/3pointercopy/4badweight），5332702instructions/495memcpy桩无math桩；portable host/ARM各1240records1279680bytes零差（另4badcurve）。工具初版缺explicit template argument已修，失败log保留。HAL runtimechannel1032(enumI+257f)，序列化1040(enumQ+257f+pad)，HAL输出G/B/R；portable normalized单channel API[0,1]，没有采用范围外端点epsilon，尚未IPA/tree集成。check-hal-fragment已改main guard以复用loader。SDK/private/camss350-math只有小工具，无workbind/phoneworker。

350处理链证据：pinned9f17f1b源码IFE动态mask/ContrastCurve影响enable，输出64greenbase；IPE GetGammaOutput接IFE/BPS，与Gamma15precalc不同。LTM13setting使用inverseGamma，有reserve igamma_en；static ignoreChromatixRGammaFlag可forceRGAMMA_EN0，useHardcodedGamma可取硬编码，target值未恢复。170/175 published lists均CST→LTM→CCM→Gamma→ChromaEnh，但未证明目标Titan/全部runtimeenable。实际281 cameraHAL e2b1b9...debugsymbols + rawregistry + RELR绑定CST34f8d0/LTM35e238/CCM350368/Gamma351bd8连续24byte槽；opaque字段不当enable、邻接不冒充physicalgraph。pipeline-role-validation/primary-sources已记录，包括170file。vendor源/asm只private。

350 representation对75unique曲线每4点抽样成65，0精确表达，最大continuous误差10DN10=2.493/255、maxRMS1.517DN10，所有fine/coarse delta可表达；只曲线域不含IGamma/LTM/CCM/ADRC/hardwareinteger，不作最终默认证明。没有手机活动，仍349最后观察338+r27/r22+344etc；348/349Gamma仍未安装。下一步优先从保留BIN解LTM reserve/IGamma、IPE CCM13和static settings覆盖，确定finaltone方案，不能直接Gamma15∘Gamma16或把256段送VFE64/旧OPEtype4。完整目标active。

原严格密钥USB SSH169.254.42.1；reference/kernel342/host.py raw_ssh沿用既有305transport和boot guard。相机worker均终态，相关故障0/taint0、CAMSS/两CCI休眠、九路相机电源关闭/users0，PW/WP各一uid10000。未刷写/重启/写NV或工厂数据。相机结果不代表全系统健康；旧GPU/modem/SSC等独立问题不伪装已解决。

C盘近满，新源继续既有E盘ext4镜像。每个WSL脚本用storage.py→284 mounted_build()挂载；需要SDK时以342/storage.py sdk_candidate临时bind，退出卸载。不要在C复制大型源码，不重放338磁盘恢复。342构建已完成、无活动SDK bind/host build。私有表、样本、vendor算法及密钥不镜像。

以下保留历史阶段，版本/当前状态以342开头为准。

# 当前检查点：341

2026-10-20，完整多摄/骁龙 ISP goal active。用户关灯休息，继续源码与内部图案，正常照明光学校准仍待后续。遵循 WORKING-BOUNDARIES.md，按本次改动验证，复用未变结果。

已部署：298 Image＋305 S5K3M5＋325 GW1＋338 CAMSS；libcamera 99990.7.2-r26、config/stack 0.1.0-r21，PW/SPA/Gst1.6.9-r3。四摄硬件 NV12/AE/AWB、RAW/RAW+NV12、主摄单次 AF/取消已有证据。默认仍无个体 LSC/WB/CCM 配置，335 CCT/CCM 候选 IPA 未安装。MemFd，非端到端 zero-copy。

338 只改 SoC CAMSS VFE175 BG 默认 rows24→16，网格32×16满足原厂16×16池化约束；容量仍768regions/22568bytes，真实packet16424bytes。四摄真实2048regions到1024cells主机/ARM与原指令各8224bytes零差；新网格四摄AWB收敛、稳定图像，共95观察帧。安装后4硬件/4PW节点、Gst/PW取流通过。相关故障0/taint0，CAMSS/两CCI休眠、9rails关闭/users0，338当时PW/WP22627/22630；339结束为23394/23397，340结束为24236/24239，341结束为25981/25984 uid10000。没有活动构建/采集/安装worker。

338 已安装 CAMSS SHA c7ebd3b6d4e288530d88455e3a2504b23f627fa12bb34efeac6659365c6f256f，loaded note SHA0227d29bb5129e2fc69866529147b21b902d441c855f848fd5eaa3093c590297。源码 /mnt/samurai-full282/source338，branch samurai-lux-grid338，commit e3aa81b109e44735161036a2adede105e437ed01，clean，父3346c762e...；包含334CCM硬件支持。原318模块在 /var/lib/samurai/k338-install-r1/qcom-camss-before.ko。原严格密钥USB SSH169.254.42.1，reference/kernel338/host.py raw_ssh；切换沿用305boot guard，普通只读不重复guard。只换CAMSS模块，没有包/Image/DT/刷写/重启/NV写入。详见 reference/kernel338/README.md。

C盘近满曾使首次338 checkout失败/WSL只读，已恢复；新源码改放既有E盘32GB ext4镜像。每个访问此树的WSL脚本先用 reference/kernel284/storage.py mounted_build()，不要格式化或向C盘新增大型副本。后续IPA副本也放E ext4，用临时bind mount接SDK构建路径。私有host恢复记录在kernel338/host-recovery，不镜像。

339 已完成：在335候选IPA集成337四个libipa源，新增可选aec_lux模式节点及LuxProfile包装，私有Statistics返回luxValid/exposureIndex/luxLuma/luxIndex，不使用标准物理Lux控制。每统计帧使用其已生效SOF WB上下文和真实曝光行/增益码；ns=llround(lines*lineUs*1000)。缺失/错误/不兼容/重复统计不推进滤波，start/stop重置。默认配置未改，没有自动选择工厂/供应商。

339 候选 /mnt/samurai-full282/libcamera339-lux-built/src/libcamera-v0.7.2；0034以335为base。首次DSO加载发现ValueNode无uint64 accessor（虽然链接通过），改string+from_chars解析64bit纳秒，重建签名；最终build attempt2成功。实际ARM DSO11cases通过，7组63有效记录共756bytes与原指令完全一致，亮度可359.018；8个配置含禁用+3拒绝配置。真实四摄+广角补偿5采集122frames全部实时lux，AWB稳定、恢复完成。原厂指令对曝光/滤波日志最大误差0.000507（六位日志，容差0.003）；120帧匹配338稳定TPG亮度模型。前摄SOF0/1亮度.1，保留滤波核对但不冒充338稳定raw；分析首版错误假定从首帧稳定，已修正记录，未重采。没有改手机安装文件/模块，338继续加载。所有worker终态，PW/WP23394/23397 uid10000，taint0/3平台休眠/9rails关闭users0。详见reference/kernel339/README.md。

339私有profiles-private.json：5个工厂来源unit profile来自335，Metering106/Arbitration110 table0/first knee的显式诊断anchor；另广角开启颜色补偿/关闭滤波/禁用3种配置，不宣称物理模式已绑定。安装系统依旧r26/r21无这些默认。profiles及expected/actual、算法和样本不镜像。339/storage.py sdk_candidate()临时bind E候选到SDK work/libcamera，exit卸载，不要套用旧rename-only构建器或在C复制541MB。

340 已完成实时AEC/CCT→CCM联动。源码 /mnt/samurai-full282/libcamera340-runtime-ccm-built/src/libcamera-v0.7.2，0035以339为base，仅CAMSS IPA camss.cpp/colour_correction_profile.{h,cpp}三个文件。colour_correction.aec_source=runtime可选，lux_index或analogue_gain轴；默认reference兼容。runtime可不填reference.aec_value，DRC/HDR/LED仍显式reference。无AEC或CCT保留旧矩阵、无历史unity。每次WB+CCM proposal冻结CCM状态/源Sof/AECfloat/CCT，prepare不再被后续统计改变；硬件字段含offset/q相同不重复传，元数据按ack firstSof。paramsApplied清旧ccmInputs，等待对应最新ISP上下文统计；旧SOF不提议。手动优先/零gainfallback保留。

340候选build57.7sec通过；实际ARM9新case、66份CCM包+metadata5016bytes独立原厂CamX源码零差，另2份前摄disabled启动包；两项335原合同(referenceCCM、reference+staticLSC)通过，96/1888容量不变。新合同初版Werror缩进报错已修，未改功能源码。私有kernel340/profiles从339生成，明确runtimeAEC；gain-axis-diagnostic修改触发域，只诊断不声称真实factorygain轴绑定。front-explicit-ccm-experiment明确override enabled=true；正常sunny_imx471-unit保留factory disabled。检查JSON中的ccm_enabled与factory_ccm_enabled已分开。

340手机R1 worker24203终态，通过4摄*4相位(500us/1x,5000us/1x,25000us/8x[前12000us]/AWB)，222frames/16images；73已生效revision、222矩阵metadata7992bytes与独立源码零差，10组不同CCM的图像对均不同，末AWB锁定。首版分析把image sequence当kernelSof，前摄实际offset1，其余0，改用实际Pair/恢复事件核对全部帧，未重采/未改驱动。sourceAEC以精确float bits日志保存，十进制lux日志差<0.000498。/var/lib/samurai/k340-aec-ccm-r1完成，未装包/换模块，仍338/r26/r21；PW/WP24236/24239 uid10000，taint0、相关故障delta0、3平台休眠9railsdisabled/users0。无活动session或相机worker。详见reference/kernel340/README.md。

341 已完成候选动态LSC：/mnt/samurai-full282/libcamera341-dynamic-lsc-built/src/libcamera-v0.7.2，0036以340为base；新DynamicLensShading解析完整lens/DRC/HDR/LED/AEC/CCT核心树，mode dynamic可选，其他默认static。AEC实时lux/gain，其他坐标显式reference；五份Default根原厂轴均lux_index/sensitivity_ratio且enabled1，单个golden（已核XML）。仅显式golden/unit主表对，非多光源/供应商自动绑定。复用已有单表合成/GRGB均衡/Hermite/Q10；shared tuning_interpolation.h与CCM共用保留数值规则。每revision冻结LSC+CCM+WB，后续stats不能改准备包；不变网格不重传，1792块/1848或1888容量不变，无内核/板级/传感器改动。

341 build83.29sec；ARM10配置143提交，105LSC+125CCM块193160bytes原LSC源码/独立Hermite零差，38次LSC省略；原CCM+静态LSC两合同兼容/3错误配置通过。原函数oracle私有编译封装缺cstddef已补齐。控制方法proof reference/kernel341/control-method-validation.json。动态配置/profile/table/math库只私有，Public patch0036及通用代码可镜像。

341现场：最终8组（4摄factory/unit）各4相位选定369帧/32图/163LSC状态，追踪值与原函数+独立重采样一致，283帧CCM metadata10188bytes零差；8组AWB均锁定，前摄factory CCM仍disabled。14组可重复图案factory/unit图对不同，PN9随机差异不用于证明个体效果。R1主摄两组49/48通过后前摄渐灰AWB缺有效区域450帧终止，保存failure；R2复用主摄，只补剩余，前摄仅手动3phase14/14通过，广角渐灰AWB451/451失败但保留手动图，长焦50/50全过。算法门槛未降；R3前摄用已有PN9(index4)43/43全过；R4广角PN9 44/42全过。PN9按控制和AWB锁定，不要求图像字节稳定，手动相位是生效快照非全滤波收敛。cases-r1/r2/r3.json保留各清单，当前cases.json仅R4广角2项；analyze-probe.py r1,r2,r3,r4合并已通过案例并保留R1/R2失败。私有images-r1..r4，所有run worker终态。

R4曾在prepare-runtime工具完成前错误发送了半写tar，解包EOF、未启动worker。确认无state/worker后保留目录为/var/lib/samurai/k341-dynamic-lsc-r4-incomplete-transfer，再以完整包启动pid25965并完成。代码已改tmp+atomic replace，但仍须等准备工具返回成功后再launch；不可仅超时就重发。recover-transfer.py只针对已验证未启动的那次目录，不能重放。

341结束无活动build/SDK bind/相机worker。手机仍r26/r21+298/305/325/338，PW/WP25981/25984 uid10000，taint0、故障delta0、CAMSS/CCI休眠9railsdisabled/users0；没有安装新IPA/调校包，也未刷写/重启/写NV。source-state动态LSC仅候选，部署以338内核为准。详见reference/kernel341/README.md。

下一步342：从341候选推进实际曝光表物理模式/主摄模组供应商绑定和统一发布；通用代码可以独立发布，但不能把诊断Default/anchor/primaryunit选择冒充已证明的自动工厂选择。正常照明光学、几何同步、连续AF等完整目标仍在。C近满继续E ext4，用341/storage.py sdk_candidate()临时bind构建测试后卸载；勿向C复制大型源码，不重跑未改组件。

以下保留历史阶段，出现“当前/下一步”以本段341为准。

最新完整r26包源/home/cy122/x2pro-linux/libcamera214-root/work/libcamera321-lsc-built/src/libcamera-v0.7.2；原work/libcamera已恢复，316源保留。不要用旧315/316生成器覆盖321。linux-port/packages配方含0030。回退r25/r20包/world/repositories在/var/lib/samurai/k321-install-r1，318旧模块在k318-install-r1/qcom-camss-before.ko。不要在r26上重放首次安装。

320已纠正IMX319个体packed40：每51点额外跳1字节，地址208+5*i+floor(i/51)，884值全非零，不修补原数据。正确值/private kernel320/stock-unit-lsc-private.json，原始双读kernel299。不要使用304/317旧单位解码/旧候选零点结论。Checksum仍未确认，但不能把它变成所有可回退运行配置试验的硬门槛，也不能假称校验完成。

322：广角七原厂LSC根完整触发树/表/golden与XML对应，三套配置。Default25/130、Usecase33为1262、PreviewFeature1.12四根相同。区间内保持、仅间隙线性插值。显式Default/lux100/CCT6500的factory与真实unit均通过已安装IPA→318硬件内部灰阶图；两份884编码字与独立模型完全一致。真实个体LSC已临时应用，默认未启用。mode2对应mode0域span1631/1223、first0/0、step2/2。reference/kernel322/README.md。

323：长焦六根94基础/6golden完整对应，三套。Default25/278/488；625另有LED1，组装器已支持显式LED索引，不默认选择多分支。本轮LED0，396组触发通过。mode3 2104x1560对应mode0 4208x3120，参考起点同8/8；span2103/1559、first0/0、step2/2。factory内部图案已通过系统IPA，当时尚无长焦个体应用，327已补齐临时光源0实测。reference/kernel323/README.md。

324：本机原厂vendor只读取得qtech_s5kgw1、sunny_s5kgw1、sunny_imx471调校，均与298库存指纹匹配，已卸载。三文件各2个IFE LSC根，基础区域5/18/22，golden各2，完整触发树/网格与原厂解析器对应。原始调校/private kernel324/*-tuning-private.bin、解码*-trees-private.json，私有profiles已生成。主摄两文件明显不同且未绑定本机；qtech描述EEPROMName还写Sunny_19696，名字不证明供应商。

324四映射：GW1 4608x3456 span4639/3471 first16/8 step2/2；4608x2592 first16/440。IMX471 2304x1728 span2303/1727 first0/0；1928x1088 first200/302。均按原厂/当前真实裁剪与数字偏移，固定CamX约定用mode0输出域。目标HAL fullResolution赋值仍未独立反汇编；不要说公开版本全部匹配。前摄full4608x3456仍需remosaic，未启用。

324 R1主摄TEST_PATTERN查询返回6，0帧，当前GW1驱动没有该控制。R2前摄off通过，factory因共享gain对象产生YAML alias被拒绝；生成器改为每模式独立副本，复用未改采集二进制重新打包。R3两前摄模式off/factory均实际稳定3帧，ACTIVE尺寸读回确认；近似独立模型p99 1.478/1.541，max4.127/8.851/255，不是RAW光学精度。工具SDK/private/camss324-runtime/lsc-smoke，通过公共SensorConfiguration显式选sensor output；cases.json有10计划案例，但仅前摄4项R3通过，主摄6项不可算通过。reference/kernel324/README.md。

325已部署：GW1标准TEST_PATTERN菜单0Disabled/1ColorBars/2ShadeColorBars，映射16-bit0x0600值0/2/3，依据真我同GW1官方源码。15+行传感器补丁沿用PM缓存/group hold/启动setup，不改板级DT、SoC或IQ表。源码/home/cy122/x2pro-linux/camera325-gw1-tpg-kernel，分支samurai-gw1-tpg325，提交4318dd1c2f7b8971b267cc50d9129e86e99bccdb，tracked clean，父318；旧318树保持。最终GW1模块SHA61c81f47bd29925f95ef6ad146e8f3231b3b01b3f64f458a09680eb450d2a167，noteSHAb80626da86f24d4eaf53ca78e3baa6462cf204adfc257de859bf418f0e9fbd57。模块Werror/ABI/intree及格式通过。原9f1a模块在k325-install-r2/s5kgw1-before.ko，中间509c在k325-install-r3/s5kgw1-before.ko，不能重放旧前置的安装脚本。

325 R3两主摄模式off/Qtech/Sunny各实际稳定3帧，ACTIVE尺寸读回确认、控制缓存及流中0→2切换、媒体/控制恢复成功。四个factory均产生可辨效果，基准梯度确定的彩条内部区近似独立模型p99约1.67～1.78、max3.24～3.40/255；不是RAW光学精度。默认Gst主摄640x480和PW各12帧、四摄/四PW节点通过。四摄工厂LSC运行配置链路至此齐全，广角另有真实unit；默认工厂/单位LSC仍未启用。参考reference/kernel325/README.md。下一步继续主/前/长焦个体读取/布局/绑定以及动态触发，不需要再次卡在主摄图案。

326已完成其余三摄个体读取：两份GW1描述与当前vendor指纹相同而复用，前摄/长焦版本不同，已ro/noload/noexec取当前文件并卸载。按当前类型表验证主摄0x50/9984 bytes、前摄0x54/5682、长焦0x50/12272，地址16bit、READ枚举3。使用系统cam --capture=0并等待首个成功帧持有供电，I2C只发2字节地址指针再READ；各完整双读相同、传回核对。R1因缺/proc/PID/task/PID/children而在实际EEPROM前失败并恢复，改stat PPid+pidfd后R2全部通过，380帧仅供电期间观察，无图像文件。三摄全部主LSC884值非零，WB分母正；主/长焦LSC起点208，前摄512，沿用本机HAL每51点跳1字节，主摄旧步长会有3假零。独立C顺序游标/Python随机地址、host和ARM各7072值完全一致。reference/kernel326/README.md。

正确新个体数据/private kernel326/reads-r2/{s5kgw1,imx471,s5k3m5}-read{1,2}-private.bin；decoded-unit-private.json含当前描述逐光源WB/LSC、未应用。descriptor-layouts-private.json含当前类型行；descriptor-sources-private.json定位主摄115缓存及326新前摄/长焦文件。光源0主表可用于明确诊断配置。注意长焦光源2的GR低字节在原厂写208而正常packed40为209，必须保留事实并明确选择光源，不把5项都当alias同表；本轮没有修补任何值。326当时未应用三摄值；327已补齐光源0可回退配置试验，默认仍不启用。不要把未知checksum变成所有实验硬门槛。

AE同步进一步事实：已查本机HAL旧命名GW1分支0x50323c/0x503250，主参考偏移0x3400、36bytes；位于当前9984常规段之外，另正常供电小读双读一致。该位置命中拒绝哨兵0xff，没有可用主参考，不能据此应用同步系数。新文件/private kernel326/reads-ae1/s5kgw1-ae-master-read{1,2}-private.bin。广角299及长焦326的0x2d00数字字段非零，长焦共同布局仍候选；decoded-ae-reference-private.json保留结果。旧分支接受s5kgw1_p24c128e_sunny/_19696，而当前Sunny描述为_19781；不能强认版本完全一致。继续主参考正确来源/旧persist只读备份调查时先找现存资料，不盲扫或重读旧0x3400。未写persist。

326 /var/lib/samurai/k326-eeprom-r1失败恢复、r2完整读取完成、ae1小读完成，均终态。当前打包read.tar.gz最后为ae-read-plan.json，不盲目复用launch-read重读。后续327已实测新个体配置，继续动态调校。

327：复用325通用lsc-smoke与313fixture，三摄新增14个factory/unit配对配置，主摄Qtech/Sunny两分支各两模式、前摄两模式、长焦一模式，均通过当前r26 IPA到硬件。仅显式Default UID25/lux100/CCT6500/LED0/EEPROM光源0诊断，主摄供应商仍未绑定；不选择/修补长焦光源2。真实AArch64 IPA 14份1792-byte块与独立Hermite/float32模型共12376个Q10值完全一致。7组unit图像均不同factory，7份factory与已有参考逐字节相同；旧off基线复用，unit近似图像模型p99主摄1.68～1.80、前摄1.49～1.54、长焦1.17/255。不是RAW/正常照明校准。四摄真实unit临时应用链路至此齐全（广角322）；默认未启用，动态CCT/AEC尚未集成。reference/kernel327/README.md。

327私有配置kernel327/profiles/{qtech_s5kgw1,sunny_s5kgw1,sunny_imx471,qtech_s5k3m5sx}-{factory,unit}.yaml；14案例reference/kernel327/cases.json；图像kernel327/images-r1、真实IPA网格*-mesh-private.bin。AArch64多模式导出工具SDK/private/camss327-mesh/dump及public dump-ipa-mesh.cpp，仅主机chroot运行，不在手机安装。手机/var/lib/samurai/k327-lsc-r1终态、恢复成功；无需重复旧工厂采集/完整包回归，后续从动态触发、供应商绑定/WB以及AE参考正确来源推进。

328：五份工厂调校（两GW1分支/IMX471/长焦/广角）共43个AWB根完整与原厂XML/选择树对应：19refPt、19MWB、5sensorCal。factory-wb-validation.json。sensorCal实际320bytes，不是schema不兼容：6个头Q+计数Q+紧密6float CCT(24bytes)+15复合rg/bg(240bytes)；初始误算344已纠正，R4全过。R1/R2缺输入schema目录内ParameterTuningTypes导致Scenario.0覆盖，不当绑定证据；R4恢复真实路径。每golden启用/count5，参考点后5对零是未用槽位，别修补。正确私有kernel328/*-factory-wb-private.json。

328个体WB复用299/326全部读回，按HAL实际ISA确认float32 R/Gb、B/Gb、Gr/Gb分别除q；当前q1、mirror掩码0，主/前/长焦invert1也不倒置，广角invert0。光源枚举0..4=D65/TL84/A/D50/H，所有正值。formatted-unit-wb-private.json。HAL FillIlluminant函数0x405878..405d84从VA0xdd800读取CCT=[6500,3800,2850,5000,2300]并原样复制比值；工厂golden CCT主=[6500,3900,2800,5000,2300]，前=[6500,3800,2850,5000,2300]，广角/长焦=[6500,4100,2850,5000,2300]。不要按同slot盲配或伪造运行CCT，328当时未确认真实对应；329已由本机算法确认按索引配对、按工厂CCT分组，payload CCT不参与。wb-reference-bundle-private.json保留两套坐标和全部参考，未应用WB。

328已只读补取本机vendor三算法：kernel328/stats-source/com.qti.stats.awb.so(338864bytes,SHAf1ca21304b2e05ff8bb554fec21b123d11697566b44e9902266a4c90d0b2629e)、awbwrapper(19848)、aec(382672,SHA3f8d12e8a907d90a7c5025db457bca50450b6eb15e74fc7a90d98fbe66080ac7)。已卸载，未执行。manifest kernel328/oem-stats-source.json；手机/var/lib/samurai/k328-oem-stats-source/source.json已完成，不必重采。算法来源/函数定位reference/kernel328/algorithm-source-validation.json。私有反汇编kernel328/{awb,aec}-functions-0x*.txt已取得，别重新反汇编整个HAL。

继续算法追踪的具体入口：AWB SetCalibrationData0x2ab90..2af88、golden/MWB0x85b8..935c、校准数量/光源分组0x9e30..a8fc、GetGainFromCCT0x9bc0..9d70、GetCCTFromGain0x9d70..9e30。AEC CalculateLuxIndex0x4b088..4b220和4b238..4b5a8、EstimateLuxIndexForSlave0x46990..46ac4。已读AEC小函数发现50常量、log10和某只读double比例系数，但调用输入/offset语义及参考域未证明，不能直接以曝光EV替代；尚未写实现/宣称完成。下一步从这些小函数推进动态CCT/lux和WB校准，不回退到已解的320bytes问题。

329：通用C++17 WB校准、MWB比值转换及正向CCT查表已写在reference/kernel329/libipa/awb_calibration.{h,cpp}，未接入/安装IPA。校准按unit/golden同记录索引配对，按工厂CCT（不是HAL payload CCT）分组；五真实来源改payload CCT999后输出不变，328对应语义已解除未知，不要继续当阻塞。输出比值因子unit/golden，与LSC方向相反；MWB先G/R、G/B，再乘因子，结果是比值，非直接颜色增益。

329用Unicorn ARM64 2.1.4对保留原厂小函数做指令仿真；无Android加载器/原厂native加载/手机运行，日志stub、系统调用/异常拒绝。原厂校准0x9e30..a8fc、MWB纯算术8f24..9114、CCT正向9bc0..9d70，与独立C++主机/AArch64 SDK Werror结果每架构3118值完全一致。覆盖63分组子集+边界/真实5份=78校准条件、19真实MWB、589CCT查询，证据reference/kernel329/math-validation.json。新数据kernel329/calibrated-ratios-private.json等只留私有。没有新相机worker、包/模块/默认配置改动。

329仿真环境/home/cy122/x2pro-linux/private-k329-venv/bin/python；check-math.py可复跑相关数学。ARM SDK/private/camss329-math/math-aarch64已成功，主机无aarch64-linux-gnu-g++，不要因此装整套新工具链，现有SDK chroot g++即可。源码8f24算术将实际MWB(R,G,B)转G/R,G/B并乘factor；CCT查表节点[12000,7500,6500,5000,4000,2850,2300,1500]→索引[0,1,2,3,5,7,8,9]，在线性Kelvin中插值，非mired；仅正向lookup，非测得CCT。

330：从321已部署r26源隔离副本集成329数学、white_balance_reference可选模式配置、ColourTemperature1500..12000 K输入、参数队列及SOF元数据。候选源/home/cy122/x2pro-linux/libcamera214-root/work/libcamera330-wb-built/src/libcamera-v0.7.2，0031补丁reference/kernel330。核心/签名IPA成功构建，SDK原work/libcamera已恢复。完整核心沿用基线werror=false；DSO/probe工具Werror。13项真实AArch64 IPA测试全过（五来源factory/unit、startup6500/runtime2850、包编码、SOF前后/统计元数据、旧AWB、禁用/错误配置）。

330手机进程临时加载候选core/signed IPA，14组内部图采集观察95帧、24稳定图；四旧unity基线逐字节相同，20张色温图增益元数据与硬件Q7量化匹配，五来源factory/unit在两个K均有图像差异。近似独立模型均值0.316..0.457/255、p99约1.21..1.45，不是RAW/光学精度。kernel330/image-validation.json。私有profiles/{五来源}-{factory,unit}.yaml无LSC；cases-private.json包含私有expected_gains，images-r1为图像，禁止镜像这两类数据。主摄两供应商仍分别试验，未绑定。

330 /var/lib/samurai/k330-cct-r1 worker15501完成，所有采集/控制/媒体恢复，相关故障delta0/taint0，CAMSS/CCI suspended、九相机rails disabled/users0；PW/WP各一个uid10000进程15580/15583。没有安装包/模块或刷写，系统版本不变。默认无WBreference/个体LSC，默认AWB不变。候选ColourTemperature控制direction改inout，但任意ColourGains反推CCT及CCM联动未实现，属于部分语义；不能称自动测量CCT。显式ColourGains优先、单独增益清手动CCT标签、AWBon忽略手动CCT；SOF前不提前报告新标签。

331：反向色温与参考点校准通用数学已实现，reference/kernel331/libipa/awb_colour_temperature.{h,cpp}，不是正向MWB查表反插值。已证明实际vptr=0x5ecb8（构造0x81b8/0x8228），+32→8380，+160→9d70。solver工厂25fa0设置vptr5f750，+24→264c0；调用方360b8..360f8交8368安装到main+de6b8。包装9d70→8380→264c0、分类26578、距离/插值267f8；最终参数由frame+44(distance)/48(CCT)/52(illum)给wrapper。

331反向参考必须refPtV1，非MWBGainV1。25da0..25ef0确认refPt前10对逐通道乘329 unit/golden因子，写main+91e，然后260f8配置估计器。已完整指令仿真和通用C++验证，别把单位参考点对应继续当未知。solver八段连接[0,1],[1,2],[2,3],[3,5]重复,[5,7],[7,8],[8,9]，边界经垂直线，二维投影权重后线性K。端点CCT12000/1500却illum1/8，不能自行改成0/9。

331五来源19refPt根factory/unit共38模型，每架构760参考值+10450节点/区间/离轨/随机查询，主机/AArch64 Werror与原厂包装函数色温/距离/分类完全一致。kernel331/inverse-validation.json，私有input/cases/output与完整反汇编不镜像。仿真无native OEM/Androidloader/手机运行；memcpy只仿真内存、sqrt数学/log stub，syscall/exception拒绝。331无手机切换/worker/安装，330最终状态复用。

332：331反向CCT已接候选IPA，white_balance_reference新增可选reference_points10对，使用unit/golden因子校准，选UID79 refPt/UID117 MWB诊断。硬件量化effective ColourGains取倒数为ratio，每revision准备时计算estimatedColourTemperature，与manual标签分开存ParameterContext，仅SOF ack后的历史帧输出；manualCCT标签优先，任意手动增益/AWBon均可估计。没有refPt的330forward-only配置保留旧行为，旧默认无假CCT。现有灰世界AWB+个体轨迹估计，不是整套OEM AWB场景算法或光学测量精度。

332候选源/home/cy122/x2pro-linux/libcamera214-root/work/libcamera332-cct-built/src/libcamera-v0.7.2，330基础+0032增量（reference/kernel332），仅IPA/libipa改动，核心复用330且内核不变。签名IPA67秒构建成功/SDK原work恢复；DSO/probe Werror，完整IPA沿用werror=false。真实AArch6415项全过：10factory/unit、forward-only、legacy、invalid/disabled、合成RGB真实AWB反馈及SOF历史。kernel332/ipa-contract-validation.json。

332手机临时candidatecore/signed IPA，五unit配置覆盖四摄（主Q/S分别），手动1.25/.75→AWBon并实际锁定，观察153帧、10稳定图，五自动图均异手动。153帧色温元数据与独立原厂指令完整wrapper一致、K舍入误差0。无固定帧数门槛，kernel332/cct-metadata-validation.json。private profiles含reference_points及*expected-private.txt，*points-private.bin、cases-private.json、images-r1和完整日志禁止镜像，公共cases已去私有数值。

332手机/var/lib/samurai/k332-cct-r1 worker16581终态，媒体/控制/服务恢复，相关faultdelta0/taint0、CAMSS/CCI suspended、九rails disabled/users0。PW/WP16618/16621各一个uid10000进程。没有安装、重启、刷写或NV/OTP/persist/EEPROM写入。设备仍r26/config-r21+298/305/318/325；默认配置不变，供应商未绑定。

333：五份保留BIN全部IFE cc12_ife共28根/567区的矩阵、偏移、DRC/HDR/LED/AEC/CCT完整树与原厂XML一致。Qtech GW1 1/18、Sunny GW1 12/204、IMX471 1/12、tele5/141、wide9/192；偏移全0，Default根37。private kernel333/*-ccm-trees-private.json，factory-ccm-validation.json含选择器，不要混淆UID相同/表相同与实际模组绑定。解码脚本decode-and-export.py，ParameterTuningTypes留schema输入目录已沿用正确路径。全保留payload/模式树不变。

333通用colour_correction.cpp/h已实现固定CamxChi源码的整数/小数分开插值、整数offset每次混合截断、矩阵RGB→GBR与Q7..Q10编码。主机/ARM Werror各2866例/182756bytes对选定原始源码片段编译oracle完全相同（567工厂区域、2255插值＋符号/舍入/四Q格式）；不是目标HAL逐指令oracle，不把两类证据混说。primary-sources.json与math-validation.json，私有oracle/矩阵数据不镜像。331/332现有CCT候选不变。

333关键纠正：现机318 CAMSS只预留COLOR_CORRECT=3 UAPI，vfe_175_params_info验证仍unsupported，必须补SoC backend，不能直接称复用已支持接口。复用296双来源相同header：COLOR_EN寄存器0x48/bit1，coeff0x760..780、offset0x784..78c、Q0x790；12s系数/11s偏移，左右位域复制，Q7..Q10。kernel333/hardware-protocol.json。UAPI“通常9s”及schema13s均不能直接当Titan175限制。数学层输出参数a/b/c/k按GBR；硬件bits原厂顺序矩阵[4,5,3,7,8,6,1,2,0]，offset[1,2,0]。

334：VFE175 CCM SoC后端已实现/临时实机验证，未安装。源码/home/cy122/x2pro-linux/camera334-ccm-kernel，samurai-ccm334，commit6c762eae4a4af55d8d9111d3c9fd8c2880f5dad1，parent325 4318dd1c2...，tracked clean。6文件133insertions/3deletions，无板级DT/传感器改动。ccm.c/h独立后端、pixel挂validator/apply/init/stop、17x params容量改COLOR_MAX，UAPI新增容量宏且只更新offset注释。header/enum/结构ABI不变，完整WB+BHIST+LSC+CCM envelope1888bytes。寄存器RMW保留其他位，coeff12s/K11s、GBR左右复制、0x48bit1、0x760/784/790，停流关闭、重开流单位但disabled。

334实际驱动函数主机/AArch64 Werror各2866参数对原寄存器位域，全MMIO/保留位、header-only disable保护页、非法flags/字段/padding、enable状态/生命周期全过。W=1 KCFLAGS=-Werror CAMSS及现有依赖闭包构建35.37秒无诊断/共享build恢复，module private334/qcom-camss-ccm334-r1.ko，SHA4f7ef0cadbec5e0dbd3df5b51d179402674e782fc7c8808ec09ce4f76dd63853，noteSHA43cc882ad8d744122dde70555e6f67784517c2acbee00a3fb1c2ece843f2d533。

334 R1 worker17856在私有factory文件校验处0帧返回2，错误是生成文件ENABLE写成DISABLE（V4L2宏ENABLE=2/DISABLE=1），驱动未错；模块/服务恢复，fault0/taint0。只修正payload，--payload-only复用工具/内核，R2 worker18160完成8阶段31帧/8图及四摄Gst各12帧（共79），无总线/相关故障。主摄ShadeColorBars2，disabled/unityQ7/非对称交换+G*.75/unityQ10/offset RGB[128,-64,32]/disable/factory/disable；两Q unity和disable回到基线逐字节相同，三个变化阶段均真图像效果。factory明确Qtech Default37 DRC1/HDRsens1/LED0/lux100/K6500诊断，未供应商绑定。

334近似NV12模型通道混合mean.381/p991.216；offset14-bit归一化mean.261/p99.927为候选域最佳，支持14bit解释。factory mean.692/p995.445/max14.093，预测输出远离截断p993.265；这不是精确RAW/光学校准，不隐藏误差或声称所有像素吻合。kernel334/pattern-r2-image-validation.json，图像/私有matrix/capture日志留private334/pattern-r2，不镜像。kernel334/samurai-ccm.c与prepare-probe.py使用实际kernel UAPI交叉gcc，无需另装工具链。普通工具plane sentinel保留但已移除任意90%像素变化门槛，按确认参数后的稳定图结束。

334 R1/R2所有worker终态，R2恢复原模块note与实验前相同；媒体/controls/服务恢复、CAMSS/CCI suspended、九rails disabled/users0，taint0，PW/WP18338/18365 uid10000。设备仍r26/config-r21+298/305/318/325，模块文件/包/Image/DT不变、未刷写/重启/写NV/OTP/persist/EEPROM。334候选尚未与332 IPA联动；不把临时kernel通过说成默认CCM已部署。

335已完成332 IPA与333 CCM数学/完整触发树、334硬件后端联动，候选源SDK/work/libcamera335-ccm-built/src/libcamera-v0.7.2，未安装。增量0033-camss-colour-correction-coupling.patch，累积330/332基线；核心库CAMSS request predicate增加ColourCorrectionMatrix，IPA可选colour_correction配置/控制/包/有效矩阵元数据，通用数学仍333，未改板级/传感器/内核。触发树DRC→HDR→显式LED→AEC→CCT保留；reference_triggers为DRC1/HDRsens1/LED0/lux100诊断，只有CCT跟revision动态更新，不把Exposure EV当lux。

335 profile每mode: colour_correction.enabled/qfactor/aec_control(lux_index|analogue_gain)/hdr_control(exposure_time_ratio|sensitivity_ratio|exposure_gain_ratio)/reference_triggers(drc_gain,hdr_ratio,led_index,aec_value)/core完整333树。原厂Default UID37均存在，前摄sunny_imx471 enabled=0；十个factory/unit正常profile保留该标志，另外两份*-ccm-experiment明确启用，仅实验。主摄两供应商仍未绑定。WB仍UID117/79个体校准，原厂表/个体/期望二进制只留private335。

335策略：可选表启用才公开ColourCorrectionMatrix；AWBoff显式手动矩阵优先，CCT或ColourGains请求无矩阵则清覆盖恢复表；AWBon清手动矩阵/CCTtag。按同revision显式手动K或硬件有效WB逆推K选表，零通道无法估K时保留上矩阵/start unity，不伪造CCT。startup预编码校验后commit；手动runtime预选后commit；prepareParameters给context存ColourCorrectionState(data/parameters/effective)，SOF ack后frame/stats都报告量化有效RGB矩阵。普通包96，WB/BHIST/LSC/CCM startup1888；无CCM保留56/1848。未改IPA ABI。

335核心+签名IPA构建119.46秒通过/SDK原work恢复，fullbasewerror=false、工具Werror。20实际ARMDSO案例全过：12profiles、合并LSC与不足容量、5parser错误、syntheticAWB→CCM+delayedSOF、legacy。独立oracle新编译333固定源GetIndexPtTrigger/CalculateInterpolationRatio+原InterpolationData/CalculateHWSetting，所有10501整数K期望供矩阵核对；不是移植实现自测，也不冒充原厂HAL指令。源码准备Meson匹配与合同80bytestruct/76byte磁盘记录padding问题修正，失败日志私有留存。

335手机R1 worker19479终态complete，临时334 CAMSS+335core/signedIPA，五组unit四摄6阶段6500→2850→asymmanual→6500restore→gain1.25/.75→AWBon，全过。253帧/30图，所有矩阵与独立oracle/explicitmanual一致，147估K帧与331原厂指令wrapper整数K误差0，AWB锁定；五组6500恢复图逐字节等于初始，矩阵与AWB各有真图差。不是光学校准。原模块/媒体/控制恢复、faultdelta0/taint0/休眠/9rails off，PW/WP19667/19708 uid10000。installed仍r26/r21+298/305/318/325；未刷/重启/NV/EEPROM/OTP/persist写。worker摘要沿用temporary_module_only名字，真实同时临时核心/IPA；future335worker字段已改temporary_userspace_and_module_only，仅字段名无新测试需重跑。

336离线已恢复AEC曝光索引/lux原语并实现通用libipa/aec_lux.{h,cpp}，未接入335 IPA。原库328/com.qti.stats.aec.so保持原指纹；解压.gnu_debugdata得真实符号：2dbd8 CExpTable::CalculateExposureIndexForManualMode完整，272b8..27300 QuerySensitivity2ExpIndex数学片段，4b088..4b220 CLuxLumaCalculator::CalculateLuxIndex完整，4aee0..4b088 calculateLuma完整包装。原库log10@plt58740用主机math.log10桩、586f0/LOGGER日志桩，无Androidloader/API/系统调用。0xf50 double精确77.898529052734375，不重新高精度算1/log10(1.03)。

336公式：manualIndex=anchor.index+float(log10(float(float(ns)/float(anchor.ns)*float(gain/anchor.gain)))*scale)；sensitivity分母按float(correction*anchor.gain)*float(anchor.ns)。lux先index+log50/luma项，comp开启加log(tableZeroSens/refZeroSens)项，max0，过滤previous+factor*(current-previous)。factor0直接current，init/reset直接current。filter处volatilefloat强制独立乘加，默认compilerFMA仍精确。平均已处理的256个8bitlux单元并floor.1；没有证明当前CAMSS BG转这些单元等价，不把green/BHIST归一化直接塞入当真lux。

336精确取6公开XSD/接口，来源primary-sources.json。对原厂五BIN只保留Metering/Arbitration目录项作analysis，载荷/mode不变。r1仅Metering导出因Arbitration1.0.0旧版vs公开1.0.1；r2私有兼容schema删除末尾disableBandingGainCapping且revision0，明确推导而非找到原厂schema。独立decoder旧Arb176全部运行slots+曝光tables/knees+ISO数组均与stockXML相同，Metering关键lux字段/采样/RGBweight/refGain也匹配。动态float数组packed4+8byte尾padding，Meteringweight3float@72、enable@88、refGain3float@96，不能按每float8byte读。89Metering+164Arb=253roots，224tables/1140knees，全firstkneeindex0。private336/factory-aec-bundle-private.json含完整Arb及关键Metering，selectors/default_field_matches仅“对应已解码字段”，不证明全Metering相同/物理模式选择。

336两张非默认主摄表Qtech root599/table1与Sunny root473/table1 correction0，原值保留，6个sensitivity0/0排除正常数值比对/通用API拒绝，manual照测；不是repair/通用门槛。主机/ARM默认FMA、Werror各2554cases30648bytes零差：1212manual+1134sens+32config+140lux+36fullprocessedluma-wrapper。Unicorn venvprivate-k329-venv；test-math.py输出/math-validation.json，stock_lux.py从329StockMath继承，全部终态无活动session。没有phone操作，仍335PW/WP19667/19708及r26/r21+298/305/318/325，复用335 final-state。

337已恢复普通RGB Bayer→16x16 processed-luma→lux数值链，generic libipa/aec_bayer_luma.{h,cpp}+更新版aec_lux.{h,cpp}在reference/kernel337/libipa，未进IPA/内核。原AEC函数4e5d0..4ed60 ProcessBGStatsRegion完整；父3c958..4198c ProcessFrameStats中权重3cedc..3cff4和无效增益log路径3d7b8..3d818、pool accumulate3d608..3d650/normalize3d68c..3d744片段，最后336完整CLux包装。起初权重oracle从3cee4少了x27加载，第一12期望字节错，已从3cedc真实加载开始修正；generic实现没有为错oracle改算法。主机/ARM各1523records29636bytes0diff，267weights(89factoryprefix*3)、1248单region、8grid额外9728原regioncalls，默认FMA/Werror。

337普通RGB/no explicit sat: sums/count orderR,B,GR,GB；每通道totalSum=rawSum+(N-count)*highThreshold；green integerfloor((grTotal+gbTotal)/2)后float；weighted=B*wB+(R*wR+G*wG)，scale=1/2^(inputbits-8)，Y=scale*weighted/(explicitNormalization*N)。satFrac=sumMissing/(4*N)。权重optionalcomp=curGain*tuningWeight/refGain，不再归一化；无效gains回退base。适用stride1/全部validcells，HDR/Y/explicitSat/skip2或4等未移植。当前driver确是RGB/shift0/noSatExt/input14，源camss-vfe-175-stats.c，maxregion390x512/count16bit/30bitsums。

337关键发现：原普通ProcessBGStats入口3cdac..3ce24强制columns&15=0、rows&15=0且总<=3072，当前CAMSS32x24不兼容。pool按integer块columns/16、rows/16分组逐region累加、最后除count；16x16/32x16/32x32/64x48都与原指令一致。物理ABImax768，不需扩大容量就可32x16；不能把当前32x24直接全局平均说成原厂等价。父x26=PARENT、ProcessBG对象PROC=PARENT+128，Y记录PROC+0x30a8+24*i；legacy pool在PARENT+0x15120=PROC+0x150a0，与GetLegacyYRegionStats的子对象偏移匹配。stock_bg.py严格允许片段/普通region，pool整条原指令对generic结果，log/math沿336stub。

337还纠正336人工亮度上限：补偿权重可使8bit缩放Y>255，原lux包装不cap；337平均函数只拒负/nonfinite，补偿grid实际Y约845~863也精确。后续必须拿337新aec_lux源，不只336旧cell<=255版本。没有phone操作，仍335恢复的r26/r21+298/305/318/325与PW/WP19667/19708；不重测旧全量。

下一步338优先从334 SoC CAMSS统计源（camera334-ccm-kernel clean commit6c762e...）让BG网格满足16倍数，保持现有UAPI最大容量/可变rows元数据，32x16可在原768预算内。实际内核/内部TPG统计验证后，把337数值链接335IPA，再曝光表物理模式/供应商绑定和lux→LSC/CCM动态调校/统一发布。底层改动应在CAMSS统计后端收敛，不改板级DT或传感器。正常光照光学、几何同步、连续AF等完整范围仍在。当前没有活动构建/采集session；335 raw_ssh沿旧严格USB链。不要从旧321/318生成器覆盖新源，也不要宣称已默认部署CCM或正常照明校准完成。

继续动态AEC/CCT触发（不能把ExposureValue直接当OEM lux index）、正常光线阴影/颜色/黑电平、畸变内参、多摄几何同步、真实曝光时间和连续AF。四实体同时流未验证；旧GPU/modem/SSC问题开放。完整目标未完成，保持active。
