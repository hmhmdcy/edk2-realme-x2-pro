# 当前检查点：427（DS4底层输出候选已上机；帧内停滞／overflow未解决）

完整多摄／骁龙ISP目标active，未完成，无需用户输入。先读WORKING-BOUNDARIES、reference/kernel427/README.md。426是progress，427有实际内核接线、Werror构建与实机失败定位，不能标为自动链路完成。

## 当前源码与实机结果

维护内核 /mnt/samurai-full282/source354，branch samurai-vfe175-ds4-dma427，HEAD a993cd8a1db892bb5d68d9e6bcccfcc048aec9fd，parent426 dbefc5bdd8de8da07128171423f098a38d6e45b0。427/ds4-dma.patch相对426，12文件。真实DS4图像节点msm_vfe0_ds4、标准VIDEO_CAPTURE_MPLANE/DMA-SG、独立WM5/group1、参数块8（flags/reserved0，仅系数；流生命周期开关）。本地QP10 FourCC未上游保留，明确description避免核心WARN；逻辑mbus0x2027，像素位序未验证。未改变DT、传感器、OTP/NV/persist。

四摄原厂系数沿用426的提取/模式选择/原Parse和DS410。DS4数据寄存器+precrop+10bitround+PD10pack已接MMIO；原HAL节点ProgramIQModuleEnableConfig 0x2a8900补充发现DS4 Y/C局部crop/round/clamp使能0xd8c/dac=0xe00。夹具节点0xff74 FULL、+4 DS4 bool=1，calc输入沿用DS410+PreCrop+Round+R2PD，完整汇总21寄存器；不是完整HAL节点初始化或真实IFE striping。7组几何actual C与原指令72B逐字一致、hostASAN/UBSAN+ARM64 qemu通过。裁剪几何仍由夹具提供，须恢复真实IFE几何，不能把局部oracle当硬件验收。

运行候选640x480 FULL对应160x120 PD10，stride768/slice60/46080B；WM活动宽640bytes、高60，frame_inc是含slice padding的layout.bytes。32bit IOVA/SG/16B对齐约束保留。缓冲拥有后arm WM、写地址FIFO、单次reg_update，空队列不启DS4。修复旧RDI fallback提前启动，WM arm顺序对齐现有路径；顺序修正本身未解决物理问题。断粮/重开/共享SOF/独立完成/缺校准与SOF错误仅模型通过，实机尚未验收。

实际临时事务r1..r8均terminal，正式模块/服务/格式恢复。r1探针memcmp附加字段过严；r2/3诊断不足，r3还发生未先poll构建终态便准备载荷，不能依赖其新版诊断；r4起source+binary SHA guard且终态后stage。r5加FULL对照/SOF；r6 FIFO顺序仍失败；r7局部使能仍失败；r8诊断确认DMA部分写入而无完整DONE。

最新r8 FULL-only对照24帧正常、tail未改；同开656 SOF但FULL/DS4均0交付。停流后安全读未交付映射：DS4仅首buffer前4 packedrows变化，前三行到byte639、第四行到511，后续全未写；FULL首buffer也只写一部分，其它buffer未写。不是图像/统计成功，不交IPE、不推进IPA历史。IRQ status1见0x800/1000；OEM281 camif error_mask1=0xefff7e80命中、原camif归overflow。无新SMMU/WARN并不代表无硬件错误！原先ISR未报告这些错误。r8诊断时间窗内错误IRQ密集，最后源码只在前4SOF事件输出，日志收敛后构建不改像素配置。最新实际二进制SHA b5b94ec927765f0ca007696fd89d53d37d1386ffdd2c941d6d7f202704df466d，最终源码/构建是后续只改日志版本，别混为一个。

## 下一步直接定位帧内回压

优先对照原厂真实IFE裁剪/striping、模块局部使能与输出端口、WM消费/行数/队列，解决0x800/1000内部overflow；不要重跑已过数学矩阵或盲加新版ISP位。现有partial DMA证明开始写但不能证明格式/完整像素。内核对这些错误应最终有可追踪失败回执，未交付的SOF不能推进任何数值历史。完整DS4后再验同帧FULL配对、断粮恢复/晚开/重开/独立停止。

随后连接真实PD10→IPE粗级backing、C multipass striping、scratch/session/frame端口1，验证DC写出/full IP消费，再合并IPA自动触发和最终成功历史实拍。425原HAL+FW oracle已证明DC双遍：640/650 scratch71488/75584，不能用单遍48；CONFIG_IO+2896是遍次，不是BL，HAL minBL181024。旧C固定单遍；较新fromDownscale未证本机支持。

TMC11实际触发/BHIST1024+曝光/gain/lux→LTM13与IPEGamma及6008B request/成功history沿用423/424，当前同帧上游GTM生效版本因果仍缺。IFE/BPS GTM与IPE LTM必须区分；TMC非零GTM份额不能清零伪造完整。前摄OEM TMC关保持，单曝光unityDRC/noHDR/noLED/no-face不等于完整AndroidAEC。

## 设备与恢复

same394启动，Image363/DT389/CAMSS389正式、420 r31/r26+419 core/adapter未永久改。首次reload前793 IPE direct成功已归档，reload后每模块生命周期jobs=completed=failed=cancelled=0，无新IPE job；这不是历史job失败。owner_refs53桌面枚举，资源/电源/映射均释放，taint历史512不增，PW/WP各1恢复。最新成功现场照片仍424：410帧/402history/2Focused且仍雾感偏色；本轮pattern失败使scene分支未执行。其它模式/视频/第五2MP身份等见363/REMAINING-CAMERA-SCOPE。

所有构建/设备worker终态后才能改依赖或新部署。每次WSL source/build/ext4访问先root storage284.mounted_build挂原32GiB镜像；source354/build不重建格式化。Unicorn PYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。OEM原件、完整ASM/寄存器/系数/图像只在private；公共保留泛化代码与脱敏记录。本地mirror scoped提交保护其它index和3处工作树，不push；完整目标继续active。
