# Realme X2 Pro 相机配置包

当前config/stack为0.1.0-r14，固定五个libcamera组件为99990.7.2-r19。三个配置载荷内容保持，仅升级依赖版本；49项运行载荷、961包及其余954包记录核对通过。相机接线和供电已在公共内核驱动/设备树管理，不添加发行版私有供电脚本。[268部署、应用验证和回退](../../../reference/kernel268/README.md)、[当前输入锁](source-lock.json)。以下r10/r15为历史。

当前config/stack为0.1.0-r10，固定libcamera/IPA/tools/gstreamer/v4l2为99990.7.2-r15。配置payload保持CPU ISP/system heap、heap模块自动加载与权限，目录0755/文件0644。通用堆video/uaccess，FastRPC池root0600。[239记录](../../../reference/kernel239/README.md)、[源锁](source-lock.json)。

16MP默认关闭，须模块参数和用户态Quad双实验开关；产品YAML保持。r15已核系统默认取流、两次start初始参数和WirePlumber新库加载；普通/隔离IPA的完整控制矩阵是225历史验收。后摄光学/颜色和全零帧仍待处理。

r15→r13/config-r8回退使用225实际七包及239事务前world/repo/配置，保持当前ff9/e49等内核模块；降级模拟通过，未完整往返。本包不含内核、设备树或私钥。
