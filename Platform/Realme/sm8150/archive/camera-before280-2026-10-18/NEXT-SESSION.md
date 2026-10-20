# Realme X2 Pro 当前检查点

2026-10-18：[279现有方案/ISP源码候选](reference/kernel279/README.md)、[278标准单次AF](reference/kernel278/README.md)、[276镜头/CCI](reference/kernel276/README.md)。完整多摄及骁龙ISP目标active，优先查现有仓库/方案，按SoC/板级/公共驱动/用户空间收敛。GW1单次AF已实机通过；连续/距离标定、画质、GUI/录像、Spectra仍未完成。

## 当前部署与启动身份

仍boot276/Image183、`7.3.0-rc6-rmx1931-samurai-k132+`，776模块/961包；libcamera五组件r24/config-r19，PW/SPA/Gst1.6.9-r3。278只更新七包，未刷写/重启/替换或卸载驱动/改DT/停DSP。boot SHA `0d6bbc0255fc7a44340b2c2c6a20f2bfa807f683f69dd20a3fb130d961dc4c64`，DTB `dcdd74ec903520c7023fa28badcb293b2e4e26ee5bac639497c63d53536b2c8d`。[部署锁](linux-port/camera/deployment-lock.json)

运输用`reference/kernel278/host.py`，仍核`/var/lib/samurai/k276-work/boot-id-private.txt`，严格原SSH密钥/276USB端点；没有k278启动guard。按实体名找设备，编号会变。Phoc3586/Phosh3803保持，PW13112/WP13115正常重启加载r24，身份见手机`/var/lib/samurai/k278-services-verified-private.json`和[最终健康](reference/kernel278/final-health-validation.json)，续作重核。

## 实际验证与边界

- 276标准lens独占VAF/lens-focus、公共CCI共享I/O PM保持。CameraManager常驻枚举释放lens fd，所有sensor休眠时lens可独立打开；本阶段没有新增内核硬件ISP功能。
- 278通用libcamera将FocusFoM随frame按值穿过工作线程/IPA，不重读可变共享focus；每buffer明确V4L2单调时钟标志。标准lens控制有串号、结果与完成时间回执，按稳定时间＋曝光/读出预算排除旧帧；停流拒绝晚到动作。其它IPA共享统计未全面重构。
- 标准AfModeAuto、AfTriggerStart/Cancel与AfState已部署，Auto默认等触发，未声明Continuous或伪造LensPosition距离。行程208…926及搜索参数仅在设备数据包s5kgw1.yaml，匹配lc898219xi并校验driver0…1023；不是EEPROM/距离标定。
- 生产引擎Werror/ASan/UBSan覆盖粗细扫/复验、重复触发、取消/旧回执、Focused/Failed时取消忽略、错误/早帧/低纹理/超时/配置及时钟边界。r1编译const接口错误已终止/恢复，r2构建通过但未部署；r3补正确取消语义、两文件增量打包，完整补丁从r23独立重现。[源与失败](reference/kernel278/README.md)
- 原生公共API五场景共890组同request RAW/RGB：无触发48帧零AF命令；搜索293帧Focused选256/FoM4355；取消72帧回Idle；取消后重触发441帧Focused选272/FoM4121；扫描中停流36帧正常回收。扫描中重复Start忽略，Focused后Cancel保持；所有预期每4帧FoM均与同request RAW重算一致。[五场景](reference/kernel278/native-af-r1-validation.json)
- 自动曝光/增益AF另389组通过，曝光33215us、增益1…4.71875，Focused选320/FoM12297。配对测量扫描约9.05秒、AE下12.24秒，需加速；跨增益FoM不能直接比较画质。[AE AF](reference/kernel278/ae-af-r1-validation.json)
- 保持320后普通原生预览无新AF命令，私人JPEG场景/窗帘可辨，边缘代理8.75px，噪声/颜色/整体偏软仍在；与AF请求不同会话，不是完整画质标定。[样片边界](reference/kernel278/af-selected-preview-optical-analysis.json)
- 完整13签名包/全部功能/34 ELF/五IPA签名/ARM工具QtPython QA通过；原214工作区2254项恢复，r23缓存2276项及r2缓存2278项保留。七包原生事务/精确降级模拟通过，50载荷/全部776模块保持核验，十模块加载note匹配。
- 四摄18段232帧/SIGINT正常退出28帧/重开通过，无强杀或回归期服务重启。最终四sensor/lens/双CCI/CAMSS suspended，九rails/共享I/O OFF/users0，四MCLK/双CCI clocks0，fault0/taint0/pstore空、CCI无错误。[最终健康](reference/kernel278/final-health-validation.json)
- SSC/SensorProxy/greetd正常、三DSP运行，物理旋转未重测；旧273 EPERM根因、GPU默认故障/Cairo CPU回退、旧modem watchdog开放。273严格手动矩阵失败与274两次通过均保留，r24完整矩阵/GUI/录像未验收；其它镜头AF和第四枚物理后摄待接入/确认。

## 源码回退与下一步

279独立候选`camera279-isp-kernel`/`samurai-isp279-candidate`提交`30b0daa8cab27f64be4f058629b65f8af1a7cc6f`，未部署/推送。准确SM8650 RFC迁移公共outputs/params/stats并修VFE170接口/IRQ/固定RDI及header-only DISABLE；30组件和V4L2对象W=1/-Werror零诊断，ASan/UBSan通过。非VFE170硬件成像证明，完整链接/启动/实机待做；[279证据](reference/kernel279/README.md)。279只读复核现机50载荷/776模块/服务/PM保持；运输`kernel279/host.py`仍核276 guard。

内核维护树`/home/cy122/x2pro-linux/camera270-kernel`仍`samurai-cci-io276`/`0d69276125ec8e7d0cc083ac421e2ad7fe79a3c8`，未推送，父0798ee688及原3184c56保留。r24/r19真实配方/锁已提升，旧r23/277归档；0028为下游公共libcamera补丁，未上游接受。Image183未整体重编，269完整候选未部署，最新完整统一内核/rootfs待做。

278匹配r23/r18七包回退2533478字节，SHA `f90a2ba7695c1a0364e6b27e217c91f28c6022508b77243530d7167bab07f570`，手机/PC双份，未实际往返。277另有r22/r17回退fb587046（2529160字节）；276 boot275/旧CCI回退a12acbdf、275 boot273/r21/r16回退7fadb874保留。私人数据`E:/edk2-samurai-out/kernel278`，不公开像素/校准/密钥。全部构建、包事务与采集终态，不重放。

继续AF加速/更多场景、Continuous、手动距离标定及GUI标准控制接入，四摄录像和画质；同步推进VFE170公共硬件PIX/统计/参数接口及pipeline/IPA。当前仍CSIPHY/CSID/VFE RDI→RAW→CPU ISP，Spectra硬件成像未接通。[ISP边界](reference/kernel274/ISP-ADAPTATION.md)、[原厂依据](reference/kernel276/OEM-TUNING.md)。普通相机测试已授权，规则见[边界](WORKING-BOUNDARIES.md)，其它硬件见[清单](linux-port/docs/HARDWARE-STATUS.md)。
