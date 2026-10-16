# Realme X2 Pro 当前检查点

最后核对：2026-10-15，阶段200，完整外设goal active。静态MMCX四域DT与CAMSS模块已成对启动；新boot四轮前摄12帧RAW10，原频率/自身384→0通过。803.82秒taint0、所列fault全0。见[边界](WORKING-BOUNDARIES.md)、[200报告](reference/kernel200/README.md)。

## 当前部署与实机依据

| 项目 | 最后核对 |
| --- | --- |
| 已部署 | boot200内嵌DT2e2f8e64…/CAMSS82cbc052…；仍Image183/logdump183、modules132覆盖hci_uart185/fastrpc189、Mesa149/UCM173/MM191 |
| 相机 | 新启动四轮IMX4711928×1088 RAW10共12帧，pattern0/无外部性能helper/频率表保持；VFE约847/CSID600MHz，自己MMCX active384/idle0 |
| 最终现场 | 新200 boot/kernel#183；803.82秒taint0，WARNING/Oops/GPU/SLPI fatal/BT重组均0；ADSP/SLPI/modem running，SensorProxy三Has true，三项Claim/Release通过 |
| 无临时相机 | fixtures/CCI/sensor/PMIC/临时VIO phandle及FW撤销，永久CAMSS绑定四域；GPIO12/15/29 CTL1/1/1、input低，P0/Q1与七Q LDO采样恢复 |
| 无线 | BT仅扫描8秒，10设备、停止/原Powered恢复，fault增量0；Wi-Fi connected。新USB peer/严格原公钥SSH/SCP与归档通过，稳定性未完 |
| MM | 文件b350c55b…保持，State−1/PowerState1/GPS0；XTRA/3服务器/capabilities103。191旧online未跨重启保持，新轨道有效期未核 |

依据：[读回](reference/kernel200/runtime-validation.json)、[相机](reference/kernel200/front-native-validation.json)、[健康](reference/kernel200/native-health-validation.json)、[外设](reference/kernel200/peripheral-regression-validation.json)。旧199状态逐字保留于[快照](archive/NEXT-SESSION-through199-2026-10-15.md)，相对链接按根解释。

## 源码、产物与回退依据

- WSL源码/home/cy122/pmos-samurai-kernel136/kernel；25 tracked改动/11 untracked、未暂存。原14其它源、IMX471/MFD/199 CAMSS/DTS/binding保持；仅开发VIO helper更新。[收据](reference/kernel200/source-final-validation.json)
- boot200主机kernel200/boot-partition-k200-mmcx.img，5109097b…/100663296字节；DTB在kernel199/sm8150-samurai-mmcx-static-private.dtb，2e2f8e64…/108410字节。只CAMSS两域属性改变，其余908节点/固件代码保持。[构建](reference/kernel200/build-package-validation.json)
- CAMSS源CPAS3ee20b59…/core53d8a710…，安装模块82cbc052…，新boot loaded build-id已核；四域ife0/ife1/top/mmcx。runtime前384，暂停0，失败保留请求/恢复ICC；频率表未改、未细分模式。17实际C/ASan/UBSan/缺请求变体及W1/schema/三补丁验证见199。
- 回退boot172 77e1a272…另存在主机kernel200/boot-rollback-k172-private.img；旧模块e9b73f4c…在手机k200-baseline及k200-deploy/原生私人归档。回退须fresh身份及旧boot/旧模块配套，保留logdump183 e73754c7…；persist/NV未改。
- Image183 bfa72dd9…、canonical DTB22c1f2ad…、config55f1f0a3…保持，Module.symvers16793行/modules.order770恢复。只刷boot；Linux RESTART2/fastboot reboot各一次。首次Windows fastboot因WSL路径本地开文件失败未传输，改路径且重核身份后成功写一次；旧失败保留。
- IMX471源110977b8…/模块c49dca63…，CCI库f9c9272a…，MFD195 d1ff82c0…，OF helper92d9176e…固定FW samurai/k196-front.dtbo。新sensor-only overlay5109da88…/3082字节，MCLK sleep改pull-down；不更新既有MMCX属性。
- VIO helper源5b7aad11…/模块5325464e…，仅开发已卸载。限定PM8150L RPMH父节点，允许初始unknown=−EINVAL；只读精确查找前后unknown/1.8V/users0保持。正常sensor首用后disabled；拒绝其它错误/enabled。W1/checkpatch/导入通过。[构建](reference/kernel200/vio-helper-build-validation.json)
- 第一相机会话6帧后GPIO15 CTL1→0，原sleep bias-disable造成；GPIOv2 bias请求硬件未生效，确认无owner/MCLK关后单次masked CTL恢复1。第二会话修改sleep pull-down后另6帧，三脚/PMIC完整恢复，无额外修补。两会话记录均保留。
- 正确GPIO12/15/29 CTL为0x0390c000/0x0390f000/0x0351d000，新boot初值全1（旧boot GPIO15为0）。当前phandles TLMM56/CAMCC201/PM8150L_GPIO240/S8C251/RPMH124/SM8150_MMCX9；临时VIO301已撤销，下次重读。
- P reset0/Q reset1、Q在4/5、8不响应，Q ID[0,0,0,1,0x51,0x2c]；本次重启仍warm，未证明硬断电cold。只有NLDO输入S8C已证，PLDO四输入未知；不套hotdog PM8009/BOB/弹出机构。195冷迁移/失败回退37C场景仍保留。
- FastRPC88553112…/hci_uart f6c5ed35…实际loaded build-id均核。SSC A.11/daemon1902…/184门控保持；MM正式APK化未做、更新会覆盖。用户暂无耳机。
- 新boot身份手机k200-runtime/boot-id-private.txt、主机kernel200/new-boot-id-private.txt。host200已转新发现USB IPv6 peer/原HostKeyAlias公钥；Wi-Fi旧实现host-before-newboot.py，私人端点kernel190文件保留。别用旧189/199 boot guard切换。
- 168原生文件、4张RAW/解码统计/媒体与归档指纹只私人保存E:/edk2-samurai-out/kernel200，全成员验证通过。[收据](reference/kernel200/evidence-export-validation.json)

## 续作与已知风险

1. 相机仍用开发VIO/CCI/sensor/PMIC overlay接入，当前已全部撤销，正常启动空sensor图。下一步板级持久化/用户态、PLDO输入/双PMICcold、其它镜头/模式/曝光色彩方向/持续帧率/长稳；不把12帧当完整相机完成。
2. GNSS191旧boot 303NMEA/online后90秒仍无fix/CNR；200重启MM电源回1但辅助能力1/服务器3保持。继续核轨道有效期、GNSS-only GeoClue/辅助自动加载及合适电源策略，不盲目DMS reset/online。两UIM no-atr/absent不证明物理无SIM，业务均待验。
3. BT phase5历史重组1、Wi-Fi第二PM35秒未关联、190 USB双向IPv6失效均保留；本次新boot短窗未复现不等于根因修好。只扫描、不配对连接。FastRPC普通信号/freezer/共享池−22/SSR、传感器运动亮暗精度、冷启长稳开放。
4. 旧193内核WARN+199热属性OF警告共3/taint512只属于旧boot，新静态DT不替换该属性且本boot0；不要抑制旧记录。core AHB hw0也见于成功帧，不当单独根因。其它见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。

导航：[会话索引](sessions/INDEX.md)、[文档索引](DOCS-INDEX.md)。
