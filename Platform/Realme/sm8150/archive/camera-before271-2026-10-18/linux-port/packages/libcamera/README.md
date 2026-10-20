# libcamera 99990.7.2-r19：公共相机补丁集

当前配方及原生部署为r19/config-r14。完整保留r15的22补丁和功能，仅新增0023修复Simple管线在其它进程改变MC图后缓存失效的链路设置；没有机型/应用判断。13包完整构建及签名/运行QA、七包原生升级、跨进程交替、Snapshot前后摄预览/界面切换/快门与JPEG解码通过。[268结果与边界](../../../reference/kernel268/README.md)、[当前输入锁](source-lock.json)。仍用既有CPU ISP及Cairo显示回退，默认GPU、画质和完整rootfs开放。以下r15数字为历史。

当前配方及实际部署为r15/config-r10，保留auto,virtual完整管线、11框架子包、tuning/desktop和原20补丁。0021补IMX319 gain helper，0022在同步IPA start后快照初始参数并补combinedMatrix，记录CPU实际处理帧身份，不改黑电平或调校。[22补丁源锁](source-lock.json)、[239构建与部署](../../../reference/kernel239/README.md)。

13包/34AArch64 ELF/5IPA签名与Qt/Python/GStreamer等QA通过，实际只升级七个运行包。候选和系统默认路径各两次start/24帧，首参正确；候选前摄RAW/RGB各六帧回归通过。后摄仍有全零帧，严格失败及光学/颜色待办保留，不以非零灰底验收。

CPU独立曝光/增益Auto/Manual、RAW-only统计及停止取消修复保持；225的大规模回归属于[历史r13证据](../../../reference/kernel225/README.md)，不能冒充r15全矩阵重测。16MP实验默认关闭，GPU ISP和完整kernel/rootfs仍开放。

外部原IPA214/APK203密钥复用，strip后重签IPA，私钥不入仓库。r15→r13/config-r8使用实际225七包和239事务前world/repo/配置；原生降级模拟通过，未完整往返，内核e49/ff9等保持。
