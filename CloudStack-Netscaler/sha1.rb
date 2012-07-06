#!/usr/bin/env ruby

require 'rubygems'
require 'base64'
require 'rest_client'
require 'openssl'
require 'cgi'


API_URL = "https://sdscloudstack.cloudlord.com:12345/client/api"
API_KEY = "77fZbJ_L0Dd0FSED63sGearUXiJMbGD-VnlXjLZ2snLuzMM_rMMPBFlzAzY_qyNRHfzO7mwvvIWSwssaKozf9A"
SECRET_KEY = "eADXllxC7tKbGy68mv2hDixtjAaV3uohiK-vTIVSpdZxH4znP79i1N2qZhoZuyPqBGADv87M_fVMeIsS8d2FYA"

#API_URL = "https://cloudstack.dlinkddns.com:10488/client/api"
#API_KEY = "yHFv7Xn58mt9PqIUlVeioRinoI4PiKgGR14J97tDEjzIp6L9Tc_JohEv0C3y2sNTGT5WMSAx3gXE6gX3bGyuaw"
#SECRET_KEY = "neudBtNEOpbMjF_ut9yQYqJ1dfsMArAWMcpYQLwwnxjIoqa-8s5Xw6dIwCb25rcbSpQWqus_2JkppLFzc4tiYw"

c1 = "command=listZones&apikey=#{API_KEY}"
api_key = API_KEY.downcase
c2 = "apikey=#{api_key}&command=listzones"

puts "c1 = [" + c1 + "]"
puts "c2 = [" + c2 + "]"

#hash = OpenSSL::HMAC.digest('sha1', SECRET_KEY, c2)
hash = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, SECRET_KEY, c2)  # Works on CentOS 5.6
puts "hash = [" + hash + "]"
signature = Base64.encode64(hash).chomp
puts "signature = [" + signature + "]"

#        "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"

s = CGI.escape(signature)
puts API_URL + "?" + c1 + "&" + "signature=" + s


