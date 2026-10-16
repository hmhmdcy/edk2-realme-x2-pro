# Realme X2 Pro 当前检查点

2026-10-15，阶段210完成有限相机接入，完整外设goal active。前摄已在正常DTS启动中自动绑定，两轮6帧真实RAW及PM释放通过；libcamera枚举前摄，用户态仍有裁剪接口与DMA allocator缺口。下一步211继续修复。210已完成一次boot刷写及启动读回，无待确认切换。[210报告](reference/kernel210/README.md)、[209快照](archive/NEXT-SESSION-through209-2026-10-15.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- 当前运输 `reference/kernel210/host.py`，新guard `/var/lib/samurai/k210-runtime/boot-id-private.txt`。新USB端点已发现并严格认证，旧端点另存私人210。reboot-request/boot-flash-request/fastboot-reboot-request三个marker均已闭环，禁止重放。k210-baseline及旧207/208/209 guard都是旧boot。
- 当前boot210 89242ade…/DTB7ff712b1…；Image183 bfa72dd9…/logdump e73754c7…/CAMSS82cbc052…/BT185保持。新imx471 c49dca63…/CCI库f9c9272a…/PM8008 d1ff82c0…，安装树772个ko/786份文件，其余769模块保持。TFTP207 b3bb82b9…/wifi854c9a8c…/MCFG helperd4c62be6…/MM191/helper421/init54/SSC9a1均保持。
- 静态IMX471 7-0010、PM8008 1-0004及CCI正常自动绑定，media0为23实体，无临时overlay/VIO/性能helper。前摄CCI1 master1/0x10、MCLK2 19.2MHz、4lane/200MHz、CSIPHY2。PMIC所在源码标签是&i2c4（0x890000），不可把运行i2c-1误作&i2c1（0x884000）。
- 正式两轮各3帧1928×1088 RAW10、2628608B，图案0/0、DMA覆盖/序号时间戳有效。自身MMCX384→0，VFE847000048Hz/CSID600MHz，结束后三路电源users0/disabled、MCLK0、sensor/CAMSS/CCI休眠，原媒体图恢复。首次另取3帧后被过严频率断言拦截，原失败保留，不算整轮验收通过。WirePlumber只在采集时短暂停止并finally恢复，没有持久禁用。
- 469秒最终健康：三个DSP running、taint/五类fault0；GPS0/Signalsfalse/rate30，BT关闭无连接，NV/产品程序保持。自动UTC准备第8次尝试后成功、chrony Normal；没有手动NTP/UTC/XTRA或新收星会话。167份本轮原生文件一致快照私人归档、逐成员核对，RAW场景/端点/私人标识及归档指纹不公开。

## 源码、产物与回退依据

- 内核 `/home/cy122/pmos-samurai-kernel136/kernel`，本轮仅改变36份已有改动中的板级DTS：68738cb9…；25 tracked/11 untracked仍未暂存。配置fbde3690…持久启IMX471/CCI，五个开发helper disabled。原16793符号保留+5CCI导出=16798，order772。Image183及旧canonical DTB22c1…保持；旧canonical不能刷作当前树。源与产物完整前备份在私人210/source-before。
- 私人210/modules为三模块，camera-dtb-r2为候选DTB，boot-partition-k210-front.img为当前镜像。回退boot在私人204/boot-partition-k204-bt-wake.img（cdd16e29…）；模块旧MFD/元数据在手机k210-install-before-r2及私人modules-before归档。正常回退需新核对当前设备，不使用旧marker。板级补丁及配置片段见reference/kernel210，完整kernel APK/rootfs尚未重建。
- 用户态root cam枚举1个Internal front camera，但CROP查询EINVAL、缺静态sensor属性/延迟/rotation，DMA provider失败禁用软件debayer。源码CROP分支赋值后break最终返回-EINVAL；SYSTEM/CMA heap在.config中为m，下一步核对安装/加载/节点/权限。不要将枚举或RAW成功写成完整拍照可用。
- 207已修TFTP回绕，原厂MCFG173文件8,807,671B自动RAM复制/mdtime可读，但mcfg.tmp仍0B；PDC1平台/25软件活动无pending是207实测。本轮没有PDC选择/激活或NV修改。radio新TFTP/wifi/MCFG仍未APK化，旧rootfs132和Mesa149打包债未完成。

## 续作与已知风险

211优先修IMX471 CROP返回值并做实际V4L2/libcamera验收，核对heap模块及访问权限/启动接入，推进普通用户态取流。当前已有WirePlumber自动持有7个闲置相机FD，做独占测试应核对真正持有者/休眠状态并恢复会话，不盲目卸载。之后验同镜像第二次启动与持续运行；完整断电冷启、四路PLDO输入、其它镜头/模式/曝光色彩方向均未验收。

GNSS真实fix/正CNR仍未解决。用户已明确手机在室内窗边，弱天空信号不能排除，尚无户外验收。209同会话1000→418ms UTC误差输入没有改变约6秒内部报告/收星，候选未部署；208原厂PQWM/PQWP已采，RF/天线不能由ADC变化推定正常。不重复同一时钟/收星对照。NTP启动延迟/GeoClue晚到Signals、原厂初始化/RF/LNA、精度冷启/SSR继续开放。[相关机型](reference/kernel205/GNSS-RELATED-DEVICES.md)。

保留完整目标：蜂窝真实SIM注册/数据/通话/SMS、传感器精度/FastRPC共享池与SSR/SSC首次204退出、BT phase5、Wi-Fi/USB PM、完整充电及其它外设、radio/Mesa可复现APK和新rootfs均未完成。[完整硬件清单](linux-port/docs/HARDWARE-STATUS.md)。
