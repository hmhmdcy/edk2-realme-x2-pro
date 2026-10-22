# 当前检查点：440（四摄原厂自动调校 r32 已正式安装）

完整多摄／骁龙ISP目标active。读WORKING-BOUNDARIES和reference/kernel440/README。手机正式版本已由420 r31/r26与419模块切换至libcamera五包99990.7.2-r32、config/stack0.1.0-r27、434匹配三模块和四份私有原厂配置。Image363/DT389/sensor/FW未变；本轮未重启验收。

## 当前源码与载荷

源码/mnt/samurai-full282/libcamera440-release-r32/src/libcamera-v0.7.2，保留439副本。420基线叠0042—0051十补丁零fuzz/offset，48个受影响文件相同。13子包构建，7运行包签名与6IPA签名通过，其它5IPA与r31相同。实际剥离包内ARM64合约通过。核心SHA0884c73489815132b5f180c303ab5ed2edc4c52f0f7b191365054aa855849a48，IPA8703093d5882488e7a0125002a71e5a23f5382594b0a5b4ae30f9ed0d63ec796，协议5。0051只修RAW-only错误强制PD10：requiresPd10=processedEnabled&&sensorConfiguration.pd10，保留内部统计，不伪造IPE历史。

内核source354/samurai-vfe175-gtm-reopen434，HEAD9bc07e6339128ae8d3525c7d5c9bca5d0fbc46f3干净。正式三模块CAMSS3edb28d1/core d391fa24/m2m e6828a0c，loaded notes匹配disk，无test参数。原厂私有profile来源主437、广角/长焦438、前439；公共YAML不变、原件不入APK。前摄保持IFE CCM/TMC10/11/GTM关闭、IPE CCM13/LTM/Gamma开启，未知1928裁剪不套2304模式。

## 实拍与正式路径

同一最终包及三模块/四配置，四摄native+isolated8路交付406图=386math+20bootstrap，每路8连续AWBlocked，实际GTM/WB版本、同SOF PD10与成功历史逐帧对应。后摄两GTM bank，前摄GTM关闭/bank0。RAW-only主72+其它各6=90图无IPE；主双流6，同SOF配对。临时cohort共412IPE完成，非当前安装计数。

正式默认路径r2/r3：四摄GST各12共48、主双流6、主自动52(49math+3bootstrap)、前自动44(42+2)、普通用户PW12，共162IPE；另RAW-only6无IPE。r3比较完全相同载荷，复用7个已通过案例，仅新跑front44+PW12。当前驱动epoch56jobs=completed=direct，failed/cancel/firsterror0，owner_refs57为桌面句柄；ICP/CAMSS/双CCI suspended，CPU/IRQ/PM/map/import/DMA释放，PW788/WP794各1 uid10000，新fault0/taint0。

安装r1/r2原报告false保留，均已实际完整离线回滚包/三模块/四配置和服务：r1把6交付等同6物理完成，另1已入队帧停机abort未commit；r2把PD10/观察数等同图像数，主52图外3观察正常discard。新审计逐SOF/token核对queue/receipt/GTM来源/成功lux/math/stop/pending，旧实拍缓存审计也通过；无运行库改动。成功root /var/lib/samurai/k440-install-r3，worker659/client终态。不要重新启动旧事务。当前仓库入口为该root签名forward，旧r31/r26七包/索引/world/repo/三模块/四配置备份齐全。

## 后续完整目标

下一步扩展真实PD10自动双遍至其它预览/录像输出尺寸，先复用原厂striping、DC网格和模式绑定，在底层处理尺寸/遍次同步；当前处理640x480，RAW原生尺寸。随后完整legacy/manual/v2/HDR、正常光学色准/平场/噪声/清晰度、连续AF/距离、第五2MP与多摄几何/同步等363完整scope继续。AWB锁定不是绝对画质验收。429越界诊断绝不恢复；DC bank/clear/消费证据沿用430/434，没有新增逐字节SRAM表导出。

每次WSL源/build/ext4先root284/storage.mounted_build挂原E盘32GiB，不格式化；SDK bind串行。20261022两轮清理保留当前源码/构建/回滚/原厂资料。USB SSH与429guard正常，密钥/原件/系数/像素/完整日志仅E:/edk2-samurai-out/kernel440及手机。镜像public导出/scoped本地commit保留无关index/worktree/untracked，不push；最新commit以git及private local-mirror-validation为准。
