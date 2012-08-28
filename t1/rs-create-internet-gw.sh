#!/bin/bash -e

# rs-internet-gateway.sh <nickname> <rs_cloud_id> <vpc_id>

# e.g. rs-create-server.sh  FIXME

# RightScale (public) cloud IDs
#1  US-East
#2  Europe
#3  US-West
#4  Singapore 
#5  Tokyo
#6  Oregon
#7  SA-São Paulo (Brazil)

# Example params:

# FIXME [[ ! $1 ]] && echo 'No Server nickname provided.' && exit 1
# FIXME [[ ! $2 ]] && echo 'No RightScale cloud ID provided.' && exit 1
# FIXME [[ ! $3 ]] && echo 'No VPC ID provided.' && exit 1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

nickname="$1"
rs_cloud_id="$2"
vpc_id="$3"

rs-login-dashboard.sh               # (run this first to ensure current session)

url="https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpc_internet_gateways"
echo "POST: $url"

#-H "User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.82 Safari/537.1" \
#-H "X-Prototype-Version:1.6.1" \
#-H "X-Requested-With:XMLHttpRequest" \

result=$(curl -v       -X POST \
-b "$HOME/.rightscale/rs_dashboard_cookie.txt" \
-H "Referer:https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpc_internet_gateways" \
-d _=" " \
"$url" 2>&1)

echo $result | grep -q -e "^< Status: 302" && echo "Create internet gateway succeeded!"

gw_id=`echo -e "$result" | grep "^< Location" | sed "s#< Location: https://my.rightscale.com/acct/.*/clouds/.*/vpc_internet_gateways/##"`
echo gateway id = $gw_id

echo "$result" > /tmp/rs_api_examples.output.txt

#echo "$result"

