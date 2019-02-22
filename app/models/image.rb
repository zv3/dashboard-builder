require 'open-uri'
class Image < ActiveRecord::Base
  attr_accessor :image_remote_url #instance variable
  has_attached_file :data, 
    :styles => { 
      :thumb => ["80x80!", "gif"], 
      :thumb_t => ["200x70!", "gif"] 
    },
    :url  => "/images/upload/:id/:style/:basename.:extension",
    :path => ":rails_root/public/images/upload/:id/:style/:basename.:extension"
  # has_attached_file :data, 
  #                   :styles => { 
  #                       :thumb => ["80x80!", "gif"], 
  #                       :thumb_t => ["200x70!", "gif"] 
  #                   },
  #                   :path => "images/:id/:style/:basename.:extension",
  #                   :storage        => :s3,
  #                   :s3_credentials => { :access_key_id => "AKIAJ6HBH4CUXHYDOYLQ", :secret_access_key => "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" },
  #                   :bucket         => 'wuca'
  before_validation :download_remote_image

  validates_attachment_presence :data, :if => Proc.new { |imports| !imports.data_file_name.blank? }
  validates_attachment_size :data, :less_than => 500.kilobytes, :if => Proc.new { |imports| !imports.data_file_name.blank? }
  validates_attachment_content_type :data, :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png', 'image/gif'], :if => Proc.new { |imports| !imports.data_file_name.blank? }

  private
  def download_remote_image
    self.image_url = image_remote_url
    self.data = do_download_remote_image
  end

  def do_download_remote_image
    io = open(URI.parse(URI.encode(image_url)))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue #rescatamos errores que puedan producirse en caso que no se pueda descargar la imagen, en vez de tirar excepciones al cliente (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end
end

# == Schema Information
#
# Table name: images
#
#  id                :integer         not null, primary key
#  data_file_name    :string(60)      not null
#  image_url         :string(200)     not null
#  data_content_type :string(10)      not null
#  data_file_size    :integer
#  data_updated_at   :datetime
#

