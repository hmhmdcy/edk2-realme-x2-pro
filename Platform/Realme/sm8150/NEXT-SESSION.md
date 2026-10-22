# 当前检查点：432（原厂 GTM 解析与 TMC11→GTM 数学验证）

完整多摄／ISP目标继续 active。先读 WORKING-BOUNDARIES.md、reference/kernel432/README.md；生产同帧 PD10、DC bank 与最近实拍见431 README。432仅离线，未访问手机、未新增实拍、未加载或永久安装。GTM硬件应用／生效版本／对应图像数学历史仍未完成，画质未验收。

## 432已验证

四份原厂文件45个GTM IFE/BPS roots、45叶子、26字段90标量，与原厂ParameterParser XML逐项一致。原始payload/enable/模式树未改，前摄3根全禁用。文件区域序列化464B→运行时360B。原HAL Parse2085f0实际执行45次，类对象192B，IQ payload为类+88；所有条目cursor耗尽，region/reserve/enable逐字节一致。14普通IFE模式查询沿用431原stock manager核对。

原GTM完整Calculate37c818用45个真实解析对象，插值一致，IFE LUT512B全部写覆盖，独立reg/LUT指针和末端哨兵核验，拒绝目标text/只读区写入。BPS根也只测试IFE输出夹具，不称BPS硬件验收。早期revision引用/输出指针夹具错误已更正，私存失败，旧结果已替代。

四摄各一Preview×3次原完整SWTMC11 Execute，共12次；后三摄9次启用ADRC经原GTM版本1指针赋值/PCHIP/contrast/打包路径完成，非零原厂GTM份额保留，输入变化改变LUT；前摄3次保持禁用。归档adrc-validation。直方图是明确合成夹具，不是本轮实拍。

可移植reference/kernel432/libipa/gtm_tmc11.{cpp,h}复用412 PCHIP，补GTM Q12/6-bit比例、原厂舍入、18-bit base/26-bit slope及IFE高32位打包。主机ASAN/UBSAN和ARM64 Werror各27例（18有效9非法保持），与原HAL LUT逐字节一致。另12 native selector0/2/3×swap×GTM LUT bank组合；注意GTM LUT bank不是IPE DC平均值表bank。仅TMC11 model2，完整legacy/manual/v2/TMC10尚未全移植，未编入IPA生产候选。

原HAL每条GTM指令未替换；HwEnvironment通过明确离线已初始化fixture返回，不执行Android设备发现，主比较selector2/swap0，不称手机平台读回；仅memset/memcpy与真实host powf等C库providers，libm不是Bionic。原厂系数、轴、XML、源副本、ASM、全日志及照片仅私存。

## 设备与候选继承431

最近实拍431 r4普通/隔离各24主摄，48自动双遍48最终数学提交，另旁路/DC切换4job；无新fault、taint0、正式模块/服务/媒体图/资源已恢复，worker/client终态。正式420 r31/r26、419core/adapter、Image363/DT389，无永久安装。432未刷新健康观测。

维护kernel source354 HEAD52127e558704de6a640d076ef605182fe6fff0d7，branch samurai-ipe-request-coarse431，clean。用户候选/mnt/samurai-full282/libcamera431-pd10-auto/src/libcamera-v0.7.2 build7沿用，IPA4；实际params/history与PD10配对详见431。不要无故重建或扩大实拍矩阵。

DC原厂RT type2→context0→bank0，粗级DC1/IP0/sumclear1，全尺寸DC0/IP1/clear0同bank。430/431原最终调度修复、重复性和真实PD10消费成立；没有片内平均表整表字节读回，a7 scratch不是统计表。429自加MMIO越界Oops已删除诊断并经用户硬重启四摄恢复；危险429build2 core da4591...禁止加载，不猜地址新增readl。

## 接续

原IFEGTM10 Execute31fc00已有431私存ASM。先恢复IFE参数/寄存器/DMI提交契约，底层typed block+真实ACK生效版本，然后生产IPA把GTM/ADRC版本绑定对应图像/IPE与最终history，再实拍。统计只能改变后续IFE图像，不能当前hist逆因果，不能清零GTM份额伪完整。其它摄像头自动/尺寸/视频、第五2MP、光学和多摄同步范围见363清单，当前样本仍雾感/偏色。

WSL每次source/build/ext4先root storage284.mounted_build，原32GiB镜像不重建。Unicorn PYTHONPATH14。host432继承429新guard与原key/known_hosts。本轮无活跃build/远端worker。原件仅private kernel432，公共仅自有代码/脱敏证据，public_module导出、scoped本地commit，保留镜像repo无关index和3处工作树，不push。此前431细节在archive/NEXT-SESSION-through431-2026-10-22.md与431README。
