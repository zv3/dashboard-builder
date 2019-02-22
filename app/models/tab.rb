class Tab < ActiveRecord::Base
  belongs_to :user
  has_many :containers, :order => "containers.order"
  validates_presence_of :title

  def columns
    layout.to_i
  end
end

# == Schema Information
#
# Table name: tabs
#
#  id         :integer         not null, primary key
#  image_id   :integer
#  user_id    :integer
#  session_id :string(255)
#  theme_id   :integer         not null
#  title      :string(60)      not null
#  layout     :string(5)       not null
#

