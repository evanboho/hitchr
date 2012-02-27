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
  
  geocoded_by :origin
  
  belongs_to :user
  
  validates :user, :presence => true

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
    @destcoords = Geocoder.coordinates(dest)
    self.bearing = Geocoder::Calculations.bearing_between([latitude, longitude], @destcoords)
  end
  
  def get_distance
    crow_flies = Geocoder::Calculations.distance_between([latitude, longitude], @destcoords)
    self.trip_distance = ((crow_flies / 10 * 1.12).round(0)) * 10
  end
  
  
  # SEARCH(es)
  
  def self.search(criteria)
    #@rides = Ride.scoped  Necessary? Better?
    @rides = Ride.where("datetime > ?", criteria[:start_date]).includes(:user)
    if criteria[:origin_city].present?
      if criteria[:miles_radius].to_i == 0 
        rides = @rides.search_origin(criteria)
        if rides.empty?
          criteria[:miles_radius] = 15
          @flash_expand = 1
        else
          @rides = rides
        end
      end
      if criteria[:miles_radius].to_i > 0
        pp "dg"
        rides = @rides.search_near(criteria)
        if rides.empty?
          criteria[:miles_radius] += 15
          @flash_expand = 1
          @rides = @rides.search_near(criteria)
        else
          @rides = rides
        end
      end
      @miles_radius = criteria[:miles_radius]
      # if rides.empty?
      #   pp "123"
      #   criteria[:miles_radius] = 30 #TODO: make it expand the radius += 15 until finds cities
      #   @rides = @rides.search_near(criteria)
      #   @miles_radius = criteria[:miles_radius]
      #   @flash_expand = true
      # else
      #   @rides = rides
      # end
    end
    if criteria[:dest_city].present?
      rides_dest = @rides.search_destination(criteria)
      if rides_dest.blank?
        @rides = @rides.search_direction(criteria)
      else
        @rides = rides_dest
      end
      if @rides.blank? && @flash_expand == false
      end
    end
    @rides
  end  
    
  
  def self.search_origin(criteria)
    if criteria[:origin_state]
      rides_origin_state = @rides.where(:originstate => criteria[:origin_state])
    end
    if criteria[:origin_city] 
      rides_origin_state ||= @rides
      rides_origin_state.where("origin LIKE ?", "%#{criteria[:origin_city]}%")
    end
  end
  
  def self.search_destination(criteria)
    if criteria[:dest_state]
      rides_dest = @rides.where(:destinationstate => criteria[:dest_state])
    end
    if criteria[:dest_city]
      rides_dest ||= @rides
      rides_dest.where("destination LIKE ?", "%#{criteria[:dest_city]}")
    end   
  end
  
  def self.search_near(criteria)
    @miles_radius = criteria[:miles_radius]  # necessary? How to set search to current miles_radius?
    @rides.near("#{criteria[:origin_city]}, #{criteria[:origin_state]}", criteria[:miles_radius])
  end
  
  def self.search_direction(criteria)
    search_bearing = Geocoder::Calculations.bearing_between("#{criteria[:origin_city]}, #{criteria[:origin_state]}", 
                                                            "#{criteria[:dest_city]}, #{criteria[:dest_state]}")
    @rides.where(:bearing => (search_bearing - 20)..(search_bearing + 20))
  end 
  
  def clean_up_cities
  	self.origin = self.origin.try(:titleize).try(:strip) if self.origin_changed?
  	self.destination = self.destination.try(:titleize).try(:strip) if self.destination_changed?
  end
  
  
end