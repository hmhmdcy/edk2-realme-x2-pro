# Realme X2 Pro 当前检查点

2026-10-16，227：FastRPC完整发布/端点owner/模块保活候选构建及11例原函数故障注入通过，尚未部署。实机旧驱动FD1/refcount0，不据此热卸载。r13/r8、boot219/e49/fae1保持；226已注UTC/XTRA，四轮仍零CNR。全外设goal active。[227](reference/kernel227/README.md)、[226完整交接](archive/NEXT-SESSION-through226-2026-10-16.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- 运输reference/kernel226/host.py，严格USB邻居/原公钥；227只读baseline guard /var/lib/samurai/k227-baseline/boot-id-private.txt，与226及219-runtime同boot。218/219-before-reboot旧身份不可用。227无服务/模块/电源改变，三DSP running、taint/五fault0；所有226 GNSS会话终态、无活动构建。
- boot219 156f0370…/DTB a214fd6b…，Image183 bfa72dd9…/logdump183 e73754c7…；IMX471 e49dab26…/29536B、CAMSS fae1ed40…/777360B，772ko保持。FastRPC仍189原模块88553112…/50240B，已在设备k227-baseline及私人227备份。
- libcamera/IPA/tools/GStreamer/v4l2=99990.7.2-r13、config/stack=0.1.0-r8。CPU/system heap YAML保持，通用堆root/video0660+uaccess、FastRPC池root0600。WP手动UID10000，重载须现取argv/env。
- IMX471 CCI1 master1/0x10、MCLK2 19.2MHz、4lane/CSIPHY2/独立TITAN_TOP；默认1928×1088/2304×1728。4608×3456双实验开关当前N。TPG普通Bayer不证明真实Quad颜色。223真实SOF/控制快照、224 RAW-only统计/live取消、225手动AE/source-cookie/start控制及无效统计hold已部署。
- 225候选八例1024帧、安装后256帧、三次同Camera五配置40请求、16MP RAW/RGB各36帧、cam/GStreamer各6帧及48算法断言通过。光学2/1延迟未标定。223暗光RAM统计RAW62–133/std约2.66/相邻约56.2%变化，非全零；未保存场景/开灯。实际颜色/几何/FOV/GUI/RGB性能仍开放。
- 最终相机/CCI/CAMSS休眠，前摄双电源关/用户0、参数N；GPS0/Signalsfalse/rate30，watch空闲0workers、chrony Normal，BT关无连接。MM191 b350c55b…；State−1/原因2/Power1，DMS shutting-down。用户明确无SIM：缺卡符合条件，业务待有卡，GNSS不依赖SIM。

## 源码、产物与回退依据

- canonical kernel /home/cy122/pmos-samurai-kernel136/kernel仍216 IMX/旧CAMSS，25tracked/11untracked、16798符号/772模块；不刷旧canonical Image/DTB。当前相机源/对象/锁在223及camera/kernel/0005。227核对51相关文件及git状态/diff保持；模块构建走外部M=，未写canonical。
- canonical相机配方/部署锁r13/r8，20补丁/13包/34ARM64 ELF/5IPA/Qt/Python。SDK /home/cy122/x2pro-linux/libcamera214-root原/work/libcamera2254项恢复，当前成功缓存libcamera225-r13-built；r12=225-built、r11=224-r11-built。IPA214/APK203私钥外置复用。
- r13→r11/config-r6七包降级：设备/var/lib/samurai/k224-r11-package-candidates/forward及私人224/camera-forward-repo-r11，恢复225事务k225-r13-package-transaction前world/repo/配置并重载WP，保持fae1/e49；降级模拟通过，未完整往返。旧r11→r8/82c为历史配套，不混用。
- 227最终FastRPC候选源f378afed…、模块7ca5d442…/50216B、vermagic同183；私人227/fastrpc227-candidate-private.ko。隔离目录/home/cy122/x2pro-linux/fastrpc227-publication；完整补丁/源码与构建锁、11例测试和ELF owner证明在reference/kernel227。原版负对照检出未初始化kref；189 freezer逐字保留。只完成候选，未改默认模块或loaded-note，未改内核源锁。
- 私人227/current-work-private.json是本阶段胶囊。226原生最终117成员归档、初版87成员保留；225原生191、224为416、223为281。USB严格邻居/64KiB只绕过截断，根因开放。226镜像8307文件/HEAD5c80582且无stage/commit/push；227镜像由私人收据确认。

## 续作与已知风险

下一步优先FastRPC受控启动部署：先核清rootfs模块路径、samurai-ssc和initramfs，准备原模块回退，现取身份后才重启；验新boot/loaded-note、实际FD模块保活及正常传感器读数。旧驱动owner缺失使FD1而ref0，不能热卸载。候选含完整初始化、ready/open原子准入、devm owner跨endpoint destroy、DMA指针恢复、.owner及exit逆序；仍未实现invoke/put_work/DMA排空，不作SSR安全或reclaim−22修复。不要盲复制2026-10-07三补丁。

后摄先处理P/Q显式初始化依赖；拟议qcom,address-setup-supplier和持久managed device link设计见227/PM8008-DEPENDENCY。gpio-hog与P驱动reset所有权、Q先probe时P早期保持尚未闭合。PLDO VIN未知，不猜供电；IMX319需OF/DT资源/runtime PM保留ACPI D0，GW1新BIN CPHY待独立核验，3M5缺CUSTOM_GPIO按OEM no-op，人像型号未知。

GNSS226四轮90秒，2932有效SNR字段含双格式重复均0/SEARCH，无TRACK/fix；241次缺列表另记。HIGH读回3；helper一次使辅助有效期0→168h，debug掩码0→31/GPS有效位30、来源local4→server3，仍无正CNR。Stop/CID释放/设备关闭通过；继续RF/OEM初始化与天空/Android对照。室内窗边、关灯/无SIM，不把室内当已证根因；不重复191/201 online或209 UTC精度负对照。

三路只读研究授权继续，手机串行。SDK C++仍ARM模拟无ccache；227外部内核模块约3秒不能当libcamera提速证据。BT phase5/只扫描、传感器运动精度/冷启、GPU ISP211 CMA黑帧/unmap349 WARN、Wi-Fi/USB PM、音频长稳/暂无耳机、充电保护、指纹/NFC实卡与rootfs132整合按[清单](linux-port/docs/HARDWARE-STATUS.md)继续。
