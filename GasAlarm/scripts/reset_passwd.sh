# usage:
# {"type":"phone", "phone_number":"12345678900","password":"112222","language":"zh_CN"}

curl -XPOST -i http://walnut-sys.net:8002/api/v1/resetpasswd -H "Content-Type: application/json" -d '{"type":"phone", "phone_number": "1234567899", "password": "abcdef","language":"en_US"}'