# 当前检查点：430（DC 遍次修复；同输入重复性与 LTM 粗级消费通过）

完整多摄／ISP目标未完成。先读 WORKING-BOUNDARIES、reference/kernel430/README.md。用户已强制重启，429四摄正式恢复48帧通过；不要再请求重启。430完成底层修复和主摄新实拍输入验证，尚未完成自动IPA双遍与GTM/history。

## 当前设备与维护源码

430 r1/r2/r3均终态通过，正式模块／服务／资源恢复，无新fault、taint0，worker/client死。正式420 r31/r26＋419 core/adapter、Image363/DT389保持，磁盘模块未改、无永久安装。当前正式IPE计数在卸载候选后重置为0；PW/WP枚举owner_refs53正常，非DMA泄漏。host.py沿用429新guard，原key/known_hosts保留；prepare-runtime动态核对当前正式notes、taint和jobs基线。

source354 branch samurai-ipe-dc-topology430、HEAD d4ac27ac5cf595c9fc7c612dfdfdbcc1a002675a，parent429 91be804b。仅2文件14行dc-topology.patch：有coarse时IO config+1200 topology3；粗级pass/stripe补6个Y/chroma写出范围半字。UAPI、6008B、DMA/m2m所有权、传感器/DT/电源不变。源码干净、哈希和零fuzz/offset回放通过。

build r1十匹配模块W1/Werror零诊断，core439608B d391fa248a2c56c7f1a7e65760dc3cc0be599e6fd3120982bc19915797df2cf3；CAMSS933bda...和m2mc4d983...与429候选相同。共享构建输出/配置/symvers恢复。无需无故重建。429 r2错误MMIO诊断build core da4591...禁止加载；430没有新MMIO读取。自身诊断Oops及恢复历史保留429/INCIDENT，别归因原厂。

## 根因、原厂证据与实机结果

旧oracle仅到HardwareDriver_EnqueueJob，遗漏后续DistributeJob和BLGenerator_GenerateBL。本轮probe-native-bl.py执行原厂BL初始化/最终调度：旧topology0粗级mask[0,0]、FULL[3,0]，DC被丢弃。仅topology3仍不够；补6范围后粗级[1,0]、FULL[3,0]。原HAL PostPipelineCreate 0x2cd8b0..0x2cd8d8片段16条件确认PPSprofile2且passes>=2用3，不是猜常量。

native-bl-validation：compiled C IO/stripe对全native HAL，完整512KiB程序、2MiBheap、全部存活分配/work/context和队列一致，40二进制对象；unused stripe脏padding不复制。OS/queue provider是夹具非原厂OS；窄READ观察不改程序/heap。C ASAN/UBSAN+ARM64输出11472B一致，legacy DCoff不变、invalid no-write/overlap检查通过。固定FULL640x480/display8＋PD10160x120 stride768/slice60/46080B，DC需IP+mask；其它尺寸未泛化。

control：正式FULL-only4jobs，LTMoff重复0byte；单遍IP/DC0重复164373bytes/YmeanAbs4.73536，证明旧不稳依赖LTM。
r1：复用428/main同SOF17 FULL/PD10和424原厂6008B包，4个real/black/white/repeat-real，首尾0byte；只变PD10输出改变。
r2：scene-pair.c新主摄pattern0，6对FULL/PD10完整同SOF、tail0，选SOF5后4个双遍jobs；首尾0byte，黑对照332742bytes/Y26.2614，白352298bytes/Y13.2961。
r3：同r2真实输入，在一次open/STREAMON内4连续request，序号0..3、scratch request1..4、requestDONE poll；四种输出各自与r2逐字节一致、首尾0byte。starts/stops1。没有依赖每帧重启来清历史。
总16direct，修复候选12；hardware-validation.json自动核对。ANR/TFoff、FULL固定，粗级变化→输出变化且重复相同，为LTM实际消费粗级输入的因果证据。

## 统计与自动链路仍缺什么

scratch原厂所需从71488变46128（46080+48），r1/r2/r3仍全a7；不是已验证DC表导出。固定参考独立LTMAverageLUT/avg3d DMI pingpong与13调校LUT不同；真正片内average RAM的具体bank、reset和字节读出尚未完成。当前恢复DC遍次后的冷/连续行为稳定，不等同已逐字节导出内部统计。不要读未映射PPS或凭猜bank改寄存器。

本轮仍固定424包，IPA数学提交0。下一步把生产libcamera424的FULL/PD10同SOF成组队列接CamssIpe：OUTPUT QN10两planes，CAPTURE NV12，保持两源FD到双DQ+requestDONE，stop先join再释放，完整缺帧/旧SOF/epoch失败不提交历史。生产源码在/mnt/samurai-full282/libcamera424-tone-domains/src/libcamera-v0.7.2，pipeline/camss-vfe，IPA/camss-vfe。本轮只读取，没有修改或克隆它。

423/424已有BHIST1024/真实曝光gain/lux/IFEgamma→TMC11→LTM13/IPEGamma→6008B和最终成功提交、single pending、缺lux hold。GTM在IFE/BPS，LTM在IPE；本机IFEGTM10::Execute0x31fc00、IQInterface::GTM10CalculateSetting0x37c818已定位但原树/数学/寄存器应用未恢复。原厂非零GTM份额不能清零。统计→后续IFE GTM生效版本→对应图像IPE→最终成功history，不能逆因果。同帧关联未验收，自动链路最后成功仍424，前摄TMC关保持。

其余四摄模式/视频/第五2MP/光学个体校准/多摄同步见363剩余清单。普通新scene已拍但没宣布画质校准通过。

## 工具和接续

所有WSL source/build/ext4操作前root导入reference/kernel284/storage.py并mounted_build；原32GiB镜像不重建。Unicorn PYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。私件kernel430有build、bl-*、control-collected-r1、runtime-collected-r1/r2/r3，所有worker/build/exec终态。原件/ASM/系数/图像不出私存。公共自有脚本+脱敏证据，scoped mirror保护无关index和3处工作树，不push。
