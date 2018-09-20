token=`cat .token`

curl -XPOST -i  -F "image=@avatar.jpg;type=image/jpeg" http://120.24.83.5:8002/api/v1/user/image   -H "Authorization: Token "$token
