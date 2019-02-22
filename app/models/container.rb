class Container < ActiveRecord::Base
	belongs_to :tab
	belongs_to :widget
	has_many :widgetparams
end
# == Schema Information
#
# Table name: containers
#
#  id        :integer         not null, primary key
#  widget_id :integer         not null
#  tab_id    :integer         not null
#  order     :integer(8)
#  column    :integer(2)
#  color     :string(6)
#

