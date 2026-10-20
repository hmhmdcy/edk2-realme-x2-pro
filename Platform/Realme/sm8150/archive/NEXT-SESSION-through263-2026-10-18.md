# Realme X2 Pro 当前检查点

263相机：同260启动/961包，生产库与262复制开关未动。共享持有340/340被覆盖，复制0/673、直连libcamera0/224。公共SPA/PW候选单/双客户端及跨框架通过，但断连重协商仍偶发1帧覆盖/PTS回退，未部署；记账清零候选已否决。[故障矩阵、哈希与续作](reference/kernel263/README.md)。目标active；r15/r10及内核保持，GUI快门/画质/后摄待办。

10月18日全量升级：55包升级、3依赖新增，现**961包**、无待更新；同260启动未重启、taint0。Phoc仍0.57，键盘待重登加载新版。回退及变更见[升级收据](reference/full-upgrade-20261018/README.md)。下文958包为历史验收。

260：桌面GNSS室外300秒280次更新、262次严格校验，GPS去重9颗TRACK/46.7dB-Hz，停止自动LOW_POWER并恢复设置。验收时boot235/Image183、958包，GeoClue2.8.2-r1/helper2-r1/MM203-r1。[实测和限制](reference/kernel260/README.md)、[室外回收](reference/kernel260/outdoor-validation.json)

261桌面检查（10月18日补充）：同260启动、958包，未更改持久配置或软件。缺中文字体、主要桌面翻译与locale支持，输入源只有US；UIM已有拼音，需接入，不能说没有引擎。商店APK插件在，但Alpine应用目录缺失，AppStream/CDN有界请求超时，pmOS镜像200。普通GTK编辑焦点显隐通过；搜索捕获误弹/不收起已复现。上游GTK8349对应，Phoc MR813已于9月19合并并随0.58发布；新接口版本2区分enable和show/hide面板。本机Phoc0.57实测只宣告版本1。优先采用上游Phoc及配套wlroots支持，禁捕获仅为定位对照；尚未部署或实机验收。[检查详情与后续](reference/kernel261/README.md)、[搜索对照](reference/kernel261/search-keyboard-validation.json)、[上游核验](reference/kernel261/upstream-compatibility-validation.json)

先读[操作边界](WORKING-BOUNDARIES.md)、[硬件清单](linux-port/docs/HARDWARE-STATUS.md)、260。当前guard为`/var/lib/samurai/k260-work/boot-id-private.txt`，PC运输代码仅私人`E:/edk2-samurai-out/kernel260/host.py`，严格固定原主机密钥。**257/259、Android251—256及旧RAM guard全部失效**，不能再执行旧worker。

## 室外复测结果与续作

用户已拿回接USB，22个本地导出文件逐项SHA256通过；`outdoor-policy/progress.json`为complete，采集worker和会话inhibitor均已退出。源配置、隐私设置和Wi-Fi原省电值恢复，最终GPS0/Signalsfalse/rate30/Power2/taint0。下一步补冷启、休眠恢复、长稳和绝对精度，不能重复启动已完成的field worker。

没有额外HIGH客户端，标准MM默认LOW也已成功。首个严格通过的更新12.97秒、末个292.96秒，不是冷启动TTFF。旧脚本要求Accuracy>0，但上游HDOP≤1映射0；18个未接纳事件未保存字段，既不能追认全有效，也不能直接当作丢星。后续诊断客户端接受非负有限精度并记录判据；原记录保持。被动观察器无自己的定位会话，零位置indication不否定桌面坐标；本轮PGA缺失不能记0。

无线SSH仍不稳定，邻居链路待查；临时代理排除已撤回。USB严格原密钥可用；260收尾生产哈希、GPS空闲/Power2/taint0通过，测试入口已清理，勿重跑cleanup。网络排查与私人日志见260，未观察到系统休眠或WLAN/remoteproc崩溃。

## 已修复与未完成

GeoClue原后端退出后留Signals=true/rate0，旧回包可能覆盖新请求；r1修复来源位所有权和异步取消协调。原生及ARM64/qemu的10项回归、实机四轮通过，无手工恢复设置。259室外300秒仍零坐标，GPS最多1颗TRACK；约258.54秒另开HIGH90秒也零坐标，最后41秒有重叠。缺失PGA不能记为0。

MM PowerState1曾误识别：258启动为SHUTTING_DOWN、结束才为OFFLINE；259的ONLINE/LOW转换失败且Reset无效。260重启后ONLINE成功，独立GET确认ONLINE↔LOW_POWER通过，详见260。

辅助服务2-r1仅对realme,samurai、缺SIM失败且无SIM对象的modem，在实际GPS请求时管理电源。显式OFFLINE保持，只从初始SHUTTING_DOWN恢复；最后只回收自己的在线租约到LOW_POWER，不写OFFLINE/Reset/RF/NV。14项生产回归在PC及真机通过；实机四轮0/15/0/20秒，自动两次上线/低功耗，五次独立DMS读回，最终GPS0/Signalsfalse/rate30/Power2/taint0。

此前USB测试在手机拿回后，具体摆位未再确认，早期网络时间未同步，零坐标不是室外灵敏度结论。随后chrony同步（stratum3、4源在线）、空闲UTC注入成功，无手工设时间；室外time_prepared=true。本轮默认LOW已定位，未部署HIGH补丁，未修改PGA/RF/时钟寄存器/NV/校准。

[258](reference/kernel258/README.md)原生Linux室外持续定位通过：287份SATELLITE坐标连续286秒、最大间隔1.012秒，GPS去重最多12颗TRACK/44.4dB-Hz、PGA全+2。原厂[256](reference/kernel256/README.md)302份、去重10颗/45.5dB-Hz、PGA全+2；15/17是重复条目数。位置/启动/辅助/USB未单变量控制，室内及PGA根因、完整5MiB MEMSHARE/SCM provider、冷启/PM/长稳/精度仍开放。

## 其它硬件与维护

其余按[240交接](reference/kernel240/HANDOFF.md)、[263相机续作](reference/kernel263/README.md)和硬件清单：libcamera r15/config-r10、Snapshot51.0，历史默认Vulkan480条fault未修。262复制路径已通过后端压力和实际预览；GUI快门、画质、其它后摄、传感器精度/旋转、SLPI重启及无SIM蜂窝业务仍待验。模块权威清单237为775ko/789项；NV/GPT/persist未回刷，248完整返回备份保留。

[pmaports](https://github.com/hmhmdcy/pmaports)默认samurai-userspace最后推送4aeae3b3；[内核](https://github.com/hmhmdcy/linux/tree/samurai-bringup)04d4d4f9。249独立公开源复现、882包rootfs和38项MM测试只是PC候选。259/260的GeoClue/GNSS修复及262相机修复仍为本地改动，未推送。旧系统约束配方仅reference/kernel260/legacy-stack，不混入249默认候选。遵循上游＋最小功能队列＋原生APK。

249构建卷`D:/samurai249-build/build-ext4-private.img`（32GiB）挂载`/home/cy122/x2pro-linux/pmos249-build`，不能mkfs；SDK github-only/sdk-r2。内核清理及PMIC/provider/DTS待办见[249](reference/kernel249/README.md)；原内核/SDK、私人回退和未提交DTB保留。
