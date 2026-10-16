# Realme X2 Pro 当前检查点

最后核对：2026-10-15，阶段188，完整外设goal active。仍kernel183/logdump183、boot/DTB172、modules132且仅hci_uart185覆盖、Mesa149/UCM173。187本机A.11首次获得三轴流；188自动开机/实际桌面用户通过，休眠后SLPI frpc_dsp fatal，自动服务已回退。规则见[边界](WORKING-BOUNDARIES.md)。用户暂无耳机，不重复问。

## 当前部署与实机依据

| 项目 | 最后核对 |
| --- | --- |
| 188最终755.26秒 | taint0、Phosh、Wi-Fi5180；ADSP/modem running，SLPI offline/供电0，原firmware指针恢复。全boot SLPI fatal/crash各1，其它所列六类故障0 |
| 默认模块 | 原fastrpc4515b1b2…保持，186失败候选未加载。hci_uart185 f6c5ed35…保持，784文件/770模块仅1覆盖 |
| A.11三轴187 | 同机型SLPI2.1-00068独立路径，accel204/gyro202/mag197测量，时间戳递增/非法0/disable ACK；原装CLI五种流、SensorProxy三项Claim/Release通过 |
| 自动服务188 | 新boot204.12秒SSC及SensorProxy自动运行、实际加载独立libssc；UID10000在elogind验证的active本地Wayland会话三项Claim/Release通过，gyro90/mag14/compass17；Polkit未改 |
| PM失败188 | Linux success1/fail0、2422 callback err0，但恢复后SLPI frpc_dsp fatal、state crashed，测量未恢复；整个测试失败。正常shutdown及原文件/自动项回退完成 |
| 蓝牙185 | NUL边界修复已部署；原扫描错误1/候选0、3模式、热重启及开启s2idle45.205秒/RTC1/QCA4 err0、延后扫描通过。Wi-Fi即时醒后检查失败保留 |

依据：[187](reference/kernel187/README.md)、[188](reference/kernel188/README.md)、[最终](reference/kernel188/final-validation.json)、[回退](reference/kernel188/rollback-validation.json)。186检查点逐字保留[through186](archive/NEXT-SESSION-through186-2026-10-15.md)，相对链接按工作区根解释；[186](reference/kernel186/README.md)、[185](reference/kernel185/README.md)仍保留。

## 源码、产物与回退依据

- WSL内核/home/cy122/pmos-samurai-kernel136/kernel当前tracked13：原183的12源及hci_qca185保持。fastrpc原a15e99ea…已恢复，失败ba187458…源和95c9e2b0…模块仅研究使用；[恢复](reference/kernel186/source-restore-validation.json)。Image/DTB/config、完整16793行Module.symvers和770项modules.order保持。
- 186[生命周期原型](reference/kernel186/fastrpc-reserved-pool-lifecycle.patch)实机reclaim−22失败，不可直接再部署。实际DT VMIDs3/5/6；SCM仅成功才更新srcvm，原第二probe至少2259/2260错误且覆盖ring，owner/权限/停机顺序仍待证明。
- A.11仅同机型SLPI文件在/lib/firmware/qcom/sm8150/realme/samurai-a11-r187只读独立目录；原00121文件保留，没有刷modem。原厂配置/校准只在RAM副本写，MMC5603转义修正沿用113。不能借用外机校准。
- [SSC服务源码](linux-port/ssc/samurai-ssc.py)及184兼容库为候选；188尝试安装已全部回退，原iio-sensor-proxy init恢复，系统库/APK DB未改，当前无自动SLPI服务。备份/失败部署/RAM/trace均封存在手机k188与E:/edk2-samurai-out/kernel188；独立184库仍保留可研究。
- 当前boot身份手机k188-reboot-runtime/boot-id-private.txt；此boot有一次A.11启动、一次自然PM fatal，现已shutdown。下一次SLPI首启需解决pool生命周期或门控热重启，勿盲目start。187/188合计各一次热重启无flash，旧身份不得复用。
- 当前USB IPv4不可达，Windows新NCM接口为APIPA；188/host.py使用私人usb-ipv6-candidates-private.json中的当前scope，并以原169.254.42.1 HostKeyAlias严格核验。下一boot重新枚举，勿沿用旧IPv6/scope；勿提权盲改主机网络。该IPv6传输可继续当前只读/正常适配操作。
- boot172/DTB172、BDS164/固件172/FdtBlob129、重要183/181回退保持。原183音频SSR/声学/PM属旧boot，不混入本次；UCM173由callaudiod管理。rootfs132更新可能覆盖本地hci_uart/UCM/Mesa修复。

## 续作与已知风险

1. 优先SLPI/FastRPC PM与停启。188恢复后fatal为err_qdi.c:964、sensor_process/frpc_dsp、PC0xb2065188；不能仅凭字符串断言电源或freezer根因。保留连续FastRPC/GLINK/IOMMU、文件服务冻结/恢复及SCM时序，查明共享池reclaim−22，勿试遍未知owner或隐藏错误。
2. 188 PM r1证据采集有缺陷：per-CPU字典覆盖仅留一核，驻留时长未在健康检查前落盘，不能称全部CPU无overrun或实际休眠45秒。[范围](reference/kernel188/failed-pm-trace-scope-validation.json)。修正版尚未重跑；真实DSP fatal不是采集脚本虚构。
3. A.11已解决原00121 accel/gyro未注册的实际缺口；但自动服务已回退、SSR/PM未过，人工运动/方向/自动旋转、亮暗响应/绝对精度、接近日用及长稳仍开放。平放Z约9.80/方向undefined不等于旋转验收。元数据使用已核对100-byte OCDT，旧13-byte布局无效。
4. GPS LOC历史55个in-progress不是fix，继续UTC/aiding/标准桌面服务；蜂窝sim-missing，IPA/双槽/错误传播及真实注册/数据/通话/SMS仍开放。实体camera仍需PM8008四输入/冷地址/复位/chip-enable供电契约与CCI/C-PHY，内部TPG不算实体出图。
5. 蓝牙按边界只扫描，连接/音频/物理断电冷启动/长稳未测；Wi-Fi醒后关联延迟、USB/充电/显示/触摸等继续见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。保护NV/校准/私人数据与电池保护。

导航：[会话索引](sessions/INDEX.md)、[文档索引](DOCS-INDEX.md)。
