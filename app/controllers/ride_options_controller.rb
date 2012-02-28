class RideOptionsController < ApplicationController

  def new
    @ride_option = RideOption.new
  end
  
  def create
    @ride = Ride.order('updated_at DESC').first #hack?!
    @ride_option = @ride.build_ride_option(params[:ride_option])
    if @ride_option.save
      flash[:success] = "...all done!"
      redirect_to @ride_option.ride
    else
      render 'new'
    end 
  end
  
  def edit
    @ride_option = RideOption.find(params[:id])
  end
  
  def update
    @ride_option = RideOption.find(params[:id])
    if @ride_option.update_attributes(params[:ride_option])
      flash[:success] = "ride updated!"
      redirect_to @ride_option.ride
    else
      render 'edit'
    end
  end

end