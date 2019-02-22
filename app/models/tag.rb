class Tag < ActiveRecord::Base
  belongs_to :widget
end
# == Schema Information
#
# Table name: tags
#
#  id        :integer         not null, primary key
#  widget_id :integer         not null
#  name      :string(60)      not null
#

