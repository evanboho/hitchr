class RidesController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :destroy]
  before_filter :get_ride, :only => [:show, :update]
  
  def index
    unless params[:start_date].nil?
      @start_date = make_date
      # @rides = Ride.paginate(:page => params[:page], :per_page => 10)
      unless params[:search_city].blank?
      search_start = params[:search_city] 
        if params[:miles_radius].to_i > 0
          @miles_radius = params[:miles_radius]
          coords = Geocoder.coordinates(search_start)
          @rides = Ride.near(coords, params[:miles_radius])
        else
          @rides = Ride.scoped
          city_state = search_start.split(',', 2)
          @rides = @rides.scoped(
            :conditions => ["rides.originstate LIKE ?", 
            "%#{city_state.last.strip.upcase}%"]) unless city_state.first == city_state.last
          @rides = @rides.scoped(:conditions => ["rides.origin LIKE ?", "%#{city_state.first.titleize}%"])
        end
        unless params[:search_dest].blank?
          search_bearing = Geocoder::Calculations.bearing_between(search_start, params[:search_dest])
          @rides = @rides.scoped( :conditions => { :bearing => (search_bearing - 35)..(search_bearing + 35) } )
        end
      end
      @rides ||= Ride.scoped
      @rides = @rides.scoped( :conditions => { :datetime => @start_date..@start_date + 14 } ) 
      @rides = @rides.reorder('rides.datetime ASC')
    else 
      # user_loc = request.
      # @rides = Ride.scoped( :conditions => 
      @rides = Ride.order('rides.datetime ASC').limit(50)
    end
  end
  
  def make_date
    Date.civil(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
  end

  def show
    @title = "#{@ride.origin} to #{@ride.destination}"
  end
  
  def new
    @ride = Ride.new
    @ride.origin = get_user_ip.city
    @ride.originstate = get_user_ip.state_code
    @ride.destinationstate = get_user_ip.state_code
    @ride.datetime = Date.tomorrow + 9.hours
  end
  
  def get_user_ip
    request.location
  end
  
  
  def get_ride
    @ride = Ride.find(params[:id])
  end
  
  def find
    # @rides = Ride.where(:origin => "Chicago").paginate(:page => params[:page], :per_page => 5)
  end
  
  def edit
    @ride = Ride.find(params[:id])
    #@ride = current_user.rides.build(params[:ride])
    #if @ride.save
    #  flash[:success] = "Ride created!"
    #else
    #  render 'edit'
    #end
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