# 当前检查点：431（原厂 bank 策略确认；生产 IPA 同帧 PD10 自动双遍 48 帧通过）

完整多摄／ISP目标未完成。先读 WORKING-BOUNDARIES 与 reference/kernel431/README.md。429硬件重启与正式四摄48帧恢复保留；430已解决丢DC和重复性，431接生产自动双遍。GTM生效版本/history、片内平均表字节读出、画质/其它模式仍未完。

## 当前设备与候选

431 r4终态passed，普通／隔离IPA各24主摄scene，48direct双遍+48数学提交；另4个旁路/DC会话转换，jobs=completed=direct52，failed/cancel/first_error0。正式模块/服务/媒体图/资源已恢复，无新fault，taint0，worker/client死。当前仍正式420 r31/r26、419 core/adapter、Image363/DT389，无永久安装、刷写或NV/OTP/persist访问。正式模块重载计数0，PW/WP枚举owner_refs53正常，非DMA泄漏。

host431沿用429新guard与原SSH key/known_hosts；prepare-runtime动态正式notes/taint/jobs基线。所有本地build/exec和远端worker终态。此前自加MMIO越界Oops在429/INCIDENT保留，危险429build2 core da4591...禁止加载，当前未加任何MMIO读取。

维护kernel source354 HEAD52127e558704de6a640d076ef605182fe6fff0d7，branch samurai-ipe-request-coarse431，parent430 d4ac27ac。只改m2m23增9减：use_coarse来自已校验当前params的LTM/DC；ensure_session匹配单/双遍，模式改变先用原destroy保护再create/configure，第三平面仅在需要DC时导入；VB2一直持有两个提交平面。core/板级DT/传感器/电源/UAPI/6008B/不确定DMA保留策略未变。

intree build1十匹配模块W1/Werror零诊断，m2m141624B e6828a0ca8069181f3f7f9818fdfe888d141c140d0ea753f52af2de00500dcb5；core d391fa...和CAMSS933bda...与430相同。共享build输出/config/symvers已恢复。session-validation执行实际ensure_session C，ASAN/UBSAN和ARM64 qemu七转换/失败保持用例通过。无需无故重建。

## 原厂平均值表策略

trace-banks/check-banks执行原firmware handle mapping/context store和最终LTM序列化，非默认夹具值推断。m2m RT type2→kind0→DC/IP bank0，非RT type3→kind1→bank1离线反例；本机HAL原位插入确认bit14/15。粗级DC1/IP0/sum-clear1，全尺寸DC0/IP1/sum-clear0，同bank。实际r4内核日志确认type2；仍无片内bank读回或平均值表逐字节导出。sum-clear是命令策略，不能称已读到所有SRAM单元为0。scratch46128仍不是已验统计导出。

保留430原厂DistributeJob/BLGenerator最终同步与program/heap/队列一致证据；当前paired用1核，DC→IP由固件控制，未加CPU bank切换。431同一开流旁路/DC/旁路/DC四请求成功，两个旁路/两个DC各相同，DC还等于430新主摄SOF5真实输入输出。初始化/转换行为稳定。

## 生产用户空间与实拍

候选/mnt/samurai-full282/libcamera431-pd10-auto/src/libcamera-v0.7.2，基424，9文件patch0046。IPA4私有SensorControlConfiguration增加pd10能力（proxy/core/module同版），按模式解析可选ife_ds4，上传零flags16B typed DS4 block，actual IPA bytes等于428原厂块。私有factory-s5kgw1只在4608x3456模式插入原厂426/428 sensorMode2 Preview coeff；另4608x2592模式未加。前摄TMC关保持。旧profile无能力不强启粗级。

pipeline链接/配置/分配内部DS4，在FULL前streamon；真实kernelSOF配对FULL640x480和PD10160x120 stride768/46080B。NV12两个逻辑Y/UV同FD连续offset和容量检查后合成FULL内存plane，再加PD10；两个FD及原SOF持有至双DQ+requestDONE，stop先join。single-pending数值串行在最终frameProcessed发送后派发下一图像；每张arrival判断250ms，sensorContexts有界保留至迟到统计，不放宽AE校验。

最终用户build7 libcamera SHA d03e076e8211026a3c663d217f73ab9998e91f81c57d109ca5e7af4ec0668a8f，IPA62505f0...、proxy3cb416...；IPA与build3后相同，actual IPA4 Werror合约+签名通过，缺lux/busy/失败/旧回执/停止重启历史复用并验证，数学/历史实现与424字节不变。source-validation两个patch零fuzz/offset，产物hash匹配。

r4普通24帧/24commit/23种参数摘要，隔离24/24/22；每次previous-ltm-lux等于上一成功提交lux。硬件审计匹配PD10_READY SOF、真实BHIST/lux/exposure/gain、6008B新包、实际请求成功及最终数值回执，图像实际Y均值/大小匹配元数据；无IMAGE_PAIR_TIMEOUT或AE拒绝。隔离多1份无应用图像的观测停止时abort，不提交数值。

r1/r2/r3失败保留私存：r1误将NV12两个逻辑视图当1plane，提交前本地拒绝，0commit；r2首帧成功/1commit，busy导致下一空旁路在旧paired session被拒；r3转换4job+13commit过，但旧global deadline提前处理新图并删曝光上下文，AE拒绝。均恢复正式环境/taint0。不得将它们写为整链通过。r4才通过完整本轮。

看过未调色NV12解码样本：场景可辨认，仍雾感/偏色，未画质验收、未重做AF/光学矩阵。原图/完整日志/系数/ASM均在private kernel431。

## GTM接续

inspect-gtm已定位本机IFEGTM10::Execute0x31fc00(2200B)和IQInterface::GTM10CalculateSetting0x37c818(10324B)，私存asm。四原厂文件GTM IFE/BPS45module roots，不把180内部目录项当roots。14普通IFE模式查询与原stock-selection-manager全部一致，私存*-gtm-directory/selections。尚未执行GTM数学、恢复typed参数块或应用到IFE。

下一步优先原厂GTM parse/tree/math→IFE参数/真实ACK生效版本→对应图像ADRC/LTM/history。GTM在IFE/BPS上游，不能用本图hist逆因果；原厂GTM份额非零不能清零伪完整。当前48次数学提交只覆盖已有TMC/LTM+真实PD10，绝不称GTM关联通过。其它四摄自动/尺寸/视频/第五2MP/个体光学/几何同步见363剩余清单。

WSL每次source/build/ext4先root storage284.mounted_build，原32GiB镜像不重建。Unicorn PYTHONPATH14。私件保密，公共仅自有代码/脱敏证据，scoped mirror保留无关index与3处工作树，不push。
