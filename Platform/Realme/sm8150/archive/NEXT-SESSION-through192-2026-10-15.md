# Realme X2 Pro 当前检查点

最后核对：2026-10-15，阶段192，完整外设goal active。两颗PM8008真机确认，六份原厂相机供电前缀已独立交叉核对；实体出图仍无。MM191/GPS辅助修复及kernel183/189组合/同boot保持，当前Wi-Fi管理。规则见[边界](WORKING-BOUNDARIES.md)。用户暂无耳机，不重复问。

## 当前部署与实机依据

| 项目 | 最后核对 |
| --- | --- |
| 组合 | kernel183/logdump183、boot/DTB172；modules132覆盖hci_uart185/fastrpc189，Mesa149/UCM173 |
| GPS191 | 50406字节/50片经标准MM注入约0.801秒，49次完成先于ACK，固件有效期0→168小时；XTRA/3服务器 |
| GPS回归 | 300.5578秒/303条NMEA校验全通过，有效GGA/RMC/raw/CNR字段0；in-view最多13不等于跟踪。旁路16条SV事件均无列表，CID/设备清理通过 |
| 最新7036.85秒 | 同189第二新boot/taint0，MM191、三个DSP保持；DMS online/PowerState3，MM仍sim-missing/bearer0、GPS0/刷新30秒。电源仅开启一次；191故障增量0，保留全boot蓝牙重组1 |
| camera192 | P@0x08/09被GPIO1复位；临时释放识别后恢复。Q@0x04/05保持；全局使能均1/LDO均关。六BIN槽位/地址/ID/供电序列与原厂工具一致，未读实体sensor ID |
| 189传感器PM | 45.2784/45.2053/45.2838秒，success3/fail0/RTC3、7266 callbacks err0；醒后四CLI及真实active Wayland UID10000 Claim/Release通过 |

依据：[192相机/复位与解析](reference/kernel192/README.md)、[192健康](reference/kernel192/native-health-validation.json)、[191报告](reference/kernel191/README.md)、[完整注入](reference/kernel191/assistance-end-to-end-validation.json)、[257场景](reference/kernel191/loc-injection-host-validation.json)、[最新状态](reference/kernel191/radio-final-validation.json)。[191逐字快照](archive/NEXT-SESSION-through191-2026-10-15.md)保存上一完整检查点，相对链接按根目录解释。

## 源码、产物与回退依据

- MM固定提交7f0bf17ab518cd78925cf7e53cc0d5c42f88b41a，190能力发现保持。[191补丁](reference/kernel191/modemmanager-loc-injection-order.patch)覆盖UTC/位置/Predicted Orbits/XTRA，独立GTask引用、提前完成保存、分片匹配/回退清理。257生产回调场景/ASan/UBSan、4原版失败/3破坏变体通过；实机为XTRA回退路径，Predicted成功只模拟通过。
- 当前程序SHAb350c55ba334b7d23564136fe3ce19bf37f95db0d374f63cc89351341d9b9ddc，源949132f3…；复用签名SDK/native190增量构建，native190源码树现为191。旧源/未去RPATH程序先备份到k191-mm-build，主机190源保持。编译告警0、去RPATH/系统库通过，APK DB保持，激活文件/INFO恢复。
- 前版190程序fbc40848…在手机k191-mm-deploy/ModemManager.original及主机kernel191/ModemManager.before191；发行版原件4d5a8258…在190。补丁仍需正式入包，APK更新/旧rootfs会覆盖；回退先核当前进程/身份/哈希，不套用旧PID。
- WSL内核/home/cy122/pmos-samurai-kernel136/kernel tracked14：183的12源+hci_qca185+fastrpc189。FastRPC源41c8db5c…/模块88553112…，hci_uart f6c5ed35…；Image/DTB/config保持，Module.symvers16793行/modules.order770。原模块4515b1b2…/原源a15e99ea…在189；不用强卸载运行模块。
- SSC固定1902…文件服务、184独立libssc、每boot一次门控；303来源/24固件只复制私人RAM。A.11路径/lib/firmware/qcom/sm8150/realme/samurai-a11-r187，原00121保留。共享池−22未解决，持续服务不要盲目stop/start。
- 当前boot身份手机k189r2-reboot-runtime/boot-id-private.txt。192 host.py沿用190私有Wi-Fi端点和原HostKeyAlias/公钥；旧USB记录保留。下一boot先只读核身份/端点，再切换。
- 192归档322bfbce…/23文件/逐成员验证；191主归档843c4d47…/42文件、radio补充b6628078…/23文件、各成员及原新程序哈希通过；190主461318d5…/322文件、USB e4bb35dd…及不完整副本、189归档7f80cdca…保留。191核对NV源manifest/蓝牙配置，重要备份未覆盖。BDS164/固件172/FdtBlob129及183/181回退保持。

## 续作与已知风险

1. GPS活跃时DMS仍shutting-down/电源OFF，标准MM开启一次后online/PowerState3，另测90秒仍无fix/CNR；当前保持ON，不重复开启或重启。有效fix/真实接收仍未解决；16条SV事件无列表，接收条件与RF/平台原因未区分。继续本机GPS/RF供电/时钟/固件核对，验证GNSS-only GeoClue/自动辅助加载，排除其它提供者混入；保留正常授权，不冒用Phosh/伪造坐标。
2. 191独立UTC ACK/status0/释放/关闭通过，190失败保留。生产时间/位置回调只做主机顺序覆盖；168小时不证明跨基带重启保留。分片完成按Part Number关联，不能简单按indication事务号归组。正式打包/冷启/长稳开放。
3. USB190双向IPv6不通但同boot无所列kernel故障，一次gadget重绑无正向恢复证据；Windows网卡复位拒绝访问。Wi-Fi管理可用，继续USB数据/邻居链路定位。此前磁盘表格误读已纠正，实际约80GB可用，未删除/迁移材料。
4. Wi-Fi189第2轮35秒未关联，后经第3轮PM才恢复，不称自行恢复。BT phase5/3.2Mbps/chunk13/partial0/firstff重组1不同于185旧phase2前导00，按边界只扫描。
5. FastRPC普通信号/freezer竞态、186共享池stop/start/reclaim−22/SSR及传感器运动/方向/亮暗/精度、冷启/长稳开放。失败SCM原型ba187458…源/95c9e2b0…模块不当修复；VMIDs3/5/6，勿试遍未知owner或隐藏错误。
6. Online前后两卡位no-atr-received，Slot接口absent/active；固件结果不替代物理插卡确认。MM仍sim-missing，继续卡槽/UIM/注册/数据/通话/SMS。camera192确认P/Q及复位、芯片全局使能均1。前摄slot2需GPIO29、VIO/VANA/VDIG/19.2MHz/RESET；OEM 1.05/1.10V实际取整1.056/1.104V已核；四组PLDO输入/冷地址/CCI/出图待解；IMX471主线仅ACPI/vana，TPG不是实体出图。其它见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。

导航：[会话索引](sessions/INDEX.md)、[文档索引](DOCS-INDEX.md)。
