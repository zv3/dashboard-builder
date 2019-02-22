class Theme < ActiveRecord::Base
  belongs_to :category, :conditions => { :category_type => 't' }
  belongs_to :user
  belongs_to :image
  validates_presence_of :image
  validates_presence_of :name
  validates_presence_of :font
  validates_presence_of :color
  named_scope :all_public, :conditions => ["public=true AND approved=true"]
  named_scope :all_public_or_from_user, lambda { |*args| {:conditions => ["(public=true AND approved=true) OR user_id=?", args.first]} }
end

# == Schema Information
#
# Table name: themes
#
#  id          :integer         not null, primary key
#  user_id     :integer         not null
#  category_id :integer
#  image_id    :integer
#  name        :string(60)      not null
#  color       :string(6)
#  font        :string(60)
#  approved    :boolean
#  public      :boolean
#

