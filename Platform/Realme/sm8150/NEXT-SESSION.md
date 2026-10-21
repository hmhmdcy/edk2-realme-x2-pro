# 当前检查点：404（原生LTM全帧几何对齐，最后实机402）

先读WORKING-BOUNDARIES.md、reference/kernel404/README.md。完整多摄／骁龙ISP目标active。用户已开灯出门，后续现场样本按实际照明／曝光判断。403交接归档archive/NEXT-SESSION-through403-2026-10-21.md。

## 最新源码与实证

404 branch samurai-ipe-ltm-geometry404，HEAD 5bd98599e9d920c46be03c416b13287336a05bc5，父403 37040a4a11e5e3197268bdbc0c64f17e5337b592，两文件干净未部署。新增类型化geometry bool data_collection/image_processing/mask_filter，camss_a5_ipe_ltm_size和encode_ltm_striping；旧bypass通过全关闭flags调用同一内部ipe_encode_striping，ABI保留。完整全帧1:1 NV12/NV21 port8/9、core1/2、even128..8192及合法padding；不支持缩放/旋转/多pass，不激活LTM运行时。

mask=IP&&mask_filter：仅此时324/6并将内部处理区域左右扩2；否则328/4。403的324/6发现仅适用于mask开启夹具，勿继续以IP alone决定。grid起点/length/处理crop使用扩展区域；输出port/full/half crops、plane lengths/radial仍用原outputfirst/length。fetch/workload按实际新分区。DC全帧继承IP条件为DC&&IP&&(((W+7)/4)&~1)>=72&&(((H+7)/4)&~1)>=54，即even282x210临界，不能用288x216。

实际C：serializer78、padding layouts16、independentIQ16+explicitDC/IP/mask16＝126次完整原HAL/FW512KiB CDM和32B job对照零差，共66060288B+4032B；hostASanUBSan和AArch64QEMU均执行。serializer每架构373152B一致，非法/短容量/参数/tail保护通过。mask-off会改变条数，650双核由4降2，8192单核26降25。IQ几何随机合法字段含bin count/termination/RGamma/LA/mask等，未将全零LUT夹具实际提交。所有测试函数与候选源码匹配，见model-source-validation.json。

原型失败均保留：首个全crop/radial扩展在640差19B；最初DC阈值在286/288附近6cases各差1B，serializer-r1-validation；遗漏mask条件的IQ随机16中多例失败，iq-geometry-r1-validation。追踪真实HAL写入/复制/分配得到quarter检查，再补mask typed字段；未改HAL指令。模型源码检查发现IQ模型尚未更新本地mask变量重构，重新编译/执行32cases后通过，不拿旧模型冒称当前源码。

W1/Werror构建0diag，核心395768B/SHAc95f1e6d0fe18c8cc0c33f0796c185da475856d7fe2a10db03d670eef150be65，共享config/outputs/symvers恢复，未安装。构建及源码状态见404对应JSON。DMA/map/unknown-DMA/reset/typed Gamma原路径未新增改变，Gamma opcode1保留，板级/传感器/产品用户空间不变。

## 下一步与组合边界

接完整类型化LTM IQ92B/13LUT2736B与同request ownership，再用本轮geometry；pre数组扩为CST generic20+LTM11两项，post CC/CV generic20+Gamma12最多3项。当前Gamma pre仅容一项，不能直接追加覆盖。保留map/unknownDMA/reset/free，LUT不能压栈。继续full LTM数值与动态触发插值；再物理像素/错误恢复、标准media request/libcamera及IFE/IPE输入域核对，避免双重CCM/Gamma。

403 ABI证据继续：resource3296B但传输2736B，额外560用途未证；13tables offsets0/48/304/560/816/1072/1328/1392/1456/1712/1968/2224/2480，sizes48,5x256,2x64,5x256；sourceCmdType1/CDMDMI opcode1 reg5c08 selectors1..13 heads156B，pre type11 disabled255。IQ2096..2184/23u32/92B；原HAL enable还受ANR440==1或topology2624==3约束。原逆Gamma29输入miss/hit7424B与352sourceoracle零差，IFEgreen64→14bit64段，不可把IPE256代入。完整factory动态math尚未完成。

原厂完整树在350Gamma、351LTM149roots/2135regions和CCM43/737、399CST/CV17/71roots1350leaves，全私有未默认激活。CC actualtype2 offsetsigned11；CST2092→5a60、CC2188→5e60、CV2200→6460、Gamma2192→6060（DMI6008 G/B/R），原有固定诊断证据不外推完整产品自动调校。

## 最后设备402（404无访问／帧／安装）

402-r1 opcode10的Gamma16帧像素失败但20传输正常，随后正式四摄48恢复；r1worker15169/collector15245终态，不重启。401fixture误sourceCmdType3，实际Gamma资源type1/CDMDMI，修opcode1后402-r2同adapter/client20帧通过：linear最大差1、zeroY0UV128、constant512全128、half误差半LSB、G/B/R各8灰阶误差1、原厂曲线8灰阶误差0、NV12/NV21十模式归一化全等。失败历史保留。

402-r2root=/var/lib/samurai/k402-gamma-r2，worker15997/collector16092/client全终态。恢复正式core395/adapter393，r30四摄各12共48direct/starts-stops4/error0/extra0；CPU/IRQ/PM/backing/maps/import释放、ICP/CAMSS/双CCI suspended、17clks0、9railsdisabled/users0、taint0。PW16240/WP16247单例uid10000，owner_refs53桌面句柄。无test_cc/chain/gamma/dropACK，无新fault/dump/timeout/reboot。最终normal epoch48；两次402总136direct不可写全像素通过。403／404只复用该历史证据。

正式core395 SHA68ab5b3d6626a51ae91dd13003aed8e199a58f3ba34c1fd24ebad7e16c688a88，adapter393 SHAff2bfa7a9439b2ef67087ff6f5db8c9d26e9a92596cd1f63b14c3a047111d4c1，CAMSS389 SHA24fcfa685d07eb8d0e1a0b8356d9ee005e5413faf29c1b384e8c79c364630288。Image363/release7.3.0-rc6-rmx1931-samurai-k363+、boot/静态DT389/logdump365、SGownerAPI、FW、r30/r25不变，module781差量沿用。host404→403→402…394，guard=/var/lib/samurai/k394-recovered/boot-id-private.txt，原USBkey/knownhosts。395失ACK恢复及394失败reboot/206061Bramoops与旧回退副本保护。

363/REMAINING-CAMERA-SCOPE.md全部继续：第五2MP身份/mux、多模式、帧长/防频闪、连续AF/光学、几何/多摄同步；implicit异步fence、SSC/旋转未全面复验。source/build先root storage284.mounted_build挂原32GiB ext4，勿格式化重建；rootPython PYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。原FW/HAL/OEM/ASM/CDM/图像/个体表私存404与前序，公共mirror只本地提交、不push/PR、保护无关index。
