# == Schema Information
#
# Table name: rides
#
#  id          :integer         not null, primary key
#  origin      :string(255)
#  destination :string(255)
#  date        :date
#  time        :time
#  message     :string(255)
#  user_id     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Ride < ActiveRecord::Base
  attr_accessible :origin, :destination, :date, :time, :message
  
  belongs_to :user
  
  validates :user_id, :presence => true
  validates :origin, :presence => true, :length => { :maximum => 20 }
  validates :destination, :presence => true, :length => { :maximum => 20 }
  validates :date, :presence => true
  
  default_scope :order => 'rides.date DESC'
  
#  before_save :check_date
  
#  def check_date
#    if !ride.date.acts_like_date?
#    redirect_to new_ride_path, :notice => "Date format incorrect."
#  end
  
end
