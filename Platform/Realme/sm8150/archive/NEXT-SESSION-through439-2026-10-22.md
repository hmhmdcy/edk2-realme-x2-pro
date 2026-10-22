# 当前检查点：439（前摄原厂 IPE CCM13 自动链路与实拍通过）

完整多摄/ISP目标active。先读WORKING-BOUNDARIES和reference/kernel439/README。前摄IMX471 mode1/2304x1728原厂非单位IPE CCM13、LTM/Gamma与真实同SOF PD10、实际GTM/WB版本和最终成功数学历史已接通；原IFE CCM、TMC10/11、GTM关闭状态保持。原生40图38math+2bootstrap，隔离43图41math+2bootstrap，共83图79成功math；隔离停机后1份未入队提案丢弃，不算图像/成功历史。两路末尾8连续locked，分别4/5帧相同实际WB保持锁定。关闭GTM时实际只观测bank0。

## 当前源码和部署

候选 /mnt/samurai-full282/libcamera439-front-colour/src/libcamera-v0.7.2，从437复制，9源文件变化。build1/IPA5：库50935792B/32cd8d4145ccb1c0f7c47a2e2d0dd9b36e8dd2364c68570d89dbbbc9c88e51be；IPA8183768B/3f83969b6e23311fed22f3f03dba6af514c4e16a293994fbf9903a50f6782e7a；sign bd9869b26859582c9f6e2533a9441e44c5e81fca39b4fcf97f5d075fc90b3791；proxy仍093df5faa73b42b741e2b61d862fefc292fcf7ced2ccfb6f6f9389f70b182dcf。Mojom未变、0050补丁零fuzz/offset重放。439/storage只在新候选不存在时回437。

内核仍source354 HEAD9bc07e6339128ae8d3525c7d5c9bca5d0fbc46f3/samurai-vfe175-gtm-reopen434，匹配434 CAMSS3edb28d1/core d391fa24/m2m e6828a0c；未改板级/SoC/sensor。正式仍420/419、Image363/DT389。本轮临时模块/服务/资源已恢复，newfault0/taint0，worker/client均终态，未永久安装。

## 数学、配置和证据

通用色彩数学区分IFE整数偏移逐级截断/11位量化与IPE浮点偏移逐级插值/13位量化，矩阵均12位Q(7+shift)。共享已有五级调校树选择器，IPE RGB到GBR排列仍由原底层编码器负责。原HAL DoInterpolation0x47ebf0+完整CC13计算/CDM，对主机/ARM64各1164例181584B零差：737原厂区域、前摄243插值及小数偏移边界随机；旧IFE oracle byte相同。ARM64前摄完整原树3坐标与原指令零差；实际IPA DSO的未来CCT/手动控制延迟生效、旧帧冻结、失败不提交、重启及main legacy/bypass/GTM回归通过。

前摄private kernel439/factory-imx471-private.yaml复用343/350/351/412/426/432及438原BLS解析。mode1/2304: CCM UID47/28区25不同非单位矩阵；LTM42/3AEC，TMC11 63/1，Gamma3，GTM21，DS4 33/PASS_FULL。编号不代表跨文件同表。IFE CCM关、TMC10/11关、GTM关，LTM/Gamma开，BLS960U14恢复3840U16/norm2175/2048。1928x1088缺原mode绑定不改。

每帧冻结实际WB/ISP上下文中的CCT/手动矩阵并复制进同帧统计观察，成功IPE图像后提交颜色数学历史和实际有效矩阵元数据。缺CCT明确保持上一成功颜色、首次单位矩阵；不编造CCT。两路SOF12保存真实FULL460800B、PD1046080B、IPA6008B及同帧输出。固定输入5次硬件回放：stock重复==原实拍逐字节；单独关闭LTM或IPE CCM均改变像素，source像素未改。83图+5replay=88硬件完成。未新增DC SRAM逐字节dump或PD10扰动，DC清理/遍次沿用430/434。

439预览为近距离键盘/桌面，偏暗，末端CCT1500K达到下限，曝光/增益达上限；不能以锁定作绝对色准/清晰度完成。NV12/sYCC全范围BT601仅诊断解码。原件/系数/照片/日志/ELF仅E:/edk2-samurai-out/kernel439。

## 下一步与完整范围

439实拍只前摄；主摄437、广角/长焦438证据保留，不能冒认已在439整合版重验。主摄原BLS/tone候选kernel437，广角/长焦kernel438各自private profiles；后两路438共96图91math+5bootstrap、各8locked、GTM两个bank，实际仍437源码。下一步整合四摄当前配置+439库+434模块为可恢复发布套件，并在同一cohort回归，随后更多尺寸/视频及legacy/manual/v2/HDR完整分支、光学/色板/均匀场/噪声清晰度。第五2MP、个体校准和多摄几何同步等363完整范围仍未完成。

每次WSL source/build/ext4先root调用284/storage.mounted_build，挂原E盘32GiB，不格式化；SDK bind串行。清理20261022删除旧.o/.a/重复未剥离文件和缓存，共8.8GiB含E盘构建卷；保留当前420/435/436/437与source354，WSL压缩并恢复稀疏。439新候选已另建，旧中间文件缺失可正常重建。429 guard/key/knownhosts，USB SSH正常；不恢复429越界诊断。镜像本地提交见git与private local-mirror-validation；439开始HEAD41def451b6bc9716d94674cb77f6ead7a39490c1，保留无关index/worktree/untracked，public导出/scoped commit不push。
