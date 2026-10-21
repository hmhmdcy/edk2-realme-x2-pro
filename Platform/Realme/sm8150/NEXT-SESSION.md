# 当前检查点：417（逐帧IQ真机通过）

读WORKING-BOUNDARIES.md、reference/kernel417/README.md。完整目标active。用户开灯上班，完整工期粗估数周且可能更长，不承诺日期。优先产品请求/实机，勿扩大已通过TMC矩阵。416归档archive/NEXT-SESSION-through416-2026-10-21.md。

## 417已完成

维护内核branch samurai-ipe-request-iq417，commit f0b6ea869e3e748e6c1ccfe06865ac8d02c3ef3a，parent406 b4f382affa9a8be089ccec6170c34d74005103ce，干净已提交未永久装。4文件改：adapter/colour.c/colour.h、新UAPI include/uapi/linux/qcom-ipe-a5.h。公共request-iq.patch和source-state含hash。core419848B SHA63131c5719526ca796955f4d833380a12c36c62557ccf539e85bd58c0f070632；adapter131888B SHA8fa34a55d07a47c7acadbb8f71b16062c96b7a4657e268744e7077538daf65f2，private417 intree-r3配对，不要用r2遗漏回调版。W1/Werror构建/28项ASanUBSan实际validator通过。

实验本地CID USER_BASE+1240非上游分配；compoundU8 packet6008固定宽度无指针/CDM。全零旁路，否则v1/size6008/knownflags/reserved/padding0；colour104/gamma3072/LTM2800。每request恰1 OUTPUT且显式params，CAPTURE普通入队；legacy nonrequest仍旁路。s_ctrl仅当前hardwareworker任务能向pending私有快照拷贝，直接设置EACCES；EXECUTE_ON_WRITE重复包生效；try_ctrl先校验，worker在图像import前setup/copy/check。req_complete/STREAMOFF/cancel回调齐；buf_out_validate ANY→NONE、拒绝隔行。核心405先copy/check再MAP、未知DMA整parcel/image引用保留不变。

r4两个context共16帧：NV12 640x480 MMAP；NV21 650x480 stride672导出DMABUF，sourceoffset16。各0/1/2/2/3/4/0/1=bypass/colour/zeroGamma/zeroGamma/LA2048/LA1024/bypass/colour；两个请求FD复用、提交后用户内存覆盖、完成读回原包一致。全部有效图像与406固定参考逐字节相同，GammaY0UV128，LA8灰块内部128/64；输入未改、尾部/seq/timestamp/控件完成通过。不能称整个彩色图恒定。无globalsysfs或诊断模块参数。libcamera/IPA仍未接新请求，formal高级IQ仍旁路。

失败保留：r1脚本查不存在/sys/class/media，改枚举/dev/media+模型；r2遗漏必需buf_out_validate，首次QBUF被拒产生vb2 WARN、无图像DMA，已修构建r3；r3把灰块内部结论扩至边缘断言失败，固件完成6次不计像素通过。r4无新增fault，但**taint512来自r2仍保留**，未清标记/未重启，不要要求0或误报新增fault。所有事务terminal worker/clients/collector均退。r1pid3323/r2pid3702/r3pid4160/r4pid4605；根/var/lib/samurai/k417-request-r1..r4，绝不盲重启事务。

## 设备与下步

最新417-r4恢复正式core395/adapter393/CAMSS389、r30/r25原配置/加载notes已核对。四摄各12应用帧=48，IPE49（前摄extra1，勿写48direct）。m2m49/49/49,error/cancel0,starts/stops4；资源释放、ICP/CAMSS双CCI suspended、17clk0、9railsdisabled/users0，PW4835/WP4838 uid10000单实例，owner_refs53桌面CAMSS句柄正常。guard394仍/var/lib/samurai/k394-recovered/boot-id-private.txt，taint512已知。Image363 release7.3.0-rc6-rmx1931-samurai-k363+、DT389/logdump365/SGownerFW不改。保护394丢ACK重启证据、395reset2us/readback/双IPE freshACK后退役修复。

下一步读已维护libcamera391-ipe-r30-built/src/libcamera-v0.7.2/src/libcamera/pipeline/camss-vfe/camss_ipe.{h,cpp}和包0040补丁，给CamssIpe及IPA接417 typed request，随OUTPUT关联、完成/取消正确回收；自动参数/history成功commit失败discard。再接407..416数值，针对LA/mask/weights/scalars/inverseGamma、IFE/IPE统计域缺口补证。当前仅合成固定诊断payload，不是完整原厂自动调校；新request带IQ的强制失ACK恢复还未测。

reference/kernel363/REMAINING-CAMERA-SCOPE.md全scope仍有效：第五2MP/OV02A1B身份共享mux勿猜OV02A10，多模式/帧长/防频闪、持续AF/光学、几何/多摄同步，implicitfences/SSC/旋转未全复验。SoC/板级DT/主线实验UAPI/驱动/用户空间分层描述，不用上层补丁掩盖底层问题。

## 407—416保留的关键约束

416纠正415：实际IPE ISPInput=SP340，SP240早256B，2cfa9c写actual2760 TuningManager不是版本。真实binder2d6564..2d6590仅cache(node149a8).version1才写请求1否则保初始0，始终绑定缓存ptr3024。HDRmodule88/92为AEC槽1/0时间/灵敏度比（槽0 t/g/s0/8/12，槽1 24/32/36），不是增益比；control2仍0。1002+4及16binder组合两架构20120B等。完整TMC11 Execute383728到RET 154调用/14context/4物理/72calc两架构1316392B等，12module0/旧property1差保留。合成stats/UID/缺失，不是Android元数据或硬件自动调校；详416。

415仅UID变刷新root，禁用仍发布旧ADRC，双锁在缓存/版本更新后抑calc；equalforce不换histptr；metadata缺失只清enable，未知版留旧knees，v0拷32/v1拷40。LTM own10 gate rootenable1/useLtm1/requestversion0，自身10分配完整计算未跑。414树2846+15两架构514980B等，68根198区全ctrl00且DRC/HDR各1段，多层/HDR其它仅夹具；qtechGW1未绑定非第五摄。

413 darkY=anchor2/ratio不clipanchor1；nohist BYTE1非float1；4轮原地平滑左更新，PCHIP b按/h再/h；X24 module112编译Gamma257末1023。413154finite/2nonfinite拒绝，142LUT72704B等/12subunity拒绝；411目标floatlog和fine-onlyunity bump，先前coarse .0001错。409scale3/curve4原地平滑，firstgain>=1024不硬夹unity；407 signed delta<0或>=32768置bit11。408raw124/140身份未解，90次计算更新非帧、.05各float、历史保存atten前、ADRC后，需requestcommit。完整数值表/ASM/原厂数据私存不可公共输出。

406 stripe416=explicitIP→reg5c60bit10，不恢复HAL DC&&IP&&quarter gate至当前fullframeAPI；IP&&mask step324/halo6/crop±2否则328/4。405IQ8944/pre32/post96/13LUT2736/type1op1reg5c08，typedLTM2800先copy/check后MAP，unknownDMA保留。

## 环境

每次WSL访问source/build/ext4先root调用reference/kernel284/storage.py mounted_build()挂原32GiB ext4，绝不重建格式化。source354/build在/mnt/samurai-full282。root PYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。原厂系数/夹具/二进制/图像日志私存/mnt/e/edk2-samurai-out/kernel417及前序，公共仅作者代码/脱敏报告。本地mirror仅scoped commit保护无关index，不push/PR。保护NV/OTP/个体备份/密钥/电池温控；未知事务先查状态。
