#!/usr/bin/ruby

require "rubygems"
require "savon"

client = Savon::Client.new do
  wsdl.endpoint = "http://www.thomas-bayer.com/axis2/services/BLZService"
  wsdl.namespace = "http://thomas-bayer.com/blz/"
end

response = client.request(:blz, :get_bank) do
  soap.element_form_default = :qualified
  soap.body = { :blz => "70070010" }
end
