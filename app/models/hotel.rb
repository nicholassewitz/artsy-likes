class Hotel < ApplicationRecord
  belongs_to :user

  validates(:name, presence: {message: 'You must have a name.'}, uniqueness: true)
  validates(:street, presence: true)
  validates(:user, presence: true)

  geocoded_by :address   # can also be an IP address
  after_validation :geocode

  def address
  [street, city, state, zip, country].compact.join(', ')
  end

  has_attached_file(:photo,
                  styles: {thumbnail: '100x100>', full: '300x300>'},
                  storage: :s3,
                  s3_region: 'us-east-1',
                  s3_credentials: {bucket: 'S3 BUCKET',
                                   access_key_id: 'ACCESS KEY',
                                   secret_access_key: 'SECRET KEY'})
  validates_attachment_content_type(:photo, content_type: /\Aimage\/.+\Z/)



  after_create(:send_create_push_notification)

  def send_create_push_notification
    puts("Hey, a new hotel titled '#{name}' was posted!")
  end

  after_update(:send_update_push_notification)

  def send_update_push_notification
    puts("The hotel '#{name}' was updated!")
  end

  def self.search(query)
    where('street LIKE ? OR city LIKE ? OR state LIKE ? OR country LIKE ? OR zip LIKE ?',
          like(query),
          like(query),
          like(query),
          like(query),
          like(query))
  end

  def self.like(condition)
    "%#{condition}%"
  end

  # def self.near(query, 10, order: :distance)
  # end
end
