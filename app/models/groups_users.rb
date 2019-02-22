class GroupsUsers < ActiveRecord::Base
  belongs_to :user
end

# == Schema Information
#
# Table name: groups_users
#
#  id       :integer         not null, primary key
#  group_id :integer         not null
#  user_id  :integer         not null
#

