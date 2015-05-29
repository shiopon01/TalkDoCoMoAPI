require 'net/http'
require 'openssl'
require 'uri'
require 'json'
require 'pp'

def request_to_docomo(http, req, hash)
    req.body = hash.to_json
    response = http.request(req)
    return JSON.parse(URI.unescape(response.body))
end

def say_docomo(response)
    print 'DCM> '; puts response["utt"]
end


☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
# 入力してください！
APIKEY = 'xxxxxxxxx'
☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆

uri = URI.parse("https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue?APIKEY=#{APIKEY}")

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

req = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})

talk = {
    "utt": "",
    "context": "",
    "mode": "dialog"
}

response = request_to_docomo(http, req, talk)
talk["context"] = response["context"]

print 'DCM> '; puts response["utt"]

loop do
    print 'YOU> '
    talk["utt"] = gets.chomp

    response = request_to_docomo(http, req, talk)
    say_docomo(response)
end