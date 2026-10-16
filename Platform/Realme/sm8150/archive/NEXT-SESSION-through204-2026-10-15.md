# Realme X2 Pro 当前检查点

2026-10-15，阶段204，完整外设goal active。已部署蓝牙UART RX wake/sleep；首轮45.14秒RTC PM/醒后扫描通过，但phase5启动错误仍复现。第二次普通启动三个DSP/SensorProxy恢复，最后610.72秒taint0/fault0。[204报告](reference/kernel204/README.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与实机依据

- boot204 cdd16e29…/静态DTB b9d9c2a1…，CAMSS82cbc052…四域保持；Image183/logdump183、modules132覆盖hci_uart185/fastrpc189、Mesa149/UCM173。
- UART13补GPIO46下降沿RX wake，sleep CTS/RTS下拉、TX/RX上拉；本机19781与X3参考支持此接线。当前power/wakeup enabled，原21固件/3.2Mbps/供电保持。首轮9设备→45.1438秒s2idle→13设备，success1/fail0/RTC1/错误增量0。RTC测试不证明外部BT事件唤醒。
- 首轮仍phase5/3.2Mbps/chunk13/partial0/firstff重组1，未修复；另SSC文件服务就绪退出、SLPI清理offline。未同boot重试。补观测源码9a1fd03f…记录退出码/ownership；第二boot自动真实加速度/光线readiness和三Has通过，不把偶发失败改成已修复。
- MM/openrc/udev 1.25.95_git20261005-r1、libmm-glib原r0，helper/stack0.1.0-r0，五签名APK保持；MM b350c55b…、helper42168f33…/init54b81745…不变。新boot加载inode正常，旧203(deleted)仅历史。
- 新boot helper自动空闲UTC第3次准备成功。首次180秒UID10000 GNSS-only：188条NMEA/176推进GGA时间，fix/正CNR/坐标事件仍0。辅助窗口0小时→自动刷新，当前1792054800/168小时，独立复核通过；准备3/完成3、worker1/完成1、idle。
- Power1/State−1/原因2/bearer0；GPS0/Signalsfalse/rate30，桌面定位恢复false、临时测试资源清理。三个DSP running/SensorProxy三Has true，CAMSS自动绑定，无新增相机帧；200四轮12帧RAW10仍仅历史，正常boot仍空sensor图。

[启动r2](reference/kernel204/reboot-r2/runtime-validation.json)、[健康](reference/kernel204/reboot-r2/native-health-validation.json)、[GNSS](reference/kernel204/reboot-r2/geoclue-first-session-validation.json)。历史逐字快照：[203](archive/NEXT-SESSION-through203-2026-10-15.md)、[200相机完整索引](archive/NEXT-SESSION-through200-2026-10-15.md)，相对链接按根解释。

## 源码、产物与回退依据

- 内核WSL /home/cy122/pmos-samurai-kernel136/kernel。原203源子集保持，board DTS439db943…已改/编译；部署为保持旧phandle的b9d9c2a1…静态候选。旧canonical DTB22c1f2ad…未覆盖，不能把它当boot204产物。Image bfa72dd9…/config55f1f0a3…、符号16793/顺序770、25 tracked/11 untracked未暂存保持。[源码](reference/kernel204/source-final-validation.json)
- 产品源linux-port/packages和linux-port/ssc；MM/轨道补丁/签名仓库等详见203快照。手机仓库/var/lib/samurai/packages/gnss-203，配置/etc/apk/repositories.d/50-samurai-gnss.list；仅公开key在手机。私钥仅主机/home/cy122/x2pro-linux/samurai-packages203/signing-private，勿复制或重生成。离线rootfs132未更新，Mesa等仍可能被官方包覆盖。
- 当前fresh身份手机/var/lib/samurai/k204r2-runtime/boot-id-private.txt；仅用reference/kernel204/reboot-r2/host.py的新USB peer/原严格key。kernel204主host属于首轮旧boot，203/202 host更旧。当前UID10000 Phosh实际bus在k204r2-runtime/desktop-env-private.json，勿猜/run/user/10000/bus。
- boot204主机kernel204/boot-partition-k204-bt-wake.img，cdd16e29…/100663296字节；回退boot200 5109097b…在kernel204/boot-rollback-k200-private.img，与当前CAMSS82cbc052…成对。更早boot172/旧CAMSS回退见203/200快照；fresh身份后执行，保留logdump183 e73754c7…/persist/NV。204共刷boot一次、两次受控启动，第二次无flash。
- 相机overlay5109da88…/MCLK sleep下拉，FW固定samurai/k196-front.dtbo；VIO初始RPMH unknown允许；200 GPIO12/15/29 CTL1/1/1，0390c000/0390f000/0351d000。旧boot15=0不沿用，临时phandle301已移除。PM8008 P0/Q1及Q4/5只warm证据，仅S8C输入已证；四PLDO输入未知，勿套Hotdog PM8009/BOB/master0。新boot下次操作前重读。
- 首轮468文件/末轮441文件私有归档与逐成员校验通过；NMEA/端点/身份/配对key/归档指纹仅E:/edk2-samurai-out/kernel204及reboot-r2。初次BlueZ Not Powered前置错误、第一次final-health错误假定GPS空闲窗口仍有效、UTC观察超时、SSC/BT启动失败均保留。

## 续作与已知风险

1. BT phase5下一步采集出错chunk内容及baud/flow/IBS时序；不得扩大185仅phase2 NUL过滤或盲丢0xff。RX wake/sleep已补，但外部事件唤醒、配对/连接/音频及长稳未验收，按边界只扫描。
2. SSC首次退出根因未知，第二boot恢复不是修复证明；现有观测可留存下一次退出码。FastRPC普通信号/freezer/共享池−22/SSR、传感器物理运动/方向/亮暗/精度长稳仍待验。
3. GNSS真实fix/CNR/RF/LNA/接收条件/电源/精度长稳开放；首次请求抢先/SSR、非零过期窗口仍未验收。OEM19781仅通用GNSS UART注释，勿杜撰LNA电源。可只读查PDC/MCFG时序；Hotdog蜂窝也未完成，勿停当前MM或激活外机配置。
4. 相机常态资源/用户态、四PLDO输入/双PMIC真cold、其它镜头模式/曝光色彩方向/持续帧率；蜂窝真实注册/数据/通话/SMS、Wi-Fi/USB PM及完整rootfs继续。203 USB大SCP停顿未修复；本轮PM中的传输暂时失败未触发重复试验。SIM-missing不证明物理无卡；用户无耳机勿再问，振动不新增脉冲。[硬件清单](linux-port/docs/HARDWARE-STATUS.md)

导航：[会话索引](sessions/INDEX.md)、[文档索引](DOCS-INDEX.md)。
