# 当前检查点：368（SFR故障处理候选已构建，现机367基线）

2026-10-20。先读WORKING-BOUNDARIES.md。原密钥USB SSH，当前boot guard `/var/lib/samurai/k367-work/boot-id-private.txt`，reference/kernel367/host.py为入口。Image/778模块363、boot固件366、静态DT来源365；libcamera五运行包99990.7.2-r29，config/stack0.1.0-r24，四份私有完整Preview默认保持362。全部相机/ISP目标尚未完成。

## 368最新进展（未部署）

原厂SendSfrMessage完整348字节指令执行11路径证明：先处理SFR，再在1b9f2向e001004c发布3；3为错误路径，不能等待它转1或发SYS_INIT。cache/log/format/power为明确桩，不冒充整RTOS。新core以3为终态失败，清理前用标准devcoredump保存568字节有界LE快照；SFR受声明/实际分配双边界限制。DMA别名及backing改在PM供电释放前回收，unmap失败保留PM引用，watchdog原因仍未证明。

实际start13组、stop7组、诊断helper与解码器ASan/UBSan通过，旧版4个反例保留。源码source354现在samurai-a5-terminal-sfr368／9c60745372258f2f37374862a06c9fd09eeaf240；只有A5后端一个C文件变更，k363实际in-tree core W1/Werror零诊断（232352字节），共享输出/config恢复，未部署。当前设备/guard/包/DT保持下述367基线，没有再次CPU释放或重启。

定点只读专用9ab00000固件RAM的一个4KiB代码页与ELF不符，停止未读异常状态页；不能据此恢复实际SFR或判断异常寄存器。raw数据私存368。解码器reference/kernel368/decode-start-dump.py只读已收集的私有devcoredump，不自动操作设备。

下一步以新的针对性诊断预先收集devcoredump，取得实际SFR原因并验证回收次序；不重放366，不在未保全错误前重复启动。尚无完整SYS_INIT/PING/PC_ACK、IPE或完整多摄校准。详见reference/kernel368/README.md。

## 实际新结果

363统一Image固定ba61a62293e0f6bc5838c06f2e85e033e3d702a8，包含348 Gamma和357公共OF/IOMMU节点引用修正。42 CAMSS组件W1/Werror无诊断，778模块匹配，实际内嵌BT模块核对。四颗已确认传感器和隔离IPA回归通过。364实机映射/核对/回收1280页；实验模块/节点可完整卸载，无OF引用故障。

364首次正确板级启动在resources返回-22；精确诊断确认overlay给已有无phandle预留节点加标签不能实时解析。365增加默认disabled的SoC ICP资源和板级camera_mem引用，既有固件9ab00000/5MiB/no-map不变。207个引用数字重排但目标路径均保持。只改logdump FAT中的DT没有生效；实际EDK2用固件卷DT。366重建固件，逐FFS证明只有DTB变化，实际boot读回和静态引用通过。不能再把FAT DT文件正确当Linux已采用它。

366一次A5实验已到固件/共享IOVA映射、资源上电和CPU释放；HFI响应持续3，500ms超时，日志记录block reset asserted，约1秒后modem watchdog并自动重启。无完整SYS_INIT/PING/PC_ACK，原worker没有正常终态。ramoops和原状态私存保留；不能把旧terminal=false改成功，不能把watchdog原因归结为某单行代码。恢复启动ICP模块/节点不在、17时钟0、taint0，临时固件副本按哈希清理，原厂和事务副本均保留。

恢复启动SSC file server exit4导致SensorProxy/桌面未起；367执行正常停服务和一次bootloader/reboot，不刷分区、不重试A5，恢复后实际状态/采集见reference/kernel367各验证JSON。完整目标继续active。

## 维护源／工具与回退

实际DT来源提交e217016006e609333a715c10f2f3e442dc4da95f（365），维护检出source354现在为上列368候选；含精确HFI ready364与诊断1947eb7，但实际Image固定ba61，静态DT来自e217。临时ICP模块按k363构建，没有永久加载。libcamera源/mnt/samurai-full282/libcamera362-serialized-built/src/libcamera-v0.7.2，正式r29/r24配方已保存。进入ext4先用reference/kernel284/storage.py::mounted_build()，SDK bind串行。

私存E:/edk2-samurai-out/kernel363～367。boot366候选c3e4e9c85d80c8ec37605cd522cf716525ae5ebe4fa801342dbf7586c292d924；logdump365 aca01bc2c91928f1a6a6690f62d14db014351ec5049e5684590b40c3c93de8da。boot276和logdump363可组合回退DT；原k298模块树/logdump和362事务的r27/r22包＋338模块＋344私有配置也保留。NV/OTP/工厂备份未写，原厂固件、校准、认证日志及密钥不进公共Git。

## 下一步

优先复用已取得的原厂CAMERA_ICP.elf、AndroidR固定源码及352上游原型，离线查响应3的写入者、CSR/共享地址语义和停机顺序；当前不安排重复A5 CPU释放。363 ELF入口和命令路径指令测试是局部证据，平台/OS等为桩，不能外推整固件状态。IPE图像会话与IO/IQ、后级Gamma/LTM/CCM尚未打通。

四颗已测为三后摄＋前摄；官方还有2MP人像摄像头，vendor的OV02A1B仅库名证据，实际身份未确认。AndroidR cam-sensor@4与现前摄共享PHY2/MCLK2/reset12，GPIO29选择关系待解，不能直接加冲突GPIO节点或当OV02A10。见reference/kernel363/REMAINING-CAMERA-SCOPE.md。

动态FrameDurationLimits、自动防频闪、其它模式、绝对颜色/黑电平/阴影、几何/多摄同步和连续AF仍开放，延期纯色/遮光可后做。不要把已取流与现有个体WB/LSC/CCM/default Gamma集成称为完整校准。
