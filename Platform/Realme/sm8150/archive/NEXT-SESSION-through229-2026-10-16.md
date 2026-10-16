# Realme X2 Pro 当前检查点

2026-10-16，229：白天4MP RAW/RGB各6帧及32帧RGB逐通道统计通过，确认非全零且有颜色差异，未保存场景，颜色准确度仍未验收。228已实测FastRPC保活1→2→1、五类SSC及活动Wayland用户Claim/Release。当前启动身份新228；boot219镜像/Image183、r13/r8保持。运行外建7ca5/O/4096，默认树内2abde已暂存，下一步干净启动。全goal active。[229](reference/kernel229/README.md)、[228](reference/kernel228/README.md)、[旧交接](archive/NEXT-SESSION-through227-2026-10-16.md)、[边界](WORKING-BOUNDARIES.md)。

## 当前部署与已验证状态

- 当前运输reference/kernel229/host.py，严格USB邻居/原公钥；guard /var/lib/samurai/k228-runtime/boot-id-private.txt。228已实际重启，219/226/227旧guard全部失效。当前无活动切换/构建/捕获；最终三DSP running、Wi-Fi connected、chrony Normal。
- boot219镜像156f0370…/DTB a214fd6b…，Image183 bfa72dd9…/logdump183 e73754c7…，228没有刷写。IMX471 e49dab26…/29536B、CAMSS fae1ed40…/777360B保持，772ko/786模块相关文件。相机/CCI/CAMSS休眠、前摄双轨关/用户0、图案0、unprocessed_fullres=N，五类fault0。
- FastRPC运行7ca5d442…/50216B，外部M=标记O导致taint4096，仅此模块有taint；不是WARN，不能写成taint0。默认文件已原子暂存真正树内2abde0ea…/50192B/intree=Y，尚未加载。二者19540字节.text逐字一致。当前refcount1，额外ADSP open→2/close→1；原189为FD1/ref0。严禁据旧ref0或强制热换。
- 228新启动自动SSC真实加速度/光线readiness，三Has真；标准五流计数55/46/9/9/1，皆干净disable。UID-only SSH子进程被策略拒绝，保留失败；核验实际active seat0 Wayland UID10000后仅移动一次性子进程至该cgroup，三Claim/Release通过，原策略未变。新候选尚未复测PM/SSR/物理精度。
- 相机全栈r13/config-r8，944包数据库保持。通用堆root/video0660+uaccess、FastRPC池root0600，CPU/system配置保持。新启动WP/桌面正常，重载须现取argv/env。
- 229 RAW4M六帧63–1018/std约37；RGB4M先6帧后32帧均有效非零。末帧BGR顺序已核对，R/G/B均值71.11/72.45/70.69，12.86%像素通道差≥12，clip约0.074%。曝光33192µs/gain1→1.573仍调，不称AE收敛或颜色准确。仅RAM统计，无图像文件/外部照明，图格式/控制/PM恢复。
- IMX471 CCI1 master1/0x10、MCLK2 19.2MHz、4lane/CSIPHY2/独立TITAN_TOP；默认2M/4M，16MP开关N。225手动控制/来源关联/生命周期修复保持。夜间223 RAW62–133/std2.66是旧样本，不作同曝光对照。
- 当前GPS0/Signalsfalse/rate30，watch空闲/data workers0、UTC自动准备。226四轮零CNR与168h XTRA属于上一启动，228/229没有重新注入/搜星或核对有效期。MM191保持，State−1/原因2/Power1；用户无SIM，业务待有卡，GNSS不依赖SIM。BT关/无连接，本启动重组错误0，不代表phase5已修复。

## 源码、产物与回退依据

- canonical /home/cy122/pmos-samurai-kernel136/kernel的FastRPC已正式整合f378afed…，树内对象/ko更新；16798符号/772顺序完整保留，Image/DTB/配置及其它核查项不变。after依据私人228/canonical-after-private.json。相机canonical仍216 IMX/旧CAMSS，不刷旧canonical树的整体输出。当前相机源锁在camera/kernel/0005及223。
- 完整FastRPC GPL源码、相对189的增量补丁和分开的运行/暂存锁：linux-port/ssc/kernel。外建候选7ca5在私人227，树内2abde在私人228/fastrpc228-intree-private.ko。真实树内目标W=1/modpost通过，11.3秒，没有插入intree宏。227的11例ASan/UBSan及原版负对照保持；189 freezer逐字保留。
- 原189模块88553112…/50240B：设备k228-baseline/fastrpc-original-private.ko及私人227/228/canonical-fastrpc-before。外建7ca5回退副本在k228-intree-stage；默认树内清单k228-intree-stage/module-tree-after.sha256。其余785条及包/程序/配置/NV/persist/boot/logdump保持。回退需核对当前身份，不能用旧启动卸载脚本。
- 相机canonical锁r13/r8、20补丁/13包。SDK原work/libcamera2254项恢复；r13缓存libcamera225-r13-built/src/libcamera-v0.7.2，229仅在private新编客户端。旧186/189构建器符号数过期，不能重放。
- 相机回退r13→r11/config-r6：设备k224-r11-package-candidates/forward、私人224/camera-forward-repo-r11，恢复225事务的前world/repo/配置并重载WP，保持fae1/e49；仅模拟通过。勿混旧r8/82c。
- 私人228/current-work-private.json与229/current-work-private.json均保留当前身份；228原生119成员归档逐项核对，含首观察器OOT失败、UID策略拒绝/修正、重启路径错误后明确状态恢复、两种模块。229像素仅RAM，数值/日志另收；归档指纹不公开。最后镜像227为8325文件/HEAD5c80582，228/229镜像由新私人收据确认。

## 续作与已知风险

优先对暂存2abde做受控新启动，要求loaded-note/taint0及readiness/五流/活动用户/模块保活。preboot须记录运行7ca5与默认2abde差异，只接受已分类O4096，不能套原88553基线。只重启不刷写；228路径错误在syscall前恢复，末回执丢失由fresh fastboot及新Linux身份闭合。

用户最新关注白天颜色。已有颜色信息，但真实CFA/几何/方向/白平衡/标定、光学2/1帧延迟/GUI/实时性能仍开放；不把全局通道均值接近当准确颜色。16MP保持实验，不无端重复已过控制矩阵。GPU ISP211 CMA黑帧/unmap349 WARN仍开放。

后摄四路未出图；先解决P/Q显式依赖和早期P reset/gpio-hog所有权，PLDO VIN未知不猜供电。IMX319 OF/资源/runtime PM候选、GW1 CPHY独立核验、3M5缺GPIO按OEM no-op、人像型号未知，见227/PM8008-DEPENDENCY。

GNSS仍无正CNR/TRACK/fix，继续查已有TFTP/RMTFS请求错误，再择一次有信息增量的RF/资源时间线；不能从clk prepare0推断XO物理关闭，不能抄Hotdog suspend watchdog修复当零CNR修复。室内窗边/无SIM，无室外或同机Android基线，不重做191/201 online、209精度、226 HIGH/注入负对照。

三路只读授权继续，手机串行。FastRPC invoke/put_work/DMA/SSR及reclaim−22、BT phase5只扫描、Wi-Fi/USB PM和大块截断、音频长稳/暂无耳机、充电保护、指纹/NFC实卡及rootfs132整合见[清单](linux-port/docs/HARDWARE-STATUS.md)。
