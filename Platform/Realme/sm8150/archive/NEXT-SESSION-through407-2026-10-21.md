# 当前检查点：407（LTM曲线与曝光衰减移植；实机仍为406）

先读WORKING-BOUNDARIES.md、reference/kernel407/README.md及406/README.md。完整多摄／骁龙ISP目标active。406交接归档archive/NEXT-SESSION-through406-2026-10-21.md。用户已开灯出门，现场样本按实际照明解释。

## 本轮407

新增reference/kernel407/libipa/ltm_curves.{h,cpp}，可移植用户空间自动/手动曲线、暗亮区域、LTM/LCE强度、曝光变化衰减、64段scale及两组16段LCE量化。输入已插值，不包含触发树/OEM时域块/ADRC/其余LA-mask-weights-scalars/完整CalculateHWSetting。浮点留用户空间，内核仅接类型化量化请求；尚未产品接入/安装。

五份原厂BIN全部149根2135区域，每区域3曝光条件6405项，加48manual边界与96auto，共6549。主机ASan/UBSan、现有AArch64 SDK/QEMU与私有固定源码参考量化零差；81非法计算+14非法编码保持输出，输入保持。actualHAL 35ec64..360560及360ac8..360c3c两片段运行6549项6587698指令，明确跳过中间OEM时域/自适应；外部powf12480次用hostlibm，不是targetBionic。99float对host/ARM全字节零差；源参考doublepow相对auto分支4float字节不同/最大6.1035e-5，量化不差。未执行原HAL最终LUT packer，此处将HAL浮点按源规则再量化核对。

首轮泛化sign规则错误：LTM scale显式强制负delta符号位，LCE仅掩码，超signed12bit负差值不能统一。208表字节失败保留curves-r1-validation.json及私有原输出；修正后全过。现有交叉g++缺失，复用原SDK而非安装工具链。check-kernel-luts.py编译与维护源相同的colour编码器，全部6549项转2800B typed请求，8944B IQ页scale/LCE共2514816B零差/3536非零项，未提交硬件/其余零表不代表完整配置。报告curves/float-comparison/kernel-luts-validation.json。

源码仍406 samurai-ipe-full-pass-ip406 HEAD b4f382affa9a8be089ccec6170c34d74005103ce，干净未永久安装，405typed所有权不变。407手机帧/worker/安装均0，不得把406恢复48重复计入407。公共mirror仅本地提交，保护无关index、不push/PR。原厂/表/ASM/图像/log/密钥都私存/mnt/e/edk2-samurai-out/kernel407及前序。

## 406必须保留的底层修正

stripe+416驱动reg5c60 bit10物理IP_EN。原HAL把它绑定DC&&IP&&有效quarter，当前显式单全帧DC0/IP1时硬件IP关而crop按IP+mask扩2，R1后续条带移位2px/LA无效。406直接416=image_processing；是原HAL多pass策略移植到单全帧API不适合，不判原完整流程有错。勿恢复DC/quarter gate。IP&&mask324step/6halo/处理扩2，否则328/4，输出crop等保持。

40632native/FW完整准备检查，至多只改5c60bit10，IP0与旁路全字节一致；128/282仅离线。W1/Werror0diag。修正核心private406/qcom-camss-icp-a5-core-intree-r1.ko 415720B SHA b0fbf678b045aa52f9db1eb54b6bfecce6fa5c10c76bb1dadbea5329d4dd28b4；test-intree旧核心仍405 ec8bf38d…勿误用。

R1 rootk406-ltm-r1/worker20269/collector20313终态，52transport+48恢复但像素失败保留；R2 rootk406-ltm-r2/worker21352/collector21413及client终态，换核心/同adapter client，52固定请求44LTM+8组合Gamma，640/650x480 NV12/21 p8/c2，13模式。IP/mask零scale和linearRGamma/DC+IP均对转换对全图零差、位移消失；LAzero/RGammazero/combinedGammazero全Y0UV128；LA2048/1024灰块分别128/64误差0，不是全彩色图常量。LTM+linearGamma最大差1；全部13模式NV12/21归一化全字节等。两轮200仅transport总数，不是全像素通过；最后正常epoch48。

## 最后实际设备证据406

正式core395/adapter393/CAMSS389恢复，r30/r25四摄IMX471/IMX319/S5K3M5/GW1各12共48direct,error/cancel/extra0。CPU/IRQ/PM/maps/import释放，ICP/CAMSS/双CCI suspended，17clks0/9railsdisabled-users0/taint0，PW21581/WP21584 uid10000单例，owner_refs53桌面句柄。无测试参数/dump/timeout/新增相关fault/重启/刷写。这是406观察，407未重新访问。

host406→405…394，guard=/var/lib/samurai/k394-recovered/boot-id-private.txt，同boot394。保留394丢ACK失败reboot/206061Bramoops和395 reset assert2us/deassert/readback及双IPE freshACK后释放修复。旧事务已终态，未知状态先查不重启。Image363 release7.3.0-rc6-rmx1931-samurai-k363+、静态DT389/logdump365/SGowner/FW不变。

## 下一步及契约

优先本机OEM时域/自适应块360560..360ac8与ADRC、DRC/HDR/AEC动态树、其余LA/mask/weights/scalars及352逆Gamma组合，明确IFE/IPE域、统计/粗级；后做非零scale/LCE实像素、连续参数/故障恢复及标准media request/libcamera。406固定诊断不是完整调校/DCstats/全部尺寸证明。

405LTM类型2800B，lock内copy/check再coherent/MAP，IQ/DMI/LUT同request，所有出口CPUcopy释放，未知DMA保留整parcel/images至quiescent。NULL回旧Gamma/colour。组合IQ8944/PAGE12288，arraybase2592/pre32最多CST20+LTM11/post96最多CC-CV20+Gamma12；旧Gamma6016/pre32/post64独立。CST2784 CC2840 CV2884，GammaDMI2928/LUT2976，LTMDMI6048/LUT6208。13LUT2736B/type1/opcode1/reg5c08/selectors1..13，resource3296额外560用途未知。原逆Gamma输入IFEgreen64，不可用IPE256。HAL ANR440==1或topology2624==3是上层策略不自动复刻。

363全部范围继续：第五2MP身份/mux、多模式、帧长防频闪、连续AF/光学、几何多摄同步，implicit fence/SSC/旋转未全面复验。source/build先root reference/kernel284/storage.py mounted_build()挂原32GiB ext4，勿格式化/重建。rootPYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。保护NV/OTP/个体备份及电池温控。
