# Realme X2 Pro 当前检查点

最后核对：2026-10-15，阶段189，完整外设goal active。当前kernel183/logdump183、boot/DTB172，modules132中覆盖hci_uart185及fastrpc189两项，Mesa149/UCM173。189 FastRPC freezer等待修复实际加载，自动SSC服务连续三轮完整休眠及醒后桌面用户访问通过；Wi-Fi/蓝牙仍有独立故障。规则见[边界](WORKING-BOUNDARIES.md)。用户暂无耳机，不重复问。

## 当前部署与实机依据

| 项目 | 最后核对 |
| --- | --- |
| 189最终828.17秒 | taint0、Phosh、Wi-Fi5180，ADSP/SLPI/modem running；SSC文件服务与SensorProxy运行，传感器供电1、A.11独立路径。全boot蓝牙重组1，其余所列九项0 |
| 模块 | fastrpc189 SHA88553112839d0a23604171edb03004a15e94f7cc3b174ebb3b9f2e56d3cc2fcc、实际build-id匹配；hci_uart185 f6c5ed35…保持，784文件/770模块共2覆盖 |
| 传感器首流187 | A.11 accel204/gyro202/mag197测量、时间戳递增/非法0/disable ACK；五种CLI与SensorProxy三项接口通过 |
| 189连续PM | 实际驻留45.2784/45.2053/45.2838秒，success3/fail0、RTC3、7266 callbacks err0、每轮8核overrun0。醒后四种CLI均有测量并正常disable，daemon/proxy身份保持，未重启DSP/重绑驱动 |
| 醒后桌面 | 实际active本地Wayland UID10000三项Claim/Release通过，gyro78/mag14/compass17；Polkit未改，平放方向undefined，lux8，未做人工运动/亮暗/绝对精度 |
| 网络/蓝牙失败 | 第2轮Wi-Fi35秒窗内未关联，经过第3轮PM后恢复5180；本boot BT phase5/3.2Mbps/chunk13/partial0/firstff重组1，不能称整机PM/蓝牙全部完成 |

依据：[189](reference/kernel189/README.md)、[三轮](reference/kernel189/three-cycle-suspend-validation.json)、[桌面](reference/kernel189/desktop-after-pm-validation.json)、[最终](reference/kernel189/final-validation.json)。188原休眠frpc_dsp fatal及回退保留，不能改记通过；[188检查点逐字快照](archive/NEXT-SESSION-through188-2026-10-15.md)，相对链接按工作区根解释。

## 源码、产物与回退依据

- WSL内核/home/cy122/pmos-samurai-kernel136/kernel当前tracked14：原183的12源、hci_qca185及fastrpc189。新fastrpc源SHA41c8db5c323404dbd6230a43206ff573e0f5ad327574d3ffe94cc741ca6da347；原a15e99ea…完整备份。Image/DTB/config未变，完整16793行Module.symvers、770项modules.order恢复。
- [Freezer补丁](reference/kernel189/fastrpc-freezer-wait.patch)保持RPC/DMA上下文等待，使用TASK_INTERRUPTIBLE|TASK_FREEZABLE；52个实际等待函数场景/ASan/UBSan与3个运行时负例通过、ARM64 W=1告警0。Qualcomm v3只是研究提案，未直接应用。普通信号通用重试和freezer伪信号竞态仍需审查，主机scheduler为stub不能代替这些实际竞态。
- 原fastrpc模块4515b1b2…在手机k189-module-deploy/fastrpc-original-private.ko及主机E:/edk2-samurai-out/kernel189。原rootfs文件在k189-deploy，当前默认模块8855…及SSC服务启用保留。运行中不要强制卸载；rootfs132更新可能覆盖本地模块/UCM/Mesa/服务，仍需正式打包。
- [SSC服务](linux-port/ssc/samurai-ssc.py)每boot只允许一次启动，固定1902…文件服务与184独立兼容库；核验本机303来源/24固件文件，只写私有RAM副本，DSP先停后停daemon再关电。系统libssc/APK DB保持。A.11固件在/lib/firmware/qcom/sm8150/realme/samurai-a11-r187，原00121文件保留，未刷modem/未借用外机校准。
- 当前boot身份手机k189r2-reboot-runtime/boot-id-private.txt；此bootA.11首启后连续运行及3轮PM，未发生SLPI fatal。两个worker均exit0且PID消失已确认。189第一次原模块试验因pm_test不存在而在休眠前退出，正常DSP stop0；不能当作硬件freezer复现。
- 当前USB采用189/reboot-r2/host.py及其私人usb-ipv6-candidates-private.json，严格沿用169.254.42.1 HostKeyAlias/原公钥。下一boot重新枚举IPv6及scope，不复用旧启动身份。两次RESTART2/fastboot reboot各一次无flash；第二次身份文件路径错误发生在发送reboot前，观察/失败保留后修正。
- 固定boot172/DTB172、BDS164/固件172/FdtBlob129及重要183/181回退保持。原183完整音频SSR/声学/PM属于旧boot，不混入当前；UCM173由callaudiod管理。189私人完整归档SHA7f80cdca…，含哈希一致的活RAM副本，来源/NV/模块树核验保持。

## 续作与已知风险

1. 继续审查FastRPC freezer伪信号与普通信号的返回路径：本地signal.c的recalc_sigpending可核对，try_to_freeze后的pending标志竞态尚未被52个stub场景覆盖。当前3轮真实PM通过，不当作所有信号/SSR/长稳证明。
2. 186共享池stop/start/reclaim−22仍独立未解决，189没有改SCM/VMID。失败原型ba187458…源/95c9e2b0…模块不能再当修复部署。实际VMIDs3/5/6，需正确时序/权限证据，勿试遍未知owner或隐藏错误。当前持续服务不要为探测而盲目重新start。
3. 蓝牙185已解决的前导00与当前phase5 firstff不同，需核对高波特率切换/有效H4边界。按边界只扫描；配对/连接/音频/冷启动/长稳仍未验收。Wi-Fi第2轮35秒未关联，后面有另一次PM，不能记为自行恢复；保留185即时醒后失败。
4. 传感器人工运动/方向/自动旋转、亮暗响应/精度、接近日常、跨boot/冷启动、SSR及长稳开放。平放Z约9.80、方向undefined和被动lux0至8不等于这些验收。原厂配置/校准/NV保持，只用本机固件。
5. 原完整目标保持：GPS LOC历史55个in-progress不是fix，继续UTC/aiding/真实fix/标准桌面桥；蜂窝sim-missing，IPA/双槽/错误传播及真实注册/数据/通话/SMS；实体camera PM8008四输入/冷地址/复位/chip-enable及CCI/C-PHY，内部TPG不算实体出图。其它待办见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。

导航：[会话索引](sessions/INDEX.md)、[文档索引](DOCS-INDEX.md)。
