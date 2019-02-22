class Request < ActiveRecord::Base
  belongs_to :user
	belongs_to :comment
	
	def deliver_request_reject(host_with_port)
    Notifier.deliver_request_reject(self, host_with_port)
  end
	
  def deliver_request_approve(host_with_port)
    Notifier.deliver_request_approve(self, host_with_port)
  end
end
# == Schema Information
#
# Table name: requests
#
#  id           :integer         not null, primary key
#  theme_id     :integer
#  widget_id    :integer
#  user_id      :integer         not null
#  comment_id   :integer
#  message      :text
#  approved     :boolean
#  request_type :string(1)       not null
#  created_at   :datetime
#

