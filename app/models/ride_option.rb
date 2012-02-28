class RideOption < ActiveRecord::Base
    
  # validates :passenger_count, :numericality => true
  # validates :ride_id, :presence => true, :uniqueness => true
  
  belongs_to :ride
  
end
