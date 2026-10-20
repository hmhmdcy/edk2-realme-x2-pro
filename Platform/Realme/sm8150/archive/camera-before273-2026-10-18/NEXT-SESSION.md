# Realme X2 Pro 当前检查点

2026-10-18：[271长焦细分增益与实景](reference/kernel271/README.md)。前摄IMX471及两后摄IMX319/S5K3M5可原生采集，长焦持续预览已有明亮、可辨认实景；首次AE慢、颜色/噪声/AF、GUI三摄、主摄和Spectra硬件ISP未完成，goal保持active。

[272 GW1主摄候选](reference/kernel272/README.md)：标准driver/静态DT/binding、匹配Image183模块和libcamera helper已编译/主机验证；未安装、未上电或刷写，主摄与Spectra仍未完成。当前部署仍为下述271组合。

## 当前部署与启动身份

仍boot270/Image183，`7.3.0-rc6-rmx1931-samurai-k132+`，774模块/961包；271没有刷写或重启。boot SHA256 `0904b3b6616652e08709891cfdee34f1f733ff1e7022b7749bedea758108e4e8`，DTB `429db1faee1eef25abc64d8ca58e3b5db82b834de926d401343f8e05752e36e6`。Image/logdump和其它773模块保持，S5K3M5现模块SHA256 `11791431fb7d50ccd64163fdc5d753b61be5844830e90d14ce4f738a42f8b8f5`，加载note匹配。

五个libcamera运行组件r20，config/stack-r15，PW/SPA/Gst仍1.6.9-r3；其它954包记录保持。S5K3M5内核增益改为原生32…512码，libcamera标准helper按code/32换算为1…16倍。**驱动与helper必须配套更新/回退，不能单独降级r19。** CPU ISP/system heap和Snapshot Cairo/禁用GL、Vulkan、offload回退保持，默认GPU故障未修。

运输`reference/kernel271/host.py`复用270严格原SSH密钥、私人端点及boot guard `/var/lib/samurai/k270-work/boot-id-private.txt`。没有新boot身份。服务权威改手机`/var/lib/samurai/k271-services-current-private.json`：PW15740/start358174、WP15743/start358179，Phoc3543、Phosh3786保持；续作重核。旧270 PID5177/5179已失效。全量当前锁为[deployment-lock](linux-port/camera/deployment-lock.json)，驱动锁为[camera kernel](linux-port/camera/kernel/source-lock.json)。

## 本轮已经验证

- 本机原厂库离线指令确认1…16倍、1/32步进，未执行或修改原库。匹配Image183树内模块W=1零诊断；13个完整功能签名APK、34个ARM64 ELF、5个IPA签名和ARM工具/Qt/Python入口通过。实际编译的helper全部481码精确往返，旧r19负向对照按预期失败。
- 新栈96组同request RAW/RGB，稳态1、1.03125、1.5、2、4、8、16、返回1倍均对应正确元数据和物理响应；未饱和档拟合最大均值残差0.0331 DN，返回1倍均值恢复。拟合截距不是黑电平/ISO标定。[物理结果](reference/kernel271/gain-response-validation.json)。
- 360组自动曝光确认33.2ms后细分增益上升，但仍在收敛；原生libcamerasrc/CPU JPEG连续600帧约19.94秒，36帧偏暗、600帧已明亮且有实景细节。改善包含正常AE持续收敛，不全归因于补丁；颜色、噪声和对焦未验收。[实景](reference/kernel271/ae-optical-review.json)。
- 标准cam三摄14段交替、长焦SIGINT正常退出及重开，共193帧全部通过，期间无服务重启。最终三sensor/双CCI/CAMSS suspended，六rails OFF/users0、三MCLK关，fault0/taint0，无相机进程。[回归](reference/kernel271/three-camera-regression-validation.json)、[最终健康](reference/kernel271/final-r1-validation.json)。

第一事务在服务退出检查中止，尚无模块/包变化，旧WP已恢复。第二事务使用新上下文完成正常sensor解绑/自身卸载、七包与模块更新及标准PW/WP启动；共享CAMSS/CCI/PMIC未卸载，桌面未重启。基线1秒CCI仍active的首次健康值保留，后续已观察自然休眠；新probe目录冲突的上传失败发生在采集前。详见[271完整过程](reference/kernel271/README.md)，所有旧事务/采集目录都已终态，不重放。

旧r19对应启动的Snapshot前后切换/快门/JPEG通过不能晋升为r20三摄GUI。旧Snapshot卡死及modem watchdog仍未修；当前pstore空不覆盖旧失败。269完整新Image/773模块候选仍未部署，不能与现机Image183混淆；完整最新rootfs未重建。

## 源码、回退与下一步

维护WSL `/home/cy122/x2pro-linux/camera270-kernel` 当前为未部署开发分支`samurai-main-camera272`，提交`3184c56b7f206ab000ab79bc99eb83d35c3e1d65`清洁；部署对应的271/ac7ccc2及270、camera-common分支保留，均未推送。272源锁仅锁候选，产品camera源锁/部署锁仍为真实271。Windows当前libcamera/config配方与源锁已更新，旧r19/r14配方及269部署锁、旧camera内核锁完整归档于`archive/camera-before271-2026-10-18`。公开pmaports维护分支未在本轮同步或发布，不能把本地晋升当成GitHub已更新。

私人资料`E:/edk2-samurai-out/kernel271`及手机k271目录。匹配旧r19/r14签名包、原模块及配置的回退已双端核验，2815504字节/SHA256 `d69a679ae8afdb2aae485ba605b5f3348cc76a8d0df9f9ee1cf8a296d6b14bb0`；只完成降级模拟，未做实际往返。第二事务手机目录`/var/lib/samurai/k271-gain-transaction-r2`；正常取流和采集已终态，样片只保存在私人目录。新诊断binary位于`/run/samurai-camera271-fractional-probes/telephoto-fractional-probe271`。

继续改善首次AE速度、验证光照变化后的稳定性及控制延迟；补sensor真实裁剪/静态属性、颜色/噪声/方向、AF、更多模式/录像、标准GUI三摄选择、GPU与长稳。不要用假几何或虚构delay消除日志。24MHz S5K3M5设备没有实机回归。

GW1主摄两家10模式与初始化已重核，272新增driver/C-PHY静态描述候选及helper；物理chip-ID、C-PHY出帧/时序、曝光与AF仍待验。候选其它后摄实际型号未确认。Qualcomm CSIPHY/CSID/VFE RDI只采RAW，成像处理仍CPU软件ISP，Spectra硬件处理未接通。保留完整多摄与ISP目标；其它硬件见[清单](linux-port/docs/HARDWARE-STATUS.md)，规则见[边界](WORKING-BOUNDARIES.md)。
