#!/usr/bin/env ruby

require "rubygems"
require "savon"

LOCAL_IP = '10.0.0.1'
LOCAL_PORT = 80
SERVICE_GROUP_NAME = 'testsg'

client = Savon::Client.new do
  wsdl.endpoint = "http://10.0.1.30/soap/"
  wsdl.namespace = "urn:NSConfig"
#wsdl.document = "http://www.thomas-bayer.com/axis2/services/BLZService?wsdl"
#wsdl.document = File.expand_path("../NSConfig.wsdl", __FILE__)
end

Savon.configure do |config|
  config.log = false            # disable logging
  config.log_level = :warn      # changing the log level
 # config.logger = Rails.logger  # using the Rails logger
end

HTTPI.log = false

print "Login: ";
response = client.request(:login) do
  soap.body = { :username => "nsroot", :password => "nsroot" }
end
print response.to_hash[:login_response][:return][:message], "\n"
if response.to_hash[:login_response][:return][:rc].to_i != 0 then require 'pp'; pp response.to_hash end

client.http.headers["Cookie"] = response.http.headers["Set-Cookie"]

#$result = $soap->bindservicegroup_ip( name('servicegroupname' => $SERVICE_GROUP_NAME),
				 #name('ip' => $LOCAL_IP),
				 #name('port' => $LOCAL_PORT) )

# Note Savon normally converts to snake_case unless you pass a string, i.e. "bindservicegroup_ip"
print "Bind service group ip: ", LOCAL_IP, ": ";
response = client.request("bindservicegroup_ip") do
   soap.body = {
      :servicegroupname => SERVICE_GROUP_NAME,
      :ip => LOCAL_IP,
      :port => LOCAL_PORT
   }
end
print response.to_hash[:bindservicegroup_response][:return][:message], "\n"

if response.to_hash[:bindservicegroup_response][:return][:rc].to_i != 0 then
	print response.to_hash[:bindservicegroup_response][:return][:message], "\n"
end

print "Unbind service group ip: ", LOCAL_IP, ": ";
response = client.request("unbindservicegroup_ip") do
   soap.body = {
      :servicegroupname => SERVICE_GROUP_NAME,
      :ip => LOCAL_IP,
      :port => LOCAL_PORT
   }
end
print response.to_hash[:unbindservicegroup_response][:return][:message], "\n"

if response.to_hash[:unbindservicegroup_response][:return][:rc].to_i != 0 then
	print response.to_hash[:unbindservicegroup_response][:return][:message], "\n"
end

#:bindservicegroup_response=>
#  {:return=>
#    {:"@xsi:type"=>"ns:simpleResult",
#     :message

print "Save ns config: "
response = client.request(:savensconfig) 
print response.to_hash[:savensconfig_response][:return][:message], "\n"
if response.to_hash[:savensconfig_response][:return][:rc].to_i != 0 then require 'pp'; pp response.to_hash end

print "Logout: "
response = client.request(:logout) 
print response.to_hash[:logout_response][:return][:message], "\n"
if response.to_hash[:logout_response][:return][:rc].to_i != 0 then require 'pp'; pp response.to_hash end

