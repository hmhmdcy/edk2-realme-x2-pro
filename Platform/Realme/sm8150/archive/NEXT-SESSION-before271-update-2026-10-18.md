# Realme X2 Pro 当前检查点

2026-10-18：[270多摄适配进行中](reference/kernel270/README.md)。S5K3M5长焦已接入公共驱动/静态DT，现有前摄和两颗后摄可原生枚举、采集。**用户调整场景后长焦已有可辨认实景，但明显欠曝/噪点重；画质、多后摄GUI、主摄和骁龙硬件ISP未完成；goal保持active。**

## 当前部署与启动身份

手机已完成一次受控切换：只刷boot270，完整分区读回SHA256 `0904b3b6616652e08709891cfdee34f1f733ff1e7022b7749bedea758108e4e8`。Image183/logdump保持，release仍`7.3.0-rc6-rmx1931-samurai-k132+`，774个模块、961个包。新S5K3M5模块SHA256 `22315c6f3eb233add16e33658bd071dbc973499744b21323adf8b771c1552f72`，现机已有CCI模块与本次构建逐字一致，其余773模块未替换。七个相机/依赖模块加载note与磁盘一致。[部署读回](reference/kernel270/postboot-identity-validation.json)、[实际绑定](reference/kernel270/postboot-hardware-validation.json)。

当前运输入口`reference/kernel270/host.py`，严格原SSH主机密钥、新鲜发现的私人USB端点，读取私人`postboot-verified-private.json`。手机guard `/var/lib/samurai/k270-work/boot-id-private.txt`。269及更早guard/PID已失效；不要绕过旧guard或覆盖旧记录。当前桌面/音频服务身份由手机`/var/lib/samurai/k270-services-current-private.json`维护，续作先核。新启动为正常锁屏，未改锁屏/idle偏好；新启动的自动旋转实屏效果和多后摄Snapshot菜单未验收。

用户态r19/config-r14/PipeWire/SPA/GStreamer1.6.9-r3沿用，APK数据库未变。CPU软件ISP/system heap与Snapshot Cairo/禁用GL、Vulkan、offload回退保持；默认GPU故障未修。269新完整Image/773模块构建仍保留且未部署，本轮不是把269完整内核晋升为已验收系统。[269历史](reference/kernel269/README.md)。

## 本轮已经验证

- 新S5K3M5完成正常chip-ID探测并绑定，标准cam枚举IMX471前摄、IMX319后摄和S5K3M5长焦；首个长焦模式2104×1560，RAW/RGB各12帧通过。[首次采集](reference/kernel270/telephoto-capture-validation.json)。
- 两颗后摄经标准libcamerasrc/CPU JPEG，各36帧并各保存一张私人JPEG，IMX319输出1600×1200、长焦2048×1536；这只证明编码/采集路径，不是长焦光学画质通过。[JPEG](reference/kernel270/two-rear-jpeg-validation.json)。
- 14段独立标准cam调用，共192帧，包含前摄/两后摄交替、长焦SIGINT正常结束和重开。每段资源回收、三MCLK关闭、fault增量0、taint0，无服务重启。[回归](reference/kernel270/three-camera-regression-validation.json)。
- 同一启动S5K3M5物理sensor彩条36帧，生成正确白黄青绿品红红蓝黑彩条；CSID测试图案未改，结束后sensor pattern恢复0、PM正常。[彩条](reference/kernel270/telephoto-bars-validation.json)。
- 旧场景24组配对RAW近黑电平。用户确认摆放正常照明、无遮挡场景后，再测24组：2ms均值65.79，32ms均值93.22/std16.79/max145；两后摄再各36帧并生成JPEG。私人原图核看均有可辨认实景，长焦仍明显欠曝/噪点重；没有改软件，不把场景改变算驱动修复。资源回收/fault0/taint0。[新场景](reference/kernel270/scene-r2-optical-review.json)。

旧269启动上的Snapshot前后切换/两张GUI JPEG也在本轮通过，但它只覆盖IMX471与IMX319；不扩写为新启动三摄GUI验收。旧启动原Snapshot意外重启与modem watchdog仍未解决，原pstore私人备份保持。当前受控启动pstore为空不抹去旧故障。

## 源码、回退与下一步

维护候选WSL `/home/cy122/x2pro-linux/camera270-kernel`，分支`samurai-multicamera270`，sensor提交`20393178c30c9043d5fbf1ffc9aa7889421f5db0`，板级提交`edd2e8c14a760b8a889b9313f45acfc1d015a7fb`。正常19.2MHz配置由标准compatible/时钟选择，不再依赖lab provider、机型根判断或驱动内电压常数；P L2/L6等接线在DTS。匹配Image183模块W=1零诊断、四类schema、实际供电函数882个ASan/UBSan API故障模型通过；模型不是内核并发或硬件故障注入。两提交本地保持，尚未发布。

私人PC目录`E:/edk2-samurai-out/kernel270`，含新boot、原boot267锁、双端模块回退、自己拍摄的JPEG、原日志和当前启动身份。只有boot已刷一次，logdump/NV/校准/工厂备份未刷；切换前source NV哈希核对通过。模块/工具上传、guard采用、quiesce、restart2、flash、拍摄及各构建目录都已执行，不可重放。新上传probe位于`/run/samurai-camera270-probes/telephoto-paired-probe270`；首次上传在写入前失败，确认0字节/无capture context后分块恢复成功。

用户已回复“已摆好，可以测试”，上述新场景测试完成。继续长焦曝光/增益与AF/模式核对。新sensor仍报告Selection默认区域和静态属性缺失，需依据真实模式补齐，不能用假几何或虚构delay消除日志。随后补标准GUI多后摄选择、颜色/方向/画质、完整模式/录像、GPU与长稳。当前分层和升级依赖见[审计](reference/kernel270/LAYERING-AUDIT.md)。

S5KGW1主摄已对本机Sunny/Qtech两份BIN完成边界检查与各两种schema投影交叉验证：每份10模式、51初始化记录，包含11条WRITE_BURST，uint32数组/8字节对齐不能沿用旧单值qword读法。原始BIN未改，未对主摄上电/写寄存器。首次XML导出达到16MiB上限，完整退出后新目录按64MiB文件/256MiB内存/15秒CPU/20秒墙钟限制成功，原失败保留。[主摄数据](reference/kernel270/gw1-metadata-validation.json)、[交叉核对](reference/kernel270/gw1-crosscheck-validation.json)。实际模组变体、主摄driver、C-PHY端点、AF及候选人像sensor仍待完成。

目前使用骁龙CSIPHY/CSID/VFE RDI采集RAW，再由libcamera CPU软件ISP处理；没有接通Spectra硬件成像处理，GPU软件ISP也不等于Spectra。完整kernel/rootfs重建、其它硬件状态和规则仍见[硬件清单](linux-port/docs/HARDWARE-STATUS.md)、[操作边界](WORKING-BOUNDARIES.md)。目标未完成。
