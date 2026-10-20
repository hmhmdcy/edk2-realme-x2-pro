# 当前检查点：370（离线quiesce窗口候选通过构建；设备证据仍369，目标active）

2026-10-20。先读WORKING-BOUNDARIES.md及reference/kernel370/README.md；最近真实设备证据在369。当前是369独立恢复启动，guard `/var/lib/samurai/k369-recovered/boot-id-private.txt`；用reference/kernel369/host.py，既有原密钥／known_hosts严格Wi-Fi端点私存kernel369/current-transport-private.json，不能用旧367guard发写操作。

## 当前设备与已验证功能

Image363（7.3.0-rc6-rmx1931-samurai-k363+）、778模块；boot固件366、实际静态DT来源365。libcamera五运行包99990.7.2-r29、config/stack0.1.0-r24，四份私有完整Preview默认保持362：已映射模式的原厂曝光／手动防频闪、IFE Gamma及既有个体WB/CCT、动态LSC、CCM。没有永久安装ICP模块或改变用户空间／个体配置。

恢复后四颗传感器各12帧GStreamer硬件采集，主摄隔离IPA另28帧／5阶段／Gamma ACK通过；故障增量0。SSC、SensorProxy、greetd、Phoc/Phosh、PW/WP正常，无需额外重启；最后taint0、十个相机模块loaded note与磁盘一致、CAMSS/双CCI休眠、九相机电源disabled/users0，无活动worker／ICP模块／临时固件／动态节点。实际结果见369/camera-runtime-validation.json和final-state-validation.json。不能外推为绝对光学校准或本机全部相机。

## 最新ICP事实（均非完整握手通过）

363完整Image含348 Gamma与357公共OF/IOMMU节点引用修正；364真实1280页映射／撤销及动态节点回收通过。365修正实时overlay不能给已有无phandle节点建引用的问题，将禁用SoC ICP与板级9ab00000/5MiB/no-map固件区建立静态联系。FAT中的DT文件不被当前EDK2采用，366已将同一DT装进实际固件卷，逐FFS仅DTB变化，运行引用验证通过。

366 A5响应3在500ms超时，记录block reset后modem watchdog并新启动，无正常终态。368优先反编译已提取原厂ELF：完整SendSfrMessage 348字节实际指令执行11路径，先处理SFR再写3；3是已证实的故障路径，不能发SYS_INIT。cache/log/format/power为明确桩，不模拟整RTOS。

368新core直接拒绝3并在清理前发布标准568字节LE devcoredump，SFR受声明/分配大小双边界限制；DMA映射回收移到PM供电释放前，unmap失败保留PM引用。实际start13／stop7和诊断helper/decoder模型通过，in-tree k363 W1/Werror构建通过，但没有真实成功清理证明。

369给临时诊断模块增加残留时钟/域时的module pin，8组实际条件模型通过；core与368产物逐字节同一。独立collector先就绪才加载test模块；只匹配新A5 failing_device/OF节点，计划先fsync再确认消费，夹具通过。一次新实验仍造成重启。原worker停在load-boot-test、terminal=false，没有改写旧记录。

实际取回568字节raw标准dump，SHA b3ca6c91f52aefee242e46efba0c5c02b7f6e46f08b18d9564fd998139a3f7bd；响应3、fw版本寄存器1000100、队列索引全0、interrupt/watchdog/protocol计数0、SFR正文空。ramoops记录CPU release后2.711ms读3、expired0、block reset asserted。collector仅raw文件落盘，decoded/result/确认消费未完成；离线解码完成。重启原因仍未证明，不能将366的modem watchdog直接当这次结论，也不能称DMA顺序调整修好了异常。

恢复boot/logdump读回正确；临时firmware副本与原厂和事务副本哈希一致后删除，原件和原state均保留。重启后代码页不匹配，停止未读异常页；同5MiB范围1280页的只读内核分配元数据均保留／mapcount0，无slab/buddy/匿名/页表占用。它只排除所观察启动的Linux普通页分配，不能证明安全世界所有权或A5权限。

## 370离线新增

同一原厂ELF的vmm_preinit/program_section_entries实际指令执行，只有L1 memset桩：代码／异常字段／页表／CSR样本为恒等映射，共享区／SFR／堆静态未映射，需后续动态VMM。原始页表／静态表只私存。初始化请求等待块4例确认请求=1才写01000100版本，结合369已读版本可推断通过等待点；不是完整RTOS、CP15或硬件SMMU验证。原始data/prefetch abort入口4例确认FAR/FSR/type偏移1099a0/1099a4/1099a8、type3/1，CP15值合成且core-save为桩，没有本机异常解码。

驱动分开quiesce_locked与stop_locked：start失败仅quiesce，保留RAM/映射/已持有PM，由owner最终stop。原先devcoredump仍先发布。临时test默认关闭hold_start_failure；显式开启且CPU/IRQ已停、块复位成功、完整固件映射和PM仍有归属时才failed-held并pin模块。root0400二进制firmware视图受两层锁／实际分配边界保护，cleanup后不可读。纯诊断接口，非正式相机ABI；DDR可能不含A5脏cache，零值不能证明没有异常。

实际start13／quiesce-stop9／旧负例2、reader15、hold-pin13的ASAN/UBSAN模型通过；MMIO/复位/DMA/PM/调度仍为桩。针对实际k363的两个in-tree W=1/-Werror模块构建通过，无诊断，未安装／加载。core232976 SHA513e25fe2ecdf77c20e28f97792be48bd9139e169501c5244bd371fbbb6d2b4e；test73320 SHA147caba4cb3b6ca2c1511442423d12de82489a1c0fcb9b47bba1ad8949e925c0。配置和既有CAMSS输出恢复。本轮无手机操作，复用369验证，没有重新宣称基线测试。

## 下一步

先准备并夹具验证独立held-failure收集／清理worker，使用369当前guard和显式hold_start_failure=1。不能直接跑369默认自动清理launcher，也不能在新worker未准备好时再启动CPU。结果确认failed-held且归属完整后，先对照原厂ELF核实固件首4KiB代码页；匹配才读109000异常页和必要页表，只私存，快照落盘后再分别观察DMA和PM释放。页不匹配／复位失败／归属不全停止读取，不读重启后旧DDR来解释新故障。最近真实实验仍369的3／2.711ms／SFR空／自动重启／无清理终态；不能称本轮修好了故障或完成握手。

大目录git grep会触发AndroidR partial clone补取，369已取消其自有grep/fetch并确认进程结束；优先复用kernel352/oem与356已保存的19781相关证据，只定点读取必要文件，别重启目录级补取。

## 源码、工具、回退

内核维护源/mnt/samurai-full282/source354，samurai-a5-quiesced-failure370／e79613d477deee2a55726cc2e05c7789057395ba；父369 f9e1ce02537f9a28f02c471888203e59c0bff794。实际Image固定ba61a62293e0f6bc5838c06f2e85e033e3d702a8，DT固定e217016006e609333a715c10f2f3e442dc4da95f。369旧候选已随恢复重启消失，370新候选未加载，默认ICP仍disabled。libcamera源/mnt/samurai-full282/libcamera362-serialized-built/src/libcamera-v0.7.2，r29/r24正式配方保持。

Git公共镜像/home/cy122/edk2-samurai/repo/Platform/Realme/sm8150。私存E:/edk2-samurai-out/kernel370含离线模型／页表／新模块；kernel369含collected-r1/raw、私有ramoops、当前guard/transport和构建；原厂ELF在kernel352。host369严格密钥，全部原始固件、SFR、内存页、认证/内核日志和校准不进公共Git。进入ext4先调用reference/kernel284/storage.py::mounted_build()，SDK bind串行。无活动构建或实验worker。

boot366 c3e4e9c85d80c8ec37605cd522cf716525ae5ebe4fa801342dbf7586c292d924，logdump365 aca01bc2c91928f1a6a6690f62d14db014351ec5049e5684590b40c3c93de8da。boot276＋logdump363可回退DT；k298旧模块树/logdump和362事务的r27/r22＋338模块＋344私有配置组合回退保留。NV、OTP、个体校准和工厂备份未写。

## 完整目标剩余

完整SYS_INIT/PING/PC_ACK、IPE图像会话与IO/IQ及后级Gamma/LTM/CCM尚未打通。已确认三后摄＋前摄，另有官方2MP人像摄像头；vendor OV02A1B只有库名证据，实际身份未确认。原厂19781 cam-sensor@4与前摄共享PHY2/MCLK2/reset12，GPIO29选择关系待解，不加冲突GPIO节点或等同OV02A10。见363/REMAINING-CAMERA-SCOPE.md。

动态FrameDurationLimits、自动防频闪、其它模式、绝对颜色／黑电平／阴影、几何／多摄同步及连续AF仍开放；用户延期的纯色／遮光可后做。整体goal保持active。
