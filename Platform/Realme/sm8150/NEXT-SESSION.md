# 当前检查点：402（Gamma命令修正及实像素通过，正式恢复395/393）

先读WORKING-BOUNDARIES.md、reference/kernel402/README.md。完整多摄／骁龙ISP目标active，用户已开灯出门；现场样本按实际照明与曝光。401交接归档archive/NEXT-SESSION-through401-2026-10-21.md。

## 最新Gamma实机与修正

402两次独立事务。r1=/var/lib/samurai/k402-gamma-r1，worker15169/collector15245终态，401核心opcode10，20direct传输无错但16个Gamma请求像素失败：线性最大差194，零/常量不是预期、两格式不等；之后正式395/393四摄48通过。失败pixels-validation-r1.json/runtime-validation-r1.json保留，transport passed不冒称像素通过，不重启旧事务。

原Gamma FillCmdBufferManagerParams初始化片段证明sourceCmdType=1 CDMDMI，3072B。401夹具擅设3 CDMDMI32，完整WriteDMI落legacy10；原厂opcode10结论撤回。使用真实类型1，原模块片段+完整WriteDMI+AddNested生成opcode1，同三条12B/每通道1024B，reg6008，selector1/2/3=G/B/R，offset0/1024/2048。原HAL不改。原FW完整AddBLs/accumulator无provider，UID0和1都编LUT并写bank6058/605c=1，UID0强制编程，排除UID0跳过假设。

只把内核固定DMI头0a0003ff改010003ff，branch samurai-ipe-gamma-dmi402，HEAD195f81dd30ca8865d440bafa32c7397006a436ef，父401 b8ce3ce92745a11b039e1335e87bbb2dd783c2c7，一个文件，干净未永久装。正常核心388520B/SHA31d203159178b413fd247aa240910558c566417ad424f5e4ab4f274cc069c5d2；W1/Werror诊断0，共享配置/outputs/symvers恢复。3450参数页/6040非法、85生命周期、19原FW/原HAL与当前C整512KiB CDM+32Bjob比较通过，均正确opcode1。

r2=/var/lib/samurai/k402-gamma-r2，worker15997/collector16092/client均终态，使用同一adapter114384B/SHA4bfbb80fcfefc50aa770b0c39c49f4c016093dda95da82c11e43144030fefe5a与同一client，只换修正核心。640x480 NV12/NV21各10模式20direct/starts-stops20/error0：generic20转换对全460800B等400；linearGamma仅100B差/最大1，zero全Y0UV128，constant512全128，half全Y/UV的2half-linear-zero仅-1/0/1。单通道G/B/R各8灰阶对已知CV系数最大Y误差1；首条保留原厂曲线8灰阶对原HAL量化LUT误差0。十模式格式归一化全等、主机CRC/输入/canary/seq/timestamp通过。厂曲线诊断不是当前场景触发插值，完整rounding/saturation/尺寸/Gamma故障复位未证明。

## 最后实际部署与状态

两次均临时加载/卸载，磁盘模块与四私有配置未改。第二次恢复正式core395/adapter393，r30四摄各12共48direct/starts-stops4/error0/extra0；CPU/IRQ/PM/backing/maps/import释放，ICP/CAMSS/双CCI suspended，17clks0、9railsdisabled/users0、taint0。PW16240/WP16247各一uid10000，owner_refs53桌面句柄；无test_cc_mode/test_chain_mode/test_gamma_mode/dropACK，无新相关fault/dump/timeout/reboot。两次合计136direct分epoch：native20+正常48各两轮，首轮Gamma像素失败不可混成全通过。最终正常计数48。

正式core395 SHA68ab5b3d6626a51ae91dd13003aed8e199a58f3ba34c1fd24ebad7e16c688a88，adapter393 SHAff2bfa7a9439b2ef67087ff6f5db8c9d26e9a92596cd1f63b14c3a047111d4c1，CAMSS389 SHA24fcfa685d07eb8d0e1a0b8356d9ee005e5413faf29c1b384e8c79c364630288。Image363/release7.3.0-rc6-rmx1931-samurai-k363+、boot/静态DT389/logdump365、SGownerAPI、FW、r30/r25保持，模块781沿用差量依据无全扫。host402→401…394，guard=/var/lib/samurai/k394-recovered/boot-id-private.txt，原USBkey/knownhosts。395失ACK复位恢复及394失败reboot/206061Bramoops/回退副本保护。

## 实现契约与接续

typed Gamma3072B，base10/signeddelta10，先锁内CPU堆复制和校验，再coherent/MAP，线数据在同retained request，未知DMA整request保留，CPU副本所有出口释放，无新独立coherent BO。IQ6016/PAGE_ALIGN8192：2592empty/2624pre/2656post3项；2752CST/2808CC/2852CV/2896DMI36B/2944LUT3072B。generic20/Gamma12/skip255。旧job/frame/colour布局及free/reset/quiesce/stop保持。401IFE/IPE职责审查可复用：IFE已有CCM/64段Gamma参数路径，IPE用户空间目前仅图像队列；不冒称当前每配置开关已核。正式默认高级IQ仍旁路。

下一步原厂LTM完整enable/DMI/inverseGamma/typed参数和所有权，再完整IQ链；之后明确IFE传递函数/CCM位置与LTM输入，避免重复CCM/Gamma，接标准media request/libcamera和原厂触发插值。不得以固定test_gamma_mode作为产品API。350全Gamma、351CCM/LTM树、352inverseGamma数值工具可复用；继续验证实际本机ABI和sourceCmdType，不能再用未核实夹具枚举冒充原厂契约。

399/400转换证据继续：CC actualtype2/offsetsigned11；CSTQ10signed13/subtractsigned11/addclamp10；CSTIQ2092→5a60、CC2188→5e60、CV2200→6460。CV Parse原native顺序r/g/b/yoff/ap/am/bp/bm/cp/cm/dp/dm/kcr/kcb；packet低ap/bp/cp/dp高am/bm/cm/dm末cb/cr。400固定RGB域/offdiag/signedoffset成立但完整公式舍入未证，不能直接默认激活全厂矩阵。

363/REMAINING-CAMERA-SCOPE.md全部继续：第五2MP身份/mux、多模式、帧长/防频闪、连续AF/光学、几何/多摄同步；implicit异步fence、SSC/旋转未全面复验。source/build先root storage284.mounted_build挂原32GiB ext4，勿格式化重建；rootPython PYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。原厂FW/HAL/OEM/ASM/CDM/图像/个体表私存402与前序，公共mirror只本地提交、不push/PR、保护无关index。r2主机分析一度把400历史目录误替r2报FileNotFound，修路径后复用样本，无重复实机。
