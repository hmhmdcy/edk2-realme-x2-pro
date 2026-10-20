# Realme X2 Pro 当前检查点

2026-10-19：[303硬件AE实机](reference/kernel303/README.md)、[304原厂EEPROM解码](reference/kernel304/README.md)。目标active、未完成。303真实联合控制480帧及AE960帧通过所述检查；当前低照度达到传感器上限，目标亮度收敛尚未验证。304仅离线解码，未应用个体调校。

## 当前部署与启动身份

已通过原严格密钥Wi‑Fi核实仍为同一#298／7.3.0-rc6-rmx1931-samurai-k298+启动，taint0；303三次运行均终态并恢复资源。Windows USB设备报告端口重置失败，NCM未出现；USB问题未修，不再将它视为手机整体离线。

内核树`/home/cy122/x2pro-linux/camera279-isp-kernel`，samurai-blc298／c5e118faec21a6c4bd2e7d5b86b3b21ad9dc2117。Image、778模块、boot276、DT及固件未改。产品libcamera0.7.2-r24／config-r19与PW／SPA／Gst1.6.9-r3仍RAW＋CPU ISP；303 opt-in候选未安装，没有刷写／重启。

Image SHA eb8054e69991528cad4f126d7723b7ef4869b288fb85c992f4803cbfeab5ddaf；logdump dfef7be4f358c5c16e8e716a60c24da8a139de73b1e07912d70f2b58613d80df；boot 0d6bbc0255fc7a44340b2c2c6a20f2bfa807f683f69dd20a3fb130d961dc4c64；DTB dcdd74ec903520c7023fa28badcb293b2e4e26ee5bac639497c63d53536b2c8d。

303/host.py现在使用已核对的原密钥Wi‑Fi端点，每次命令先比较本机boot与#298 guard。304沿用它，私人根各为E:/edk2-samurai-out/kernel303和kernel304。entity按真实媒体图发现，不固定CCI编号。[部署锁](linux-port/camera/deployment-lock.json)、[源码锁](linux-port/camera/kernel/source-lock.json)

## 最新证据与边界

- SoC保持#298 VFE175图像／参数／线性Y BHIST共享SOF，WB／BLS经标准参数接口。303复用通用libipa AGC／Histogram／ExposureModeHelper，模组策略独立YAML；没有新增内核、DT或通用算法补丁。[分层／运行收据](reference/kernel303/checkpoint-validation.json)
- 联合恒EV：20000µs×2与10000µs×4，18次双控、36实际写入、480帧。BHIST及四Y分区90域未检出混合EV瞬态，写入均SOF＋2，限定IMX3191632×1224当前模式。[独立核对](reference/kernel303/joint-physical-validation.json)
- AE隔离／签名线程各480帧，共17个生效revision、34写入、960帧标准Auto曝光／增益元数据；81个可辨识响应域与有效元数据同帧。提议到生效4 SOF、真实写入到生效2 SOF。图／控制／9供电及PM恢复、匹配worker退出，新增所测fault0。[隔离](reference/kernel303/ae-r1-association-validation.json)、[线程](reference/kernel303/ae-r2-association-validation.json)
- 四轮当前低照度均最终3331行／16倍增益，稳定低于0.16目标；严格0.01目标误差检查false，上限约束正确，不能称目标收敛。已请求把后摄朝向较明亮普通场景，待补正反方向收敛。仅双Auto或双Manual启动，混合及运行中模式切换拒绝；WB固定，RGB AWB、动态帧长、防频闪及完整IQ未做。
- 主机真实DSO／线程各720帧合成模型通过，合计1440不算实机帧。QEMU clone3 ENOSYS阻止主机隔离worker，但真机隔离已独立通过；13字节生成序列化和302源码补丁重放另测通过。
- 304证明旧EEPROM XML后半错位：WB qValue0／LSC mesh1与原BIN类型表的1／221不符。重新定位五光源WB与LSC，4420通道值经独立C解码器在两份读回中逐值核对。完整schema、factory checksum／有效标志、模组绑定、LSC几何／尺度及golden合成未确认，不应用个体数据。[304](reference/kernel304/README.md)
- 原厂IMX319 BLS16模式／288区域均960 U14仍仅OEM参考；临时WB不是本机正式校准。5传感器／镜头、两CCI、CAMSS均自然休眠、9供电关闭用户0、taint0；961包／50相机载荷／778模块全量沿用300，未重跑。旧GPU／modem／SSC故障未关闭，whole_system_healthy=false。

## 源码回退与下一步

SDK `/home/cy122/x2pro-linux/libcamera214-root/work/libcamera299-inline` **为303源码**；使用303/build-candidate.py，不重放302／299源码安装器。302已测源码与最终可运行包保全，见303说明。joint-r1、AE-r1／r2均终态，不盲目重放。AE-r2包含高低两种启动值，包与运行收据固定版本。

继续明亮场景双起点AE／错误恢复，补RGB统计与AWB、其它sensor与模式、EEPROM校验／几何、正式暗场／颜色／阴影调校。S5K3M5仍有CROP_DEFAULT／静态属性缺口，应优先下沉sensor驱动，不能在handler伪造几何；先查现有Hotdog同sensor方案并核本机寄存器窗口。用户延期纯色／遮光保持，不阻碍其它适配。

内核构建输出/mnt/samurai-full282/build，按284/storage.py核backing并保留Rust环境。稳定#290及独立778模块、k132776／248备份保留；旧产物清理见[维护收据](reference/maintenance-2026-10-19/README.md)。本地内核派生／产品配方仍未证明上游接受或零补丁升级。[操作边界](WORKING-BOUNDARIES.md)
