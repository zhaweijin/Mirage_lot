token=`cat .token`
curl -XDELETE -i http://120.24.83.5:8002/api/v1/deleteuser -H  "Authorization: Token "$token
