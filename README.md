
#### 文件描述

├── GasAlarm
│   ├── API-description-0320.md ： 这是服务器与客户端之间的接口文档。
│   ├── requirements_list.md ： 客户端需求文档。比较简略，请参考交互图理解
│   └── scripts ： 客户端与服务器之间的接口的调试脚本。
└── ti-smartconfig-demo-app ：TI 的客户端demo，实现smartconfig功能，用于设备bind
    ├── WiFi-Starter-App-iOS-Source-1.0.zip ： iOS
    └── WiFi_Starter_App_Android_Source_1.0.zip： Android

PrometheusForAndroid.tar ： 现在完成了一半的android的代码，与服务器对接的部分都完成了。完成了推送功能，二维码扫描还没弄。
coolmal.tar 这是我现在的公司的app代码。可以参考它里面的二维码生成和扫描，用来实现分享功能。


#### 页面交互的文字描述

- 首页是注册和登陆窗口。默认只支持email注册
- 注册或者登陆成功
	- 如果此用户有bind过设备，则进入设备列表
	- 如果没有bind过设备，则显示一个大大的 button，上面有一个“+” 号在页面中间，点击此button，可以进入smartconfig模式，用来bind设备。
- 设备相关
	- 设备有两个sensor，一个燃气的，一个一氧化碳的。
	- 硬件端检测两个传感器，如果发现气体数据异常，就开始上报给服务器。
	- 当气体浓度达到一定值，或者气体的泄漏时间超过某个时间，硬件会发送报警信息给服务器，并发出80分贝的警告声音和红色闪光灯。
	- 后台会接收硬件上传的数据，并保存。客户端可以获取当前状态，历史信息等。
	- 对于客户端来说，气体异常分为三个level：
		- 如果气体没有泄漏，则level为0，“正常”
		- 如果有气体泄漏，但没有达到报警点，则level =1 ，显示为“有泄漏”
		- 如果有气体泄漏，并且达到报警点，则level =2 ，显示为“报警”
	- 用户点击某一个设备，进入设备信息页面。设备信息页面显示设备详细信息，包括：设备id，设备激活时间，设备名字（可编辑修改），查看设备的历史报警记录，删除设备，分享设备给其他人等操作。
		- 每个设备有自己的唯一id。
		- 设备默认名字是自己的id。
	- 查看历史记录：
		- 调用接口会返回这个设备曾经记录过的所有气体异常记录，分别是：哪个传感器，在哪一天，发生了等级为多少的气体泄漏
		- 点击某个记录项，进入历史记录的细节页面，显示具体采样点。
			- 采样点的数据是：时间（UTC时间，单位秒），浓度。服务器端对数据做了处理，只返回小于100的采样点数目。
			- 如果会做曲线图，则绘制浓度变化曲线。如果不方便，就直接将浓度信息列表显示即可。
- 右滑进入设置界面：
	- 用户信息
	- 关于
	- 退出登录

