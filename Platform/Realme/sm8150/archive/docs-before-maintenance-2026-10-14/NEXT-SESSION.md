# Realme X2 Pro 当前检查点

2026-10-14，用户已确认EDK2之后不再白屏/花屏，先黑屏等待再出现Linux命令行。本次显示故障按实屏观察、此前24次DPMS及601秒稳定记录验收通过；冷启动、休眠和更长期稳定性仍开放。操作规则只以[WORKING-BOUNDARIES](WORKING-BOUNDARIES.md)为准。

## 当前实际状态

现机为kernel163、boot164/logdump163/modules132/software132加Mesa149修复。用户实屏反馈后的只读核对发现当前是晚于165的新boot，kernel构建号及boot/logdump读回仍匹配，桌面进程存在、taint0，显示/GPU/WARN/audio DMA prepare均0；本轮没有发送重启或刷写，不推断启动来源。当前私人身份在独立输出目录kernel165/user-feedback-live-private.json，165 first-boot及旧preflash/source身份已不能用于当前切换。此前165的Phosh21.45秒、24次DPMS/12次门控/601秒同boot/PID结果仍作为历史软件验收，不能算作新boot的测量。[实屏反馈](reference/kernel165/physical-feedback-validation.json)、[165验收](reference/kernel165/README.md)

Linux源码/主Image为163，15个显示相关文件与编译哈希相同；161 SMMU候选已撤销。EDK2 BDS源码为164候选，C/INF两文件有修改；源码树原有DTB为本地旧129文件，构建时临时使用实际132/163 DTB并恢复原文件。工作区生成固件目前是对照用的pristine132，不要当live164刷写包；真正164包在独立kernel164目录，原版boot132及logdump158/163备份保留。实际release仍7.3.0-rc6-rmx1931-samurai-k132+，必须按uname -v核对构建号，DRM按by-path解析。

158首次日志确认 DSI CTRL=0x1f5 先停至0，然后 CTL0 清理完成，随后 native PHY/DSI初始化。自动Phoc/Phosh启动，Phosh uptime19.99秒，此前155为79.67秒。全boot KMS初始化失败、DPU timeout、DSI error、GPU fault、WARN均0，taint0；音频DMA prepare9是既有待办。用户已手动多次开关屏并确认无闪屏，自动24次标准DPMS无新增错误。logdump读回及boot/persist/模块/NV/Mesa核验通过。[158证据](reference/kernel158/README.md)

首次158的现场记录从SSH就绪后230.65秒开始；92.94秒无丢失，快照是晚期live，不能声称为首帧快照。159保持同一158镜像重启，没有刷写；新boot已确认，CTRL/CTL接管和全boot零关键错误通过。早期服务17.72秒记录、93.05秒无丢失，初始TX等待位于真实PP TX done后44微秒。Phosh19.56秒，两次累计48次DPMS、24次亮屏门控通过。

159连续601.09秒/21次采样到uptime1006.20秒，同一boot、桌面PID保持，KMS/DSI/DPU/GPU/WARN/UFS UIC timeout0、taint0；随后只读收尾核对到uptime1826.80仍同boot且关键错误0。临时159启动服务已停止并退出boot runlevel。[159验收](reference/kernel159/README.md)

160第三次同镜像启动无刷写，Phoc17.44/Phosh19.43秒，全boot关键显示错误0、taint0，分区/NV/模块/Mesa保持。早期服务17.32秒就绪，初始PP TX done后225微秒完成wait。用户确认启动速度改善，但异常明确发生在edk2→首个Linux命令行之前，所以整体显示BUG仍未完成；用户已去睡觉，实体复验留待回来。160启动身份已过期，不能用于当前切换。160临时boot记录器已停止并退出runlevel。[160证据](reference/kernel160/README.md)

161空RMR候选7项实际函数和完整构建通过，但新boot出现WCD934x WARN1、taint512、SLIMbus DMA prepare917，未通过软件验收。因果关系未证明，实体白屏效果未观察；已拒收、保留失败现场并恢复SMMU源码。[161证据](reference/kernel161/README.md)

162按新的161身份正常停机并只刷回原始158，Phoc18.43/Phosh20.24秒、显示关键错误/WARN/audio DMA prepare均0、taint0，分区/NV/模块/Mesa保持，临时记录器已禁用。重建#158主Image不是原始字节副本，未用于回退；原始不可变logdump158仍是回退依据。[162回退](reference/kernel162/README.md)

163在TLMM就绪后核对本机SOFEF03F GPIO6/active-low，逻辑1保持复位并释放GPIO占用；实际13.2707秒晚于SMMU13.1784/13.1809，不能声称注册顺序保证先于SMMU。163+boot132 Phosh19.39秒、48次DPMS与第二轮12门控、601秒稳定；最终到uptime3269.73同boot/PID及taint0。第一轮trace漏了最终恢复的第12门控，工具补等待后复测，原始记录保留。[163证据](reference/kernel163/README.md)

164改本机Linux启动的BeforeExitBootServices回调，通过TLMM协议配置GPIO6并输出低；14项普通/ASAN/UBSAN真实函数及2个负对照通过。原代码重编译全部模块与实际boot132一致，候选只变BdsDxe；设备树/BootShim/header/ramdisk/compat/尾部保持。32条配置/ELF RWX/LTO提示的4种模板在原代码重编译中重现，不是零提示构建。只刷boot164，kernel163保持。只读mmap日志记录回调Success，无ring丢失。[164证据](reference/kernel164/README.md)

164首次自动桌面却音频WARN1/DMA prepare917、taint512、Phosh35.32秒；165同组合重启后这些计数0、Phosh21.45秒，原因未证明。后续用户已经实屏确认交接时无白屏/花屏，仍有黑屏等待；当前新boot只读核对关键计数仍0。临时165记录器已禁用，代码和原始证据保持。


## 显示修复链与既有失败

153 probe GPIO GPIOD_ASIS、prepare才初始化方向，避免先破坏固件显示；154在native power_on停止CTRL后重写时序，仍有首次白屏和DSI欠载。155同154重启无DSI错误，但用户偶发唤醒闪屏及启动慢。

156实现原厂首帧背光策略；DPU等待TX完成，12次实机亮屏门控顺序通过，24次DPMS通过，但首次78条DSI错误。greetd设置rc_before=samurai-radio，保留无线45秒等待与NV流程，Phosh由79.67秒提前至20.62秒。

157把停机提前至PHY配置前；首次CTL -22发生更早，停机路径未执行。一次panel重探测与原initial_session恢复Phoc/Phosh后发生新boot；用户确认没有拔插/重启等操作，原因未知、pstore为空。新157 RAM boot UFS探测阻塞，没有挂载磁盘文件系统。158根据当前RAM身份一次F1受理，device_shutdown被存储探测阻塞；保存SysRq w，再次证明同一RAM-only后一次SysRq b完成挂起bootloader切换，只刷logdump158。[157记录](reference/kernel157/README.md)

158进一步在SM8150 DPU清理boot CTL前停止全部已绑定DSI，复用一次性PM/读回保护；156首帧函数和157before-PHY幂等回退保持。22项真实函数普通与ASAN/UBSAN、完整构建/W=1/checkpatch/FAT通过。770模块中两个仅GNU build-ID不同，其余全部字节一致，原模块132兼容复用。[158补丁](reference/kernel158/before-ctl-stop.patch)

152 worker同步候选仍拒收，不混入后续候选。当前电源测试使用DisplayConfig.PowerSaveMode，wlr-randr --off曾移除唯一输出导致Phosh崩溃。165软件检查与后续用户实屏反馈已覆盖本次交接白屏/花屏故障；不代表冷启动、休眠或长期可靠性全部验收。

## 其它待办

GPU147/149既有修复保持，150无Mesa本地补丁降级未部署；软件包/完整rootfs需携带Mesa0015补丁。151软件数据库差异、充电保护、音频首次DMA/停止链、camera、传感器、蜂窝/GNSS/指纹/NFC、休眠与长稳保持开放。[硬件清单](linux-port/docs/HARDWARE-STATUS.md)。
