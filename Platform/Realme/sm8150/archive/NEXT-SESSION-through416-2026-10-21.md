# 当前检查点：416（真实版本绑定/HDR域/完整TMC11执行通过；实机仍406）

先读WORKING-BOUNDARIES.md、reference/kernel416/README.md。完整多摄/骁龙ISP目标active。415归档archive/NEXT-SESSION-through415-2026-10-21.md。用户开灯上班，问完成时间；已答全scope粗估数周且可能更长，未承诺日期。后续优先可运行候选请求/实机闭环，不再扩展已通过TMC离线矩阵。

## 416新增与415纠正

真实ISPInput在IPE主函数SP+340，2cf504..2cf514 memset19928B、2d7a64传模块Execute。415错用SP240早256B，把2cfa9c管理器指针写入当作版本；actual为input2760 TuningManager，公共415README已更正，不再追全局版本表。真实binder2d6564..2d6590读node149a8+4 version，仅==1写请求1，否则保持初始化0；始终指向node149a8缓存到input3024。16版号/初值组合执行原指令核对。

HDR377120..3771b8：AEC槽0 time/gain/sens偏移0/8/12，槽1为24/32/36；2872/2876/2880为槽1/0的时间/增益/灵敏度比。time0==0或float分母abs<1e-9保持1。TMC11 module88←2872曝光时间比、92←2880灵敏度比，身份/域已证；Long/Short枚举名未假定。control2仍零，不是2876增益比。1002valid+4invalid，两架构20120B等；两target溢出结果拒绝，16memset/35588target指令。

execute-model实际call383728到RET非拼接片段，已有清零ADRC4236存储，原factory root/完整reserve；不测分配。execute-runner单进程组合415policy/414tree/413gen/415cache/416binding/LTMgate，对4物理14普通上下文各11步=154完整调用/72重算，两架构1316392B0差。原Execute17899720指令；math logf/expf/powf hostlibm非Bionic。两不可变合成hist，仅UID/enable副本和14次缺失属性为明确合成，根选择器复用412不重跑。

序列涵盖hist-only/force相等不换hist/锁缓存更新/解锁不重算/force用旧hist/缺属性/新UID关闭恢复/同UID翻enable不刷新/敏感度变化。12次module.version0但ADRC旧version1，IPE按对象头仍bind1；wire一致不是硬件有效性证明。整个IFE发布/整个IPE Execute未执行，Android实际metadata/产品request未接，fullTMC11产品/fullLTM/default仍false。

415原状态733+7/consumer1152+3/cache63+1两架构44400/18480/271360B等保持。policy仅UID变刷新，raw enable→3016，六floatabs→double<1e-9；禁用仍发布旧ADRC3024/清module104，双锁在缓存/版本更新后抑calc；metadata缺失只清enable/未知版留旧knees，v0拷32/v1拷40。此前ISPInput112标签也已纠正为node14938辅助基址+112=node149a8缓存头。LTM own10 gate rootenable1/useLtm1/requestversion0，否则copyupstreamLtm，无globalenable/version再gate，自身10分配/完整计算未跑。

## 下一步以候选请求和实机验收推进

先读405/406 typed LTM接口及固定诊断客户端、现有r30/r25分发/IPA路径，落实407..416数值接入候选request的状态/表生成接口；逐项确认非零调校真正需要的LA/mask/weights/scalars、352inverseGamma、IFE/IPE输入域/统计缺口，针对该缺口补，避免再重复TMC已通过用例。408raw124/140身份、state候选随完成提交/失败丢弃仍需解决。随后受控非零LTM/颜色/曝光实机、连续参数/资源恢复/标准media request-libcamera；不把离线通过写成实机完成。

reference/kernel363/REMAINING-CAMERA-SCOPE.md全目标保持：第五2MP/OV02A1B身份mux勿猜OV02A10、多模式/帧长/防频闪、自动与连续AF/光学、几何多摄同步，implicitfences/SSC/旋转未全复验。

## 414/413/412/411保留

414 actual三层383cdc..384048，2846+15两架构514980B等；68根198区全ctrl[0,0]且DRC/HDR各1段，forcedgain/HDR1/2/多层只夹具，qtechGW1未绑定不是第五相机。136动态chain/51gap/131LUT67072B等、5subunity拒绝，最终原HALpacker未跑。root136/DRC24/HDR40/AEC192、rootctrl68/72 core120/128，X23=SP64；完整细节见414。

413gen384048..38565c，31组覆盖198区156+12两架构1393056B等，154finite/2nonfinite拒绝；142LUT72704B等/12subunity拒绝。X24=module112编译Gamma257末1023，controlledGamma非运行证据；darkY=anchor2/ratio不clipanchor1，r1 26项251B失败已修；model-r1 X23错/r2漏X24保留。nohist是BYTE1不是float1；hist4轮原地平滑左值已更新，coeff b按/h再/h。412模式树/411TMC10差异详其README；旧测试复用。

## 底层与设备

维护内核406 samurai-ipe-full-pass-ip406 b4f382affa9a8be089ccec6170c34d74005103ce干净未永久装；407-416仅用户空间数值，SoC/板级DT/主线/传感器/DMA/请求/default不改，phone/新worker/新帧0。原厂源码/系数/表/ASM/XML/产物/日志图像密钥私存/mnt/e/edk2-samurai-out/kernel416及前序，公共mirror仅本地提交不push/PR，保护无关index。

408Face首指针124float，BPS10003或raw140==1跳state，勿猜HDR/flash；signal>0切换重置90次计算非帧，previous+(current-previous)*.05独立float；strength→smoothing→保存proposed历史→atten→quant，ADRC后，history勿存atten后，仍需requestcommit。409 scale3/curve4顺序平滑更新左值；407signed delta<0或>=32768置bit11，漏大正delta698B已修。

406 stripe416=explicitIP→reg5c60bit10，勿恢复原HAL DC&&IP&&quarter>=72×54 gate到当前单fullframeAPI；IP&&mask324step/6halo/crop±2else328/4，outputcrop保持。正确private406/core-intree-r1.ko415720B SHA b0fbf678b045aa52f9db1eb54b6bfecce6fa5c10c76bb1dadbea5329d4dd28b4，test-intree旧405。406R2 fixed52=44LTM+8Gamma 640/650×480 NV12/21，mask移位修，LA灰块非彩色全图常量，LTM+linearGamma最大差1；两轮200仅transport。20269/20313及21352/21413/clients终态。恢复正式395/393/CAMSS389，r30/r25四摄48/error-cancel-extra0，资源释放/双CCI等休眠/17clks0/9railsdisabled-users0/taint0，PW21581/WP21584 uid10000单例/owner_refs53桌面句柄。407-416未访问不作新健康声明。

host406→…394同boot394，guard=/var/lib/samurai/k394-recovered/boot-id-private.txt；保护394丢ACK重启/206061Bramoops和395reset2us/readback/双IPE freshACK后退役修复。未知事务先查；Image363/DT389/logdump365/SGownerFW不改。405typed2800锁内copy/check后MAP，IQ8944/pre32/post96/type1-opcode1-reg5c08/13LUT2736，未知DMA整parcel保留。source/build先root storage284 mounted_build()挂原32GiB ext4勿格式化；rootPYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。保护NV/OTP/个体备份/密钥/电池温控。
