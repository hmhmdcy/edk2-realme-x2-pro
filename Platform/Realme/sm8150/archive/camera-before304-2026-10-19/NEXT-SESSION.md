# Realme X2 Pro 当前检查点

2026-10-19：[303硬件AE候选](reference/kernel303/README.md)。按用户新目标恢复适配，目标active、未完成。本轮手机不可达，无新增实机试验、刷写、重启或安装；当前启动未复核。以下设备版本来自最后已验证记录。

## 当前部署与启动身份

设备#298／7.3.0-rc6-rmx1931-samurai-k298+；内核树`/home/cy122/x2pro-linux/camera279-isp-kernel`，samurai-blc298／c5e118faec21a6c4bd2e7d5b86b3b21ad9dc2117。778模块、boot276、DT及固件沿用302记录。产品libcamera0.7.2-r24／config-r19及PW／SPA／Gst1.6.9-r3仍按RAW＋CPU ISP解释；303候选未安装。

Image SHA eb8054e69991528cad4f126d7723b7ef4869b288fb85c992f4803cbfeab5ddaf；logdump dfef7be4f358c5c16e8e716a60c24da8a139de73b1e07912d70f2b58613d80df；boot 0d6bbc0255fc7a44340b2c2c6a20f2bfa807f683f69dd20a3fb130d961dc4c64；DTB dcdd74ec903520c7023fa28badcb293b2e4e26ee5bac639497c63d53536b2c8d。

303/host.py保留原严格密钥和#298 guard。USB网络接口未发现、两次SSH失败；先恢复连接并核实真实状态，勿以旧身份盲目切换。上次entity为main8-0010／lens8-0072、tele6-002d、wide9-0010、front7-0010，仅供历史定位，生产代码按entity发现。[部署锁](linux-port/camera/deployment-lock.json)、[源码锁](linux-port/camera/kernel/source-lock.json)

## 实现与验收边界

- SoC保留298 VFE175 WB／BLS、图像／参数／Y BHIST共享SOF。303未改内核、DT、通用libipa或产品包；模组曝光策略只在独立YAML。[分层收据](reference/kernel303/checkpoint-validation.json)
- 302最终实机960帧／36次控制变化及144图像分区响应通过，真实写入SOF＋2；范围仅IMX319当前模式。隔离请求有时延后一图像帧，元数据按实际有效上下文。[302](reference/kernel302/README.md)
- 303复用AgcMeanLuminance／Histogram／ExposureModeHelper接入候选，按epoch／SOF／revision等待控制生效。真实DSO与线程proxy各720帧合成延迟模型通过，共1440帧；三档可达亮度收敛、极暗上限及旧帧／未知上下文／停流重开通过，不计作摄像头出帧。[DSO](reference/kernel303/ipa-contract-validation.json)、[proxy](reference/kernel303/proxy-contract-validation.json)
- QEMU不实现生产Process使用的clone3，独立worker未启动，完整隔离IPC仍未通过；生成序列化13字节字段与往返另测通过，不替代IPC。Auto只支持启动时双Auto或双Manual，混合和运行中切换拒绝；WB固定、无RGB AWB，无动态帧长／防频闪／完整IQ。
- IMX319驱动曝光／增益分写、未用group-hold控制簇。联合恒EV实机测试包已编译，未执行；不能据模型认定物理锁存。必要时在sensor驱动层修正。
- 原厂IMX319 BLS16模式／288区域均960 U14；本机EEPROM双读一致但完整布局／校验未核实、未应用。OEM参考及临时WB不是本机正式暗场／色彩校准。[299](reference/kernel299/README.md)
- 最后实机健康沿用302：图／控制恢复、供电／PM自然回收、无新增所测故障。961包／50相机载荷／778模块全量核对沿用300。本轮未重新确认这些状态；旧GPU／modem／SSC缺陷未关闭，whole_system_healthy=false。

## 源码回退与下一步

SDK `/home/cy122/x2pro-linux/libcamera214-root/work/libcamera299-inline` **现为303源码**，续作使用303/build-candidate.py，不能重放302／300／299安装器覆盖。303 private根`E:/edk2-samurai-out/kernel303`；独立joint及AE包和哈希见303两份bundle收据，均未上机。302已测源码和最终可运行包已核对保全；源码回退方法见[303](reference/kernel303/README.md)。

接回手机后先核当前boot及资源，再`303/launch-capture.py joint r1 isolated`，按终态poll并执行`analyse-joint.py r1`；脚本不会重复已有运行目录。20000µs×2与10000µs×4共18次联合变化，核36真实写入、有效帧及BHIST／四Y分区过渡。只有实机分析passed后启动器才允许AE。补真机隔离、变光收敛、取消／丢SOF／worker错误恢复，再推进RGB统计／AWB、多摄／模式、EEPROM校验与正式IQ。纯色／遮光延期不妨碍其它测试。

内核构建输出/mnt/samurai-full282/build；按284/storage.py核backing并保留Rust环境。稳定回退#290及独立778模块、k132776／248备份保留；旧产物清理与重建见[维护收据](reference/maintenance-2026-10-19/README.md)。旧302运行均终态，不盲目重放。[操作边界](WORKING-BOUNDARIES.md)
