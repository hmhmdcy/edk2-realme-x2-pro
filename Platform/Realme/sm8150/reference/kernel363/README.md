# 363：统一内核与原厂 HFI 入口核对（进行中）

362已把r29/r24、VFE175 Gamma和完整Preview默认安装到k298；继续ICP之前，需要让357公共OF/IOMMU节点引用修正进入实际Image。当前复用`/mnt/samurai-full282/source354`、固定提交`ba61a62293e0f6bc5838c06f2e85e033e3d702a8`构建独立k363；包括已测传感器/CAMSS348代码，实验ICP模块默认不启用。没有为了模块卸载去在相机驱动里补偿框架引用计数。

已有Image298和配置在准备时与298完整构建记录匹配，旧构建产物已另存，原initramfs293保留；新initramfs363只替换与新release匹配的三个蓝牙模块。构建目标为完整Image、DTB和独立778模块，签名用户空间及四份私有默认保持362。构建/打包/切换是否完成，以对应验证JSON及NEXT-SESSION为准；源码文件存在不代表设备已切换。

继续优先反编译已提取的原厂`CAMERA_ICP.elf`，没有重复下载或读校准分区。离线执行原始Thumb `fwEntryFunction` 的全部本体，12场景覆盖成功、共享/堆地址缺失、映射失败、ISR/信号/互斥量/线程创建失败。成功路径写HFI响应1，失败路径写2，早期idle线程失败保持0；测试路径没有写3。[结果](firmware-init-validation.json)。

分配、OS线程/信号/互斥量、IRQ注册和MMU映射由明确的桩提供，没有运行调度器或A5硬件；这些结果不能证明实际固件启动，不能推断所有其它函数都不会写3。它们说明356把响应3放行为SYS_INIT尝试并不构成成功证明；后续应等待明确初始化成功再交命令，并保留超时及清理。

另执行原始`ICPDomainCmdHandler`的SYS_INIT及三种64位cookie的PING路径：分别生成56字节0x20001和16字节0x20006回复；初始化error字段和PING cookie均从偏移8开始，符合当前解析器关键字段。[回执证据](firmware-messages-validation.json)。消息投递/日志为桩，芯片与MMIO值是合成数据，没有模拟调度器或实际硬件IRQ。

切换流程准备独立模块目录和只含Image/DTB的FAT logdump候选，保留当前k298 logdump及当前r29/348模块树作回退。只有相关构建/包和当前设备身份核对完成后才执行正常停服务/一次重启、仅logdump刷写及新启动读回。没有NV/OTP/校准分区写入。ICP正确板级0x9ab00000/5MiB仍待实际CPU访问与完整SYS_INIT/PING/PC_ACK，IPE IO/IQ及后级调校仍未完成。
