class Category < ActiveRecord::Base
  has_many :widgets, :dependent => :nullify
  has_many :themes,  :dependent => :nullify
  validates_length_of :name, :within => 1..60
  named_scope :type_of_themes, :conditions => { :category_type => 't' }
  named_scope :type_of_widgets, :conditions => { :category_type => 'w' }
end

# == Schema Information
#
# Table name: categories
#
#  id            :integer         not null, primary key
#  name          :string(60)      not null
#  category_type :string(1)       not null
#

