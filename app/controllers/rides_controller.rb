class RidesController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :destroy]
  before_filter :get_ride, :only => [:show, :update]
  
  def index
    @rides = Ride.paginate(:page => params[:page], :per_page => 10)
    unless params[:search].blank?
      if params[:miles_radius] == "0"
        @rides = @rides.search(params[:search])
      else
        s = Geocoder.coordinates(params[:search])
        @rides = Ride.near(params[:search], params[:miles_radius])
        # @rides = @rides.paginate
      end
    end
  end

  def show
    @title = "#{@ride.origin} to #{@ride.destination}"
  end
  
  def new
    @ride = Ride.new
    @ride.datetime = Date.tomorrow + 9.hours
  end
  
  def get_ride
    @ride = Ride.find(params[:id])
  end
  
  def find
    # @rides = Ride.where(:origin => "Chicago").paginate(:page => params[:page], :per_page => 5)
  end
  
  def edit
    @ride = current_user.rides.build(params[:ride])
    if @ride.save
      flash[:success] = "Ride created!"
    else
      render 'edit'
    end
  end

  def update
    if @ride.update_attributes(params[:ride])
      flash[:success] = "Ride updated."
      redirect_to @ride
    else
      render 'edit'
    end
  end
  
  
  def create
    @ride = current_user.rides.build(params[:ride])
    if @ride.save
      flash[:success] = "Ride created!"
      redirect_to ride_path(@ride)
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