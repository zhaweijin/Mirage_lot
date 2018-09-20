token=`cat .token`

curl -XPOST -i http://120.24.83.5:8002/api/v1/user/anonymous -H  "Authorization: Token "$token  -H "Content-Type: application/json" -d '{"type":"email", "email_addr": "23767251@qq.com", "password": "123456", "language":"zh_CN"}'
