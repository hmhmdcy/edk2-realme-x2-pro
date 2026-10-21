# 当前检查点：411（本机TMC10膝点修正与AEC插值；实机仍406）

先读WORKING-BOUNDARIES.md、reference/kernel411/README.md及410/409/408/406证据。完整多摄/骁龙ISP目标active。410归档archive/NEXT-SESSION-through410-2026-10-21.md。用户已开灯出门，现场按实际光照/曝光解释。

## 411本机差异与新插值

原HAL TMC10完整入口3774b0，膝点段377a08..377d50；实际logf/float商后取整，只有1e-9 unity比较，无固定源码额外0.0001扩张。修正共享kernel410/libipa/tmc10.cpp，旧410报告/哈希描述修正前源码，不冒称当前目标。prior-source-r1保留1301中100curve/70gain不同12421B；最终58LUT改变4044B。knee2643=原1301+95半索引x7邻floatx普通/暗部1330+12unity，另33invalid；target/hostASanUBSan/ARM SDKQEMU各909840B零差，fp-contractfast。2640finite knees/2598sample success，3371838目标指令，logf7929/powf176886为hostlibm非Bionic。sampler3c6328是64段65点/Q10，W5=10；mix3626f8..36273c保持。41退化非有限/零归一化端点等仍原子拒绝。

kernel411/libipa/tmc10_aec新增全部11字段与选区indices/ratio，区内copy、区间gap插值，double差求ratio再float，字段整数/小数拆分放大1e6分别舍入，勿普通lerp/FMA。factory5根均lux控制；未使用realGain轴重叠默认区按原序firstmatch，不排序改写。837=687factory触发扫点+150synthetic树，另11invalid，完整HAL函数及采样1329895指令，两架构各339200B零差，输入不变/失败输出保持。237项关闭根只数值检查；强制gain控制仅夹具。只TMC10 AEC，不是TMC11 DRC/HDR/AEC树或全部LTM13触发树。

model-r1最初kneeX/Y读反（实际out+16 X/+32 Y）；aec-r1最初inputrealGain/lux写反（实际+16gain/+20lux），两架构各108196B差，修夹具未改原指令/数学；原始参考/输出私存，失败报告保留。最初inspect.py影子标准库已改inspect-tmc.py。原HAL不修改。

chain2643中2596成功/47拒绝含2有限firstGain<1024不夹值。实际ADRC25612307指令/provider memcpy2596，sourcepacker、host/ARM、维护树native typed LUT1329152B零差。其余IQ/LUT填0，非完整原厂流水线/硬件；原HAL最终packer未执行。

## 原厂数据与当前层级

410五供应商TMC10根18区BIN全部字段与OEM ParameterParser XML全等；qtech/sunny GW1各5区、IMX471/S5K3M5各3、IMX319两区，前摄/长焦TMC10原关闭保持。qtech GW1未绑定物理模式只数值夹具，5文件非第五摄像头。原厂有TMC11，固定仓库SWTMC11关闭回退TMC10，但本机实际版本配置/模式选择未证，勿以文件存在推断。

维护内核406 samurai-ipe-full-pass-ip406 HEAD b4f382affa9a8be089ccec6170c34d74005103ce干净未永久装；411只用户空间数值，不改SoC/板级DT/传感器/主线/DMA/请求/default。407-411手机访问/worker/新帧0，不重复406。公共mirror本地提交不push/PR，保留无关index；原厂/source/系数/ASM/XML/程序/log/图像/密钥私存/mnt/e/edk2-samurai-out/kernel411及前序。

下一步实际TMC10/11选择及TMC11 DRC/HDR/AEC插值，LA/mask/weights/scalars、352inverseGamma，IFE/IPE输入域/统计粗级、408raw124/140与请求候选state提交；再非零调校实像素/连续参数/恢复/media request-libcamera。完整ADRC/LTM仍false。reference/kernel363/REMAINING-CAMERA-SCOPE.md完整范围：第五2MP/OV02A1B身份/mux勿猜OV02A10、多模式/帧长防频闪、连续AF/光学、几何多摄同步，implicitfences/SSC/旋转未全面复验。

## 409/408/407规则

409已采样ADRC转换/混合2783valid40invalid零差；后缀max与顺序3scale/4curve平滑用更新左邻，mix>0curveRatio3else1，curve round/scale max后truncate。407 signed scale delta<0或>=32768都置bit11；首轮漏大正delta698B保留已修，LCE独立clamp/mask，旧4076630/4083978两架构保持。typed2935LUT1502720B全等属历史数值证据。

408Face信号input首指针+124float，BPS10003或raw140==1跳过且state不动，标签未全定位勿猜HDR/flash。signal>0切换重置90次计算更新非90相机帧；previous+(current-previous)*.05，count0新值。strength->smoothing->save proposed history->attenuation->quant，ADRC后；history勿存atten后，state不alias且需请求生命周期提交。3931valid47invalid原HAL/host/ARM全等，长短Unicorn TB越界首轮失败保留，stop_pc hook修正原指令未改。

## 406最后物理设备与保护

stripe416驱动reg5c60bit10 IP_EN。原HAL DC&&IP&&quarter移至单fullframe显式API，DC0/IP1硬件IP关但mask扩2，R1移位2px/LA无效。406改416=explicit image_processing勿恢复DCquarter，不据此判原multipass有错。IP&&mask324step/6halo/处理扩2 else328/4，outputcrop保持，32native/FW仅IPbit变，小128/282仅离线。正确private406/core-intree-r1.ko415720B SHA b0fbf678b045aa52f9db1eb54b6bfecce6fa5c10c76bb1dadbea5329d4dd28b4；test-intree仍旧405415752/ec8bf38d…勿混。

406R1 worker20269/collector20313终态，52transport+48restore但像素失败；R2 worker21352/collector21413/clients终态，52fixed44LTM+8Gamma，640/650x480 NV12/21 p8c2/13模式。IP/mask/linearRGamma/DC+IP全图转换零差/位移消失；LAzero/RGammazero/Gammazero Y0UV128；LA2048/1024灰块128/64零差非彩色全图常量，LTM+linearGamma最大差1，NV12/21归一化全等。两轮200仅transport非全像素通过，最后normal48。

最后406正式core395/adapter393/CAMSS389，r30/r25四摄各12=48direct error/cancel/extra0；CPU/IRQ/PM/maps/import释放、ICP/CAMSS/双CCI suspended、17clks0/9railsdisabled-users0/taint0，PW21581/WP21584 uid10000单例/owner_refs53桌面句柄；无test参数/dump/timeout/新增fault/reboot/flash。407-411未访问，不作新健康声明。host406→405…394，同boot394，guard=/var/lib/samurai/k394-recovered/boot-id-private.txt。保护394丢ACK失败reboot/206061Bramoops、395reset assert2us/deassert/readback/双IPE freshACK后退役修复；未知状态先查不重启旧事务。Image363 release7.3.0-rc6-rmx1931-samurai-k363+、DT389/logdump365/SGownerFW不变。405typed2800锁内copy/check再MAP，IQ8944/pre32/post96/type1-opcode1-reg5c08/13LUT2736，同request/未知DMA整parcel保留。

访问source/build先root reference/kernel284/storage.py mounted_build()挂原32GiB ext4，勿格式化重建；rootPYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。保护NV/OTP/个体备份/密钥及电池温控。
