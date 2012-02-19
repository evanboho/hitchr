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
  include ActiveModel::Validations
  	
  attr_accessible :origin, :originstate, :destination, :destinationstate, 
                  :datetime, :message
  
  belongs_to :user
  
  validates :user_id, :presence => true
  validates :origin, :presence => true, 
            :length => { :maximum => 20 } #, :case_sensitive => false
  validates_presence_of :originstate
  validates :destination, :presence => true, 
            :length => { :maximum => 20 } # , :case_sensitive => false
  validates :datetime, :presence => true
  
  default_scope :order => 'rides.datetime ASC'
  
  def origin=(value)
    self[:origin] = value && value.titleize
  end

  def destination=(value)
    self[:destination] = value && value.titleize
  end
  
  def self.search(search)
    if search
      r = Ride.where(:datetime => Date.today..Date.today + 14)
      r = r.where('origin LIKE ?', "%#{search.titleize}%")
    else
      where(:datetime => Date.today..Date.today + 14)
    end
  end
  
end