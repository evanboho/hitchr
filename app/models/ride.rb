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
  after_validation :geocode
  before_save :clean_up_cities
  before_save :get_your_bearings
  before_save :get_distance
  
  
  def get_user_ip
    user_location = Geocoder.request
  end
  
  def get_dest_lat_long
    
  end
  
  def get_your_bearings
    dest = destination + ', ' + destinationstate
    @destlatlong = Geocoder.coordinates(dest)
    destlat = @destlatlong.first
    destlong = @destlatlong.last
    self.bearing = Geocoder::Calculations.bearing_between([latitude, longitude], @destlatlong)
    self.bearing ||= 90
  end
  
  def get_distance
    crow_flies = Geocoder::Calculations.distance_between([latitude, longitude], @destlatlong)
    self.trip_distance = ((crow_flies / 10 * 1.12).round(0)) * 10
  end
  
  def self.state_search(city_state)
    scoped(:conditions => ["rides.originstate LIKE ?", "%#{city_state.strip.upcase}%"])
  end
  
  def self.city_search(city_state)
    scoped(:conditions => ["rides.origin LIKE ?", "%#{city_state.titleize}%"])
  end
  
  def self.search_near(search_start, radius)
    @miles_radius = radius  # necessary? How to set search to current miles_radius?
    coords = Geocoder.coordinates(search_start)
    @rides = Ride.near(coords, radius)
  end
  
  def self.city_state_search(search_start)
    @rides = Ride.scoped
    city_state = search_start.split(', ', 2)
    @rides = @rides.state_search(city_state.last) unless city_state.count == 1
    @rides = @rides.city_search(city_state.first)
  end
  
  
  def self.search(search)
    unless search.nil?
      # start_date = params[:start_date] 
      start_city = search[:start_city]
      scope = Ride.scoped({})
      scope = scope.scoped :conditions => ["rides.origin LIKE ?", "%#{start_city.titleize}%"]
      
      # r = Ride.where(:datetime => Date.today..Date.today + 14)
      where('origin LIKE ?', "%#{search.titleize}%")
    else
      find(:all)# where(:datetime => Date.today..Date.today + 14)
    end
  end
  
  def clean_up_cities
  	self.origin = self.origin.try(:titleize) if self.origin_changed?
  	self.destination = self.destination.try(:titleize) if self.destination_changed?
  end
  
  
end