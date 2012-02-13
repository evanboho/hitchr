class RidesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  
  def index
    @rides = Ride.all
  end

  def new
    @ride = Ride.new
  end

  def show
  end
  
  def create
    @ride = current_user.rides.build(params[:ride])
    if @ride.save
      flash[:success] = "Ride created!"
      redirect_to rides_path
    else
      render 'ride_path'
    end
  end
  
  def destroy
    Ride.find(params[:id]).destroy
    flash[:success] = "Ride deleted"
    redirect_to rides_path
  end

end