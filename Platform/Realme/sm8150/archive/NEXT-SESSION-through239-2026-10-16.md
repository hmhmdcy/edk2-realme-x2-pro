# Realme X2 Pro 当前检查点

2026-10-16，239为progress：r15/r10完整构建及七包默认安装完成，实际同相机两次start首参正确；光学/颜色、后摄全零帧和GNSSfix仍开放，goal active。[239](reference/kernel239/README.md)、[Linux使用与近机型](reference/kernel239/RELATED-LINUX-SOLUTIONS.md)、[238归档](archive/NEXT-SESSION-through238-2026-10-16.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与状态

仍236启动，guard /var/lib/samurai/k236-runtime/boot-id-private.txt，233及更早无效。运输reference/kernel239/host.py、私人239/current-work-private.json。所有root构建/worker/export终态，无切换待决；239 trace/临时挂载已清。三只读代理研究已完成；手机仍主线程串行操作。

boot235 44c6a215…/100663296B，DTB469e1456…、Image183 bfa72dd9…、logdump183 e73754c7…；MFD6021a359…/22208B、lab5198e2bd…/17992B、provider2223f337…/9744B、IMX319176f68d7…/36624B、前摄e49dab26…/29536B、CAMSSff9fdfa3…/777680B、FastRPC2abde0ea…/50192B、BT185f6c5ed35…保持。775ko/789文件权威清单k237-camss-install/module-inventory-after-private.json，默认和加载note匹配。

系统libcamera/IPA/tools/GStreamer/V4L2=99990.7.2-r15，config/stack0.1.0-r10。49payload记录及944包总数/937无关记录核验；默认无候选环境取流、WirePlumber新库重载均通过，PipeWire/Phosh/Phoc/session身份保持。旧236 userspace-check含r13库hash，不可盲套；239 final-health按新49路径验证、其余旧hash与loader不变。

两sensor/CCI0/CCI1/CAMSS suspended、四camera rails OFF/users0、MCLK1/2关；三DSP running、SensorProxy三Has、Wi-Fi/chrony正常，taint/fault0。BT Powered=true/Discovering=false/1连接只观察，不pair/connect/disconnect。GNSS idle0/Signalsfalse/rate30，watch idle/timeprepared/dataworker0；MM−1/reason2/power1，用户无SIM。239无GNSS搜星/SET，无刷写/重启。

## 源码、产物与回退依据

0021 IMX319 helper已随r15安装：gain=1024/(1024-code)，8倍896。0022 0150a091…在同步IPA start后saveIspParams，并发布初始combinedMatrix、加入CPU真实frame/sequence/timestamp日志；不改BLC/调校/控制延迟/异步逐帧API。22补丁/全管线/Qt/Python/GStreamer/5IPA保持，13签名包/34AArch64 ELF/5IPA验签和ARM入口QA通过；实际仅装七运行包。原214的2254文件/链接/模式恢复，r14缓存2269不变。

SDK /home/cy122/x2pro-linux/libcamera214-root；r15源/对象 /work/libcamera239-r15-built/src/libcamera-v0.7.2，输出/packages239-r15及/packages-config239-r15、QA /candidate239-r15。主机QA /home/cy122/x2pro-linux/libcamera239-r15-qa-prefix；私人239/camera-forward-repo-r15完整13包、camera-runtime-repo-r15实际七包，RAM /run/samurai-camera239-r15。主配方/部署锁已更新r15/r10。

持久仓库 /var/lib/samurai/k239-r15-package-candidates/forward/packages.adb；原生r15→r13/r8七包降级模拟通过，未完整往返。旧实际七包k225-r13-package-candidates/forward、事务前world/repos/config/DB在k239-r15-package-transaction。r13→r11旧回退保持。239原生153成员私有归档逐一核对，无场景像素；ODM2文件另导出，不公开payload/指纹。

canonical精确after228（16798符号/772顺序），旧216相机/旧CAMSS输出不能整刷。设备k237-camss-install/before旧fae1+metadata、235-stage/before旧232 MFD/config、236-lab-fix/before旧lab；私人235boot、23245f398f2…、219156f0370…保持。lab有消费者不能复演未绑定/ref0卸载，不热卸有children的MFD。未知VIN不猜。

## 续作与已知风险

239配对12request：RAW1632x1224/stride2048与RGB1624x1224/stride4872，同seq/time；一处源seq跳5但严格递增，不强求seq=requestidx。全有效像素统计与LUT边界重算通过，不声称不同ROI逐像素等价。RAW约63–72DN/mean63.965、BLC16时RGB几乎0，BLC12后约37；噪声/非零不证明光学正常。r14旧FIFO参数0→16→12、gamma1→1/2.2已证。

r15候选和默认各同Camera configure一次/stop-start两次各12帧，Processing身份逐帧匹配，首BLC16/gamma1/2.2/gains1/identity均正确，无旧参残留。严格全非零仍失败：候选run0q0–1/run1q0–3，默认run0q0–3/run1q0–2；program0/diagnostictrue不抹passedfalse。非identityCCM未运行测。前摄r15候选RAW/RGB各6帧通过，用户纯色测试延期，不再索要。后摄朝向可选问题未答，不能断言桌面遮挡；只RAM统计不存图/加光。

S5K3M5两schema投影和独立原BINdecoder已全核917init+4x53模式；末0x0101 WRITE8、row5 delay5微秒、6f12重复写保留，原BIN不变。append relative=EOF-dataoff124448保留24B section2尾；两reader已终态，XML initSettings/initSetting层级修正后复用结果不重跑。模式3=2104x1560/4lane/LLP9648/FLL1663，无PDAF流，OEMclk481930000只是元数据。资源：CCI1 master0 0x2d/reset23/MCLK3 19.2M/CSIPHY3，VIOpm8150l_l1/VANA P L6 2.8V/VDIG P L2实际1.056V，AF P L3另路。现lab mask9 L1/L4；下一步严格L2/L6 mask0x22/shared lease/复位隔离及S5K驱动离线适配，不能整抄Hotdog24M/602.5M。canonical S5K get_selection height=width bug仍在。

最新上游S5K3M5已OF但仅24M，IMX471为ACPI笔记本1928模式，不覆盖本机e49；OV02A10有endpoint修复但本机物理身份未验，GW1未找到可直接用驱动。Hotdog四摄可参考、GNSS仍只启停；X3未启相机端点，OPPO有不同电源/时钟，samurai Halium camera/GPS未勾。SurfaceDuo同SM8150通过vendorHAL+binder+GeoClue取得fix，移植须匹配ABI依赖，不单拷so。

GNSS实际ODM gps.conf已ro采/卸载/前后hash同，Android16/SDK36；与205社区e7c13逐字节一致，39启用/34数值。实际libloc_core35表默认GPS_LOCK3/LPP0/CAP7/MODEM2不等于运行值；ODM无GPS_LOCK/LPP2/CAP23/MODEM1。libgps.utils固定vendor/etc/gps.conf无ODM回退，尚无Android映射/注入证据。RF_LOSS日志在reportSv不证LNA供电；不从AOSP缺键推运行0。MM SUPL字节序修复本机已含；gnss-share MM无自动XTRA。未得到新RF SET依据，不重跑已覆盖同CID/GSV/unlock/辅助矩阵。GNSS真fix、其它后摄/蜂窝业务/蓝牙传感器长稳及完整kernel/rootfs仍待完成。
