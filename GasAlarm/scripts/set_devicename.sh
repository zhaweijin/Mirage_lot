token=`cat .token`
curl --compressed -XGET -i http://120.24.83.5:8002/api/v1/device/setname/$1/$2 -H  "Authorization: Token "$token

# $1:device_id
# $2:name