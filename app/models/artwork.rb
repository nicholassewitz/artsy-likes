class Artwork < ApplicationRecord
  include ActiveModel::Serializers::JSON

  belongs_to :user

  validates(:name, presence: {message: 'You must have a name.'}, uniqueness: true)
  validates(:user, presence: true)



  has_attached_file(:photo,
                  styles: {thumbnail: '100x100>', full: '300x300>'},
                  storage: :s3,
                  s3_region: 'us-east-1',
                  s3_credentials: {bucket: 'artsy-likes',
                                   access_key_id: 'AKIAIYKWXJSTNDLT56JA',
                                   secret_access_key: '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'})
  validates_attachment_content_type(:photo, content_type: /\Aimage\/.+\Z/)



  after_create(:send_create_push_notification)

  def send_create_push_notification
    puts("Hey, a new artwork titled '#{name}' was posted!")
  end

  after_update(:send_update_push_notification)

  def send_update_push_notification
    puts("The artwork '#{name}' was updated!")
  end

  def self.search(query)
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

    artists = api.artist(id: query)
      new(name: artists.name, user: User.first, id: artists.id, photourl: artists.thumbnail)
    end

  # artists._get
  # new.from_json(artists._response.body.to_json)


  # def self.search(query)
  #   where('street LIKE ? OR city LIKE ? OR state LIKE ? OR country LIKE ? OR zip LIKE ?',
  #         like(query),
  #         like(query),
  #         like(query),
  #         like(query),
  #         like(query))
  # end

  def self.like(condition)
    "%#{condition}%"
  end

  # def self.near(query, 10, order: :distance)
  # end
end
