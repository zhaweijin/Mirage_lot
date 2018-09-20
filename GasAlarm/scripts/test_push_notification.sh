token=`cat .token`

curl -XPOST -i http://120.24.83.5:8002/api/v1/xgpush -H "Content-Type: application/json" -d '{"account_list":["23767251@qq.com"],"message":"{\"content\":\"xgpush debug message content\",\"title\":\"xgpush debug title\"}"}' -H "Authorization: Token "$token


#curl -XPOST -i http://120.24.83.5:8002/api/v1/pushnotification -H "Content-Type: application/json" -d '{"message":"Test xgpush notification,from coolmal server"}' -H "Authorization: Token "$token
