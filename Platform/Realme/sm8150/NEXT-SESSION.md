# 当前检查点：400（转换链固定模式实像素通过，正式恢复395/393）

先读WORKING-BOUNDARIES.md、reference/kernel400/README.md。399交接归档archive/NEXT-SESSION-through399-2026-10-21.md。完整多摄/骁龙ISP目标active，用户已开灯出门；现场样本按实际照明与曝光。

## 本轮实机与像素

一次root=/var/lib/samurai/k400-chain-r1，worker12945/client13157/collector13040全部终态且cmdline不活跃，不重启旧事务。临时正常399core+固定400adapter，640x480 NV12/NV21各8模式共16direct、starts/stops16/error0，无CPU图像处理。参数取已原XML核对的SunnyIMX319 mode0/Preview CST/CV根，CV第一保留叶只作诊断，不声称当前运行时插值叶。

48平坦色块模式：0旁路Y等输入；1 CST+CV；2加单位CC，全460800B等1；3零CC全部Y0/UV128；4半CC围绕模式3编码黑色缩放，全Y/UV的2half-unit-black仅-1/0/1；5 R/B交换相对单位358968B变；6 RGBoffset(-64,+32,+96)425675B变；7相反offset360759B变。八模式NV12/NV21归一化UV后所有字节相同。主机CRC/输入生成器/尾canary/seq/timestamp通过，灰阶块Y精确，中色块offset正向Y+1/opposite和误差<=1。

支持所测固定CST->CC->CV RGB域及offdiag/signed offset路径。完整通道方程、所有尺寸/矩阵/饱和/舍入、完整Gamma/LTM/自动原厂调校尚未证明。luma拟合19训练块/29留出块首best最大误差1，但3模型训练同分有歧义，只是推断，非独立硬件公式/offset量纲证明。不能直接启用所有原厂矩阵默认调校。

之后卸临时模块恢复正式core395/adapter393，默认r30四摄各12=48direct/starts-stops4/error0/extra0，fixture恢复。临时16、恢复48及实验前48不同epoch分开。collector13.015s终态无dump/timeout，无新相关fault、未重启/刷写/永久安装。

最终实际核对400：正式磁盘/加载notes及四私有配置一致；CPU/IRQ/PM/backing/map/import释放，ICP/CAMSS/双CCI suspended，17clks0、9railsdisabled/users0、taint0。PW13169/WP13172各一uid10000，owner_refs53是桌面CAMSS句柄。test_chain_mode/test_cc_mode/dropACK均无。

## 源码构建、正式部署

永久源仍399 branch samurai-ipe-conversions399，HEADde94e65e7ab4ae2ec23ee1665f981d0aeb7395e7，干净未永久装；400无新增永久源改。正常399core380760B/SHA6927c4c34d40871f420e29dda2f04b0a1722a3ce76007588304243e6f01256ba与test核心逐字节同。400fixedadapter111296B/SHA719aa4858b29f4bd3a6efbcb4ed7f56f59ad87067c714424ae9f28220b9c67f8，宏CAMSS_A5_TEST_CHAIN/八固定选择，无任意CDM；原厂数值头私有。W1/Werror诊断0，辅助模块只构建未安装，临时源/私有头撤回、共享配置/outputs/symvers恢复。build handle81149已观察exit0。

首次client编译相邻if误导缩进被Werror拒绝，分行修复；夹具OFFSET/YOFFSET标记冲突在adapter构建前纠正。初始日志/夹具私存，非硬件失败，adapter首次构建和runtime首次事务均通过。

正式core395354864B/SHA68ab5b3d6626a51ae91dd13003aed8e199a58f3ba34c1fd24ebad7e16c688a88；adapter393SHAff2bfa7a9439b2ef67087ff6f5db8c9d26e9a92596cd1f63b14c3a047111d4c1；CAMSS389SHA24fcfa685d07eb8d0e1a0b8356d9ee005e5413faf29c1b384e8c79c364630288。Image363/release7.3.0-rc6-rmx1931-samurai-k363+、boot/静态DT389/logdump365、SGownerAPI、FW、r30/r25保持。host400委托399…394，guard=/var/lib/samurai/k394-recovered/boot-id-private.txt，原USBkey/knownhosts。395失ACK恢复/394失败reboot/206061Bramoops与旧回退副本保持。

## 接续优先级与契约

下一步本机HAL确认Gamma真实enable、DMI包及完整LUT，纳入同request所有权，再LTM/完整IQ。产品用户空间整合前核对现IFE已做CCM/Gamma/颜色转换，避免重复应用，定义输入输出颜色域；接标准media request/libcamera与原厂触发插值，再正常光照校准。不要把固定test_chain_mode当产品API。

399已恢复17CST根/71CV根1350叶，与原XML一致、14mode上下文28选择匹配。nativeParse证明CV顺序r/g/b/yoffset/ap/am/bp/bm/cp/cm/dp/dm/kcr/kcb，packet低chroma ap/bp/cp/dp高am/bm/cm/dm，末cb/cr；398新版reg名am/ap推测撤回。actualIPECC type2、offsetsigned11，不是396type1/13位。CSTQ10signed13、subtractsigned11、add/clamp10；CSTIQ2092→5a60/data5a68/12w，CC2188→5e60/data5e68/9w，CV2200→6460/data6468/8w。Gamma位置必须从实际模块核实，勿沿用早期邻字段猜测。

内核API camss_a5_ipe_run_colour_chain_status：enabledtyped参数锁内复制/检查，allocation/MAP前拒绝；旧job/frame/API和free/unknownDMA/reset函数体保持。IQ2860在原4096页，2592empty、2624pre、2656post、2720CST56B/2776CC44B/2820CV40B；frame40base、44/48相对32/64。399的2232参数页/2956拒绝、64生命周期和19原FW/native整512KiB CDM+32Bjob零差复用。

363/REMAINING-CAMERA-SCOPE.md完整继续：第五2MP身份/mux、多模式、帧长/防频闪、几何/多摄同步、连续AF和光学；异步implicitfence未证明、SSC/旋转未全面复验。source/build先root mounted_build()挂原32GiB ext4，不格式化重建；rootPython复用PYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。FW/HAL/OEM/ASM/CDM/图像/个体表私存400及前序，公共mirror只本地提交、不push/PR、保留其它改动。
