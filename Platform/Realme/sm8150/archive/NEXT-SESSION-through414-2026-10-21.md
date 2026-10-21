# 当前检查点：414（TMC11三层插值及动态数值链通过；实机仍406）

先读WORKING-BOUNDARIES.md、reference/kernel414/README.md。完整多摄/骁龙ISP目标active，413归档archive/NEXT-SESSION-through413-2026-10-21.md。用户已开灯出门，后续拍摄按实际照明/曝光解释。

## 414新增

kernel414/libipa/tmc11_tree按实际HAL前缀383cdc..384048恢复DRC→HDR→AEC选区及AEC→HDR→DRC回填。搜索4ac150/4ac498/4ac908、44字段回调4ab450均执行原指令，只有memset提供器。root136B、DRC24B、HDR40B、AEC192B=trigger16+region176；root controls68/72、core count120/ptr128。module+64root,+72DRC,+80gain,+84lux,+88/+92HDR输入，X23=SP+64。HDR0读88/1读92/2实际触发零并选第三组区间；88/92上游身份未证，勿套新版第三HDR浮点输入。

2846valid(2524原厂触发+322合成多层)+15invalid，hostASanUBSan/ARM SDKQEMU各514980B零差；2847529原指令。20区间容量、重叠/firstmatch、相邻float边界、三层双子节点、整数小数拆分1e6独立舍入均核对。所有68根控制[0,0]且DRC/HDR各一段，强制gain/HDR1/2及多层树仅数值夹具。关闭根不启用，qtechGW1未绑定物理模式不是第五相机。

动态chain68根各2状态=136，51实际gap插值；portable tree实际输出接413生成/412采样/409ADRC/sourcepacker/native typed LUT。每架构全生成1127712B零差，131有效LUT67072B一致，5finite firstGain<1024按409契约拒绝不夹unity。原厂gen33599012/sample1508536/adrc1254515指令，logf/expf/powf用hostlibm非Bionic；最终原HALpacker未跑。分进程串接非产品生命周期，合成统计非现场，其他IQ/LUT填零，phone0。

## 下一步

先实际版本metadata：私有412/version-near-0x2e014c-private.asm、原HAL2dffe4附近。ISPInput+112为16Bmetadata、+116version，0/1不同布局，未知版有诊断；未观察Android实际版，不可从TMC10/11 enable推断。补HDR88/92及408raw124/140上游身份、候选state随请求提交。再LA/mask/weights/scalars、352inverseGamma、IFE/IPE输入域/统计粗级、非零全调校实像素/连续参数/恢复/标准media request-libcamera。TMC11完整运行版及fullLTMnumeric/product/default仍false。

reference/kernel363/REMAINING-CAMERA-SCOPE.md完整范围保持：第五2MP/OV02A1B身份mux(勿猜OV02A10)、多模式/帧长/防频闪、连续AF/光学、几何/多摄同步，implicitfences/SSC/旋转未全复验。

## 413/412/411保留

413 actual gen384048..38565c：198区去重31组，156+12invalid两架构1393056B全等，154finite/2nonfinite原子拒绝；142chain72704B0差、12finite subunity拒绝。native module+76dark,+96hist/+104ADRC,+112Gamma257；X24=module+112。defaultGamma38396c..383a28从0/FF写同编译表末1023，controlledGamma不代表运行会用。logweights/db39c、gamma/d5fe8私存。

darkY=anchor2/ratio，不clipanchor1，generation-r1 26项251B差已修；model-r1 X23错/model-r2漏X24失败保留。nohist contrast是memset BYTE1=01010101非float1，区别allzero histogram。hist clip/零箱抑峰/重分配后4轮原地平滑，右后左且左已更新，勿双buffer。coeff b按/h再/h勿h²。

412原厂68根198区全字段XML等，4物理14普通上下文28查询与GetModule相符，全model2/order5；Bezier未验。主/广TMC10/11on、前两版off、长焦10off/11on仍不能推运行版。PCHIP normalize前64(eq+1)/4095、只clip63/64固定1；gain0=gain1、mix clamp(2-y1/x1)，下界<=1，勿stdclamp倒置bounds；contrast总读hist/推进hi/Q10clip8191。

411 TMC10按本机logf/float商、仅1e-9unity，无公开源coarse0.0001；AEC11字段全核对，actual input gain16/lux20/outX16/Y32。409/411/412旧全量测试无代码变更复用。

## 底层与设备

维护内核406 samurai-ipe-full-pass-ip406 b4f382affa9a8be089ccec6170c34d74005103ce干净未永久装；407-414只用户空间数值，SoC/板级DT/主线/传感器/DMA/请求/default不改，手机/新worker/新帧0。原厂源码/系数/表/ASM/XML/产物/日志图像密钥私存/mnt/e/edk2-samurai-out/kernel414及前序，公共mirror仅本地提交不push/PR，保护无关index。

408 Face信号首指针+124float，BPS10003或raw140==1跳过state；勿猜HDR/flash。signal>0切换重置90次计算非相机帧，previous+(current-previous)*.05独立float，strength→smoothing→保存proposed历史→atten→quant，ADRC后；history勿存atten后，仍需请求commit。409 scale3/curve4顺序平滑更新左值；407signed delta<0或>=32768置bit11，漏大正delta698B失败已修。

406 stripe416=explicit image_processing→reg5c60bit10，勿恢复原HAL DC&&IP&&quarter>=72×54 gate到当前单fullframeAPI；IP&&mask324step/6halo/crop±2else328/4，outputcrop保持。正确private406/core-intree-r1.ko415720B SHA b0fbf678b045aa52f9db1eb54b6bfecce6fa5c10c76bb1dadbea5329d4dd28b4，test-intree仍旧405。

最后406R2 fixed52=44LTM+8Gamma，640/650×480 NV12/21，mask移位已修，LA灰块非全彩常量，LTM+linearGamma最大差1；两轮200仅transport非全像素通过。20269/20313及21352/21413/clients终态。恢复正式core395/adapter393/CAMSS389，r30/r25四摄各12共48/error-cancel-extra0，资源释放、ICP/CAMSS/双CCI休眠、17clks0/9railsdisabled-users0/taint0，PW21581/WP21584 uid10000单例/owner_refs53桌面句柄。407-414未访问不作新健康声明。

host406→…394同boot394，guard=/var/lib/samurai/k394-recovered/boot-id-private.txt；保护394丢ACK重启/206061Bramoops，395reset脉冲2us/readback/双IPE freshACK后退役修复。未知事务先查不重启；Image363/DT389/logdump365/SGownerFW保持。405typed2800锁内copy/check后MAP，IQ8944/pre32/post96/type1-opcode1-reg5c08/13LUT2736；未知DMA整parcel保留。

source/build先root reference/kernel284/storage.py mounted_build()挂原32GiB ext4，勿格式化重建；rootPYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。保护NV/OTP/个体备份/密钥/电池温控。
