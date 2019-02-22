class WidgetParams < ActiveRecord::Base
	belongs_to :widget
	belongs_to :container
end