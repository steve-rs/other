#!/usr/bin/env ruby

require 'rubygems'
require 'base64'
require 'rest_client'
require 'openssl'
require 'cgi'

hash = OpenSSL::HMAC.digest('sha1', "key", "value")
puts "hash = [" + hash + "]"

signature = Base64.encode64(hash).chomp
puts "signature = [" + signature + "]"

s = CGI.escape(signature)
puts "s = [" + s + "]"


