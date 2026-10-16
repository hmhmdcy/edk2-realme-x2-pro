# Realme X2 Pro 当前检查点

最后核对：2026-10-15，阶段186，完整外设goal active。当前kernel183/logdump183、boot/DTB172、modules132且仅hci_uart185覆盖、Mesa149/UCM173。186两次热重启无flash；失败FastRPC候选已恢复原文件/源码，并在第二新boot确认原版加载。规则见[边界](WORKING-BOUNDARIES.md)。用户暂无耳机，不重复问。

## 当前部署与实机依据

| 项目 | 最后核对 |
| --- | --- |
| 当前88.77秒 | 新boot taint0、Phosh/声卡、Wi-Fi5180；ADSP/modem running，SLPI offline/供电0且此boot未启动。0秒日志及九类所列错误0 |
| 默认模块 | 原fastrpc4515b1b2…已恢复/加载build-id核对；失败95c9e2b0…未加载。hci_uart185 f6c5ed35…保留，784文件/770模块仅1覆盖 |
| SLPI证据 | 原00121属性查询通过；DSP-first stop后第二rproc start0，但后续FastRPC probe反复−22；不能称完整重启通过 |
| 失败候选 | 337主机场景/606 alloc-free/4负例及ARM64构建通过；实机第一轮wise_light采样0，stop reclaim−22，计划后三轮未通过且后两轮未执行。原模块文件/维护源恢复 |
| A.11 | 官方同机型区间/所选modem.img ZIP CRC449fd477/SHAe870086c…通过；SLPI2.1-00068已离线提取，22头/20段/同base/20MiB fits，未部署手机 |
| 蓝牙185 | 启动NUL边界修复已部署；原扫描错误1/候选0、3模式响应、热重启及开启s2idle45.205秒/RTC1/QCA4回调err0、延后扫描通过。Wi-Fi即时醒后检查失败保留 |
| 光线184 | wise_light实体96测量、原始通道变化；独立libssc候选CLI41样本/SensorProxy光线/接近Claim/Release通过。lux0/惯性缺失，系统库/自动服务未改 |

依据：[186](reference/kernel186/README.md)、[恢复现场](reference/kernel186/restored-runtime-r2-validation.json)、[原停启范围](reference/kernel186/lifecycle-validation.json)、[原样失败](reference/kernel186/candidate-runtime-failure-validation.json)、[A.11](reference/kernel186/a11-reference-validation.json)。185完整检查点逐字保留[through185](archive/NEXT-SESSION-through185-2026-10-15.md)，相对链接按工作区根解释；[185](reference/kernel185/README.md)、[184](reference/kernel184/README.md)仍保留。

## 源码、产物与回退依据

- WSL内核/home/cy122/pmos-samurai-kernel136/kernel当前tracked13：原183的12源及hci_qca185保持。fastrpc原a15e99ea…已恢复，失败ba187458…与95c9e2b0…候选另存，仅研究使用；[恢复](reference/kernel186/source-restore-validation.json)。Image/DTB/config、完整16793行Module.symvers和770项modules.order保持。
- 失败[补丁](reference/kernel186/fastrpc-reserved-pool-lifecycle.patch)/[构建](reference/kernel186/fastrpc-module-build-validation.json)/[主机测试](reference/kernel186/fastrpc-host-tests-validation.json)不可作为修复验收。实机当前DT VMIDs3/5/6，SCM只有成功才更新srcvm，仍需核对实际权限与停机时机。
- 原fastrpc备份手机k186-load-fastrpc-r2/fastrpc-original-private.ko、主机E:/edk2-samurai-out/kernel186；原hci_uart ae57a822…仍k185-deploy及185封存。软件/rootfs132更新可能覆盖hci_uart185/UCM173/Mesa149；不强制卸载。
- 当前boot身份手机k186-reboot-runtime-r2/boot-id-private.txt。186baseline/preflash属于第一旧boot，186r2-preflash和候选测试属于第二旧boot，下一操作重新取身份。当前新的SLPI首启机会未使用。
- 当前镜像与重要回退E:/edk2-samurai-out/kernel183/181等保持，boot172/DTB172、BDS164/固件172/FdtBlob129保持。原183音频[SSR/声学/PM](reference/kernel183/README.md)属旧boot，不混入当前；UCM173由callaudiod管理。

## 续作与已知风险

1. 完整GPS/实体camera/蓝牙/传感器/蜂窝目标保持active。优先原驱动SCM入口/返回及rproc/glink/sysmon顺序追踪，查明SDSP pool回收−22；不要试遍未知owner、忽略SCM失败或复用失败源。原第二probe错误至少2259/2260、末尾ring覆盖，初始导出前缀假设失败保留。
2. 当前新boot未启动SLPI，可做完整门控后A.11独立路径首启/属性及惯性流试验；仅本机SLPI文件，不刷modem、不导入外机校准。A.11 strings/布局检查不算传感器已工作。
3. 原00121 accel/gyro实例为空。184libssc名称配置仅独立候选，lux均0、自动亮度/接近日常/惯性/持续服务未验收。旧C28/C35磁力计结果各自保留。原RPC日志没见prjName/pcbVersion/modemType请求，元数据缺失不是已证根因；旧13-byte SMEM布局无效，应使用已核对100-byte OCDT。
4. GPS LOC历史55个in-progress不算fix，继续UTC/aiding/标准服务；蜂窝sim-missing，IPA/双槽/错误传播及真实注册/数据/通话/SMS仍开放。camera内部TPG不算实体出图，继续PM8008四输入/冷地址/复位/chip-enable本机供电契约及CCI/C-PHY。
5. 蓝牙连接/音频、物理冷启动/长稳仍未测，按边界只扫描；Wi-Fi醒后关联延迟、USB/充电/显示/触摸等待办见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。保护NV/校准/私人数据和电池保护。

导航：[会话索引](sessions/INDEX.md)、[文档索引](DOCS-INDEX.md)。
