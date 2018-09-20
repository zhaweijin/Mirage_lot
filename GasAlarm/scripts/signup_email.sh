# curl -XPOST -i http://120.24.83.5:8002/api/v1/signup -H "Content-Type: application/json" -d '{"type":"phone", "phone_number": "18665991299", "password": "123456", "language":"en_US"}'
# curl -XPOST -i http://120.24.83.5:8002/api/v1/signup -H "Content-Type: application/json" -d '{"type":"qq", "thirdparty_id": "openid_JHDKL123456", "language":"en_US"}'
# curl -XPOST -i http://120.24.83.5:8002/api/v1/signup -H "Content-Type: application/json" -d '{"type":"anonymous", "anonymous_id": "anonyid_123456", "language":"en_US"}'

curl -XPOST -i http://120.24.83.5:8002/api/v1/signup -H "Content-Type: application/json" -d '{"type":"email", "email_addr": "23767251@qq.com", "password": "123456", "language":"zh_CN"}'
