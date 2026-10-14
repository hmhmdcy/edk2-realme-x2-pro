历史快照：阶段151收尾更新前的文档，仅保留历史证据；当前状态以NEXT-SESSION.md及linux-port/docs/HARDWARE-STATUS.md为准。

# Realme X2 Pro继续检查点（阶段149，2026-10-13）

阶段150完成无Mesa本地补丁方案研究，现机仍保持下述149状态。限定本机的内核兼容候选同时拒绝EN_VM_BIND及VA_START、保留VA_SIZE，让原版Turnip通过GET_IOVA使用147的64 KiB分配器。原版系统库在独立进程模拟中通过36次像素验证、23,921,097像素零差异，含非零图像子分配；无新增fault。候选已编译adreno_gpu.o，未完整构建或部署，不能先移除149系统库补丁。代价是稀疏绑定、地址capture/replay及lazy BO能力降级，未来Mesa仍须检查回退。详见[150研究](../reference/kernel150/README.md)与[会话记录](../sessions/150-no-mesa-patch-gpu-research.md)。

最新状态：本轮自主继续 GPU 修复，当前可复现的 A640 自动 VM_BIND CCU 翻译故障已修复并实际部署。手机 #147/software132 加 Mesa149 本地库补丁；未重启或刷分区。原驱动及同构建基线在释放图像前方小 BO 的 GMEM 用例中首轮失败，完整 core、映射及命令证据确认图像前方 8 KiB 的未映射读取。64 KiB 自动 IOVA 对齐修复库完成 185 次像素读回、160,820,781 像素零差异，36 次 Settings 面板打开/正常退出，以及 PM、稀疏重绑定、旧非对齐地址重放与 Vulkan/GLES 并发通过。部署后新增 fault0；累计 fault3 含进入前1次和原驱动对照2次，taint0、物理桌面保持。

公开补丁为 [0015](../linux-port/patches/0015-mesa-turnip-a640-vm-bind-iova-alignment.patch)，源码摘要与已编译候选一致。系统库 SHA256：`97f3638851b534070f649fabfbdbb3d330b4ad0e2b0ea93b78026ad71d78fb5e`。原库、已部署库、收据和回退工具在手机 `/var/lib/samurai/k149-deployment`；主机私有产物在 `E:/edk2-samurai-out/kernel149`。13条收据保留10条成功和3条失败，工具/解码限制见 [149目录](../reference/kernel149/README.md)。

这是 `mesa-vulkan-freedreno-26.2.4-r1` 的本地库补丁，包数据库不变；普通 Mesa 包更新可能覆盖，须将补丁加入对应版本构建。旧完整 rootfs132 镜像不含本次更新。完整源码及两套构建在手机 `/var/lib/samurai/k148-mesa`，SDK 在 `/tmp/k148-sdk`，重启后需重新准备。再次切换前重新核对当前设备状态。整机显示启动、音频、充电等待办保持；原始 GNOME core 已到期，本次修复依据新复现的完整证据，未恢复旧 core。

以下为阶段148历史交接，旧“修复尚未完成”描述已经由阶段149结果更新；其中旧源码、稳定镜像及设备来源位置仍供参考。

当前操作边界仅以[WORKING-BOUNDARIES](../WORKING-BOUNDARIES.md)为准。

当前目标是继续修复Vulkan VM_BIND问题，2026-10-13已按用户要求完成本轮收尾，修复尚未完成。手机保持#147/software132；阶段147限定GLES验收之后，GNOME Settings出现新的CCU READ TRANSLATION和GSK Vulkan VK_ERROR_DEVICE_LOST，累计GPU fault为1。完整原始core未及时保存，尚未复现和证明根因。

阶段148已隔离编译Mesa 26.2.4基线及A640自动VM_BIND IOVA采用64KiB对齐的候选，单个测试进程通过VK_DRIVER_FILES选择；系统驱动未替换、内核未更新或刷写。候选像素、GTK GMEM、稀疏绑定与运行时PM测试通过，但未推广。原始物理vkcube尝试导致过一次Phosh退出，已恢复原greetd配置中的桌面，后续无头测试保持桌面与当前启动，taint0；新测试无新增GPU/WARN/DPU/DSI/DMA错误。

继续看[148调查与候选](../sessions/148-vulkan-vm-bind-diagnostic-candidate.md)、[148工具和收据](../reference/kernel148/README.md)、最终[vulkan-validation.json](../reference/kernel148/vulkan-validation.json)和[closeout.json](../reference/kernel148/closeout.json)。36条收据中32条返回成功、4条失败，失败和测试限制均保留。旧地址重放、并发、颜色格式矩阵、内存回收、GNOME服务正常退出及手机布局/default自动调优均通过；没有新增fault，仍须抓取可复现故障，不能宣告Vulkan已修。

30分钟core捕获窗口已结束，active=false，无新core；测试进程及k148追踪实例均为0，启动与桌面保持，taint0，系统驱动/包数据库/greetd配置SHA保持。37份原始归档已保存手机/var/lib/samurai/k148-private-archives并核对SHA，/tmp重复副本约578MiB已移除。主机E:/edk2-samurai-out/kernel148有24份原始归档、收尾收据包及两套库副本，SHA核对通过；其余归档保留手机持久目录。源码及两套构建在手机/var/lib/samurai/k148-mesa，SDK仍在/tmp/k148-sdk，重启后需重新准备。临时上传源码已保存到/var/lib/samurai/k148-tools/uploaded-sources后移除；继续测试时需重新上传工具依赖，先核对实际状态。

阶段147限定目标已完成：A640内核管理私有VM的IOVA起点改为64KiB对齐，撤销无效的146 CCU事件顺序改动。原145的固定800×600像素成功后迟发CCU READ TRANSLATION在147限定测试中未再复现。#147当时通过20次像素验证和6次1080×2259持续绘制，逐次退出后35–90秒观察无fault，taint0、GPU/WARN/DPU/DSI/DMA prepare均为0；这属于后续新Vulkan故障之前的历史验收。

当前手机#147/software132：boot132/logdump147/modules132/rootfs132，147仅刷logdump，148未刷写。完整源码/Image在WSL /home/cy122/pmos-samurai-kernel136/kernel（目录136不代表版本），Image和可刷logdump在私有E:/edk2-samurai-out/kernel147。770模块与132逐字节相同，config/DTB保持；147收尾时boot/persist/NV/来源/模块核验通过，临时GPU实例清除，当时没有待取core。

详见[147修复与验收](../sessions/147-a640-gmem-alignment-fix.md)、[146隔离实验](../sessions/146-gpu-gmem-isolation.md)和[147补丁与报告](../reference/kernel147/README.md)。私有当前启动身份为E:/edk2-samurai-out/kernel147/embedded-boot-id-private.txt和手机/var/lib/samurai/k147-closeout/boot-id-private.txt。再次刷写或重启必须重新检查实际状态，不重用146启动身份及147部署收据。

本次范围：A640旧式内核管理私有VM/GLES GMEM；Vulkan用户管理VM_BIND与其他型号未验收。整机显示启动偶发问题、音频、充电等仍未解决，不把本次干净窗口当作整机适配完成。

原145回退镜像仍保留。旧118诊断构建卷从封存恢复到E:/edk2-samurai-out/kernel118/build-volume.ext4，原压缩备份保持；148最后的离线解码结束后已卸载该卷并释放对应loop，ext4镜像保持。使用它前在同一WSL调用中确认挂载。解压时检查Windows实际卷空间，不能只看WSL虚拟容量。C盘本轮不完整解压文件已移除，临时腾挪的原下载文件已复原并核验。
