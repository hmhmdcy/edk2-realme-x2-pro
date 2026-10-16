# Realme X2 Pro 当前检查点

最后核对：2026-10-15，阶段195，完整外设goal active。PM8008地址迁移失败后重新请求自身复位，37场景通过且旧版失败；新模块cold/warm真机probe保持。可撤销VIO phandle已让标准OF精确查到真实1.8V，撤销后节点/电源状态恢复。IMX471尚未实体probe或取帧。193实体ID0x0471、r2时钟WARN/taint512保留；规则见[边界](WORKING-BOUNDARIES.md)，用户暂无耳机。

## 当前部署与实机依据

| 项目 | 最后核对 |
| --- | --- |
| 部署 | kernel183/logdump183、boot/DTB172、modules132覆盖hci_uart185/fastrpc189；Mesa149/UCM173、MM191 |
| 相机195 | 新MFD cold/warm各通过，七LDO采样与P0/Q1恢复；VIO精确OF lookup1.8V、未enable/设压，节点/对象/状态恢复，临时模块撤销 |
| 最新16368.69秒 | 同189第二boot，taint512/WARN1来自193r2；ADSP/SLPI/modem running，MM191/PowerState3/GPS0，SensorProxy三个Has true；BT重组1，Oops/GPU/SLPI fatal0 |
| GPS191 | 标准MM 50406字节50片XTRA注入，49片完成先到，固件有效期0→168小时；UTC成功。300秒303NMEA仍无fix/CNR，online后另90秒仍无fix |
| 传感器189 | 三轮45.2—45.3秒PM，success3/fail0/RTC3，7266 callbacks err0；四CLI及Wayland UID10000 Claim/Release通过 |

依据：[195报告](reference/kernel195/README.md)、[MFD原生](reference/kernel195/pmic-native-validation.json)、[VIO引用](reference/kernel195/vio-native-validation.json)、[最终健康](reference/kernel195/native-health-validation.json)。[194逐字快照](archive/NEXT-SESSION-through194-2026-10-15.md)保留旧源、失败及回退索引，相对链接按根目录解释。

## 源码、产物与回退依据

- WSL源/home/cy122/pmos-samurai-kernel136/kernel。原14源保持；当前19个tracked改动，新增Sony绑定与4个OF开发C文件，均未暂存。195开发代码/增量补丁checkpatch通过，绑定沿194。[当前源/补丁](reference/kernel195/source-final-validation.json)
- IMX471源30e94aa1…、模块62e5f050…/CCI库f9c9272a…；MFD源057ccd62…/模块d1ff82c0…；PMIC fixture e5b9405e…，VIO helper源868c9b2a…/模块9e83668e…。均树内Kbuild/ABI/导入符号通过，非强制加载。194电源7场景/195地址37场景ASan/UBSan通过，旧地址函数被新增回归检出；目标W=1无告警，全树另5条既有告警。模块仅私人临时加载，安装目录未改。
- [前摄候选DT](reference/kernel194/sm8150-samurai-camera-warm.dts)引用真实三路电源/选择GPIO/CCI1 master1/DPHY2；Q有reset/initial-address，P暂用GPIO1 hog保持复位。独立DTB d79dd115…未部署；Sony严格schema通过，PMIC仍缺四路PLDO输入报4项required，未伪造接线。不是上游完整板级DT。
- Image183 bfa72dd9…、canonical DTB 22c1f2ad…、config 55f1f0a3…保持；Module.symvers16793行/modules.order770恢复。VIO临时phandle301标准OF lookup通过并撤销；正式DT由编译建立引用。193独立前摄PM引用修复/失败保留。运行FastRPC源41c8db5c…/模块88553112…，hci_uart f6c5ed35…；原件回退在189，不强卸载活跃模块。
- MM固定7f0bf17ab518cd78925cf7e53cc0d5c42f88b41a，190能力发现+191 LOC异步/引用/分片/回退修复；257场景/4原版失败/3破坏变体通过。原生XTRA通过，Predicted成功仅模拟。运行b350c55ba334b7d23564136fe3ce19bf37f95db0d374f63cc89351341d9b9ddc，源949132f3…，MM native190源已更新191；签名SDK复用，APK DB未改，正式入包待办，APK更新会覆盖。
- MM190回退fbc40848…在手机k191-mm-deploy/ModemManager.original/主机kernel191/ModemManager.before191，发行版4d5a8258…在190。INFO/激活已恢复。DMS只开启过一次，保持online，不重复reset。
- SSC固定1902…文件服务、184独立libssc、每boot一次门控；303来源/24固件只复制私人RAM。A.11路径/lib/firmware/qcom/sm8150/realme/samurai-a11-r187，原00121保留。共享池−22未解决，不盲目stop/start。
- 当前boot手机k189r2-reboot-runtime/boot-id-private.txt，195基线另存；host195沿用190私人Wi-Fi端点、原HostKeyAlias/公钥。USB190双向IPv6未恢复，一次gadget重绑无正向证据、Windows网卡复位拒绝访问；下一boot重新读身份/端点。
- 195归档10c5f4aa…/37、194 0afa8fa2…/42、193 936fe956…/67均逐成员验证；192/191原件索引保留在快照。BDS164/固件172/FdtBlob129、183/181及NV/校准备份保持。

## 续作与已知风险

1. 组合VIO live phandle、Q LDO约束、pinctrl与CCI，让普通IMX471实体probe/PM，再接CAMSS取帧。当前驱动仅4lane/200MHz/1928×1088 RAW10；[同平台Hotdog仓库](https://github.com/Sr-0w/hotdog-linux-bringup)固定47087509c4289c2580c54f5433e55366b2e00445、WSL /home/cy122/x2pro-linux/hotdog-ref195无checkout。其1748方形/525.2625MHz和CAMNOC补丁已保存私人供比较；PM8009/BOB/gate/CCI1 master0/弹出机构不照搬。主线评审已删除sensor重复PD，先实测正常CCI父层次。前摄193 ID确认，其它BIN仍仅候选。
2. 本次Q复位路径成功不等于整机断电/跨boot通过；若P先占用8，Q安全拒绝且自身保持复位；释放后的迁移错误也请求自身复位，复位调用本身失败只记错、不保证物理恢复。双PMIC顺序仍待设计。四路PLDO父网络未知，不因本次L5 ready补假BOB/VPH；OEM1.05/1.10V请求实际1.056/1.104V已核。其它镜头/完整模式/用户态待验；内部TPG三帧不是出图。
3. GNSS仍无有效fix/CNR，16条SV事件无列表；接收条件/RF/平台原因未区分。继续GNSS-only GeoClue/辅助自动加载及本机RF/时钟核对，正常授权、不伪造位置；168小时不证明跨基带重启保留。
4. 两UIM no-atr-received/Slot absent-active、MM sim-missing/bearer0不证明物理插卡状态。卡槽/注册/数据/通话/SMS待验。BT phase5/3.2Mbps/chunk13/partial0/firstff重组1区别185旧phase2前导00，只扫描。
5. FastRPC普通信号/freezer、共享池−22/SSR，传感器运动/方向/亮暗/精度/冷启/长稳仍开放，不把失败SCM原型当修复。Wi-Fi189第二轮35秒未关联，第三轮PM后才恢复，不称自行恢复；USB独立链路待解。其它见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。

导航：[会话索引](sessions/INDEX.md)、[文档索引](DOCS-INDEX.md)。
