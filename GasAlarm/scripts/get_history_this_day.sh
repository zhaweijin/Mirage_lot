token=`cat .token`

device_id="hw001"
resource="gas"
date="2014-12-11"
offset=28800

# resource:目前只有两种，gas 和 co
# date格式： yyyy-mm-dd
# offset:是客户端当前时间与UTC时间的offset，比如中国上海是 +8:00，则offset = 8 * 3600 = 28800

curl --compressed -XGET -i http://120.24.83.5:8002/api/v1/historythisday/$device_id/$resource/$date/$offset -H  "Authorization: Token "$token

# history2
# $1:device_id
# $2:resource
# $3:date : 2015-05-10
# $4:offset
