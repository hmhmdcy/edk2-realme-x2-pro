278当前：boot276/Image183保持，libcamera r24/config-r19已部署标准单次Auto AF和帧统计/镜头回执。原生触发/取消/重触发/停流及AE下AF通过，四摄232帧回归。配对测量AF约9–12秒需加速；连续AF/距离标定、画质、GUI录像、Spectra和完整统一构建仍未完成。[278证据](../../../reference/kernel278/README.md)。以下按历史阶段阅读。

277当前：boot276/Image183、776模块/961包，libcamera r23/config-r18。公共RAW空间统计及标准FocusFoM已部署；主摄固定曝光失焦/返回、同request RAW与元数据一致、四摄241帧回归通过。AF搜索/标定、画质、GUI/录像、Spectra与完整统一构建仍未完成。[277证据](../../../reference/kernel277/README.md)。以下按历史阶段阅读。

276当前：boot276/Image183、776模块/961包、libcamera r22/config-r17。标准镜头/流生命周期及公共CCI共享I/O供电已部署；标准手动对焦光学响应、前＋三后摄238帧回归与资源回收通过。默认SSC/桌面正常启动，物理旋转待重测、旧EPERM根因未明。AF算法、画质、四摄GUI/录像、Spectra和完整统一构建仍待完成。[276实际状态](../../../reference/kernel276/README.md)、[原厂调校依据](../../../reference/kernel276/OEM-TUNING.md)。以下按各历史阶段阅读。

274：主摄原厂镜头命令已产生真实光学响应；标准V4L2 lens/静态DT/独占VAF候选0798ee688已编译并通过13个回调主机用例，尚未部署，须先配套Simple lens生命周期。相同96组控制两轮通过但旧失败根因未明；现机仍273/r21，SSC失败及Spectra未接通保持。[274证据与分层](../../../reference/kernel274/README.md)。以下按各历史阶段阅读。

273已部署：GW1主摄已实机绑定并经C-PHY取得RAW/RGB和实景JPEG，前摄＋三后摄238帧交替通过。当前boot273/Image183、775ko/961包、libcamera r21/config-r16；完整控制切换仍失败，AF/画质/GUI/Spectra及SSC开机问题未完成。[实际状态](../../../reference/kernel273/README.md)。以下272及更早内容按当时状态解释。

272未部署候选：新增GW1标准驱动、静态DT/binding和libcamera helper，编译/主机故障注入通过；现机仍为下述271，主摄出帧/AF/Spectra未完成。[候选与证据](../../../reference/kernel272/README.md)。

271（2026-10-18）：当前S5K3M5原生32…512增益码与libcamera r20/config-r15已配套部署；前摄/两后摄原生回归通过，长焦持续预览已有明亮实景，首次AE慢、画质/AF/主摄/Spectra仍待完成。当前身份与源码见[271](../../../reference/kernel271/README.md)。下文旧阶段按历史解释。

# IMX471内核补丁链

2026-10-18最新：[269](../../../reference/kernel269/README.md)维护分支已删除五个禁用OF实验helper，固件IOVA限制移到RMX1931板级树，公共CAMSS使用标准DMA mask/SG检查。新Image、DTB及全部773模块已从同一清洁提交完整构建成功，五相机目标W=1诊断0，全树1140条待分类；937节点设备树语义保持。候选尚未部署／发布，完整rootfs尚未重建；手机仍267固件/Image183及267模块。以下219/223与267/268构建状态是历史记录，不能替代当前部署身份。

依次保留215的测试图案16位写与216的模拟增益上限修复，219新增原厂4MP/实验16MP模式、固件链路频率过滤及像素阵列时序修复。新增两补丁在保存的216源/板级树上独立重放，结果与实际部署源码逐字一致。[锁](source-lock.json)、[重放收据](../../../reference/kernel219/kernel-patch-integration-validation.json)。

旧模式实际行长5120；三模式阵列速率387.2/326.4/约578.133MHz经活动寄存器和各120帧时间戳核对。保持PLL表，显式写旧模式行长，修正PIXEL_RATE元数据。16MP仍须模块实验参数，默认关闭，真实颜色/标准CFA/几何未验收。

本目录保存补丁与指纹，不代表宿主canonical源/DTB已更新；其仍为216源和旧canonical板级树。部署boot219及模块e49与旧输出分别核对，禁止把旧canonical DTB当当前部署树刷写。Image183保持，后置四摄/未知供电父网与完整rootfs整合继续开放。

223新增独立的0005 CAMSS补丁：只在SM8150/VFE170发布标准FRAME_SYNC，给缓冲保存真实SOF号，缺标记返回错误。fae1模块与r8已配套部署，160帧临时试验逐帧对应独立事件流。完成时间戳保持EOF，未校准物理曝光延迟；canonical CAMSS仍原始源，完整内核/rootfs整合待办。[锁内camss条目](source-lock.json)、[223证据](../../../reference/kernel223/README.md)。
