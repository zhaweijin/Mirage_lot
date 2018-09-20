token=`cat .token`

device_id="hw001"
offset=28800

# 功能描述
# 查找此设备（包括所以resource）所有产生过的报警事件。按天返回。返回信息包括：哪一天，发生了什么报警（支持同一天多种报警事件）
# offset是客户端当前时间与UTC时间的offset，比如中国上海是 +8:00，则offset = 8 * 3600 = 28800

curl --compressed -XGET -i http://120.24.83.5:8002/api/v1/historyallalarms2/$device_id/$offset -H  "Authorization: Token "$token

# history1
# $1:device_id
# $2:offset
