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
  
  geocoded_by :origin
  
  belongs_to :user
  
  validates :user_id, :presence => true
  validates :origin, :presence => true, 
            :length => { :maximum => 20 }
  validates_presence_of :originstate
  validates :destination, :presence => true, 
            :length => { :maximum => 20 }
  validates :datetime, :presence => true
  # validates :bearing, :presence => true
  
  # default_scope :order => 'rides.datetime ASC'
  before_validation :geocode
  before_save :titleize_cities
  after_validation :get_your_bearings
  before_save :get_distance
  
  def get_dest_lat_long
    
  end
  
  def get_your_bearings
    @destlatlong = Geocoder.coordinates(destination)
    destlat = @destlatlong.first
    destlong = @destlatlong.last
   # self.bearing = @destlatlong
    self.bearing = Geocoder::Calculations.bearing_between([latitude, longitude], @destlatlong)
    self.bearing ||= 90
  end
  
  def get_distance
    #destlatlong = Geocoder.coordinates(:destination)
    self.trip_distance = Geocoder::Calculations.distance_between([latitude, longitude], @destlatlong)
  end
    
  
  def self.search(search)
    if search
      r = Ride.where(:datetime => Date.today..Date.today + 14)
      r = r.where('origin LIKE ?', "%#{search.titleize}%")
    else
      find(:all)# where(:datetime => Date.today..Date.today + 14)
    end
  end
  
  def titleize_cities
  	self.origin = self.origin.try(:titleize) if self.origin_changed?
  	self.destination = self.destination.try(:titleize) if self.destination_changed?
  end
  
  
end