# 当前检查点：410（TMC10采样与ADRC数值链路；实机仍406）

先读WORKING-BOUNDARIES.md、reference/kernel410/README.md及409/408/406证据。完整多摄/骁龙ISP目标active。409归档archive/NEXT-SESSION-through409-2026-10-21.md。用户已开灯出门，现场按实际光照/曝光解释。

## 410新增与证据边界

五份原厂供应商调校TMC10共5根18区，BIN控制/保留字段/全部AEC区域与原厂ParameterParser XML全等。qtech/sunny GW1各5区、前摄IMX471/长焦S5K3M5各3区、IMX319两区。前摄/长焦TMC10原关闭，未启用；同时有TMC11，不能推断实际版本。qtech GW1未绑定当前物理模式，仅数值夹具；五份供应商文件不是第五物理摄像头。

kernel410/libipa/tmc10计算4膝点/6系数、LTM/GTM百分比、65点GainQ10及mix。膝点/百分比仅固定CamxChi源码对照，未执行本机膝点生成！原HAL sampler3c6328是64段特化，Qfactor10在W5；mix3626f8..36273c。1301项=18区x10gainx6dark1080+200synthetic+21edge，另33invalid；1298目标采样1391456指令/84370powf provider（hostlibm非Bionic），有限输出/mix零差。hostASanUBSan与ARM SDKQEMU各453560B零差，fp-contractfast。41退化非有限采样拒绝，3零归一化端点拒绝（即使rate0原函数得有限unity）。原始oracle与API有效域映射分存。

model-r1误查源BOOL返回：目标特化不写W0/调用者不用，改检查STOP/输出/保护区；原指令不改。tmc-r1两架构各261B差仅零端点/rate0有效域映射，原始输出仍保留，不冒充数值通过。

chain1301中1254成功/47拒绝；其中2项有限首gain<1024因下游契约拒绝，不夹值。TMC source膝点+目标核对采样/mix，接409实际HAL ADRC转换混合12323438指令/memcpy1254，源packer，再host/ARM及现有native typed LUT共642048B零差。关闭根未激活/其余IQ和LUT填0，仅数值链路，不是全原厂流水线/硬件；最终HAL LUTpacker仍未执行。

## 底层与接续

维护内核406 samurai-ipe-full-pass-ip406 HEAD b4f382affa9a8be089ccec6170c34d74005103ce干净未永久装；410仅用户空间数值层，板级DT/传感器/主线/DMA/请求/default不改。407-410手机0、新worker/帧0，不重复406。公共mirror本地提交不push/PR，保护无关index；原厂/source/系数/ASM/XML/程序/log/图像/密钥私存/mnt/e/edk2-samurai-out/kernel410及前序。

下一步实际TMC10/11选择、本机膝点生成、DRC/HDR/AEC动态插值；LA/mask/weights/scalars和352inverseGamma，IFE/IPE输入域/统计粗级、408raw124/140身份与候选状态提交；再非零调校实像素/连续参数/恢复及标准media request/libcamera。完整ADRC/LTM仍false。reference/kernel363/REMAINING-CAMERA-SCOPE.md全部范围继续：第五2MP/OV02A1B身份/mux（勿猜OV02A10）、多模式/帧长防频闪、连续AF/光学、几何多摄同步，implicitfences/SSC/旋转未全面复验。

## 409/408/407保留

409 sampledGain/equivalent12/forwardGamma10各65->ADRC scale/curve->mix->LUT；2783valid40invalid target/source/host/ARM2591514B零差，gain/mix当时合成。插值整数/小数拆分放大1e6/double分别舍入，不能普通lerp/FMA；后缀max与顺序3scale/4curve平滑使用已更新左邻；mix>0curve比例3else1，curve round/scale max后truncate。2935pack/native LUT1502720B全等。407signed scale delta<0或>=32768都置bit11，旧漏大正差首轮698B失败保留已修；LCE独立clamp/mask。旧4076630与4083978两架构保持。

408Face smoothing signal原input首指针+124float，BPSparent10003或raw140==1跳过且state不动，字段标签未全定位勿猜HDR/flash。signal>0状态切换重置90次计算更新，非相机90帧；previous+(current-previous)*.05，count0直接新值。strength->smoothing->save proposed history->attenuation->quant，ADRC后；history不能存atten后。API输入/输出/next不alias，候选state需请求生命周期提交。3931valid47invalid原HAL/host/ARM全等，长短Unicorn TB越界误入日志首轮失败保留，stop_pc hook修正无原指令改动。407曲线强度/曝光衰减细节与source/HAL精度边界见原证据。

## 406最后物理设备与恢复保护

stripe416驱动reg5c60bit10 IP_EN。原HAL DC&&IP&&quarter策略直接用于当前单fullframe显式API，DC0/IP1硬件IP关但mask crop扩2，R1移位2px/LA无效。406设416=explicit image_processing，勿恢复DC-quarter gate，不据此判断原multipass有错。IP&&mask324step/6halo/处理扩2，else328/4，outputcrop保持；32native/FW checks只IPbit可变，小128/282仅离线。正确private406/core-intree-r1.ko415720B SHA b0fbf678b045aa52f9db1eb54b6bfecce6fa5c10c76bb1dadbea5329d4dd28b4；test-intree仍旧405415752/ec8bf38d…勿混。

406R1 worker20269/collector20313终态，52transport+48restore但像素失败保留；R2 worker21352/collector21413/clients终态，同adapter/client换core，52fixed=44LTM+8combinedGamma，640/650x480 NV12/21 p8c2/13模式。IP/mask/linearRGamma/DC+IP全图转换零差/位移消失；LAzero/RGammazero/Gammazero Y0UV128；LA2048/1024灰块128/64零差，非彩色全图常量。LTM+linearGamma最大差1；NV12/21归一化全等。两轮200仅transport非全像素通过；最后normal epoch48。

最后406正式core395/adapter393/CAMSS389，r30/r25四摄IMX471/IMX319/S5K3M5/GW1各12=48direct，error/cancel/extra0，CPU/IRQ/PM/maps/import释放、ICP/CAMSS/双CCI suspended、17clks0/9railsdisabled-users0/taint0。PW21581/WP21584 uid10000单例，owner_refs53桌面句柄；无test参数/dump/timeout/新增fault/reboot/flash。407-410未访问，不作新健康声明。

host406→405…394，guard=/var/lib/samurai/k394-recovered/boot-id-private.txt，同boot394。保护394丢ACK失败reboot/206061Bramoops、395reset assert2us/deassert/readback/双IPE freshACK后退役修复；未知状态先查不重启旧事务。Image363 release7.3.0-rc6-rmx1931-samurai-k363+，DT389/logdump365/SGownerFW不变。405typed2800锁内copy/check再MAP，IQ8944/pre32/post96/type1-opcode1-reg5c08/13LUT2736，同request/未知DMA整parcel保留。

访问source/build先root reference/kernel284/storage.py mounted_build()挂原32GiB ext4，勿格式化重建；rootPYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。保护NV/OTP/工厂个体备份/密钥与电池温控。
