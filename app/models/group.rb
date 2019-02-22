class Group < ActiveRecord::Base
  has_and_belongs_to_many :widgets
  has_and_belongs_to_many :users
  belongs_to :user
  validates_presence_of :name
end
# == Schema Information
#
# Table name: groups
#
#  id      :integer         not null, primary key
#  name    :string(60)
#  user_id :integer         not null
#

