class Comment < ActiveRecord::Base
  belongs_to :widget
  belongs_to :user
	has_one :rating
  validates_presence_of :message
end

# == Schema Information
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  widget_id  :integer         not null
#  message    :text            not null
#  created_at :datetime
#

