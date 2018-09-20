## APP与服务器端交互文档

Author | date | changlog
--- | --- | ---
shujun | 0517 | 重新整理文档，细节根据需要完善。
shujun | 0518 | 修正获取历史数据的接口。
shujun | 0519 | 修改获取历史数据的接口。重构数据结构。
shujun | 0522 | 修改获取历史数据的接口的返回值结构。

----

==请在添加修改之后，更新changlog==

-----

#### 获取历史数据

Update ==0522==

Update ==0519==


重新整理了后台与app之间的数据接口：

APP的功能有两个：

- 被动接收后台的推送消息
- 主动查询报警记，分两步
	- 告诉用户当前状态：安全，异常，报警。level:0,1,2
	- 查看所有异常记录：列出此产品记录的所有异常和报警，包括：日期，报警类型。我们当前的产品，提供两种：gas 和  co
	- 查看具体某次某类型报警的气体浓度曲线。客户端可以得到：某种气体，浓度异常起止时间，以及这段时间内n秒一次的浓度采样值。

测试方式：

- get_alldevices.sh  查看后台所有设备
- bind.sh  选择一个与自己的用户绑定。（一个设备可以有多个用户来绑定，后台暂时模拟了两个硬件，一共记录了6次报警）
- get_history_all_alarms.sh 查看我的某个设备的所有报警事件记录
- get_history_this_day.sh  查看我的某个设备的，某个报警事件的具体信息。

>以上脚本的使用，请参考脚本内容。

#### 脚本 的返回值数据类型

```
旧的接口 ：./get_history_all_alarms.sh 
{
    "err_code": 0,
    "payload": {
        "device_id": "hw001",
        "count": 9,
        "datas": [
            {
                "date": "2010-2-9",
                "resources": {
                    "gas": 1
                }
            },
            {
                "date": "2010-7-12",
                "resources": {
                    "gas": 2
                }
            },
            {
                "date": "2013-4-1",
                "resources": {
                    "co": 1
                }
            },
            {
                "date": "2014-12-11",
                "resources": {
                    "co": 2,
                    "gas": 2
                }
            }
        ]
    }
}
```

新的接口，重新定义了返回数据结构，以方便客户端UI实现。

```
{
    "err_code": 0,
    "payload": {
        "device_id": "hw001",
        "count": 10,
        "datas": [
            {
                "date": "2010-2-9",
                "resource": "gas",
                "alarm_level": 1
            },
            {
                "date": "2010-7-12",
                "resource": "gas",
                "alarm_level": 2
            },
            {
                "date": "2011-9-21",
                "resource": "co",
                "alarm_level": 1
            },
            {
                "date": "2011-12-23",
                "resource": "gas",
                "alarm_level": 2
            },
            .....
```


==解释==

>这个脚本的功能就是： 查询此device，在其生命周期里面，所有发生过的alarm_level >0 的事件
>payload.datas 是一个array，数组的元素是一个struct，struct 的 成员有两个：
>date 是日期，格式是 yyyy-mm-dd
>resource暂时只有两种，“gas” 和 “co”
>alarm_level 分三种， 0：一切正常，1：气体浓度异常，但还未达到报警点，2：气体浓度达到报警点


```
get_history_this_day.sh

返回：

    "err_code": 0,
    "payload": {
        "device_id": "hw001",
        "Resource": "gas",
        "count": 125,
        "datas": [
            {
                "timestamp": 1418253130,
                "value": 23
            },
            {
                "timestamp": 1418253135,
                "value": 45
            },
            {
                "timestamp": 1418253140,
                "value": 68
            },
            .....
```

==解释==

>功能：此接口返回某次报警的具体sensor数据，用来绘制曲线。 ==返回数据已经做了处理，在整个报警事件中，采样点数范围是50~100个。如客户端有更多需求请提出。谢谢==
>四个参数：device id， resource name， date， offset
>resource:目前只有两种，gas 和 co
>date格式： yyyy-mm-dd，这个是 `./get_history_all_alarms.sh` 这个脚本的返回结果里面解析得到的。
>offset:是客户端当前时间与UTC时间的offset，比如中国上海是 +8:00，则offset = 8 * 3600 = 28800
>
>返回值：
>datas里面是array
>array里面是struct
>struct结构体有两个信息：时间（unix time），气体浓度。
>气体浓度是模拟了一个先增加后减少的一个过程。APP可以对数据采样，然后画图，来告诉用户，这次气体泄漏是什么时候开始，持续多长时间，浓度最高多少等信息。


#### update ==0518==

1. 历史记录	 done
	- 已经修正bug。现在提供三个接口。见下面具体描述
2. 设备名字 done
	- 根据讨论结果，后台设置设备的默认名字为其mac地址，用户可编辑。
3. 用户的 userimage 的获取 done
	- get_user_image.sh 接口已经作废。
	- 使用接口 `set_user_image.sh` 来设置用户头像。客户端获取用户头像是通过http下载文件的方式。只有在本地无缓存的时候才执行一次。
	- 下载头像文件路径：`"http://120.24.83.5:8002/api/v1"  + "/files/image/" + user_image_file_name `。其中 user_image_file_name 在通过脚本获取的用户信息里面。
4. 模拟硬件 ：未完成
	- 模拟燃气报警器的工作情景，模拟数据供测试，包括:
		- 随机的某些天里面，燃气会泄漏一次。
		- 泄漏的时候，燃气sensor数据呈抛物线状变化：低——高——低

#### 获取历史数据的接口 ==已经作废==

- get_allhistory.sh用来调试，获取所有的resource的历史数据。数据量可能很大，请重定向到文件分析。
- get_history_start_end.sh 用来获取在某一时间段
	- 给出的参数格式见脚本。
	- 后台处理流程是：查询所有此时间段的此resource的报警事件。按天给出查询结果


**参数描述**

```
offset=28800
device_id="hw001"
resource_name="gas_alarm"
start="2015-05-17"
end="2015-05-20"
```

- 暂时我们只有gas_alarm 的 resource。如果要查询其他报警事件呢？
- 数据库查找是否可以再精确一些？
- start 和 end是时间段的起止日期，如果要查询 0510，0511，0512 这三天的历史数据，start = 2015-05-10， end=2015-05-13，也就是说，结果包括start那一天，不包括end那一天。


#### ==Something More==

- 以上获取历史数据的处理方式是否可用？
- 对于这个产品，目前我们只是简单的抽象出resource的概念。但实际上resource之间并非孤立存在的。比如报警产生时，报警状态与sensor采样数据都是会记录的。所以，对于硬件与后台之间，数据传输分2种：
	1. 硬件判断发生报警事件或者sensor感应到异常（比如：燃气泄漏，一氧化碳泄漏，非法入侵等）之后，硬件发送给后台的数据。
	2. 客户端主动去实时的pull数据。这些数据不需要保存到后台。
- 我们是否可以对resource重新抽象一下，将报警事件类型，与sensor 两个相关量结合起来？

#### Device 与 Resource的概念

- 在我们产品中，借用了device和resource的概念。用户买到的是一个空气检测器和报警器，其中：
	- 整个产品叫做一个device，一个device 使用它的mac地址作为唯一id，与用户建立直接的关系。
	- 一个产品里面可以有多个传感器，开关等，比如燃气传感器，一氧化碳传感器，燃气门阀，燃气表，红外探测器，插座开关，以及其他一些气体sensor。这些每一个单独被测量或者控制的个体，叫做resource。
	- 一个device里面可以有多个resource，每一个resource有自己的名字。
	- bind和unbind操作，是与 device 相关的
	- 远程查看，远程控制，是与 resource 相关的

#### ==重新抽象resource== 0518

>站在客户端的角度，需要为用户提供怎样的交互？
>>有报警事件，请准确，及时，确保送达的上报信息给用户
>>用户想直观的查看：什么时候，发生何种预警，具体是什么情况？
>>

>那我们需要：
>为每一种报警情况，抽象一种resource（而不是为每一个外部sensor抽象一个resource），数据类型统一：
>>type：烟雾，PM2.5，Gas,CO，红外检测
>>name：用户自定义名字，比如卧室，厨房等地点
>>time：数据采集的时间
>>value：采集传感器的值

>这样，硬件上报的数据，存入数据库的数据，客户端查询得到的数据结构，都要重新定义。
>

```
如果你主动打开app，页面显示当前实时状态：
1、设备名字
2、设备在线？
3、当前状态：安全，异常，报警？

如果发生报警
1、及时推送：那个设备（名字）发生报警。
如果你点开app
2、主页告诉你当前状态：某设备报警，图标变成红色
3、点开设备：从几点几分到几点几分，某种气体异常，关了阀门？报告给了物业？

历史数据查询功能：
1、哪个resource的报警记录？后台查找全部数据库，按天返回报警情况
2、具体某次报警事件的情况
```

-----

#### API规则

- 遵循最简化设计原则，以实现产品功能为主。
- 暂定使用http接口，不使用https
- 暂定只实现email注册和手机注册，手机注册可以不处理验证码
- app端实现必要的用户操作和输入有效性的保证，比如email地址合法性验证，密码合法性，手机号码合法性验证。
- API版本：在URL中使用主版本号，默认 `/v1`。
- 所有的POST操作和返回值，以及GET操作的返回值，都使用JSON格式。
- 时间格式：使用unix 的UTC时间，int64 ，64位整数
- 消息推送：使用[腾讯信鸽推送](http://xg.qq.com/xg/ctr_index/download)


#### 用户管理

- 注册需要提供系统语言信息，暂时支持中英文，分别使用 "en_US", "zh_CN" 来表示。具体参见最新脚本：signup.sh
- 注册需提供具体的用户类型：phone| email | wechat | weibo | qq | anonymous
- 规范了注册成功之后的返回信息：用户id，type，language，name（如果用户提交了name信息）
- 用户管理接口：
	- 注册 :signup.sh
	- 登录 : login.sh
	- 注销登录 : logout.sh
	- 删除用户 : delete_user.sh
	- 密码重置: reset_passwd.sh
	- 设置用户信息 :set_userinfo.sh
	- 设置用户头像 :set_user_image.sh
	- 获取用户信息 :get_userinfo.sh
	- 获取用户头像 : ~~get_user_image.sh或者~~ 通过http链接下载

**细节规范app端需实现**

> 手机短信验证
> email地址合法性验证，小于50个字符
> 检验密码长度：6~20个字符

#### 设备相关接口

- 清除后台数据库，用于调试 ：clear_db.sh
- 获取后台所有设备，用于调试：get_alldevices.sh
- 删除设备，用于调试，用户只会做解除bind操作：delete_device.sh
- 设备bind: bind.sh
- 设备unbind : unbind.sh
- 设备信息设置 :暂时只有设置设备名字， set_devicename.sh
- 某用户查看自己的设备信息 :get_mydevices.sh
- 设备历史记录获取:get_history1.sh and get_history1.sh，分别获取某resource的时间段历史记录，以及某一天的记录
- 设备分享:等效于建立设备的bind，bind.sh
- 取消设备分享:解除与设备的bind，unbind.sh


#### 设备与用户的关系遵循以下规则

- 设备分享其实是一种bind操作，我们通过二维码将设备id提供给其他人，其他人就可以使用bind接口，建立与设备之间的联系
- 每个人都可以分享自己的设备给其他人
- 每个人仅查看，建立，解除自己与设备的关系。一个设备的所有用户是互相不可知，且平等的。

#### 设备第一次上电bind的流程

1. 产品上电，通过检测按键状态，进入smartconfig模式（如果没有保存过路由器信息，则自动进入smartconfig模式。硬件通过LED灯指示不同模式）。
2. SmartConfig流程
	- app端输入路由器密码，点击确认。
	- 硬件解析到路由器ssid和密码。（这一步是TI smartconfig内部实现）
	- 硬件连接到路由器。
3. 硬件通过mqtt协议，连接远程服务器成功。
3. 硬件订阅来自服务器端mqtt proxy的消息，topic: `server/to/#hwid`，其中 hwid 是硬件的MAC地址。
4. 硬件发布消息给proxy，topic:`to/server`,服务器将新发现的硬件信息存入数据库。
5. 硬件在局域网内广播自己的ID，APP接收到广播并解析出硬件ID。
6. APP调用bind 接口 ，得到硬件ID。
	- 以硬件ID为参数，做设备绑定操作
	- 绑定完成，后台会主动给device发送特定消息。
	- devie收到消息，则停止广播自己的ID。
	- device进入正常工作模式。
7. APP调用接口unbind，可解除用户与设备之间的关系。


#### API的数据交互

- 所有操作的返回值都是json格式
- 所有POST操作的参数都通过 json格式的body传输
- 返回值结构体细节请参考相关脚本执行的返回值。



#### 操作的返回信息格式如下

当http操作失败时，有两种情况：

1. 通过http返回的状态值来判断http 操作是否OK。比如40x是某种错误。
2. 如果http操作完成，返回20x，再通过返回json数据的err_code 是否等于0，判断操作是否成功。当err_code 不等于0 时候（用户自定义错误返回码，格式4200x），操作失败，并带有错误描述信息 error_description。具体见下面。

==请客户端处理以上两种情况==

例如： 当未授权操作时：

```
HTTP/1.1 401 Unauthorized
Content-Type: application/json
Request-Id: mbp15.local/QsBOAt0j3D-000002
Date: Sun, 17 May 2015 16:18:21 GMT
Content-Length: 112

{"err_code":42000,"error":"unauthorized_access","error_description":"Request refused or access is not allowed."}
```

**关于用户自定义的错误返回码**

```
  ErrCodeDefault  int = 42000
  ErrWrongParam   int = 42001   // 参数错误，比如bind的时候，用的deviceid是已经bind过的，或者unbind的时候，deviceid是没有bind的。
  ErrAuthFailed   int = 42002   // 用户名或者密码错误，token错误等
  ErrUserNoFound  int = 42003   // 登陆用户不存在
  ErrUserHasExist int = 42004   // 注册用户已存在
  ErrDBOperation  int = 42005   // 数据库操作错误，比如mongodb的操作错误。可以理解为后台系统错误。
  ErrDeviceNoFound  int = 42006 // 设备没找到。设备id错误，后台数据库没记录
  ErrPermissionDeny int = 42007 // 没权限，比如user没有这个设备等

```

如需为某个特定错误指定特定err_code，请随时提出来。


>后期可以根据需要再做扩展。


#### 匿名用户

>用户可以不注册即可使用所有功能，app获取手机mac地址，作为id，以匿名用户的方式登录。
>局限在于：用户只能在此手机使用，换了手机，就无法主动登录。
>当用户注册，或者用第三方登录时，会用新的账户信息替换匿名用户，不会失去之前的数据。

- 匿名用户只与用户手机绑定。请app取手机的mac地址作为匿名ID，转换成16进制格式的字符串。
- 匿名用户无需注册，直接登陆。（后台会在第一次登陆的时候，创建用户信息）
- 匿名用户可以在以后重新补充修改用户信息。脚本： set_anonymous_info.sh

#### 第三方用户

- 第三方用户无需注册，直接登陆。（后台会在第一次登陆的时候，创建用户信息）
- 第三方用户使用的是从第三方授权服务器那边得到的唯一ID登陆。并在登陆的时候，提交从第三方授权服务器那边得到的.

#### 用户信息

- 设置用户头像 ：set_user_image.sh（支持格式：jpg， png，gif）
- 设置用户信息 ：set_userinfo.sh， 可以设置的信息：name,sex, language。
	- 包括用户昵称，头像，性别等。头像有默认的选择，昵称不要求唯一性检查。

#### 重置密码

- 手机用户，app负责check 手机验证码。
- email用户，后台会发送一个验证码到邮箱，一次性的使用。用户重置密码的时候，需提供此验证码。


#### 测试流程

- 注册用户， 请修改注册信息。signup_email.sh
- 登录用户，获取token，保存在本地目录下的.token文件。token_update.sh
- 查看有哪些可用的设备。get_alldevices.sh
- 找一个设备进行bind：bind.sh
- 查看设备当前状态：get_mydevices.sh
- 查看设备某resource的历史信息：get_history1.sh get_history2.sh


-----

#### 以下表格是旧文档，仅做参考

~~功能分析表格~~

- | url | 进度| 描述
--- | --- | --- | ---
1 | signUp | - | 注册。两种注册方式：phone number 注册和 email 注册。（默认国内用户使用 phone 注册，国外用户使用 email 注册）
2 | login  | - | 登录。使用 phone number 登录 ， email 登录 ， 或者第三方账户登录。
3 | logout | -  | 注销登录。
4 | resetPassword | - | 如果用户忘记密码，可以在验证后重新设置密码。 APP根据手机验证码来允许用户重新输入密码。
5 | setUserinfo | - | 设置用户信息，包括用户昵称，头像，性别等。头像有默认的选择，昵称不要求唯一性检查。
6 | getUserInfo | - |  获取用户信息 。
7 | bind | - |  将自己与设备bind。 流程：建立设备与用户之间的关系，在设备有消息需要推送的时候，抽取userlist里所有用户进行推送。
8 | unbind  | - |  将自己与设备解绑定.流程：删除deviceinfo中userlist的用户id，如果userlist为空，则取消proxy 对此硬件发布的信息的订阅，并删除所有相关历史数据，和设备信息。
9 | getDevices  | - | 获取设备信息。包括当前设备状态，传感器采集，在线与否等。
10 | setDevices | - | 操作设备。比如设置开关，设置定时开关，设置设备名字。。。。具体根据需要自定义。
11 | ShareDevice	 | - | 分享设备。此接口是被分享者端的APP调用。
12 | getHistory | - | 获取设备传感器历史数据。
