class RidesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  
  def index
    @rides = Ride.all
  end

  def show
    @ride = Ride.find(params[:id])
    @title = "#{@ride.origin} to #{@ride.destination}"
  end
  
  def new
    @ride = Ride.new
  end
  
  def edit
    @ride = current_user.rides.build(params[:ride])
    if @ride.save
      flash[:success] = "Ride created!"
    else
      render 'edit'
    end
  end

  
  
  def create
    # if current_user.rides.date.acs_like_date?
    @ride = current_user.rides.build(params[:ride])
    if @ride.save
      flash[:success] = "Ride created!"
      redirect_to rides_path
    else
      render 'new'
    end
  end
  
  def destroy
    Ride.find(params[:id]).destroy
    flash[:success] = "Ride deleted"
    redirect_to rides_path
  end

end