require 'pp'
class RidesController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :destroy]
  before_filter :get_ride, :only => [:show, :update]
  
  def home
    @rides = Ride.order('datetime ASC').limit(10)
  end
  
  def index
    @flash_expand = 0
    criteria = {}
    if params[:start_date].present?
      @start_date = make_date
      criteria[:start_date] = @start_date
      criteria[:miles_radius] = params[:miles_radius].to_i
    end
    if params[:search_dest].present?
      criteria[:dest_city] = get_city(params[:search_dest])
      criteria[:dest_state] = get_state(params[:search_dest])
    end
    if params[:search_origin].present?      
      criteria[:origin_city] = get_city(params[:search_origin])
      criteria[:origin_state] = get_state(params[:search_origin])
      # criteria[:miles_radius] ||= 0
    end
    criteria[:start_date] ||= Date.today
    @rides = Ride.search(criteria)
      if @rides.blank?
        flash.now[:notice] = "No rides matched your results. Try increasing the search radius."
      end
    @miles_radius = 10
    @rides = @rides.paginate(:page => params[:page], :per_page => 15).reorder('datetime ASC') if !@rides.empty?
  end
  
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