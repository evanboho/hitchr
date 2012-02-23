class RidesController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :destroy]
  before_filter :get_ride, :only => [:show, :update]
  
  def index
    unless params[:start_date].nil?
      @start_date = as_date
      # @rides = Ride.paginate(:page => params[:page], :per_page => 10)
      unless params[:search_city].blank?
        if params[:miles_radius].to_i > 0
          coords = Geocoder.coordinates(params[:search_city])
          @rides = Ride.near(coords, params[:miles_radius])
        else
          @rides = Ride.scoped
          city_state = params[:search_city].split(',', 2)
          @rides = @rides.scoped(
            :conditions => ["rides.originstate LIKE ?", 
            "%#{city_state.last.strip.upcase}%"]) unless city_state.first == city_state.last
          @rides = @rides.scoped(:conditions => ["rides.origin LIKE ?", "%#{city_state.first.titleize}%"]) unless city_state.nil?
        end
      end
      @rides = @rides.scoped( :conditions => { :datetime => @start_date..@start_date + 14 } ) 
    else 
    @rides = Ride.all
    end
  end
  
  def as_date
    Date.civil(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
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
    @ride = Ride.new(params[:ride])
    @ride.user_id = current_user.id
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