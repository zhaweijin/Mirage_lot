token=`cat .token`
curl --compressed -XGET -i http://120.24.83.5:8002/api/v1/device/getdetail -H  "Authorization: Token "$token

