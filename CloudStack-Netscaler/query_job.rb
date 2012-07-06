#!/usr/bin/env ruby

require 'rubygems'
require 'base64'
require 'rest_client'
require 'openssl'
require 'cgi'
#require 'json'

# API_URL /  API_KEY  / SECRET_KEY = all defined in INPUTS
API_URL = "https://sdscloudstack.cloudlord.com:12345/client/api"
API_KEY = "77fZbJ_L0Dd0FSED63sGearUXiJMbGD-VnlXjLZ2snLuzMM_rMMPBFlzAzY_qyNRHfzO7mwvvIWSwssaKozf9A"
SECRET_KEY = "eADXllxC7tKbGy68mv2hDixtjAaV3uohiK-vTIVSpdZxH4znP79i1N2qZhoZuyPqBGADv87M_fVMeIsS8d2FYA"

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
    response = RestClient.send(method, url)
  else
    raise "HTTP method #{method} not supported"
  end
  response    
end

params = {
  'command' => 'queryAsyncJobResult',
  'jobid' => '32'
}



  #'apikey' => API_KEY
r = request(params, API_URL, :get)
puts "Response:\n" + r
#puts JSON.stringify(r)

