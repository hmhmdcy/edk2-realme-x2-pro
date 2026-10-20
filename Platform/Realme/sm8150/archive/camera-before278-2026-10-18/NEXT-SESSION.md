# Realme X2 Pro 当前检查点

2026-10-18：[277 RAW清晰度/标准FocusFoM部署](reference/kernel277/README.md)、[276公共CCI与标准镜头](reference/kernel276/README.md)。完整多摄及骁龙ISP目标active，按SoC/板级/公共驱动/用户空间收敛。三后摄＋前摄可取流；AF搜索/标定、画质、GUI/录像、Spectra仍未完成。

## 当前部署与启动身份

boot276/Image183、`7.3.0-rc6-rmx1931-samurai-k132+`，776模块/961包；libcamera五组件r23/config-r18，PW/SPA/Gst1.6.9-r3。277只更新七包，未刷写/重启/替换或卸载驱动。boot SHA `0d6bbc0255fc7a44340b2c2c6a20f2bfa807f683f69dd20a3fb130d961dc4c64`，DTB `dcdd74ec903520c7023fa28badcb293b2e4e26ee5bac639497c63d53536b2c8d`。[部署锁](linux-port/camera/deployment-lock.json)

运输用`reference/kernel277/host.py`，仍核`/var/lib/samurai/k276-work/boot-id-private.txt`，严格原SSH密钥/276USB端点；没有k277启动guard。实体按名称查找，编号会变。服务见手机`/var/lib/samurai/k277-services-verified-private.json`及[最终健康](reference/kernel277/final-health-validation.json)：Phoc3586/Phosh3803保持，PW10140/WP10143正常重启后加载r23系统库。续作重核，不复用已终态采集。

## 已验证与边界

- 276标准LC898219XI/VAF唯一消费者、sensor lens-focus及公共CCI可选vddio已部署；SoC域原本正确，板级仅双CCI共享I/O。CameraManager常驻枚举不持lens fd，所有sensor休眠时lens可独立打开。13镜头/14CCI实际回调主机用例、schema与W=1通过。[276](reference/kernel276/README.md)
- 277通用软件ISP新增RAW绿色空间统计，4×3分区、平滑梯度、亮度归一化，有界320×240取样；标准FocusFoM仅在统计有效且frame匹配时报告，每4帧一次，无机型/应用分支。20组格式/绿色相位、CSI-2/非打包等价、边界与ASan/UBSan通过。[源码](reference/kernel277/focus_stats.h)
- 原r22独立helper和新r23两轮各96组同请求RAW/RGB，固定31999us/1倍增益，位置208/304/880/208。r23中位FoM3921/4204.5/684/3945；失焦下降并返回恢复。全部已报告元数据与同request RAW重算一致，稳定阶段12个报告样本。独立重算约10ms，不是整链时延/30fps验收。[元数据](reference/kernel277/focus-metadata-r1-validation.json)
- FoM硬件光学曲线只验证GW1；其它三摄取流已回归。镜头GET是缓存目标，无位置反馈/距离标定。没有AF搜索、AfMode/AfTrigger/AfState产品实现，不能以扫描探针代替AF。
- 完整13签名包正常abuild及功能/五IPA签名/ARM工具/Qt/Python QA通过；原214工作区2254项恢复、r22缓存2274项保持。原生七包更新及精确降级模拟通过，其余954包记录、全部776模块保持，49载荷与十模块加载note匹配。[最终健康](reference/kernel277/final-health-validation.json)
- r23前＋三后摄18段241帧交替、SIGINT正常退出37帧及重开通过，无强杀，回归期无服务重启。最终四sensor/lens/双CCI/CAMSS suspended，九rails/共享I/O OFF/users0，四MCLK/双CCI clocks0，fault0/taint0/pstore空、CCI无错误。[四摄](reference/kernel277/four-camera-regression-validation.json)
- SSC/SensorProxy/greetd正常、三DSP运行，三Has为true；物理旋转未重测，273 EPERM根因未证明修复。GPU默认故障/Cairo CPU回退、旧modem watchdog开放。273严格手动矩阵失败及274同矩阵两次通过均保留；r23完整矩阵/GUI/录像与新像素视觉复核仍待做，第四枚物理后摄未确认。

## 源码回退与下一步

内核维护树`/home/cy122/x2pro-linux/camera270-kernel`仍干净`samurai-cci-io276`/`0d69276125ec8e7d0cc083ac421e2ad7fe79a3c8`，未推送；父0798ee688及原3184c56保留。实际r23/r18配方/锁已提升，旧r22/276归档；0027是下游公共软件ISP补丁，未上游接受。Image183未整体重编，269完整候选未部署，最新完整统一内核/rootfs待做。

277七包匹配回退2529160字节，SHA `fb587046bc48d22fc9e23b3ddd1cb0a1a0a802ec53f0250c9564191b8beab039`，含实际旧r22/r17签名包及配置/数据库/服务备份，手机PC双份，未实际往返。276另有boot275/旧CCI回退a12acbdf（24228955字节），275另有boot273/r21/r16回退7fadb874（26120859字节）。私人资料`E:/edk2-samurai-out/kernel277`，不公开像素/校准/密钥。

继续libcamera标准AF控制/搜索与模组标定，处理移动稳定、陈旧帧、低纹理失败、取消/连续模式；再做完整矩阵、四摄GUI/录像/画质、旋转。同步推进VFE170公共硬件PIX/统计、参数接口、pipeline/IPA；当前CSIPHY/CSID/VFE RDI→RAW→CPU ISP，Spectra硬件成像未接通。[ISP边界](reference/kernel274/ISP-ADAPTATION.md)、[原厂资料用途](reference/kernel276/OEM-TUNING.md)。普通相机测试已授权，规则见[边界](WORKING-BOUNDARIES.md)，其它硬件见[清单](linux-port/docs/HARDWARE-STATUS.md)。
