# Realme X2 Pro 当前检查点

2026-10-17：258已完成Linux同位置室外/拔USB/无线GNSS复测，287份有效位置全部SATELLITE，连续286秒、最大间隔1.012秒；GPS去重最多12颗TRACK、44.4dB-Hz，PGA全+2。257正常Linux/boot235/Image183保持，taint0、三DSP running；会话和临时报告已清理，Power1恢复，无线SSH保留。[258实测与原厂对照](reference/kernel258/README.md)。

先读[操作边界](WORKING-BOUNDARIES.md)、[硬件清单](linux-port/docs/HARDWARE-STATUS.md)、[258](reference/kernel258/README.md)。当前仍为257正常Linux启动，guard为/var/lib/samurai/k257-runtime/boot-id-private.txt；旧247/248、Android251—256及257 RAM guard均失效。运输代码/端点、原始身份仅私人E:/edk2-samurai-out/kernel257；使用linux-host.py和transport="wifi"，严格固定正常Linux原主机密钥。用户已确认室外拔USB，258采集完成，原始坐标/NMEA/卫星编号仅私人kernel258保存。Android启动分区、共享336文件和GPSTest数据已备份，NV/GPT/persist未回刷。[257返回依据](reference/kernel257/README.md)

## 公开仓库与维护方式

- [pmaports](https://github.com/hmhmdcy/pmaports)：默认samurai-userspace，4aeae3b3035412794b2204e2f8bc104cef082a54；上游基线862c5af2ca9a48f43e934d9ea55fee0dd47a67f2，完整历史保留。6个主题提交保存最终用户态差异，samurai-bringup保留整理过程；没有强推旧分支。
- [内核](https://github.com/hmhmdcy/linux/tree/samurai-bringup)：04d4d4f93171574201db1837a1b195e3aeccde4e已推。相对a90ee4305（7.3-rc6）仍有120文件差异、OF fixture/overlay与诊断；不是纯净维护队列。
- [EDK2与历史证据](https://github.com/hmhmdcy/edk2-realme-x2-pro)：保留启动链与240/247/248等记录；本地生成DTB仍有既有未提交修改，不能随文档提交。

用户要求跟随上游且补丁纯净。按上游＋最小功能队列＋原生APK维护；新候选重放补丁、构建/升级模拟后，再实机验收并固定标签。详见[pmaports维护策略](https://github.com/hmhmdcy/pmaports/blob/samurai-userspace/samurai/MAINTENANCE.md)。当前IMX319仍依赖235/237 lab PMIC/provider，必须正式化电源/reset/静态DTS并验证，不能直接删配置冒充清理完成。

## 249独立核验

GitHub新clone，公开pmbootstrap3.12.0提交200f512…，另有公开且校验锁定的kernel=none功能补丁；没有复制旧私有SDK。13个目标配方及crossdirect构建通过；源检查14配方/88本地SHA512/102生产文件/1工具补丁通过，GitHub CI通过。

libcamera原6发行版补丁＋6最终下游功能补丁，零fuzz重放；1490源码文件净比较一致、21改动文件锁通过。r18/config-r13构建；Turnip26.2.4-r2；MM1.25.95_git20261005-r4完整重建、38测试通过。RAM COW/sharedmem/TFTP/RPC四项ASan/UBSan回归通过，已知builder进程寿命分配不做leak验收。

882包离线根目录；189包文件哈希、78ARM64 ELF、QMI GI、服务路径与用户配置通过，finalize重复执行通过；3项CLI帮助/版本通过。签名APK仓库仅34个当前候选包，拒绝同名多版本索引；samurai标签绑定设备库来源，apk更新索引及upgrade模拟通过。候选测试账号已锁定，不含旧登录身份。

明确自备同机私有输入，301 SSC文件/160固件manifest通过；248备份保持RO。源码配方不含厂商固件/NV/私钥。完整启动链尚未一键复建；滚动依赖、APK/IPA新签名不保证历史逐字节一致。维护纯度检查按预期拒绝实验供电配置。所有这些结果均不是新实机硬件验收。

## 源码、产物与回退依据

257恢复后仍boot235＋Image183，完整模块文件随248镜像恢复，775ko/789项的权威清单仍为237；libcamera历史r15/config-r10、Snapshot51.0-r0，248备份958包。新候选版本不得当成已上机版本。canonical旧内核/旧SDK继续保留，勿重置/覆盖。

显示修复跨UEFI164和内核153–165；GLES147与Turnip149分属内核/用户态。Snapshot仅应用CPU覆盖（GSK_RENDERER=cairo、GDK_DISABLE=gl,vulkan,offload）两轮预览/清理通过；默认Vulkan出现480条历史fault，CPU两轮无新增不代表根因修复。实屏画面/颜色、回收告警、其它后摄仍开放。传感器精度/旋转与SLPI同boot重启生命周期、蜂窝无SIM业务未验。

GNSS见[258](reference/kernel258/README.md)：Linux原生QMI持续定位通过，GPS4110条测量中4099条TRACK，559份含fresh报文覆盖297秒；定位后频率不确定度2.93—5.45m/s、source1、reset7保持。原厂302份成功位置对照保持；两端PGA均+2，不能把旧−6/−10当固定系统增益。普通SV列表内部重复，原厂15/Linux17是条目数，去重峰值10/12颗。lock_point仍全假而实际定位成功。此次临时正常电源在线后恢复；位置/USB/启动/辅助状态未单变量控制，室内失败根因未解。完整5MiB连续内存/SCM provider未补齐，本轮仍可fix；桌面服务、冷启/PM/长稳/精度待验，未测TTFF。

[248返回记录](reference/kernel248/STATUS.md)保存21分区、6LUN GPT与完整userdata私人备份依据。clean-r6的PC partclone/F2FS检查通过。257已完成实际Android→Linux返回；后续切换仍需核当前身份，不重放旧重启/刷写请求。

## 续作与已知风险

249开发及GitHub新clone位于PC私有32GiB ext4构建卷D:/samurai249-build/build-ext4-private.img，挂载点/home/cy122/x2pro-linux/pmos249-build；不得重新mkfs。GitHub新SDK为github-only/sdk-r2，rootfs位于其work/chroot_rootfs_realme-samurai。私有测试日志/manifest在E:/edk2-samurai-out/kernel249。构建卷和248原始备份/恢复镜像均保留。

下一步是独立维护内核候选：整理最后相机电源/provider，拆出正常驱动与DTS，移除临时OF/trace；按显示/GPU/音频/无线/传感器/相机主题逐hunk审查。完成构建、模块一致性和必要实机回归之前，不发布纯净维护版。上游更新不是无人值守刷机；当前未配置自动化升级任务。
