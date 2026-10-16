# libcamera 99990.7.2-r15：Realme X2 Pro 补丁集

当前配方及实际部署为r15/config-r10，保留auto,virtual完整管线、11框架子包、tuning/desktop和原20补丁。0021补IMX319 gain helper，0022在同步IPA start后快照初始参数并补combinedMatrix，记录CPU实际处理帧身份，不改黑电平或调校。[22补丁源锁](source-lock.json)、[239构建与部署](../../../reference/kernel239/README.md)。

13包/34AArch64 ELF/5IPA签名与Qt/Python/GStreamer等QA通过，实际只升级七个运行包。候选和系统默认路径各两次start/24帧，首参正确；候选前摄RAW/RGB各六帧回归通过。后摄仍有全零帧，严格失败及光学/颜色待办保留，不以非零灰底验收。

CPU独立曝光/增益Auto/Manual、RAW-only统计及停止取消修复保持；225的大规模回归属于[历史r13证据](../../../reference/kernel225/README.md)，不能冒充r15全矩阵重测。16MP实验默认关闭，GPU ISP和完整kernel/rootfs仍开放。

外部原IPA214/APK203密钥复用，strip后重签IPA，私钥不入仓库。r15→r13/config-r8使用实际225七包和239事务前world/repo/配置；原生降级模拟通过，未完整往返，内核e49/ff9等保持。
