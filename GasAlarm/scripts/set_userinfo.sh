token=`cat .token`
curl --compressed -XPOST -i http://120.24.83.5:8002/api/v1/setuserinfo -H  "Authorization: Token "$token -H "Content-Type: application/json" -d '{"sex":"female","name":"mama","language": "en_US"}'

