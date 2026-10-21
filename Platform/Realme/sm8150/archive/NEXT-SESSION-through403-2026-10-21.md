# 当前检查点：403（LTM契约／逆Gamma核实，原生分区基础，最后实机402）

先读WORKING-BOUNDARIES.md、reference/kernel403/README.md。完整多摄／骁龙ISP目标active。用户已开灯出门，现场样本按实际照明／曝光判断。402完整交接归档archive/NEXT-SESSION-through402-2026-10-21.md。

## 最新源码与实证

403源码branch samurai-ipe-ltm-partitions403，HEAD37040a4a11e5e3197268bdbc0c64f17e5337b592，父402195f81dd30ca8865d440bafa32c7397006a436ef，两文件，干净未部署。原生camss_a5_ipe_ltm_partitions选择324步长/6halo，旧bypass选择328/4，复用检查范围计算。只计算fetch/output范围，尚未生成完整LTM条带或接运行时。Gamma402 opcode1、旧API/layout/reset/DMA清理均保留。W1/Werror构建通过诊断0，核心390248B/SHA9b7488b41798872ca07d9d93bf33f8b07b38fc951228cc48d5e2b934c16d300d，共享config/outputs/symvers恢复，build60864已观察exit0。

本机LTM原HALInitialize初始化13个offset0/48/304/560/816/1072/1328/1392/1456/1712/1968/2224/2480。13表长度48、5x256、2x64、5x256，实际传输2736B；原资源3296B，额外560用途未证，勿假定平均表或丢弃。原resource片段sourceCmdType1/CDMDMI，完整WriteDMI/AddNested执行13次，opcode1、reg5c08、selectors1..13、头156B，3IOVA边界和disabled通过。原提交器type11 pre-LTM（off2096 enable），disabled255，6描述符片段case通过。

IQ2096..2184共23u32/92B，字段名/宽度见contract-validation.json；86组独立随机源寄存器和全位边界通过，邻字段保持。原HAL模块开关还受ANR IQ440==1或inputTopology2624==3约束，30组合通过。ignoreChromatixRGammaFlag==1只清RGamma；不能仅根据调校module_en推断当前产品最终启用。

逆Gamma原始inlined片段3618a4..362320，29输入各miss/hit，88882448指令/58memcmp provider，无数学桩；7424B与352保存sourceoracle零差，复用352旧portable host/AArch64结果，不冒称重跑SDK。IFEgreen64节点→LTM14bit64段，不能输入IPE256。原厂/linear/reverse/black/white/alternate/plateau/impulse/随机含非单调全通过。初始Initialize夹具缺已有buffer指针转posix_memalign，不是HAL错误；补合法buffer后通过，旧夹具私存，原HAL不改。

完整原HAL条带+原FW CONFIG_IO/frameprepare止220a2前：12常规(128/640/1920/4608,port8/9,core1/2,DC/IP开关)+16边界(324/326/328/330/648/650/656/658 xcore1/2)+2上界8192宽共30。全零LUT仅离线几何fixture，从未实机调校。IP启用后324/6、色度对齐/向core倍数取整、右到左分区被实际原HAL核对；326单核LTM2条/bypass1，650双核LTM4条/bypass2。条数相同时也有processing crops/grid/radial/workload差异，不能直接用旧bypass blob开LTM。640DC+IP旧条带CDM差19B；650双核差1127B且job不同。私存stripe-differences-private.json和stripe-boundary-differences-private.json及全原blob/CDM/job供后续推导。

实际候选C hostASan/UBSan与AArch64QEMU各92组/3352B零差：26LTM+66bypass(含383原62cases)。非法/短容量/count/尾保护通过。production helper已提交但完整LTMserializer/runtime尚无，不将此当LTM已支持。

## 下一步与组合边界

优先完成native LTM处理裁剪/网格/DC字段和整blob，用403完整原HAL/FW CDM作oracle；分区已就绪，勿再从头研究324/6。继续完整LTM数值输入/输出复现，然后typed完整IQ/LUT和同request所有权；pre需CSTgeneric20+LTM11两项，现Gamma布局pre只有32B一项不能直接追加；post为CC/CVgeneric20+Gamma12最多3项。保留map/unknownDMA/复位所有权，避免大LUT压内核栈。再物理LTM组合/错误恢复和标准media request/libcamera，明确IFE CCM/Gamma和LTM inverse输入域，避免重复处理，接原厂动态触发树。

原厂完整树仍在350Gamma、351LTM149roots/2135regions和CCM43/737、399CST/CV17/71roots1350leaves；个体/工厂表全私有，未默认激活。CC actualtype2 offsetsigned11，CSTIQ2092→5a60、CC2188→5e60、CV2200→6460；CV native r/g/b/yoff/ap/am/bp/bm/cp/cm/dp/dm/kcr/kcb，packet低ap/bp/cp/dp高am/bm/cm/dm末cb/cr。400固定RGB域/offdiag/offset效应仍成立，完整一般公式舍入未证。

## 最后设备402（403无访问／帧／安装）

402-r1 opcode10的Gamma16帧像素失败但20传输正常，随后正式四摄48恢复；r1worker15169/collector15245终态，不重启。401fixture误sourceCmdType3，实际Gamma资源type1/CDMDMI，修opcode1后402-r2同adapter/client20帧通过：linear最大差1、zeroY0UV128、constant512全128、half误差半LSB、G/B/R各8灰阶误差1、原厂曲线8灰阶误差0、NV12/NV21十模式归一化全等。失败历史保留。

402-r2root=/var/lib/samurai/k402-gamma-r2，worker15997/collector16092/client全终态。恢复正式core395/adapter393，r30四摄各12共48direct/starts-stops4/error0/extra0；CPU/IRQ/PM/backing/maps/import释放、ICP/CAMSS/双CCI suspended、17clks0、9railsdisabled/users0、taint0。PW16240/WP16247单例uid10000，owner_refs53桌面句柄。无test_cc/chain/gamma/dropACK，无新fault/dump/timeout/reboot。最终normal epoch48；两次402总136direct不可写全像素通过。403只复用该历史证据。

正式core395 SHA68ab5b3d6626a51ae91dd13003aed8e199a58f3ba34c1fd24ebad7e16c688a88，adapter393 SHAff2bfa7a9439b2ef67087ff6f5db8c9d26e9a92596cd1f63b14c3a047111d4c1，CAMSS389 SHA24fcfa685d07eb8d0e1a0b8356d9ee005e5413faf29c1b384e8c79c364630288。Image363/release7.3.0-rc6-rmx1931-samurai-k363+、boot/静态DT389/logdump365、SGownerAPI、FW、r30/r25不变，module781差量沿用。host403→402…394，guard=/var/lib/samurai/k394-recovered/boot-id-private.txt，原USBkey/knownhosts。395失ACK恢复及394失败reboot/206061Bramoops与旧回退副本保护。

363/REMAINING-CAMERA-SCOPE.md全部继续：第五2MP身份/mux、多模式、帧长/防频闪、连续AF/光学、几何/多摄同步；implicit异步fence、SSC/旋转未全面复验。source/build先root storage284.mounted_build挂原32GiB ext4，勿格式化重建；rootPython PYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。原FW/HAL/OEM/ASM/CDM/图像/个体表私存403与前序，公共mirror只本地提交、不push/PR、保护无关index。
