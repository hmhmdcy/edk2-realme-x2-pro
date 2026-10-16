# Realme X2 Pro 当前检查点

最后核对：2026-10-15，阶段201，完整外设goal active。GPS辅助窗口/UTC自动补时服务已部署，同boot真实UID10000 GeoClue启停与自动触发通过；仍无fix/正CNR。4705.66秒同200启动，taint0/所列fault全0。见[边界](WORKING-BOUNDARIES.md)、[201报告](reference/kernel201/README.md)。

## 当前部署与实机依据

| 项目 | 最后核对 |
| --- | --- |
| 基础组合 | boot200/静态DT2e2f8e64…/CAMSS82cbc052…；仍Image183/logdump183、modules132覆盖hci_uart185/fastrpc189、Mesa149/UCM173/MM191 |
| GPS辅助服务 | /usr/sbin/samurai-gnss-assist cf3d92a4…，init54b81745…/OpenRC default已启用；GPS active才工作，当前空闲；没有改电源或Setup/Start |
| GPS数据 | 旧窗口10-02 08至10-09 08 UTC已过期；新51331字节30370293…标准注入后为10-15 05至10-22 05 UTC，独立查询核对。UTC后GGA时间不再为0 |
| 实际定位 | GNSS-only GeoClue UID10000五轮183/92/92/182/32秒，NMEA4/91/97/260/37，校验错0；GGA有效/RMC active/raw fix/正CNR/GeoClue位置事件全部0 |
| 电源与清理 | 一次标准Power1→3：DMS shutting-down→online；当前MM−1/原因2、bearer0，GPS0/Signals0/刷新30；桌面定位原false已恢复，测试policy/DesktopId/程序已移除 |
| 整机 | ADSP/SLPI/modem running，SensorProxy三Has true；4705.66秒taint0，WARNING/Oops/GPU/SLPI fatal/BT重组0。NV源保持，201未重启/刷写 |
| 相机200证据 | 新boot四轮12帧IMX471 RAW10、原频率/自身MMCX384→0，无外部helper；最后GPIO12/15/29 CTL1/1/1、P0/Q1与七Q LDO恢复。临时相机资源仍全部撤销 |

依据：[辅助](reference/kernel201/assist-native-validation.json)、[GeoClue](reference/kernel201/geoclue-native-validation.json)、[健康](reference/kernel201/native-health-validation.json)。[200逐字快照](archive/NEXT-SESSION-through200-2026-10-15.md)保留完整相机源码/回退/引脚索引，相对链接按根解释。

## 源码、产物与回退依据

- WSL /home/cy122/pmos-samurai-kernel136/kernel；200所有源保持，25 tracked改动/11 untracked未暂存。Image183 bfa72dd9…、canonicalDTB22c1f2ad…/config55f1f0a3…、符号16793行/顺序770保持。[收据](reference/kernel201/source-final-validation.json)
- 新产品源reference/kernel201/samurai-gnss-assist.py/initd，安装cf3d92a4…/54b81745…，watch-state记录启动源hash；依赖Python/dbus/GI Qmi/Qrtr/chrony，APK/新rootfs未整合。[部署收据](reference/kernel201/assist-deployment-validation.json)
- 服务active触发串行worker、活动每小时复查/失败十分钟后再试；chrony同步后自身LOC补UTC/查绝对有效期，过期走TLS全球URL/MM注入/读回。当前有效便跳过，已知无效窗口私人缓存。37检查及UTC/QMI清理原生通过，详见201报告。
- 同boot一次自动启用/完成见k201-product-snapshot/watch-state.json；受控试验前重启后当前计数0且idle，新快照k201-product-snapshot-r3。区分历史验收与重置计数。
- 受控旧e905a729…注入一次返回Core.Aborted，有效期仍当前，未建立过期现场、未继续桌面试验/未强制清缓存。备好的新文件无需回注。完整自动过期刷新分支仍未原生证明，不能将模型或手工更新当成该分支通过。
- QMI窗口秒/小时、UTC注入毫秒；GeoClue支持无SIM GPS，refresh0是不节流，详见201。
- 首次AccessDenied/父清理失败与独立清理保留；最终Signals1/rate0正常化0/30，阶段初未记、归因未证。桌面设置前后false已核。
- MM191运行文件b350c55b…保持，APK更新会覆盖原MM补丁；当前Power3由201一次标准on对照留下，仍无真实SIM业务。不盲目reset/online，也不把SIM-missing/no-atr当物理无SIM证明。
- boot200在主机kernel200/boot-partition-k200-mmcx.img，5109097b…/100663296字节；DT2e2f8e64…，驱动82cbc052…四域/build-id已核，频率表保持。详情见200。
- 回退boot172 77e1a272…在主机kernel200/boot-rollback-k172-private.img；旧CAMSS e9b73f4c…手机k200-baseline/k200-deploy及归档。须fresh身份后旧boot/旧模块配套，保留logdump183 e73754c7…/NV/persist；201只加辅助程序/服务，无启动分区变更。
- 相机仍开发overlay/正常启动空sensor图。200 sensor-only overlay5109da88…/MCLK sleep pull-down，固定FW samurai/k196-front.dtbo；VIO helper允许RPMH初始unknown。原模块/源码hash与GPIO/PMIC完整细节见200快照，全部临时资源已撤销。
- GPIO12/15/29新boot CTL全1，地址0x0390c000/0x0390f000/0x0351d000（旧boot15为0）；200首6帧后单次恢复，后6帧改sleep后完整恢复。临时VIO301已撤销，下次phandle重读。P0/Q1、Q4/5、8无响应仅warm；PLDO四输入未知，仅S8C已证，勿套hotdog布线。
- 当前boot身份k200-runtime/boot-id-private.txt及k201-baseline；host201沿host200新USB peer/原公钥，Wi-Fi端点私人kernel190文件/实现kernel200/host-before-newboot.py。新boot重新发现身份、端点与Phosh bus，不用旧guard。
- 122份最终原生文件及首版105份均核对；NMEA/配置/会话端点/身份/归档指纹只在E:/edk2-samurai-out/kernel201。200四张RAW及更早归档仍私人保存。[收据](reference/kernel201/evidence-export-validation.json)

## 续作与已知风险

1. 先验证普通重启后OpenRC辅助服务与冷时间GPS恢复；不先手工UTC以免掩盖自动路径。新boot重取UID10000实际Phosh环境并只测GNSS来源；helper不能当GPS fix完成，自动过期全链路/活跃中停止/SSR还待验。
2. 继续GNSS电源策略（含用户WWAN/rfkill偏好、低功耗模式）、RF/LNA/时钟/本机OEM资源与真实接收条件；online已有GSV但无CNR不等于RF正常。真实fix/精度/冷启长稳仍开放。不要为强造过期状态删除未知校准数据。
3. 补辅助服务与MM正式APK/新rootfs；推进相机持久化板级/用户态、PLDO输入/双PMICcold、其它镜头模式/曝光色彩方向/持续帧率。相机已有12帧不是完整日用完成。
4. 蜂窝真实注册/数据/通话/SMS、BT phase5历史重组、Wi-Fi/USB PM、FastRPC普通信号/freezer/共享池−22/SSR、传感器物理精度/长稳继续。BT只扫描，振动不新增脉冲。旧193/199告警属于旧boot，本boot0；其余见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。

导航：[会话索引](sessions/INDEX.md)、[文档索引](DOCS-INDEX.md)。
