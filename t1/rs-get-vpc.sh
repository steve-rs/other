#! /bin/sh -e

# SJB: THIS IS NOT FINISHED 

# rs-get-vpc.sh [Cloud ID]

cloud_id=1
[ ! "$1" ] && cloud_id=$1

. "$HOME/.rightscale/rs_api_config.sh"
. "$HOME/.rightscale/rs_api_creds.sh"

#rs-login-dashboard.sh (run this first to ensure current session)

url="https://my.rightscale.com/acct/$rs_api_account_id/clouds/$cloud_id/vpcs;vpcs"
echo "GET: $url"

curl -v       -b "$HOME/.rightscale/rs_dashboard_cookie.txt" -X GET \
  -H "X-Requested-With: XMLHttpRequest" \
  -H "Referer: https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpcs" \
  -d _=" " "$url" 2>&1 | grep "t1.*test"

#echo $result > /tmp/rs_api_result

#curl -s -S -b "$HOME/.rightscale/rs_dashboard_cookie.txt" \
#        -H "X-Requested-With: XMLHttpRequest" \
#        -H "Referer: https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpcs" \
#        "https://my.rightscale.com/acct/$rs_api_account_id/clouds/$rs_cloud_id/vpcs;vpcs" | grep "$vpc_name" -C 3 | grep vpc- | sed -e 's/.*<td>\(.*\)<\/td>.*/\1/p' | head -n 1 | sed 's/  //g'  # aws vpc ID

case $result in
	*"200 OK"*)
		echo "Get VPC of cloud $cloud_id successfuly initiated."
	;;
	*)
		echo "$result"
		echo "Get VPC of cloud $cloud_id failed!"
	;;
esac
