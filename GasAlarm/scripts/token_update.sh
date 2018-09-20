# ./login.sh | grep access_token | python -m json.tool | sed -n -e '/"access_token":/ s/^.*"\(.*\)".*/\1/p' > .token
./login_email.sh | grep access_token | sed -n -e '/"access_token":/ s/^.*"\(.*\)".*/\1/p' > .token
#./login-weibo.sh | grep access_token | sed -n -e '/"access_token":/ s/^.*"\(.*\)".*/\1/p' > .token
# ./login-anonymous-short.sh | grep access_token | sed -n -e '/"access_token":/ s/^.*"\(.*\)".*/\1/p' > .token
# ./login-anonymous-long.sh | grep access_token | sed -n -e '/"access_token":/ s/^.*"\(.*\)".*/\1/p' > .token

