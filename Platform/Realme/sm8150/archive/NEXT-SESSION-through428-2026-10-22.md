# 当前检查点：428（原厂 Crop 修正色度坐标；四摄 DS4 完整同帧输出通过）

完整多摄／骁龙 ISP 目标 active，未完成，无需用户输入。先读 WORKING-BOUNDARIES、reference/kernel428/README.md。427 是实际接线和失败定位的 progress；428 是原厂真实几何生产纠错、底层修复和四摄实机通过的 progress。下一步直接接 IPE 粗级消费，不重跑已过数学矩阵。

## 维护源码与修复根因

原32GiB镜像 /mnt/samurai-full282，source354/build。HEAD 906a6b9d26afe0e7c3f3758dad2fb5c0e778634e，branch samurai-ds4-precrop-isolation428，parent427 a993cd8a1db892bb5d68d9e6bcccfcc048aec9fd。precrop-chroma.patch 相对427仅一文件修正色度crop X：交织色度分量宽仍等于FULL，只有高度减半。427夹具注入半宽X，局部oracle只证明错误输入的寄存器一致，不能当有效几何。428先绕过precrop诊断r3成功，再原使能恢复且X修正r4/r5/r6成功；precrop-isolation.patch仅中间诊断，不要安装。

执行本机HAL完整FULL Crop Create315e88/Execute3161b0，path0 VideoFull（1是FD）。构造cfg必须有效可写；最后hook确认无写原映像。cfg/full尺寸和MNDS比例+144给定，产生calculated+2c78 preCrop：640x480时Y(0,0,639,479)、C(0,0,639,239)。再原PreCrop/DS410/Round/R2PD/NodeEnable，7组actual C逐字一致、hostASAN/UBSAN+ARM64 qemu过。5组wholeCrop生产检查过；MNDS完整执行、任意sensor ROI/striping未完成，不能扩大范围。原厂系数和4物理模块/模式选择沿用426；原件私存。

最新Werror build r2 10匹配模块终态通过，CAMSS a9096d39b368eff3c59c133fd03e493d65294edc0635cf6c5ded46df9f5050c7，core ae2ca7e3ede81ccb019422d7250376c23377537d2c328571817a3390db179099不变425，m2m不变427。共享build输出和配置恢复，源码干净、补丁无fuzz/offset复放。无DT/传感器/ABI/队列变化，无永久安装。

## 最终硬件与像素结论

r6 worker终态通过：主GW1 4608x3456/tele3M5 2104x1560/frontIMX471 2304x1728/wideIMX319 1632x1224，各现有一模式顺序拍。FULL640x480 NV12+DS4160x120 PD10，stride768/slice60/46080B，WM5/group1。main FULLonly24；8个pattern/scene各18DS4，共144完整帧，全部同SOF FULL完成伙伴，共236同时FULL。每次断粮一处预期SOF缺口、恢复成功；DS4独立停流后FULL至少再6帧。所有mmap尾部与PD10行padding未改。采样前4SOF共32诊断未命中OEM CAMIF错误掩码，不代表所有错误注入验收。

V4L2 timestamp是DONE完成时刻，seq才是SOF标签；两个DONE差最多154us，不要求时间戳相等。r5旧探针3缓冲且每FULL落盘导致main-scene一个DS4无FULL伙伴，不能声称r5有144配对。r6四缓冲、只保存FULL第4/18帧+所有DS4后通过。未来生产仍必须丢弃孤立粗级帧，hold已提交历史，不能依赖probe永不掉帧。

r1尺寸替换损坏460800前置失败，r2tele复现partialDMA，r3bypass诊断成功，r4恢复precrop+正确X成功；r5/r6四摄成功。均终态恢复正式模块、媒体格式、PW/WP。r6私有capture-collected-r6，公共hardware/pixel-layout/source等validation可复查。

PD10每8byte：6个高8bit字节，随后LE低12bit按同6分量顺序各2bit，高4reserved；分量存储Y00,Y10,Y01,Y11,Cb,Cr，raster索引0,2,1,3。3普通色条共7904恒定邻域10bit差最多3；main ShadeColorBars有垂直渐变，不能套等值色条。4路scene全24排列各自最佳均列优先，参考只是近似4x4均值，不等于精确原厂filter相位；144帧reserved高4均零。pd10.py为诊断decoder，QP10仍本地未保留FourCC。已查看front FULL/coarse构图色彩相符，但上游仍雾/偏色，未声称最终画质校准完成。

## 下一步直接接真实 PD10 → IPE

425原HAL/FW已经证明DC0一遍/DC1两遍、PD10端口1影响CDM重定位，640/650 scratch71488/75584；CONFIG_IO+2896是遍次，不是BL，HAL minBL181024。旧维护C仍固定单遍48，不得继续。连接真实PD10 backing所有权、C multipass striping、scratch/session/frame端口1；先证明DC统计实际写出及full IP消费，然后合并IPA。避免新固件fromDownscale猜测，本机未证。

处理域：GTM在IFE/BPS上游，LTM在IPE。TMC非零GTM份额与同图像实际应用版本因果仍缺，不得清零伪造完成。423/424现有IPA实际曝光/gain/lux+同SOF preWB1024BHIST+IFEgamma→原TMC11→LTM13/IPEGamma→6008B request、最终成功才提交数学history、单pending/缺BG或lux hold。424最后自动IPE现场410帧/402history/2Focused且雾偏色；428是新IFE现场成功，不是新自动IPE成功。front OEM TMC关保持；单曝光unityDRC/noHDR/noLED/no-face不等于完整AndroidAEC。

same394启动、Image363、DT389/CAMSS389正式、420 r31/r26+419 core/adapter未改。427reload前793历史IPE完成保留，reload后当前生命周期jobs/completed/failed/cancelled=0，428无IPE job；不是历史失败。owner_refs53桌面枚举，资源/映射/电源释放，taint历史512不增。其它模式/视频/第五2MP身份见363/REMAINING-CAMERA-SCOPE。

每次WSL source/build/ext4前先root storage284.mounted_build挂原镜像，不能重建格式化。构建/worker先poll terminal再stage/deploy；无pending shell或remote worker。Unicorn PYTHONPATH=/home/cy122/.local/lib/python3.14/site-packages。OEM原件/ASM/系数/图像仅private；泛化代码/证据public。mirror scoped本地commit保留其它index和3处工作树，不push，完整目标继续active。
