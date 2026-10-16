# Realme X2 Pro 当前检查点

2026-10-16，238为progress：完整r14/r9候选、IMX319 48帧RAW控制通过；RGB48帧中启动q1全零，严格验收失败，未安装。匹配vendor GNSS离线核验和近机型研究完成，真fix未解决。goal active。[238](reference/kernel238/README.md)、[近机型方案](reference/kernel238/RELATED-LINUX-SOLUTIONS.md)、[237归档](archive/NEXT-SESSION-through237-2026-10-16.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与状态

仍236启动，guard /var/lib/samurai/k236-runtime/boot-id-private.txt，233及更早无效。运输reference/kernel238/host.py、私人238/current-work-private.json。所有root worker/构建/export终态，无切换待决；238 trace/临时挂载已清。三个只读代理已收束，手机仍主线程串行操作。

boot235 44c6a215…/100663296B，DTB469e1456…、Image183 bfa72dd9…、logdump183 e73754c7…；MFD6021a359…/22208B、lab5198e2bd…/17992B、provider2223f337…/9744B、IMX319176f68d7…/36624B、前摄e49dab26…/29536B、CAMSSff9fdfa3…/777680B、FastRPC2abde0ea…/50192B、BT185f6c5ed35…保持，默认与加载note匹配。775ko/789文件权威清单k237-camss-install/module-inventory-after-private.json，236的CAMSS清单旧。

系统libcamera仍99990.7.2-r13/config0.1.0-r8，包库/用户态/loader保持；r14仅RAM /run/samurai-camera238-r14。两sensor/CCI0/CCI1/CAMSS suspended、四camera rails OFF/users0、MCLK1/2关；三DSP running、SensorProxy三Has、Wi-Fi/chrony正常，taint/fault0。BT Powered=true/Discovering=false/1连接仅观察，不pair/connect/disconnect。GNSS idle0/Signalsfalse/rate30，watch idle/timeprepared/dataworker0；MM−1/reason2/power1，用户无SIM。238没搜星/SET、没重启/刷分区。

## 源码、产物与回退依据

最小0021仅注册IMX319 gain helper：1024/(1024-code)，2/4/8倍=512/768/896，无blackLevel/像素尺寸/延迟。原20补丁/全部管线/Qt/Python/GStreamer/5IPA保留，13签名包、34AArch64 ELF和5IPA对内嵌key验签通过。实际C++遍历961码、旧r13负对照通过；原214全部2254文件/链接/模式恢复，r13缓存保持。

SDK /home/cy122/x2pro-linux/libcamera214-root：r14源码/对象 /work/libcamera238-r14-built/src/libcamera-v0.7.2，输出/packages238-r14及/packages-config238-r14，QA /candidate238-r14；主机QA prefix /home/cy122/x2pro-linux/libcamera238-r14-qa-prefix，私人238/camera-forward-repo-r14保留13包/manifest。RAM49文件来自7包，config父目录已755并经UID10000读验。首次错anchor后错误续启构建，编译前失败/恢复，失败cache另存且r14脚本已前置assert。

RAW probe源556681ba…/二进制8a697139…91888B；RGB源0b63e607…/二进制6e091556…92000B。RAW r1因CPU config父目录700失败；RGB r1因1632宽被CPU边界改1624在configure前退出，两次清理与失败保留。r2均独立context，未盲重放。

RAW r2四阶段各12帧/最后6settle：1999us/1→31995us/1→31995us/8→1999us/1，均值63.973→64.717→70.595→63.973，std0.386→1.213→9.233→0.386。I²C发送trace exposure201→3216→201、gain0→896→0，8核loss0；不是ACK/readback。过渡约一帧错位未物理标定，噪声变化不足以验收光学成像。

RGB r2 1624x1224程序exit0/48帧/元数据/全清理通过，但仅queued_index1/sequence1 allzero，wrapper exit1/passed=false必须保留；q0=14..15，q2=33..38。97原生证据成员私有逐一验证，vendor首采54/补采27成员另存，不公开payload/指纹/场景。RAW日志真实存在于debayer_cpu.cpp及r2 stderr；此前称日志不存在是搜错文件，已纠正，不抹旧收据。

canonical仍精确after228（16798符号/772顺序），其中旧216相机/旧CAMSS输出不能整刷。回退设备k237-camss-install/before有旧fae1+metadata，235-stage/before有旧232 MFD/config，236-lab-fix/before有旧lab。当前lab有IMX319消费者，不能复演未绑定/ref0热卸；不热卸有children的MFD。私人235 boot、23245f398f2…、219156f0370…回退保持，完整风险看237归档。

## 续作与已知风险

先诊断RGB启动：实际IPASoftSimple start准备参数却未立即通知DebayerParams，随后异步更新；BLC默认16约RAW10 64DN，直方图可降12。公式对高8位15/16依次得到14/15→0→33/38，与三帧吻合但尚非同帧实参证明。上游255→16及缓存复位等效修复已在r14，不重套；不复制一加IMX371猜测4096黑电平。下步固定2ms/1倍短12帧，记逐帧SensorBlackLevels/ColourGains/Gamma/实际Debayer参数，必要时同request配对RAW/RGB。保持passed=false直至解释/修复；之后前摄r14回归再考虑默认安装。前摄纯色按用户延期，不再索要，仍只RAM统计/不加光。

S5K3M5先读私人237/next-agent-results-private.md：两种192前缀XML投影+独立有界decoder验917init（末0x0101 WRITE8、其余16bit、5us微秒延迟）和4x53模式，保留6f12重复写；本机19.2MHz/CCI1 master0 0x2d/reset23/MCLK3/CSIPHY3，与Hotdog24MHz不同。P现仅mask9 L1/L4；新增L2/L6严格mask0x22及共享lease/复位隔离未完成，不猜VIN。

GNSS实际vendor Android16/SDK36，API30实现+API36接口标记不足以判ABI错配；115↔238分区相同=true，关键公开vendor文件逐字节相同不代表全包。vendor无gps.conf，设备树放ODM；205 gps与228 ODM izat仅社区资料，未采本机ODM，不称一致或变化。liblbs_core离线按izat推演0x84 Cell(type0,cfg0)/WiFi(3,0)/SAP(1,2)，每条1000ms等0x84；不是观测Android发包/RF开关，sap mode2是MODEM_DEFAULT。libsynergy缺失有LBSApiV02 fallback，loc_net_iface属AGPS，不证standalone依赖。下一项仅匹配ODM gps.conf来源；未得到新SET方案，不重复同CID/GSV/unlock/辅助矩阵。Hotdog GNSS仅启停，SurfaceDuo/一加6成功是厂商HAL路线；gnss-share已核MM后端无XTRA。其它后摄、光学颜色、GNSSfix、蜂窝业务/SSR和全机长稳仍见硬件清单。
