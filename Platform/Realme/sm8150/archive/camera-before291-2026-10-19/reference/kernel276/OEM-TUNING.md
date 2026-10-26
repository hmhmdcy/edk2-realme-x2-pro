290（2026-10-19）：#290完整Image/独立778模块已部署，原厂协议确认并修复VFE175 FULL后处理门控，带入TPG历史隔离和Gamma时钟修复。四摄RAW＋CPU ISP 235帧；标准接口TPG硬件NV12三帧、黑白中性通过，无用户态MMIO。实体硬件ISP/独立红蓝/统计与IPA/完整画质仍待做。[290证据](../kernel290/README.md)。以下旧阶段按当时状态阅读。

289（2026-10-19）：现机为288完整Image/778模块，四摄RAW＋CPU ISP回归234帧；本轮定位内部TPG继承C-PHY及Gamma SRAM上传缺时钟，修复候选ff8d2e9fc完整构建通过、未部署。临时硬件对照192个LUT字精确读回，黑白亮度恢复但色度仍错误，CST/统计/IPA继续；根部署锁已更新。[289证据](../kernel289/README.md)。

# 原厂资料可复用的内容与调校边界

最新[287](../kernel287/README.md)：原厂Demux/MNDS协议落实SoC后端并完整构建，另更新引导/固件/DT/驱动/用户态及升级依赖审计；仍未部署或完成Spectra成像/画质调校。

最新[286](../kernel286/README.md)：原厂FULL/Gamma协议落实到SoC后端，标准曲线和输出位深候选完整构建通过；DMI/图像尚待实机验证，完整画质调校未完成。

最新[285](../kernel285/README.md)：本机原厂CST12事实落实到公共SoC后端，标准色彩矩阵与设备画质调校分开；候选完整构建通过，物理色序和硬件ISP图像仍待验证。

后续281已只读提取本机原厂HAL并静态恢复CamX调试符号，交叉核CAMIF及多个成像模块范围，新增未部署的VFE175 CAMIF候选；完整硬件ISP仍缺。后续278已实现标准单次AF，本文276时的“尚未完成AF”按当时阶段阅读。[281原厂依据与源码](../kernel281/README.md)、[278单次AF](../kernel278/README.md)

后续280纠正了硬件命名：本机原厂SM8150选择VFE175/CSID175；下文VFE170仅为此前读取的参考表/共用后端名，不能作为本机全部ISP寄存器依据。调校分层原则保持。[280核对](../kernel280/README.md)

2026-10-18。可以并且应当参考原厂资料，但硬件描述、驱动协议、模组标定和成像算法分别归入对应层。原厂开源内核与系统vendor文件是不同来源；不能因为内核开源，就假定CamX、Chromatix或完整画质算法源码均公开。

| 资料 | 可以提取 | 在本项目的归属与限制 |
| --- | --- | --- |
| 原厂DTS/DTBO | regulator/GPIO/reset、时钟、CCI地址、CSI连接、安装方向及EEPROM拓扑 | 板级DT；转换为当前binding并验证，旧高通私有属性不能直接照搬 |
| 原厂传感器/镜头驱动与模组配置 | sensor模式表、PLL/曝光时序、模拟/数字增益、Bayer/quad排列、actuator命令及延时 | 标准V4L2 sensor/lens驱动；模组变体须匹配，不能只凭传感器名称认定镜头 |
| 原厂CAMSS/VFE内核 | SM8150/VFE170资源、bus client、寄存器、IRQ与统计/输出接口线索 | SoC公共驱动；现有线索不能替代硬件PIX/统计功能的实际实现 |
| 本机vendor相机BIN/XML、CamX/Chromatix等 | 可识别的模组参数、校准布局与调校参考 | 部分是二进制且格式/单位/算法不同，不能直接作为libcamera Simple tuning加载；不声称内容全可解码 |
| EEPROM/OTP/工厂标定 | 若布局/版本/校验明确，可只读取得本模组AWB/LSC/AF端点/PDAF等个体标定 | 按实际存在的数据解析，保留原件，不写回；不把一台手机的校准值当整型号通用常数 |
| 实机受控RAW样本 | 黑电平、饱和、曝光/增益响应、噪声、颜色/阴影和对焦曲线 | 补齐缺失标定并验证迁移参数；必须对应sensor模式、温度/增益/光源和处理管线 |

项目已使用原厂资料推进，而非只靠目测调参：274按匹配XSD直接解码本机Sunny/Qtech GW1 actuator BIN，并以独立XML解析交叉核对。Sunny LC898219XI的初始化及16位大端位置命令已迁入标准V4L2镜头驱动；276通过标准节点证明了实际光学响应。这里证明的是命令与供电/生命周期正确，尚未完成自动对焦或距离标定。[274来源与交叉验证](../kernel274/README.md)、[276实机](README.md)

原厂内核固定提交9668fcdc6ec15be7a10d66f7b93c347829e0fdb6中的VFE170定义已用于定位FULL/DS4/DS16/统计输出；当前维护CAMSS仍使用RAW writer，Spectra硬件成像未接通。曝光、白平衡、颜色、降噪、锐化、AF搜索策略应进入匹配的IPA/调校数据；接线进DT，寄存器协议与PM进公共驱动。[分层证据](../kernel274/ISP-ADAPTATION.md)

当前画质改进顺序：先固定正确sensor模式/时序/增益和可控焦点；核对可读模组校准布局，完成黑电平、AWB/颜色、阴影/噪声及AF标定；用标准libcamera控制/IPA承载。Spectra另需公共硬件参数/统计接口和pipeline/IPA，再将可复用参数转换到该处理链。原厂参数只能作为有来源的起点，不能保证直接恢复原厂画质。

降低升级补丁量的路径是公共驱动与libcamera功能进入各自上游，设备差异保留为标准DT、固件和调校数据包。目前仍有下游内核/用户空间补丁，尚不能承诺发行版主线内核及libcamera更新无需补丁；完整最新统一Image/rootfs也尚未部署。

外部原始来源：[realme官方X2 Pro内核仓库](https://github.com/realme-kernel-opensource/realmeX2Pro-kernel-source)、[libcamera运行时调校配置](https://docs.libcamera.org/master/runtime_configuration.html)。本地固定版本、提取物哈希及实际收据优先于可变网页；没有将厂商二进制或私人校准/样片公开。
