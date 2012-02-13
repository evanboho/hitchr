class PagesController < ApplicationController
  def home
    @ride = Ride.new if signed_in?
  end

  def contact
    
  end
  
  def about
    
  end
  
  def help
    
  end
  
  def headers
    
  end
  
  def signin
   
  end
  
  def contact
   
  end
  
end
