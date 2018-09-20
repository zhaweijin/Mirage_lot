token=`cat .token`
curl -XGET -i http://120.24.83.5:8002/api/v1/helloworld -H  "Authorization: Token "$token
