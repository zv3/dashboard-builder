class Rating < ActiveRecord::Base
  belongs_to :widget
  belongs_to :user
end

# == Schema Information
#
# Table name: ratings
#
#  id        :integer         not null, primary key
#  widget_id :integer         not null
#  user_id   :integer         not null
#  rate      :integer(2)      not null
#

