# 当前检查点：413（本机TMC11直方图/膝点生成通过；实机仍406）

先读WORKING-BOUNDARIES.md、reference/kernel413/README.md及412/411/408/406证据。完整多摄/骁龙ISP目标active。412归档archive/NEXT-SESSION-through412-2026-10-21.md。用户开灯出门，样本按实际光照解释。

## 413新增与下一步入口

kernel413/libipa/tmc11_generation生成176B区域的实际TMC11直方图预处理、膝点/9coef、百分比和1024点对比度。原HAL片段384048..38565c，非完整Execute/触发插值。native module+64root,+72DRC/+76dark,+96hist指针/+104ADRC指针,+112Gamma257；X23=SP+64区域基址，X24=module+112 Gamma，漏设两者的model-r1/r2失败保留。SWTMC11 Execute入口383728，插值前缀383cdc..384048可继续核对；root的controls68/72及core120附近需按实际ABI验证，勿凭新版header猜字段。

原厂198区精确去重31组，4统计状态124项+32Gamma/增益/退化=156，另12invalid。154有限/2非有限生成，target/hostASanUBSan/ARM SDKQEMU各1393056B零差；完整processedHist/knees/coeff/percent/HE均核对，fp-contractfast。数学provider为hostlibm非Bionic。统计合成非现场。2纯hist退化结果原子拒绝，不能转成默认表下发。

本机有限darkY=anchors[2]/ratio，不按anchors[1]裁剪；Clamp下界是商自身，固定源helper不同。generation-r1 26项各251B差保留已修，目标记录复用。

gamma-default直接执行38396c..383a28，从全0/FF模块内存均写同257点编译默认Gamma、末1023；原表私存。数值接口Gamma显式，controlled替代Gamma不代表模块运行会用它。nohist与allzero hist不同：nohist原HAL memset字节1，非float unity，必须保留语义，不能当正常统计曲线。预处理clip/第0箱抑峰/裁剪量重分配后4轮原地平滑，右邻后左邻，左值已更新；勿双缓冲。

chain156中142有效/2生成nonfinite拒绝/12finite firstGain<1024按409契约拒绝不夹unity。目标generated histogram/knee/HE->412实际normalize/PCHIP/contrast->409实际ADRC->sourcepacker/native typed LUT72704B全等；其余IQ/LUT填0、原HAL最终packer未执行，无硬件提交。

接续本机DRC/HDR/AEC三层插值、实际版本metadata；LA/mask/weights/scalars、352inverseGamma，IFE/IPE域/统计粗级、408raw124/140身份与请求候选state提交；再非零调校实像素/连续参数/恢复/media request-libcamera。完整LTM/ADRC仍false。reference/kernel363/REMAINING-CAMERA-SCOPE.md完整范围：第五2MP/OV02A1B身份mux勿猜OV02A10、多模式/帧长防频闪、连续AF/光学、几何多摄同步，implicitfences/SSC/旋转未全复验。

## 412/411保留

412原厂68根198区XML全等，4物理14普通上下文28queries与GetModule一致，全model2/order5；Bezier未验证。主/广两版on、前两版off、长焦TMC10off/TMC11on，不代表最终运行版。qtechGW1未绑定物理模式，五文件非第五相机；普通context无Feature/Scene/Effect，关闭根保持。

412 normalize前64(eq+1)/4095，只clip63/64固定1；PCHIP gain[0]=gain[1]、mix clamp(2-y1/x1,0,1)，TMC10无+1且用darkGain勿混。contrast始终读hist/推进hi/Q10 clip0..8191，PCHIP下界<=1，勿std::clamp倒置bounds；源码差异及旧1192用例见412，source膝点/合成HE已由413实际生成补上。

411已修共享410 TMC10：logf/float商、只1e-9unity，无公开源coarse0.0001。AEC11字段/indices/ratio全HAL核对，区内copy/gap插值、double ratio、整数/小数拆分1e6舍入、原序firstmatch。实际input+16gain/+20lux、out+16X/+32Y，首轮ABI/旧LUT差异保留，详见411。

## 底层/状态规则

维护内核406 samurai-ipe-full-pass-ip406 b4f382affa9a8be089ccec6170c34d74005103ce干净未永久装。413只用户空间数值，SoC/板级DT/主线/传感器/DMA/请求/default不改。407-413手机/新worker/新帧0，不重计406。原厂源码/系数/表/Gamma/logweights/ASM/XML/程序/日志图像密钥私存/mnt/e/edk2-samurai-out/kernel413及前序；公共mirror仅本地提交不push/PR，保护无关index。

409后缀max/顺序3scale和4curve平滑用更新左邻，mix>0curveRatio3else1，curve round/scale max后truncate；407signed scale delta<0或>=32768置bit11，首轮漏大正delta698B保留已修，LCE独立clamp/mask，旧4076630/4083978保持。408Face信号input首指针+124float，BPS10003或raw140==1跳过state不动，标签未全定位勿猜HDR/flash。signal>0切换重置90次计算更新非相机帧，previous+(current-previous)*.05；strength->smoothing->save proposed history->attenuation->quant，ADRC后。history勿存atten后，state不alias且需请求生命周期提交。Unicorn TB长短越界首轮保留，stop_pc hook修正无原指令改变。

406 stripe416=explicit image_processing驱动reg5c60bit10，勿恢复原HAL DC&&IP&&quarter gate到当前单fullframeAPI，不据此判原multipass有错。IP&&mask324step/6halo/处理扩2 else328/4，outputcrop保持；R1移位2px/LA无效失败保留，32native/FW仅IPbit变，小128/282仅离线。正确private406/core-intree-r1.ko415720B SHA b0fbf678b045aa52f9db1eb54b6bfecce6fa5c10c76bb1dadbea5329d4dd28b4；test-intree旧405415752/ec8bf38d…勿混。

最后406R2 fixed52=44LTM+8Gamma，640/650x480 NV12/21 p8c2/13模式，mask移位消失，LA灰块验证非彩色全图常量，LTM+linearGamma最大差1；像素范围详406。R1/R2两轮200仅transport非全像素通过；worker20269/20313及21352/21413/clients终态。恢复正式core395/adapter393/CAMSS389，r30/r25四摄各12=48direct/error/cancel/extra0，资源释放、ICP/CAMSS/双CCI suspended、17clks0/9railsdisabled-users0/taint0，PW21581/WP21584 uid10000单例/owner_refs53桌面句柄，无test参数/dump/timeout/新增fault/reboot/flash；407-413未访问不作新健康声明。

host406→405…394同boot394，guard=/var/lib/samurai/k394-recovered/boot-id-private.txt；保护394丢ACK失败reboot/206061Bramoops、395reset assert2us/deassert/readback/双IPE freshACK后退役修复，未知状态先查不重启旧事务。Image363 release7.3.0-rc6-rmx1931-samurai-k363+、DT389/logdump365/SGownerFW不变。405typed2800锁内copy/check再MAP，IQ8944/pre32/post96/type1-opcode1-reg5c08/13LUT2736，同request/未知DMA整parcel保留。

source/build先root reference/kernel284/storage.py mounted_build()挂原32GiB ext4，勿格式化重建；rootPYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。保护NV/OTP/个体备份/密钥/电池温控。
