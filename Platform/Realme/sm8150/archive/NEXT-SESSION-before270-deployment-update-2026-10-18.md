# Realme X2 Pro 当前检查点

2026-10-18：[270多摄续作进行中](reference/kernel270/README.md)。用户已要求继续摄像头适配并询问多个后摄与骁龙ISP。已在269同启动取得标准IMX319后摄24帧，以及Snapshot前后切换/两张GUI JPEG/正常退出；既有modem watchdog仍未解决。S5K3M5候选已改用公共供电/静态DTS，匹配模块已暂存，773→774模块；DT-only boot270及双端回退准备完成。当前切换进度必须读270实际事务收据，不能重放安装/切换动作；旧host guard重启后失效。以下269版本数字按旧检查点解释，待本轮部署核验后更新。

2026-10-18：[269收尾](reference/kernel269/README.md)。用户要求停止新增实验、更新文档；本轮已收尾，完整摄像头和整机适配未完成。后续按用户指示续作，不把本轮进展当成全目标完成。

## 当前手机身份

固件仍boot267／Image183，`7.3.0-rc6-rmx1931-samurai-k132+`，773ko／961包。用户打开Camera (Snapshot)后意外重启，原267/268启动guard与PID失效。现用[269 host](reference/kernel269/host.py)、原严格SSH主机密钥和重新发现的私人USB端点；guard `/var/lib/samurai/k269-work/boot-id-private.txt`，本地主机身份收据在私人269目录。不要绕过旧guard或把旧PID当当前服务。

收尾Phosh7908、PW8731/start75856、WP8738/start75860，手机 `/var/lib/samurai/k269-services-current-private.json` 为该次核对权威。续作先重读，用户可能已操作。桌面重建的临时--unlocked用户启动覆盖已恢复，lock/idle偏好未改；当前会话沿用--unlocked至退出。

libcamera五组件r19、config/stack-r14、PW/SPA/Gst1.6.9-r3保持。49项相机包载荷重新核对。五模块当前文件SHA前缀：PM8008 MFD bcdbf711、regulator d4dbb9cd、IMX319 53917b99、IMX471 e49dab26、CAMSS ff9fdfa3，加载note与磁盘一致。双PM8008走公共MFD/regulator及设备树供电，lab模块、板级reset provider和旧loader配置均已撤。[部署锁](linux-port/camera/deployment-lock.json)。

## 已验证与下一步

整屏旋转方向已修：RMX1931板级设备包提供标准udev `ACCEL_MOUNT_MATRIX=-1,0,0;0,-1,0;0,0,1`，X/Y取反、Z保持，原版SensorProxy SSC后端处理。正常竖握及左侧朝上的传感器报告正确；桌面重建后独立观察为left-up／90°，用户确认自动旋转正常。完整左右往返未被观察窗口录下，单独记录用户反馈，不能冒充机器轨迹。当前SSC路径没有内核IIO节点，属于板级用户态配置，不能称DTS修复；后续IIO接入才由驱动消费DT挂载矩阵。[旋转说明与证据](reference/kernel269/README.md#整屏旋转板级配置不改应用)。

桌面原先先于radio／SSC启动，当前标准OpenRC配置改为greetd依赖dbus和iio-sensor-proxy，撤掉相反的before-radio边，依赖缓存更新通过；下一次整机启动顺序仍待验。`samurai-platform 5-r1`与`samurai-desktop 3-r1`完整配方已同步，25项源校验通过，前者同时删除旧实验供电参数和reset softdep。两项手机配置单独部署，APK尚未构建／安装。候选pmaports工作树 `/home/cy122/x2pro-linux/pmaports-camera-common269`，本地提交5e955a7c19355da6962eba9f03874cdf0081dfff，未发布；原目录及其用户改动保持。

Snapshot意外重启未解决。上一启动pstore已保存262132字节，末尾6196秒modem watchdog、6202秒日志结束；未见相机WARN/Oops栈，但证据不足以排除打开相机的关联。旋转规则当时尚未写入。新启动只做一次既有Cairo启动器36.84秒观察，无新增fault，但传感器全程suspended、vb2完成／取出0，未实际取流；这不是相机通过或重启问题修复。随后读取到息屏，标准接口唤亮后输出恢复；按用户要求收尾，未追加第二轮。[重启与补测边界](reference/kernel269/README.md#snapshot意外重启未解决)。

此前268同一旧启动已验证：标准cam72帧、跨框架交替36帧、系统预览1097帧／1081次保留前缀检查、9张后台JPEG；未改Snapshot前后预览、Switch Camera、两次快门及三张GUI JPEG解码通过。这些历史结果保持，但不能覆盖本轮新启动的稳定性问题。[268](reference/kernel268/README.md)。CPU ISP/system heap及Snapshot Cairo/禁用GL、Vulkan、offload回退仍在，默认GPU未修。

内核维护树 `/home/cy122/x2pro-linux/upstream` 当前 `samurai-camera-common`／1f5da50bbcba4fbe89917db7987429fdf078f257，原samurai-bringup/db301b64保留。已删除五个禁用OF实验helper；固件IOVA窗口移到RMX1931设备树，公共CAMSS保留标准DMA mask／完整SG检查和动态调试。40024个实际函数ASan/UBSan案例及旧实现负对照、四类DT schema通过，新旧937节点全部属性语义相同。[269源码及范围](reference/kernel269/README.md#内核收敛与验证边界)。

**新Image＋全部773模块＋DTB已完整构建成功，尚未部署。** 输出 `/home/cy122/x2pro-linux/camera269-full-build-r1`，release `7.3.0-rc6-rmx1931-samurai-k269+`；Image SHA256 9153da19b7ead38943792a84526723fb6d17177a0a2a45939972cd08465a3f61，DTB 51b289d64645a2decd77147a1d0be0ed2165ed3e72890086939da10a1e6e610a。构建已terminal/exit0，勿重启同一事务。五相机模块W=1诊断0，全树1140条尚待分类；其它外设源码与现机对应仍待核，新Image不可直接当已验收产物刷写。完整rootfs尚未重建，候选源本轮未发布，远端状态按268历史收据解释，续作先重读远端。

最后只读健康：无相机进程，269跟踪关闭；四rails disabled/users0，双sensor／双CCI／CAMSS suspended，MCLK1/2关；本次启动warning/Oops/modem/fatal/GPU0、taint0。[健康收据](reference/kernel269/final-health-validation.json)。这不抹除上一启动modem watchdog。所有新事务目录已执行，不能盲目重放采用guard、安装矩阵、重建桌面、拍摄探测或完整构建脚本。

下一步：核新身份与原日志，在真正出帧／窗口可见条件下复现Snapshot故障；核首次启动顺序；审核完整内核与其它外设对应后准备一致Image/DTB/模块和回退再上机；整合可重放用户态/rootfs及发布源。低照度/颜色/相机图像方向、其它后摄、录像、GPU与长稳继续待办。前摄纯色测试按用户延期。旧r15/r10七包回退、267旧模块/boot备份及268事务均保留。

## 其它功能和规则

先读[操作边界](WORKING-BOUNDARIES.md)与[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。NV/校准/工厂备份不误写；电池保护不绕过；切换前核当前身份；密钥和私人数据不公开，蓝牙只扫描、不配对/连接，振动不新增脉冲。PC私人目录为E:/edk2-samurai-out/kernel269及历史267/268；场景、原日志、USB端点、启动ID、密钥和含私人initramfs的镜像不公开。

260桌面GNSS室外300秒280次更新、262次严格校验，停止后LOW_POWER与设置恢复通过；18次未分类、Accuracy=0旧校验问题、冷启/PM/长稳/绝对精度仍开放。[260](reference/kernel260/README.md)。261中文/字体/输入法/商店及Phoc文本输入待办；full upgrade961包、Phoc0.57保持，[维护](reference/full-upgrade-20261018/README.md)。本轮没有重做其它硬件验收，基带新增watchdog须保留在稳定性待办。

上轮检查点已[归档](archive/NEXT-SESSION-through268-2026-10-18.md)。早期[240交接](reference/kernel240/HANDOFF.md)与[267](reference/kernel267/README.md)、[268](reference/kernel268/README.md)保留对应阶段证据，旧身份／版本／PID不用于当前操作。
