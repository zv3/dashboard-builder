class Role < ActiveRecord::Base
  has_many :users
end

# == Schema Information
#
# Table name: roles
#
#  id          :integer         not null, primary key
#  name        :string(60)      not null
#  description :text
#

