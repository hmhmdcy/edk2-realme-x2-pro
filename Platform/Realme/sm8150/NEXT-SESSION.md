# 下一阶段：显示启动回归与充电安全（session77）

先读sessions/77-bq28z610-live-gauge-and-display-regression.md、reference/kernel77/README.md，
再看session76充电研究与session75显示/GPU回退证据。

当前仍用#76 Image/config/logdump；BQ28Z610已接入，两个启动45个连续样本与
标准寄存器读值/单位对应。仅刷boot一次，第二次仅重启；未写充电/保护参数。
当前boot_id=aada8705-14a3-4012-bf84-eeb0f7987b96，taint0；末次电池包8.649V、
SOC100%、温度29.3°C、电流0。充电控制尚未接入，Charging/Good不能作安全验收。
两次首次启动出现DSI FIFO/MDP FIFO下溢，完整开关屏后停止；新GPU12次读回/fence
与两次数字彩条/电源循环通过。当前DSI累计194条已停止增加，首次接管回归仍开放。
session75曾完成39096次GPU渲染、用户纯白及fresh-boot彩条光学验收；它是回退基线，
不能替代本轮首次启动的验收。详见sessions/77-bq28z610-live-gauge-and-display-regression.md、
reference/kernel77/README.md。下一步优先定位显示启动回归，再推进MP2650安全控制。

下一步先定位首次显示接管，不能只做开关屏恢复就宣称修复。BQ28Z610挂在&i2c15、
100kHz、0x55；实际Linux是1-0055，触摸仍0-0020。NVM更新关闭，不添加充电控制器、
monitored-battery或保护编程。负电流、温度实物校准、完整充放电和充电控制仍未验。

当前boot sha3fbbd0eecf7e793f97920d55bd9ec2a30329d6e53edb307200160a23e1de923e。
logdump保持sha607fc6b4b0caba8ca5c7ea6677fd8259c81a216f91b2d6de7603e3f56d9881d0。
回退boot是本地kernel77/boot-before.img，sha43ddcba2444e1672cd95205f6984c761eaeb59c83162cffdffb371c50a29c37b。
只写boot/logdump且每次PARTNAME核对；Android/全部数据/GPT保留，固件/镜像/密钥不发布。

实际Linux/home/cy122/x2pro-linux/linux、initramfs/home/cy122/x2pro-linux/initramfs，
Git/home/cy122/edk2-samurai/repo。不得重置未提交内核修复，不运行旧build-image.sh。
EUD/TOP_CFG0x11/整帧/RX53/F1/两终端与init/USB hook/SSH身份保持。
SSH/SCP工具reference/kernel72，169.254.42.1；普通USB/EUD单接口owner并finally释放。
新启动要等9501枚举再com-up/开COM14，排完早期console；F1断开错误与真实回执分开记录。
当前0011/0012保留，0013为只读gauge DT。90Hz、休眠、各GPU频点、无线/音频/其它硬件待做。
全硬件目标active；不以注册数量或warning消失验收，只推fork/master。
