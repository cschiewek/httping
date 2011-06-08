#!/usr/bin/env ruby
# HTTP ping utility

require 'net/https'
require 'uri'

MAX = (2**(0.size * 8 -2) -1)

uri = URI.parse(ARGV.first || 'http://google.com')
count = ARGV[1] ? ARGV[1].to_i : MAX
http = Net::HTTP.new(uri.host, uri.port)

if uri.default_port == 443 then
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
end

request = Net::HTTP::Get.new(uri.request_uri)
puts "GETTING #{uri}"
count.times do
  start_time = Time.now
  response = http.request(request)
  time = Time.now - start_time
  puts "from #{uri} response=#{response.code}(#{response.message}) ttl=#{time.round(3)}"
  sleep(1.0 - time)
end