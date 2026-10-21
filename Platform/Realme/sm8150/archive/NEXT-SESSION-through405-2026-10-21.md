# 当前检查点：405（LTM类型化请求与所有权，最后实机402）

先读WORKING-BOUNDARIES.md、reference/kernel405/README.md。完整多摄／骁龙ISP目标active。用户已开灯出门，后续按实际照明判断。404交接归档archive/NEXT-SESSION-through404-2026-10-21.md。

## 候选实现与证据

branch samurai-ipe-ltm-ownership405，HEAD 3b65d2989ca8d71b658f8a859e8784be3e6bb965，父404 5bd98599e9d920c46be03c416b13287336a05bc5。四文件colour.c/h、boot.c、ipe.h；干净未安装。新增camss_a5_ipe_run_ltm_status(a5,session,job,colour,gamma,ltm,result)，NULL LTM回原Gamma/colour。旧job/colour/Gamma布局和函数体未变，404几何未变。内部API已实现，不等于产品已调用或物理验证。

LTM CPU类型2800B：IQ22个有名u32（enable由显式请求固定1）；weights12xu16；LA2x64、curve64、mask64为u12base/s12delta，scale64/LCE2x16为s12base/s12delta；RGamma5x64为u14base/s14delta。拒绝越界/非0或1标志，不接任意CDM/寄存器/设备LUT地址。

组合IQ8944B/PAGE_ALIGN12288。arraybase2592、空common0、pre32(absolute2624,max2)、post96(2688,max3)；CST2784/56、CC2840/44、CV2884/40；GammaDMI2928/36、LUT2976/3072；LTMDMI6048/156、LUT6208/2736。pre CSTgeneric20+LTM11，post CC/CVgeneric20+Gamma12。旧Gamma路径6016/8192、pre32/post64仍保留，不能拿新post96用于旧API。

lock内先复制Gamma（可选）再LTM，校验副本后才coherent alloc/MAP；geometry DC/IP/mask从已检查ltm_copy读取。IQ/LUT与frame/stripe/scratch/BL在同一保留请求；临时CPU副本所有出口释放。未知MAP/frame/UNMAP或清理失败保留DMA backing，quiesce/reset前禁止释放。原有DMA/reset所有权未放宽。

parcel实际C hostASanUBSan/ARMQEMU各128cases1144832B零差，110invalid保持输出/tail；IQ92B对实际HAL3669e0..366b4c，DMI对实际WriteDMI/nested（type1 opcode1）。LUT packing在private编译403固定source四个packer，e2；仅量化打包，不是full numeric HWSetting/ADRC。夹具修正见405README，HAL未改。

firmware59cases：实际C页+404实际Cgeometry，完整HALstriping与FW CONFIG_IO/frameprepare止enqueue前，整512KiB CDM/32B job零差；全部colour/Gamma组合、NV12/21、128/326/650/1920/4608/8192和650分区改变DC/IP/mask组合；pre32/post96各链接一次，IQ页不变。base37+--extra22，无物理帧。

transfer145cases ASanUBSan：原4种路径、新LTM无/有Gamma、NULL LTM Gamma回退；每种18故障/成功情形，额外非法/分配失败。调用方在kmemdup后被provider改为ff，最终wire和geometry仍取副本；LTM或第二份copy失败均清理CPU副本/不分配coherent，不确定完成保留整个request和图像refs。transport/alloc/geometry是provider，404几何math另证；不冒称硬件fault/concurrency通过。source-model匹配15colour+6DMA+15request/cleanup共36真实函数。

W1/Werror构建0diag，核心415752B/SHAec8bf38df201464f7e724bd090c30f113aeea1495dbfd78d6cc38e627d15bb85；共享config/outputs/symvers恢复。正式设备与adapter未动，Gamma opcode1保留，

## 下一步与既有约束

继续完整LTM数值/动态触发与输入域；尽快用固定诊断adapter验证405实际LTM组合像素和错误恢复，再恢复正式路径。不可将离线原厂packer和FW enqueue前对照当实机LTM支持。接标准media request/libcamera前明确IFE/IPE CCM/Gamma/逆Gamma职责与原HALANR440==1或topology2624==3的启用策略；当前内核API显式enable，不自动选择Chromatix。

404 geometry：仅IP&&mask用324步长/6halo/处理左右扩2，否则328/4；输出crop/plane/radial用原output范围。DC全帧继承IP条件为DC&&IP&&(((W+7)/4)&~1)>=72&&(((H+7)/4)&~1)>=54（even282x210），非288x216。full-frame1:1 port8/9/core1/2、even128..8192和合法padding；缩放/旋转/多pass未实现。403 raw LTM partition helper仅用于mask开启路径。

403 LTM ABI：13offsets0/48/304/560/816/1072/1328/1392/1456/1712/1968/2224/2480，sizes48,5x256,2x64,5x256，2736B传输；resource3296B额外560用途未证。type1/CDMDMI opcode1 reg5c08 selector1..13头156B/pretype11，IQ2096..2184/23u32/92B。原逆Gamma29输入miss/hit7424B对352sourceoracle零差，输入IFEgreen64而非IPE256。

原厂完整调校树在350／351／399私有目录，未默认激活；完整数值调校、光学与全部模式仍未完成。

## 最后设备402（405无访问／帧／安装）

402-r1 opcode10的Gamma16帧像素失败但20传输正常，随后正式四摄48恢复；r1worker15169/collector15245终态，不重启。401fixture误sourceCmdType3，实际Gamma资源type1/CDMDMI，修opcode1后402-r2同adapter/client20帧通过：linear最大差1、zeroY0UV128、constant512全128、half误差半LSB、G/B/R各8灰阶误差1、原厂曲线8灰阶误差0、NV12/NV21十模式归一化全等。失败历史保留。

402-r2root=/var/lib/samurai/k402-gamma-r2，worker15997/collector16092/client全终态。恢复正式core395/adapter393，r30四摄各12共48direct/starts-stops4/error0/extra0；CPU/IRQ/PM/backing/maps/import释放、ICP/CAMSS/双CCI suspended、17clks0、9railsdisabled/users0、taint0。PW16240/WP16247单例uid10000，owner_refs53桌面句柄。无test_cc/chain/gamma/dropACK，无新fault/dump/timeout/reboot。最终normal epoch48；两次402总136direct不可写全像素通过。403／404／405只复用该历史证据。

正式core395 SHA68ab5b3d6626a51ae91dd13003aed8e199a58f3ba34c1fd24ebad7e16c688a88，adapter393 SHAff2bfa7a9439b2ef67087ff6f5db8c9d26e9a92596cd1f63b14c3a047111d4c1，CAMSS389 SHA24fcfa685d07eb8d0e1a0b8356d9ee005e5413faf29c1b384e8c79c364630288。Image363/release7.3.0-rc6-rmx1931-samurai-k363+、boot/静态DT389/logdump365、SGownerAPI、FW、r30/r25不变，module781差量沿用。host405→404→403→402…394，guard=/var/lib/samurai/k394-recovered/boot-id-private.txt，原USBkey/knownhosts。395失ACK恢复及394失败reboot/206061Bramoops与旧回退副本保护。

363/REMAINING-CAMERA-SCOPE.md全部继续：第五2MP身份/mux、多模式、帧长/防频闪、连续AF/光学、几何/多摄同步；implicit异步fence、SSC/旋转未全面复验。source/build先root storage284.mounted_build挂原32GiB ext4，勿格式化重建；rootPython PYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。原FW/HAL/OEM/ASM/CDM/图像/个体表私存405与前序，公共mirror只本地提交、不push/PR、保护无关index。
