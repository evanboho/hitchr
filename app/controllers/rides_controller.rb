require 'pp'
class RidesController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :destroy]
  before_filter :get_ride, :only => [:show, :update]
  
  def index
    if params[:start_date].present?
      @start_date = make_date
      criteria = {}
      criteria[:start_date] = @start_date
      criteria[:miles_radius] = params[:miles_radius]
      if params[:search_origin].present?      
        criteria[:origin_city] = get_city(params[:search_origin])
        criteria[:origin_state] = get_state(params[:search_origin])
      end
      if params[:search_dest].present?
        criteria[:dest_city] = get_city(params[:search_dest])
        criteria[:dest_state] = get_state(params[:search_dest])
      end
      @rides = Ride.search(criteria)     
      if @rides.blank?
        flash.now[:notice] = "No rides matched your results. Try increasing the search radius."
      end
    else 
      @rides = Ride.where("datetime > ?", Date.today)
      @rides = @rides.reorder('datetime ASC')
    end
    if @flash_expand == true
      flash.now[:notice] = "No starting cities matched your search. We expanded the radius to 25 miles around."
    end
  end
  
    # unless params[:search_city].blank?
    #   if params[:miles_radius].to_i > 0
    #     @rides = Ride.search_near(search_start, params[:miles_radius])
    #   else
    #     @rides = Ride.city_state_search(search_start)
    #   end
    #   unless params[:search_dest].blank?
    #     search_bearing = Geocoder::Calculations.bearing_between(search_start, params[:search_dest])
    #     @rides = @rides.scoped( :conditions => { :bearing => (search_bearing - 35)..(search_bearing + 35) } )
    #   end
    # end
  
    # if !params[:search_dest].blank?
    #   flash[:notice] = "Please enter a start city."
    # end
  
    
  
  
  def make_date
    
    Date.civil(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
  end

  def show
  end
  
  def new
    @ride = Ride.new
    loc = get_user_ip
    @ride.origin = loc.city
    @ride.originstate = loc.state_code
    @ride.destinationstate = loc.state_code
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

  def get_city(input_string)
    input_string.split(',')[0].strip.titleize
  end
  
  def get_state(input_string)
    split_result = input_string.split(',')
    split_result.length > 1 ? split_result[1].strip.upcase : nil
  end
  
end