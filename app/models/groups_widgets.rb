class GroupsWidgets < ActiveRecord::Base
  belongs_to :widget
end

# == Schema Information
#
# Table name: groups_widgets
#
#  id        :integer         not null, primary key
#  widget_id :integer         not null
#  group_id  :integer         not null
#

