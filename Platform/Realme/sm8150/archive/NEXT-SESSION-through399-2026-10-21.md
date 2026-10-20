# 当前检查点：399（类型化CST／CC／CV链已构建，离线；设备最后证据397）

先读WORKING-BOUNDARIES.md、reference/kernel399/README.md。398交接归档archive/NEXT-SESSION-through398-2026-10-21.md。完整多摄／ISP目标active。用户已开灯出门，现场样本重新核实照明／曝光。

## 原厂恢复与字段纠正

五份保留调校BIN完整恢复17 CST根、71 CV根/1350叶，与原厂XML读取器逐项一致；原payload不改，数据只私存399。原选择管理器与独立mode reader在14 Preview/Video上下文、28查询一致。参数enable不能等同Android运行时enable或当前插值叶。

本机cv12 Parse真实片段1350叶+1逐字段不同值用例证明8B槽→4B浮点，无重排。native数据顺序rToY,gToY,bToY,yoffset,ap,am,bp,bm,cp,cm,dp,dm,kcr,kcb；packet低chroma槽ap/bp/cp/dp、高槽am/bm/cm/dm、末字cb/cr。398从新版寄存器名推测am/ap标签撤回，按位置数值验证不变。所选原厂CV很多不对称，不能交换。

继续保持398更正：actualIPE CC type2、offsetsigned11(-1024…1023)，不是396 type1/13位。397四个zerooffset固定矩阵实像素观察仍有效，不证明负offset。CST实际type2，matrixsigned13/Q10，subtractsigned11，addoffset/clamp0…1023。CST IQ2092→5a60/data5a68(12w)；CC2188→5e60/data5e68(9w)；CV2200→6460/data6468(8w)，勿用2196。CVcoefQ8signed12，yoffset/kcb/kcr数值clampsigned11，kcb/kcr字段13。

## 内核候选与验证

新增camss_a5_ipe_run_colour_chain_status：typed module mask/cst/cc/cv，锁内复制并检查启用模块，allocation/MAP前拒绝错误，禁用字段忽略。固定寄存器包由驱动生成，无任意CDM/IQ指针。旧job/frame及旁路/独立CC API保持；free/unknownDMA/quiesce/stop/reset函数体不变。

IQ2860B仍在原4096B页：2592共同空array，2624pre(1项CST)，2656post(最多CC、CV两项)；2720/56B CST、2776/44B CC、2820/40B CV。frame40=IQbase+2592，44preoffset32，48postoffset64。零独立DMA分配，跟随原request MAP/retain/reset回收。

实际C完整2860页2232组：17CST+737CC+1350CV+128mask/random，全6383520B与本机原HAL数值/完整CDM零差，主机ASan/UBSan和AArch64QEMU；2956非法无写。64 actual transfer/DMA模型覆盖旧旁路、独立CC、新链及未知MAP/FRAME/UNMAP/cleanup错误和分配前拒绝。未新注入硬件故障。

完整原HAL striping和原FW CONFIG_IO/帧准备：三尺寸×port8/9×cores1/2共12全模块组+其余7mask。actual C页 pre/post各链接一次；current production native C stripe在开启转换时与原HAL产生相同整512KiB CDM+32Bjob，19组零差，停enqueue前。限定1:1 NV12；新转换组合NV21/缩放/物理像素未验证。

source354 branch samurai-ipe-conversions399，HEADde94e65e7ab4ae2ec23ee1665f981d0aeb7395e7，父3988b1e8903a550ffc20a2d8f1de574c37f2260fff3，仅4文件，干净未装。正常核心W1/Werror成功诊断0，380760B/SHA6927c4c34d40871f420e29dda2f04b0a1722a3ce76007588304243e6f01256ba。共享配置/outputs/symvers恢复，build handle54050已观察exit0终态。

下一步临时固定参数adapter+合成颜色块，先CST/CV pair再单位/零/半幅/非对角/负offsetCC实像素，核对通道/范围/饱和/舍入并建立RGB域；不能只凭ACK或近似恒等验收。再标准media request/libcamera、原厂触发插值、Gamma/LTM组合。399无phone操作，不默认启用调校，不能当已完成完整IQ。

## 正式部署：最后证据397，非399复验

core395354864B/SHA68ab5b3d6626a51ae91dd13003aed8e199a58f3ba34c1fd24ebad7e16c688a88；adapter393SHAff2bfa7a9439b2ef67087ff6f5db8c9d26e9a92596cd1f63b14c3a047111d4c1；CAMSS389SHA24fcfa685d07eb8d0e1a0b8356d9ee005e5413faf29c1b384e8c79c364630288。Image363/release7.3.0-rc6-rmx1931-samurai-k363+、boot/静态DT389/logdump365、FW、SGownerAPI、r30/r25保持。

397临时4 CC帧后恢复395/393默认四摄各12/48direct、starts-stops4/error0，epoch不混。最终CPU/IRQ/PM/backing/maps/import释放，ICP/CAMSS/双CCI suspended，17clks0、9railsdisabled/users0、taint0；PW10681/WP10684各一uid10000，owner_refs53为桌面CAMSS句柄。worker10439/client/collector10536终态，无test_cc_mode/dropACK参数，不重启旧runtime。

host399委托398…394，guard=/var/lib/samurai/k394-recovered/boot-id-private.txt，原USBkey/knownhosts。状态切换先核实实际设备。395失ACK恢复和394失败/reboot/206061Bramoops及旧回退副本保持；SSC/旋转未全面复验。

363/REMAINING-CAMERA-SCOPE.md完整继续：第五2MP身份/mux、多模式、帧长/防频闪、几何/多摄同步、连续AF和光学；异步implicitfence未证明。source/build先root storage284挂原32GiB ext4，不格式化重建；rootPython复用PYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。FW/HAL/OEM/ASM/CDM/图像/个体表仅private399及前序；公共mirror只本地提交、不push/PR、保留其它改动。
