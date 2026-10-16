# Realme X2 Pro 当前检查点

最后核对：2026-10-15，阶段185，外设适配goal active。当前kernel183/logdump183、boot/DTB172、modules132且hci_uart覆盖185、Mesa149/UCM173。一轮受控热重启及一次s2idle，无flash。规则见[边界](WORKING-BOUNDARIES.md)。用户暂无耳机，不重复问。

## 当前部署与实机依据

| 项目 | 最后核对结果 |
| --- | --- |
| 组合 | #183 SMP PREEMPT Oct15 00:20:49；Image bfa72dd9…、logdump e73754c7…、boot172 77e1a272…、DTB172 22c1f2ad…保持 |
| 蓝牙修复 | 有界功率脉冲窗口处理前导NUL，帧内0/padding/普通错误保留；短写与flow失败恢复。hci_uart SHAf6c5ed35…已装默认路径，原ae57a822…保持 |
| 验证 | 实际QCA/H4 C代码1049场景/ASan/UBSan及5负例通过；原模块扫描新增重组1，候选3模式0；热重启自动服务加载，0秒日志重组0 |
| 蓝牙PM | 开启无连接s2idle45.205秒，RTC IRQ1、success1/fail0、2392回调err0/QCA4，前后同模块；延后独立3模式扫描通过，无配对/连接指令 |
| Wi-Fi限制 | 组合试验醒后2秒未关联5180，扫描前检查失败；随后自行恢复，未手工重连。原失败保持，精确恢复时长未测 |
| 当前530.53秒 | taint0、Phosh、Wi-Fi5180；ADSP/modem running，SLPI offline/供电0且此boot未启动。蓝牙服务在/关/扫描关/连接0；原配置及密钥保持，PCM闭/功放静音 |
| 核验 | 784树文件/770模块仅1覆盖、boot/logdump/persist/NV/原固件通过；12类所列全boot0，脉冲计数6，不称所有功能完成 |
| 光线184 | wise_light实体96测量、原始通道变化；libssc独立候选库CLI41样本与SensorProxy光线/接近Claim/Release通过。lux仍0/惯性缺失，系统库与自动服务未改 |

依据：[185](reference/kernel185/README.md)、[最终](reference/kernel185/final-validation.json)、[重启](reference/kernel185/reboot-runtime-validation.json)、[PM](reference/kernel185/powered-suspend-validation.json)、[组合失败](reference/kernel185/combined-trial-failure-validation.json)、[醒后扫描](reference/kernel185/postresume-scan-validation.json)。184完整状态逐字保留[through184](archive/NEXT-SESSION-through184-2026-10-15.md)，原相对链接按工作区根解释；[184](reference/kernel184/README.md)与[SSC兼容层](linux-port/ssc/README.md)保留。

## 源码、产物与回退依据

- WSL内核/home/cy122/pmos-samurai-kernel136/kernel tracked13：原183的12源保持，加hci_qca.c SHA645ded49…。[模块构建](reference/kernel185/module-build-validation.json)、[补丁](reference/kernel185/qca-power-pulse-rx.patch)。整包Image/DTB/config保持，完整Module.symvers及modules.order恢复。构建报告的runtime=false是部署前快照，后续见185部署报告。
- 旧hci_uart手机k185-deploy/hci_uart-original-private.ko、baseline及E:/edk2-samurai-out/kernel185完整封存。停BlueZ/原工具卸载后才恢复模块，不强制卸载。rootfs132更新可能覆盖hci_uart185/UCM173/Mesa149，原132模块清单保持。
- 当前boot身份在k185-reboot-runtime、k185-final；185 preflash属于切换前boot，下一次操作重新取身份。184final及183all各属于旧boot，不混用。
- 当前镜像及重要回退E:/edk2-samurai-out/kernel183、181等保持；logdump181及旧178/180/181音频失败保持。SD1的172/171原件、BDS164/固件172/FdtBlob129保持。
- 183前boot的活跃双工合成crash原客户端恢复、左右声学及2次PM见[183](reference/kernel183/README.md)。当前boot未重做声学/SSR；185蓝牙PM不能代替完整音频PM验收。UCM173由callaudiod管理，不强制补端口模块。

## 续作与已知风险

1. 完整目标GPS、摄像头、蓝牙、传感器、蜂窝等仍active。当前SLPI此boot未启动，可用于新的受控试验；优先原00121文件服务/OEM元数据、LSM6DS3C注册与ready停启。184同boot第二次start−110、v3 --debug失败和所有旧固件试验保持，不盲目重复start。
2. 184libssc 0.4.4 OEM名称配置候选仍未替换系统库/自动服务；lux均0，准确度/接近日常/惯性/持续服务未验收。C28/C35历史磁力计结果不冒充当前固件，加速度/陀螺仍缺。
3. GPS LOC历史控制链和55个in-progress报告不算fix；继续UTC/aiding及标准定位服务。蜂窝sim-missing，IPA/双槽/错误传播可推进，真实注册/数据/通话/SMS未验收。
4. 摄像头内部TPG三帧DMA不算实体出图；继续PM8008四输入/冷地址/复位/chip-enable本机供电契约，再CCI/C-PHY/用户态。不借外机校准。
5. 蓝牙UART启动错误已有修复/扫描/热启动/一次开启PM证据；连接/音频、物理断电冷启动及长稳仍开放，按边界只扫描。Wi-Fi醒后关联延迟、USB/充电/显示/触摸及其它待办见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。

导航：[会话索引](sessions/INDEX.md)、[文档索引](DOCS-INDEX.md)。
