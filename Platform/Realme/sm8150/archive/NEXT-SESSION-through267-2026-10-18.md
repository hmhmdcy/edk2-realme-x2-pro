# Realme X2 Pro 当前检查点

267已部署公共PM8008 MFD/regulator及标准IMX319＋新DTB，实验模块/板级reset provider和loader配置已撤。当前为267新启动/Image183，guard `/var/lib/samurai/k267-work/boot-id-private.txt`，运输使用reference/kernel267/host.py及私人新USB IPv6端点、原主机密钥。PW4314/start2484、WP4318/start2486，手机k267-services-current-private.json为权威；260旧guard、265旧PID失效。未改cam完成前后各3轮/共72帧并正常回收。GStreamer run18暴露跨进程libcamera Simple管线缓存link状态问题，拍照尚未在新启动通过，下一步修公共库并交替验收。[267当前结果与失败](reference/kernel267/README.md)。以下265为上一个启动的历史，不用于当前身份核对。

266架构复核：用户明确主线Linux＋SM8150公共支持＋RMX1931 DTS，尽量不改发行版/应用。当前仅部分符合；实验性供电和用户态补丁仍需收敛。IMX319元数据候选已移除未部署的机型方向默认值，方向只由DTS提供；当前启动DT缺该属性，尚未换模块/DTB或重启。[266候选与差距](reference/kernel266/README.md)。265仍为现机部署权威。

265相机公共层：core/SPA/Gst 1.6.9-r3已原生部署，组合候选3201次、系统2972次保留前缀检查0变化/回收错误。系统前后摄6张照片、六轮关闭、崩溃/跨框架并用及全池恢复通过；Snapshot窗口777缓冲/766渲染、1920×1080 JPEG解码通过。后摄偏暗、内核元数据、GUI切换、其它后摄及GPU仍待办，目标active。[265结果与失败](reference/kernel265/README.md)、[源码配方](linux-port/packages/pipewire-common/README.md)。

先读[操作边界](WORKING-BOUNDARIES.md)、[硬件清单](linux-port/docs/HARDWARE-STATUS.md)和265。同260启动guard为/var/lib/samurai/k260-work/boot-id-private.txt，运输复用私人E:/edk2-samurai-out/kernel260/host.py的严格原主机密钥；旧启动身份不可用于切换。

## 相机当前部署与续作

核心e946e511…、SPA3529ac3c…、Gst2f893caf…系统路径已映射，SPA/Gst精确依赖core-r3。仅三个包记录变化、仍961包；原core/SPA r2与Gst r1可信APK在手机/PC保留，联合降级模拟通过。新增Gst Busy所有权＋SPA图退役后新图像分配，不复制像素或清零计数。boot235/Image183、libcamera r15/config-r10的49项、无复制开关与CPU显示配置保持。

当前PW8911/start4904567、WP8913/start4904568、Phosh2261/start1967；权威/var/lib/samurai/k265-services-current-private.json。私人覆盖已撤，264旧清单与265候选PID不可再用。33个上下文全终态、PM/MCLK/图案/trace恢复、新增fault0/taint0，924个归档成员SHA核验。手机k265与PC E:/edk2-samurai-out/kernel265保留原包、失败及私人图片，不重复一发式安装或快门。

检查限定每帧前65536字节。v2一次多客户端无结果未记退出码，临时引用竞争由64轮对照检出；v3单独1次变化、SPA单独4次变化，组合重新验收通过。完整配方12摘要/7patch/7输入匹配；实际为SDK增量编译与可信载荷打包，完整abuild未跑。旧SDK broadcast树SPA被失败实验改写过，按当前配方复现。

下一步先补内核方向/裁剪元数据、IMX319低照度，再GUI选择/切换、S5K3M5/GW1、颜色/噪声、录像与长稳。用户确认后摄朝向光线较弱的电脑桌，有细节而偏暗，不归因于遮挡。GUI控制器未匹配切换动作，本轮只验收前摄窗口。默认GPU/GPU ISP退出告警未修。图/格式/AE由libcamera正常管理，不外部写回旧值。

## 用户态维护与桌面

10月18日full upgrade：55包升级、3依赖新增，现961包；未重启，同260启动。Phoc仍0.57，键盘待重登加载新版。[升级与回退](reference/full-upgrade-20261018/README.md)。下述958包为升级前历史验收。

261检查：缺中文字体、主要桌面翻译和locale，输入源US；UIM已有拼音需接入。商店APK插件在而Alpine应用目录缺失，AppStream/CDN超时。GTK编辑焦点显隐通过，搜索误弹/不收起复现；Phoc0.57只宣告版本1。上游Phoc MR813已合并并随0.58发布，新接口版本2区分enable与show/hide；优先上游及匹配wlroots，未部署或实机验收。[261详情](reference/kernel261/README.md)

## GNSS已验收与待办

260普通桌面GNSS-only室外300秒280次更新、262次严格校验、GPS去重9颗TRACK/46.7dB-Hz，停止后自动LOW_POWER并恢复设置；无额外HIGH客户端。验收boot235/Image183、958包，GeoClue2.8.2-r1/helper2-r1/MM203-r1。旧采集器错误要求Accuracy>0，上游HDOP≤1可映射0；18个余下事件没存字段，不能追认或直接算丢星。PGA未观测不能记0。[260](reference/kernel260/README.md)

用户已拿回接USB，260室外worker及inhibitor已退出，22个导出文件SHA核对；源配置/隐私/Wi-Fi省电恢复，最终GPS0/Signalsfalse/rate30/Power2/taint0。首次严格更新12.97秒不是冷启TTFF。下一步冷启、PM、长稳和绝对精度，不重跑已完成worker。无线SSH不稳定，USB原密钥可用，无remoteproc/WLAN崩溃证据；临时代理排除撤回。

GeoClue r1修复来源位所有权/异步取消协调，10项回归通过。辅助服务2-r1只对本机缺SIM且无SIM对象，在真实GPS请求管理自己的在线租约；显式OFFLINE保持，回收LOW_POWER、不写Reset/RF/NV。14项回归及实机四轮通过。259 OFFLINE失败不能当ONLINE对照；260重启后独立GET确认ONLINE↔LOW通过。258原生室外287份/286秒、去重12颗TRACK/44.4dB-Hz/PGA+2；256原厂302份、去重10颗/45.5dB-Hz/PGA+2，位置/启动/辅助并非单变量。完整5MiB MEMSHARE/SCM provider及室内PGA根因仍待办。[258](reference/kernel258/README.md)、[256](reference/kernel256/README.md)

## 其它硬件与源码

其余见[240交接](reference/kernel240/HANDOFF.md)和硬件清单：充电闭环、传感器精度/旋转、SLPI重启、真实SIM业务与外围完整适配开放。模块权威清单237为775ko/789项；NV/GPT/persist未回刷，248完整返回备份保留。遵循上游＋最小功能补丁＋原生APK。

[pmaports](https://github.com/hmhmdcy/pmaports)默认samurai-userspace最后推送4aeae3b3；[内核](https://github.com/hmhmdcy/linux/tree/samurai-bringup)04d4d4f9。249独立源复现、882包rootfs与38项MM测试只属PC候选；259/260GNSS与262—265相机修复仍本地未推送。旧栈约束在reference/kernel260/legacy-stack，不混入249默认候选。

249构建卷D:/samurai249-build/build-ext4-private.img（32GiB）挂载/home/cy122/x2pro-linux/pmos249-build，不能mkfs；SDK github-only/sdk-r2。原内核/SDK、私人回退及未提交DTB保留，内核清理/PMIC/provider/DTS待办见[249](reference/kernel249/README.md)。上个检查点全文已[归档](archive/NEXT-SESSION-through264-2026-10-18.md)。
