# Realme X2 Pro 当前检查点

2026-10-18：[276公共CCI供电/标准手动对焦](reference/kernel276/README.md)、[275镜头生命周期及失败](reference/kernel275/README.md)。目标继续多个摄像头及骁龙ISP，按SoC/板级/驱动/用户空间收敛，保持active。三后摄＋前摄可取流，AF算法、画质、GUI/录像、Spectra仍未完成。

## 当前部署与启动身份

boot276/Image183，`7.3.0-rc6-rmx1931-samurai-k132+`，776模块/961包；libcamera五组件r22/config-r17、PW/SPA/Gst1.6.9-r3。boot SHA `0d6bbc0255fc7a44340b2c2c6a20f2bfa807f683f69dd20a3fb130d961dc4c64`，DTB `dcdd74ec903520c7023fa28badcb293b2e4e26ee5bac639497c63d53536b2c8d`。Image/logdump/固件可执行部分保持。[部署锁](linux-port/camera/deployment-lock.json)

运输用 `reference/kernel276/host.py`，guard `/var/lib/samurai/k276-work/boot-id-private.txt`，严格原SSH密钥/新USB接口；旧guard不可操作当前启动。实体按名称查找，编号会变。服务身份见[最终健康](reference/kernel276/final-health-validation.json)及手机`/var/lib/samurai/k276-services-current-private.json`，续作重核。275/276两次受控启动均终态成功，当前无待判定切换。

## 已验证与未验收

- 275新增标准LC898219XI模块与lens独占VAF，七包原生升级r22/r17；完整13包签名构建及功能QA通过，原214工作区/r21缓存保持。但独立镜头CCI超时，四摄枚举不等于镜头成功。保持IMX319可打开，仅保持CCI域/时钟仍失败，所有干预已恢复auto。[275](reference/kernel275/README.md)
- 276公共CCI驱动增加可选vddio与PM/回滚/移除管理，板级仅双CCI新增共享I/O supply；无SoC dtsi变化。W=1/schema通过，14个实际回调主机故障用例/UBSan通过。新CCI b2808f63，镜头03517eea，其余775模块不变，十个相关加载note匹配。
- 存活CameraManager四摄枚举后不持有lens fd，四sensor/lens/双CCI/CAMSS休眠，九rails与共享I/O OFF/users0、四MCLK/双CCI clock关闭，无新增CCI超时；所有sensor休眠时lens独立打开成功。[生命周期](reference/kernel276/manager-lifetime-validation.json)
- 原生libcamerasrc流中有lens fd及唯一VAF消费者，标准V4L2位置208/304/880/208产生明显失焦及返回恢复，边缘扩散代理9.4/8.04/46/8.88px。无raw I2C旁路，GET仅缓存目标；AE未锁、JPEG/统计非同request，无距离标定/AF算法验收。[光学](reference/kernel276/standard-focus-optical-analysis.json)
- 主摄RAW12/RGB12通过，RGB有一次跳号；前＋三后摄18段238帧交替/SIGINT正常退出/重开通过。未强杀，服务未重启。[四摄](reference/kernel276/four-camera-regression-validation.json)
- 最终49载荷、776模块/961包核验，fault0/taint0/pstore空，电源/时钟回收。275/276默认SSC/SensorProxy/greetd正常，三DSP运行、三传感器Has为true，无nodeps恢复。物理旋转未重测，273 EPERM根因未证明修复。GPU默认故障/Cairo CPU回退及旧modem watchdog保留。
- 273严格手动矩阵失败、274同96组矩阵两次通过均保留；未确认根因，r22完整矩阵未重测。四摄GUI/录像待验收；第四枚物理后摄未确认。

## 源码、回退与下一步

维护树 `/home/cy122/x2pro-linux/camera270-kernel` 干净分支`samurai-cci-io276`/`0d69276125ec8e7d0cc083ac421e2ad7fe79a3c8`，未推送。标准lens父提交0798ee688，原3184c56保留；in-tree不表示上游接受。实际r22/r17配方及[源码锁](linux-port/camera/kernel/source-lock.json)已提升，旧273/r21归档。Image183未整体重编，269完整候选未部署，最新完整统一Image/rootfs待做。

匹配276回退为boot275/旧CCI，双份24228955字节，SHA `a12acbdf518011cc6685f6e4be725893311b79e0188d965434fec94feeb3a5b2`。275另有boot273/r21/r16回退26120859字节，SHA `7fadb874f21e3f73c877c804af962005aa339ffe53e969f0728c0c2e1b81eadb`。均未实际往返。私人数据在`E:/edk2-samurai-out/kernel275`与`kernel276`，不公开像素/校准/密钥。

继续标准libcamera AF控制/算法与模组标定、r22手动矩阵、四摄GUI/录像及物理旋转；同步推进VFE170公共PIX/统计、参数接口与pipeline/IPA。当前CSIPHY/CSID/VFE RDI→RAW→CPU ISP，Spectra硬件成像未接通。[ISP分层](reference/kernel274/ISP-ADAPTATION.md)、[原厂资料用途](reference/kernel276/OEM-TUNING.md)。普通相机测试已授权，规则见[边界](WORKING-BOUNDARIES.md)；不重放已终态采集，其它硬件见[清单](linux-port/docs/HARDWARE-STATUS.md)。
