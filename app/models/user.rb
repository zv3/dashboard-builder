class User < ActiveRecord::Base
  acts_as_authentic
  belongs_to :role
  has_many :widgets
  has_many :tabs
  has_and_belongs_to_many :groups
  attr_accessor :session_id

  def activate!
    self.active = true
    save
  end

  def deliver_activation_instructions!(host_with_port)
     reset_perishable_token!
     Notifier.deliver_activation_instructions(self, host_with_port)
   end

   def deliver_activation_confirmation!(host_with_port)
     reset_perishable_token!
     Notifier.deliver_activation_confirmation(self, host_with_port)
   end

   def deliver_password_reset_instructions!(host_with_port)
     reset_perishable_token!
     Notifier.deliver_password_reset_instructions(self, host_with_port)
   end

   def role_symbols
     Array.new << role.name.underscore.to_sym
   end
end

# == Schema Information
#
# Table name: users
#
#  id                :integer         not null, primary key
#  role_id           :integer         not null
#  username          :string(255)     not null
#  email             :string(255)     not null
#  crypted_password  :string(255)     not null
#  password_salt     :string(255)
#  persistence_token :string(255)
#  perishable_token  :string(255)
#  first_name        :string(20)
#  last_name         :string(20)
#  web_site          :string(150)
#  active            :boolean
#  banned            :boolean
#  logged            :boolean
#  created_at        :datetime
#  updated_at        :datetime
#

