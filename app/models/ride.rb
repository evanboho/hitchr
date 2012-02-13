# == Schema Information
#
# Table name: rides
#
#  id          :integer         not null, primary key
#  origin      :string(255)
#  destination :string(255)
#  date        :time
#  user_id     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Ride < ActiveRecord::Base
  attr_accessible :origin, :destination, :date
  
  belongs_to :user
  
  validates :user_id, :presence => true
  validates :origin, :presence => true, :length => { :maximum => 20 }
  validates :destination, :presence => true, :length => { :maximum => 20 }
  
  # validates :date => presence => true
  
  default_scope :order => 'rides.created_at DESC'
end
