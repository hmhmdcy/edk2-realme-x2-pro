# 当前检查点：435（主摄原厂GTM/TMC/LTM生产自动链路与成功历史实拍通过）

2026-10-22按用户要求清理主机：WSL 28处过期构建共86019个中间对象约9.5GiB，Windows uv缓存清理完成；C盘可用约11.8GiB，WSL根分区读写恢复，无需文件系统修复。源码、配置、最终镜像/模块、原厂数据、密钥和实拍证据保留。source354 HEAD9bc07e6仍tracked clean；435库/IPA/签名/proxy与build6记录hash一致。明细在私有E:/edk2-samurai-out/host-cleanup-20261022/verified-summary.json；少量旧运行时移到E:/expired-builds-quarantine-20261022。436尚未开始设备试验，后续仍先调用284 mounted_build。

完整多摄/ISP目标active。先读WORKING-BOUNDARIES、reference/kernel435/README。435主摄单曝光链路已实际接通：统计N→后续IFE GTM实际ACK/cookie→图像M+同SOF PD10→匹配immutable TMC/ADRC的IPE/LTM→最终成功math history。r3普通/隔离IPA5各24张，全48 IPE作业；各21次数学提交+3显式启动帧，合计42完整GTM/TMC/LTM双遍提交+6不冒算数学的bootstrap。正式环境恢复，无fault、taint0，未永久安装。**画质仍有明显雾感、偏绿、环状亮度分布，尚未验收；完整多摄范围未完成。**

## 当前源码/产物

用户候选 /mnt/samurai-full282/libcamera435-gtm-history/src/libcamera-v0.7.2，build6/IPA5。libcamera50839408B/5edff049…；IPA8100224B/51052914…；proxy1674864B/093df5fa…，签名验证通过、最终编译无诊断。完整hash见435build-validation。15文件patch0047以431build7为基线，零fuzz/offset字节一致；历史准备/修复脚本一次性执行，不盲目重跑。IPA5最终frameProcessed同步，必须匹配新库/模块/proxy，不混前期IPA5或正式IPA4。

内核未改，继续source354 HEAD9bc07e6339128ae8d3525c7d5c9bca5d0fbc46f3，branch samurai-vfe175-gtm-reopen434，clean。434 CAMSS2935224B/3edb28d1…，core439608B/d391fa24…，m2m141624B/e6828a0c…同431。板级DT/sensor/电源/DMA所有权未改，不重建未改内核。

## 435实现/关键约束

原TMC生成拆成prepareTmc/prepareGtm，IPE calculate接受实际生效的上游snapshot，不用M统计倒生成M的上游GTM。IfeGtmHistory分pending与active，参数DQ只提交，统计type3实际回执才确认cookie/generation/bank/status，ready版本sourceSOF必须<M；同包WB/CCM/LSC上下文也按真实ACK确认。每token shared_ptr<const Version>持完整TMC/cache/被选histogram，不受IFE继续更新影响；numeric state记实际gtmCookie/generation，仅最终成功推进。IPE失败不伪回滚已ACK IFE。

初始type9完整disabled cookie，等真实统计生成首个GTM前colour-only bootstrap，无数字历史。缺lux/忙时仅同GTM cookie允许重用committed LTM；未知版本/不匹配拒绝，hold成功历史，不能拿旧LTM配新GTM。原生trigger不变的force update保留旧histogram，变化才更新；math对象存实际histogram及SOF。日志source-sof/source-histogram是提案来源统计，不意味着hold时必定消费了该新histogram。

普通proxy同步方法直接调用IPA、统计排队，可并发。模块16公共入口recursive_mutex保护；最终frameProcessed改同步，下一帧前完成数学receipt。保留单pending数值历史、同SOF FULL/PD10持有至2DQ/requestDONE、stop先join、原250ms有界等待。

原factory主摄mode2/4 GTM UID21及三轴来自432，原其它调校字段未动。原manual_curve_enable=1/v2_enable=1保留；支持明确TMC11 ADRC model2分支，非完整legacy/manual/v2移植，非零GTM份额不清零。enable与TMC/use_gtm矛盾拒绝。实际编译profile三ADRC→原完整HAL GTM各512B零差异。432旧九原厂LUT/hostARM各27数值证据继承，前摄原厂禁用不改。当前只主摄4608x3456实拍；2592高仅导出配置。

## 实机/失败/离线证据

r1报告3帧(含最后失败)，2math提交：等待FULL对应PD10被旧stale回收，后帧越过旧帧。修coarseReady只回收未认领SOF、pin等待FULL对应PD10，finish最旧SOF优先。r2报告10帧(含失败)，6math提交：应用控制等GTM ACK，却阻断回传ACK所需统计。修EAGAIN继续drain统计、IPA控制等待时暂停新自动ISP提案直到请求执行。均保留private logs/samples，恢复正式环境，无fault taint0；没有延长超时掩盖失败。

r3 runtime-collected-r3已收集67项，普通/隔离各24连续SOF0..23、24真实PD10、24IPE成功，21math成功+3bootstrap。每路queued9/observed8GTM，两bank观测，最后未ACK提案不算生效。全部PREPARE/QUEUE/最终receipt按token/SOF/gtmcookie/generation/source统计链接；revision只成功+1，previous LTM lux来自上次成功。具体N0→cookie2在M3生效，图3 mathrev1；N3→cookie3在M6生效。RTtype2每路scratch48启动→46128 DC，48固件逻辑帧完成；core计数不可误算物理遍数。

正式模块/服务/图/资源恢复，before/after module notes一致，newfaults空、taint0。worker/client/build/exec均终态，无活任务；无重启。正式磁盘仍420/419、Image363/DT389未永久更新。PNG private kernel435 scene-{native,isolated}-{first,last}-private.png已看，画质缺陷不可隐藏。

实际ARM64模块/profile Werror契约覆盖旧factory/bypass、新GTMDQ/ACK/启动/因果/immutable/失败/缺lux匹配hold/错误版本/控制等待恢复/重启；actual module hash51052914…匹配build6。host ASAN/UBSAN actual history与coarseReady检查通过。独立原完整GTM三profile输出512B各零差异。434保留61组pattern九GTM阶段中BHIST与BG payload各仅一种，FULL/PD10明确变化，支持当前tap在GTM上游解释，不扩展所有tap/mode。

DC规则继承431原生指令：RTtype2→kind0→bank0，粗遍DC1/IP0/sumclear1，FULL DC0/IP1/clear0。430修final-distributor丢DC，cold/persistent同输入相等、固定FULL只改PD10会因果改变输出。片内DC整表未逐字节读回，a7scratch不是统计；429越界诊断已删，危险build2core da4591…禁止加载，不猜MMIO。434 GTMLUTbank0/1与此不是同资源。

## 下一步：画质与扩大范围

优先保存同一帧IFE FULL/真实PD10/IPE输出，定位环状亮度、雾感、偏色来自LSC/GTM/Gamma/信号域还是IPE LTM局部处理；使用原厂模式/配置和因果对照在底层修，不能只凭增亮宣布画质通过。复用当前已验证链路，不重跑无关矩阵。

然后其它摄像头自动GTM/TMC/LTM、其它尺寸/视频，保持前摄原厂禁用语义；再个体光学、多摄几何/同步、第五2MP等完整363清单。main真实链路成功不代表多摄/所有HDR/legacy/manual/v2 tone完整。

每次WSL source/build/ext4先root storage284.mounted_build原32GiB盘，禁止重建。Unicorn PYTHONPATH14。host435继承434→429新guard、原key/knownhosts；SSH正常。原件/轴/系数/ASM/全日志/像素仅private kernel435，public_module导出并scoped本地commit，保留mirror无关index和三工作树，不push；435前mirror efd01b4c。完整目标active。
