# 当前检查点：362（已部署，完整目标继续）

2026-10-20。四摄／骁龙ISP目标active，尚未完成；下一步转ICP/A5固件和IPE会话。规则见WORKING-BOUNDARIES.md。

363进行中：正在从source354固定357提交构建独立k363的完整Image/778模块，尚未切换设备；现场仍为下述362组合。构建worker759，私有kernel363/boot-build-state-private.json为状态入口，已有执行只轮询，不重复启动。相关新脚本与原厂入口12场景证据见reference/kernel363/README.md。

## 当前设备与新增结果

严格原密钥USB SSH 169.254.42.1；沿用360恢复后的boot guard。当前Image仍7.3.0-rc6-rmx1931-samurai-k298+，固件boot276未改。已安装libcamera五运行包99990.7.2-r29、config/stack0.1.0-r24；CAMSS现为348 Gamma模块，note SHA256 d8c0f30d189aa8e69e377ba58c891955f3bc795abfb6b8ed6a9562a1d118333a。其余传感器及板级DT未改。

本机四份360完整Preview配置已更新/etc/libcamera/ipa/camss-vfe/{model}.yaml；原厂曝光/手动频闪和IFE Gamma成为已对应模式的默认，个体WB/CCT、动态LSC/CCM保持。五模式安装后137帧隔离请求通过；四个硬件/四个PipeWire节点，GStreamer/PipeWire各12帧通过。最终taint0、双CCI/CAMSS休眠、九路电源disabled/users0、服务各一个uid10000，无活动362 worker或ICP模块。[结果与边界](reference/kernel362/README.md)、[安装](reference/kernel362/install-r1-validation.json)。

361的分发器生命周期修复已纳入r29。362另修CAMSS同步IPC提交所有权，以及公共PipelineHandler同camera递归提交顺序。r1先越过空队列崩溃但暴露请求硬件顺序错误，已保留失败；r2/r3五模式隔离138帧+线程/实景57帧通过。不能删除断言、禁用隔离或重放旧事务。正常实景取流不等于绝对光学校准；五Preview模式不能外推所有模式/用途。

## 源码与回退

工作区E:/RealmeX2Pro edk2；Git镜像WSL /home/cy122/edk2-samurai/repo/Platform/Realme/sm8150。完整源码/mnt/samurai-full282/libcamera362-serialized-built/src/libcamera-v0.7.2；正式配方linux-port/packages/libcamera和samurai-camera-config已同步，0037/0038/0039补丁纳入。模块源/mnt/samurai-full282/source348，samurai-ife-gamma348、30086bae4d60abe70784a1176bbe418434833b2f。

完整13包及7运行包签名仓库私存E:/edk2-samurai-out/kernel362；手机/var/lib/samurai/k362-install-r1为成功新事务，repository/rollback保留r27/r22离线包，backup保存原338模块、四份344私有配置、APK world及仓库指针。回退必须组合恢复旧配置/模块/包，不能只降用户空间后继续使用新默认。原厂数据/私有校准/固件/密钥/原始认证日志不进公共Git。

SDK /home/cy122/x2pro-linux/libcamera214-root；进入E盘ext4先调用storage284.mounted_build()，SDK /work/libcamera bind串行且退出释放。构建及安装已终态，不重启旧handle。

树外364候选：依据363原厂ELF入口12场景，已准备精确HFI ready等待补丁及生产start函数8场景ASan/UBSan回归，旧版提前接受3可复现。尚未应用到source354/未编译模块/未发机；reference/kernel364/README.md和apply-source.py包含363完成后的前提。不要在363构建期间改其固定源码。

## 剩余

ICP内核源/mnt/samurai-full282/source354，samurai-iommu-node-lifetime357、ba61a62293e0f6bc5838c06f2e85e033e3d702a8。357公共OF/IOMMU引用修正已构建未装；356正确Realme firmware0x9ab00000/5MiB命名memory-region第7构建未发机，错误generic0x8b700000不可复用。旧356R5无正常终态，不改写成功；360已恢复当前Linux启动。尚无完整SYS_INIT/PING/PC_ACK及真实IPE会话。继续优先原厂ELF/源码/反编译和352固定上游原型；350/351/352后级Gamma/LTM/CCM待硬件会话接入。

动态FrameDurationLimits、自动频率检测、其它模式/用途、绝对颜色/黑电平/阴影、几何/多摄同步及连续AF仍开放。IFE Gamma不是最终原厂显示色调，未知前摄裁剪保持generic，缺IQ的高分辨率不造表。
