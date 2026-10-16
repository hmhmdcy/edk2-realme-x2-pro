# Realme X2 Pro 当前检查点

2026-10-16，225收尾：完整libcamera r13/config-r8已安装，前摄独立曝光/增益控制通过；boot219/e49/fae1保持，全外设goal active。[225记录](reference/kernel225/README.md)、[边界](WORKING-BOUNDARIES.md)、[历史through224](archive/NEXT-SESSION-through224-2026-10-16.md)。

## 当前部署与已验证状态

- 运输reference/kernel225/host.py，严格USB邻居/原公钥；guard /var/lib/samurai/k225-baseline/boot-id-private.txt，与219-runtime/220至224-baseline同boot。218及219-baseline/before-reboot旧身份不可用。225事务verified，构建/原生测试均终态；BT只扫描，不新增振动。
- boot219 156f0370…/DTB a214fd6b…，Image183 bfa72dd9…/logdump183 e73754c7…；225未刷/重启。IMX471 e49dab26…/29536B、CAMSS fae1ed40…/777360B及loaded-note核对。772ko保持，CCI/PM8008等指纹见219。
- libcamera/IPA/tools/gstreamer/v4l2=99990.7.2-r13，config/stack=0.1.0-r8；944包/937无关记录/49payload保持。CPU/system heap YAML不变，通用堆root/video0660+uaccess，FastRPC池root0600。WP手动UID10000，重载须现取argv/env，桌面/PipeWire保持。
- IMX471 CCI1 master1/0x10、MCLK2 19.2MHz、4lane/CSIPHY2/独立TITAN_TOP；默认1928×1088/2304×1728。4608×3456须模块+用户态双实验开关，当前N。TPG普通Bayer不证明真实Quad颜色。
- 220逐配置sensorInfo、223 CAMSS真实SOF号与捕获控制快照、224 CPU RAW-only统计及live请求取消修复保持。225的0018补独立Auto/Manual、AeEnable优先级、自动期间忽略手动值、切换冻结/恢复、start前控制；来源cookie随DelayedControls历史，模式/值按捕获来源而非当前请求。0019线程start输出转发，0020无效统计保持最新准备目标。
- r13候选2M/4M RAW/RGB×普通/隔离IPA八例1024帧九阶段控制通过；安装后系统默认RAW2M/RGB4M256帧通过。147/35帧捕获模式不同于新请求但元数据正确，换算<1µs。候选两模式及安装后各同Camera五次重配40请求（20完成/20取消）通过。安装后16MP RAW/RGB各36帧、cam/GStreamer各6帧通过，实验N/WP恢复。48实际算法断言通过；光学2/1帧延迟未标定。
- 暗光证据仍223：4MP RAW/RGB各6帧只RAM统计，RAW62–133/std约2.66/相邻约56.2%变化，均非全零。225未改变照明或保存场景；CPU ISP内部读RAW统计，客户端不检查场景像素。亮光颜色/几何/实际曝光未验收。
- 225最终相机/CCI/CAMSS休眠，两前摄电源关/用户0、图案0/参数N；GPS0/Signalsfalse/rate30，watch空闲0workers、chrony Normal；三DSP running、BT关无连接、taint/五fault0、NV源保持。Modem State−1/原因2/Power1；UIM absent/no-atr是221历史结果，不证明未插卡。

## 源码、产物与回退依据

- canonical kernel /home/cy122/pmos-samurai-kernel136/kernel仍216 IMX cc756279…/对象1388a070…/旧DTB22c1…及原CAMSS82c源；25 tracked/11 untracked、16798符号保持。当前IMX源61931497…/e49/a214与223 CAMSS另存，不刷旧canonical输出。223 SOF四源/模块在私人kernel223，公共camera/kernel/0005及内核源锁锁定；180源/对象/模式按Linux JSON核对，225未改内核源锁。
- 当前canonical配方/配置/部署锁r13/r8，完整20补丁/13包/34ARM64 ELF/5IPA/Qt/Python保留。SDK /home/cy122/x2pro-linux/libcamera214-root原/work/libcamera2254文件/链接/模式恢复，无before225快照；当前缓存work/libcamera225-r13-built，r12为225-built、r11为224-r11-built。r12首构建失败及无效统计失败保留，未部署；同算法fixture未改。原IPA214/APK203私钥外置复用，二次逐字重建未验。
- 当前r13→r11/config-r6仅降级七包，使用设备/var/lib/samurai/k224-r11-package-candidates/forward及私人224/camera-forward-repo-r11；恢复225事务k225-r13-package-transaction前world/repo/配置，重载WP，保持fae1/e49。签名/payload/降级模拟通过，未完整往返。r11→r8及r7/82c是历史配套回退，不混用。IMX/boot回退依据见through224，操作前现取身份。
- 私人kernel225/current-work-private.json；225原生191成员归档逐成员核对，r12主机失败日志另存私人225。USB严格邻居/64KiB为截断绕过，根因开放。224归档416、223为281成员。

## 续作与已知风险

前摄本阶段控制链收尾，下一步优先后摄/GNSS/蜂窝主要阻塞，不无端重复通过的矩阵。SDK C++仍ARM模拟且无ccache；先验证匹配Alpine/musl的宿主cross-native2/Meson和增量缓存，再实测收益。用户已授权并启动三路只读研究：GNSS、后摄及BT/传感器/蜂窝；主流程筛选结论，手机操作始终串行。[安排](reference/kernel225/ACCELERATION-PLAN.md)。

真实CFA/几何/颜色/方向/光学曝光/延迟/标定/GUI/性能、后置GW1/3M5/IMX319/人像及未知PLDO输入开放，不猜供电。GPU ISP211 CMA/黑帧/unmap349 WARN/taint512开放，149 CCU修复保持。

GNSS无fix/正CNR、室内窗边；221GPS强制/GLO-BDS-QZSS-GAL启用/四黑名单0不证明RF，多频GET error57不证明无L5。209缩小UTC误差未改善约6秒报告，勿盲重复。[相关机型](reference/kernel205/GNSS-RELATED-DEVICES.md)。207MCFG173文件/8807671B RAM复制、mdtime/PDC活动无pending通过，mcfg.tmp仍0B；SIM/注册/数据/通话/SMS开放，外发需明确目标。

BT phase5、传感器FastRPC/SSR/首启、Wi-Fi/USB PM、音频长稳/耳机（暂无）、充电保护、指纹/NFC实卡与rootfs132整合按[清单](linux-port/docs/HARDWARE-STATUS.md)继续，全goal active。
