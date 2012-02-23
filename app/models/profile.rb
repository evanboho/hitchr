class Profile < ActiveRecord::Base

  belongs_to :user
  attr_accessible :birthday, :sex, :home_town, :user_id, :about_block
  
  validates :user_id, :presence => true
  
  # validates :home_town, :presence => true
  
  before_save :city_not_blank
  
  def city_not_blank
      home_town ||= ''
  end
  
  
  # validates :birthday, :presence => true
  
  # geocoded_by :current_user_city

  # after_validation :geocode
  
  after_validation :geocode_stuff
  
  def geocode_stuff
    unless home_town.blank?
      coords = Geocoder.coordinates(home_town)
      result = Geocoder.search(coords).first
      self.home_town = result.city + ', ' + result.state_code + ' ' + result.postal_code
      self.latitude = coords.first
      self.longitude = coords.last
      # self.home_zip = result.postal_code
    else
      self.home_town = ''
    end
  end
  
  def current_user_city
    home_town
  end
  
  def current_user_city=(city)
    coords = Geocoder.coordinates(current_user_city)
    self.home_town = Geocoder.address(coords)
  end
  
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.zip = geo.postal_code
    end
  end

end
