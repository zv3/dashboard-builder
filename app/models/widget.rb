class Widget < ActiveRecord::Base
  belongs_to :image
  belongs_to :user
  belongs_to :category, :conditions => { :category_type => 'w' }
  has_many :comments
  has_and_belongs_to_many :groups
  has_many :tags
  has_many :ratings
  attr_writer :tag_names
  after_save :assign_tags
  before_create :get_preferences
  validates_presence_of :name
  validates_presence_of :url
  validates_format_of :url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
  # validates_presence_of :image

  def tag_names
    @tag_names || tags.map(&:name).join(' , ')
  end

  private
  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/,+/).map do |name|
        Tag.create(:name => name, :widget_id => self.id)
      end
    end
  end

  def get_preferences
    require 'net/http'
    # metodo para obtener las preferencias de un widget
    url = 'http://nvmodules.netvibes.com/widget/json?uwaUrl=' + self.url
    url = url.gsub(/ /,"+")
    self.preferences = Net::HTTP.get_response(URI.parse(url)).body
  end
end
# == Schema Information
#
# Table name: widgets
#
#  id          :integer         not null, primary key
#  category_id :integer
#  user_id     :integer         not null
#  image_id    :integer
#  name        :string(60)      not null
#  description :string(100)
#  url         :string(200)     not null
#  approved    :boolean
#  public      :boolean
#  preferences :text
#

