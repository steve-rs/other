#!/usr/bin/env ruby

# This script adds or removes a "member" to or from a Netscaler "Service Group".
# Service Groups allow you to manage multiple servers. A service group is a representation of one
# or more services. You can add servers and services to the service group.
#
# Variables that need to be defined in the environment:
#  SERVICE_GROUP_NAME : The service group name as defined on the Netscaler
#  SERVICE_IP         : The IP address of the member to be added
#  SERVICE_PORT       : The port the member's service is listening on
#  NS_HOSTNAME        : The hostname or IP address of the Netscaler to be managed
#  NS_USERNAME        : The username
#  NS_PASSWORD        : The password
#
# Note: Any network interface on the Netscaler can be used for management purposes under Network->IPs
# See more on Netscaler configuration in "NS-VPXGettingStarted-Guide.pdf" and "NS-TrafficMgmt-Guide.pdf" which can be
# downloaded from the Netscaler appliance itself or from the Citrix's website.
#
# This script uses the Savon soap gem to communicate with Netscaler. Savon requires the following packages:
# libxml2-dev libxslt-dev

require 'rubygems'
# Install the soap gem if needed 
system "sudo gem install savon" unless Gem.available?('savon')
require 'savon'
require 'pp' # Only used for outputing any negative responces 
require 'yaml'

# Ensure the following variable are set in the environment
abort "SERVICE_GROUP_NAME undefined!" unless (SERVICE_GROUP_NAME = ENV['SERVICE_GROUP_NAME'])
abort "SERVICE_IP undefined!"         unless (SERVICE_IP =         ENV['SERVICE_IP'])
abort "SERVICE_PORT undefined!"       unless (SERVICE_PORT=        ENV['SERVICE_PORT'])
abort "NS_HOSTNAME undefined!"        unless (NS_HOSTNAME =        ENV['NS_HOSTNAME'])
abort "NS_USERNAME undefined!"        unless (NS_USERNAME =        ENV['NS_USERNAME'])
abort "NS_PASSWORD undefined!"        unless (NS_PASSWORD =        ENV['NS_PASSWORD'])

print "SERVICE_GROUP_NAME=", SERVICE_GROUP_NAME, "\n"
print "SERVICE_IP=",         SERVICE_IP, "\n"
print "SERVICE_PORT=",       SERVICE_PORT, "\n"
print "NS_HOSTNAME=",        NS_HOSTNAME, "\n"
print "NS_USERNAME=",        NS_USERNAME, "\n"
print "NS_PASSWORD=",        NS_PASSWORD, "\n"
#print "\n"

client = Savon::Client.new do
  wsdl.endpoint = "http://" + NS_HOSTNAME + "/soap/"
  wsdl.namespace = "urn:NSConfig"
end

Savon.configure do |config|
  config.log = false            # disable logging
#  config.log_level = :warn      # changing the log level
#  config.logger = Rails.logger  # using the Rails logger
end

# Disable logging in the http module
HTTPI.log = false

print "Login: "
response = client.request(:login) do
  soap.body = { :username => NS_USERNAME, :password => NS_PASSWORD }
end
print response.to_hash[:login_response][:return][:message], "\n"
pp response.to_hash unless response.to_hash[:login_response][:return][:rc].to_i == 0

client.http.headers["Cookie"] = response.http.headers["Set-Cookie"]

# Note Savon normally converts to snake_case unless you pass a string, i.e. "bindservicegroup_ip"
print "Bind service group ip: SERVICE_GROUP_NAME=", SERVICE_GROUP_NAME, " IP=", SERVICE_IP, " PORT=", SERVICE_PORT, ": "
response = client.request("bindservicegroup_ip") do
   soap.body = {
      :servicegroupname => SERVICE_GROUP_NAME,
      :ip => SERVICE_IP,
      :port => SERVICE_PORT
   }
end
print response.to_hash[:bindservicegroup_response][:return][:message], "\n"

puts "to_hash"
puts response.to_hash
puts "to_yaml"
puts response.to_yaml
puts "pp to_hash"
pp response.to_hash 

pp response.to_hash unless response.to_hash[:bindservicegroup_response][:return][:rc].to_i == 0

print "Unbind service group ip: SERVICE_GROUP_NAME=", SERVICE_GROUP_NAME, " IP=", SERVICE_IP, " PORT=", SERVICE_PORT, ": "
response = client.request("unbindservicegroup_ip") do
   soap.body = {
      :servicegroupname => SERVICE_GROUP_NAME,
      :ip => SERVICE_IP,
      :port => SERVICE_PORT
   }
end
print response.to_hash[:unbindservicegroup_response][:return][:message], "\n"
pp response.to_hash unless response.to_hash[:unbindservicegroup_response][:return][:rc].to_i == 0

print "Save NS config: "
response = client.request(:savensconfig) 
print response.to_hash[:savensconfig_response][:return][:message], "\n"
pp response.to_hash unless response.to_hash[:savensconfig_response][:return][:rc].to_i == 0

print "Logout: "
response = client.request(:logout) 
print response.to_hash[:logout_response][:return][:message], "\n"
pp response.to_hash unless response.to_hash[:logout_response][:return][:rc].to_i == 0 

