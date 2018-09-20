token=`cat .token`
curl -XGET -i http://120.24.83.5:8002/api/v1/device/bind/$1 -H  "Authorization: Token "$token

## $1:device_id
