# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE


client_id = '13d75ce4ae1e79d46953'
client_secret = '2019021385bb3050c5f262f771d54fa2'

api = Hyperclient.new('https://api.artsy.net/api') do |api|
  api.headers['Accept'] = 'application/vnd.artsy-v2+json'
  api.headers['Content-Type'] = 'application/json'
  api.connection(default: false) do |conn|
    conn.use FaradayMiddleware::FollowRedirects
    conn.use Faraday::Response::RaiseError
    conn.request :json
    conn.response :json, content_type: /\bjson$/
    conn.adapter :net_http
  end
end

xapp_token = api.tokens.xapp_token._post(client_id: client_id, client_secret: client_secret).token

api = Hyperclient.new('https://api.artsy.net/api') do |api|
  api.headers['Accept'] = 'application/vnd.artsy-v2+json'
  api.headers['X-Xapp-Token'] = xapp_token
  api.connection(default: false) do |conn|
    conn.use FaradayMiddleware::FollowRedirects
    conn.use Faraday::Response::RaiseError
    conn.request :json
    conn.response :json, content_type: /\bjson$/
    conn.adapter :net_http
  end
end


# artists = api.artist(id: 'andy-warhol')
# puts "#{artists.name}"
