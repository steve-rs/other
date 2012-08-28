#!/usr/bin/env ruby

require 'rubygems'
require 'base64'
require 'rest_client'  # gen install rest-client
require 'openssl'
require 'cgi'
require 'json' # gen install json_pure. Note: 'pure' is needed due to a bug on CentOS 5. See http://theforeman.org/issues/1330

# Note: API_URL / API_KEY / SECRET_KEY / LB_RULE_ID must all be defined in RightScale INPUTS (in the environment)

## TEST values
#API_URL = "https://sdscloudstack.cloudlord.com:12345/client/api"
#API_KEY = "77fZbJ_L0Dd0FSED63sGearUXiJMbGD-VnlXjLZ2snLuzMM_rMMPBFlzAzY_qyNRHfzO7mwvvIWSwssaKozf9A"
#SECRET_KEY = "eADXllxC7tKbGy68mv2hDixtjAaV3uohiK-vTIVSpdZxH4znP79i1N2qZhoZuyPqBGADv87M_fVMeIsS8d2FYA"
#LB_RULE_ID = 111
## TEST values

abort "API_URL undefined!"    unless (API_URL =    ENV['API_URL'])
abort "API_KEY undefined!"    unless (API_KEY =    ENV['API_KEY'])
abort "SECRET_KEY undefined!" unless (SECRET_KEY = ENV['SECRET_KEY'])
abort "LB_RULE_ID undefined!" unless (LB_RULE_ID = ENV['LB_RULE_ID'])

def generate_signature(params)
  params.each { |k,v| params[k] = CGI.escape(v.to_s).gsub('+', '%20').downcase }
  sorted_params = params.sort_by{|key,value| key.to_s}

  data = parameterize(sorted_params, false)

  #hash = OpenSSL::HMAC.digest('sha1', SECRET_KEY, data)
  hash = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, SECRET_KEY, data)
  signature = Base64.encode64(hash).chomp
end

def parameterize(params, escape=true)
  params = params.collect do |k,v| 
    if escape
      "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
    else
      "#{k}=#{v}"
    end
  end
  params.join('&')
end

def generate_params_str(params)
#  unless params[:response]
    params[:response] = "json"
#  end
  params[:apikey] = API_KEY
  params[:signature] = generate_signature(params.clone)
  str = parameterize(params)
end

def request(params, api_url, method = :get)
  case method
  when :get
    url = api_url + "?" + generate_params_str(params.clone)
    puts "Request URL:"
    puts url
    response = RestClient.send(method, url)
  else
    raise "HTTP method #{method} not supported"
  end
  response    
end

##############################################
# Fetch the VM ID for this server

# This will grab the IP addr of the router with the meta-data for this server (tested on CentOS)
ip = `cat /var/lib/dhclient/dhclient-eth0.leases | \
  egrep "dhcp-server-identifier.*[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | tail -1 | awk '{print $NF}' | tr -cd "[^0-9.]"`

abort "Cannot find IP addr of the meta-data router/server" if ip == ""
puts "Will retrieve mete-data from IP = [#{ip}]"

url = 'http://' + ip + '/latest/vm-id'
vmid = RestClient.send(:get, url)

abort "Cannot retrieve this server's VM ID from #{url}" if vmid == ""
puts "This VM ID = [#{vmid}]"

puts "Load balancer rule ID = [#{LB_RULE_ID}]"

##############################################
# Make CS API request to assign this server to a load balancer

# Note, remove a VM from a rule using the api command "removeFromLoadBalancerRule"
params = {
  'command' => 'assignToLoadBalancerRule',
  'id' => LB_RULE_ID,
  'virtualmachineids' => vmid.to_s 
}

response_s = request(params, API_URL, :get)
tmp = JSON.parse(response_s)

puts "Response:\n" + response_s

if tmp['assigntoloadbalancerruleresponse'].has_key? 'jobid'
  jobid = tmp['assigntoloadbalancerruleresponse']["jobid"]
else
  puts "No job id returned ... exiting"
  exit 0
end

##############################################
# Query and wait for async command to finish ...

params = {
  'command' => 'queryAsyncJobResult',
  'jobid' => jobid
}

puts "Waiting for job (jobid=#{jobid}) to complete"

a_while = 2
tries = 3

begin
  puts "Sleeping #{a_while} second(s)"
  sleep a_while

  response_s = request(params, API_URL, :get)
  puts "Response:\n" + response_s
  tmp2 = JSON.parse(response_s)
  
  job_res_resp = tmp2['queryasyncjobresultresponse']

  tries -= 1
  a_while += 5
end while job_res_resp['jobstatus'] == 0 and tries > 0

puts "Giving up waiting for job to complete" unless tries > 0

jobstatus = job_res_resp['jobstatus']

case jobstatus
when 2
  print "Request failed: "
when 1
  print "Request succeded: "
when 0
  print "Request still in progress: "
else
  print "Unknown result: "
end
  puts "job status #{jobstatus}"

exit 0

