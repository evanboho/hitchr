class RidesController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :destroy]
  before_filter :get_ride, :only => [:show, :update]
  
  def index
      @start_date = make_date
      unless params[:search_city].blank?
        search_start = params[:search_city] 
        if params[:miles_radius].to_i > 0
          @rides = Ride.search_near(search_start, params[:miles_radius])
        else
          @rides = Ride.city_state_search(search_start)
        end
        unless params[:search_dest].blank?
          search_bearing = Geocoder::Calculations.bearing_between(search_start, params[:search_dest])
          @rides = @rides.scoped( :conditions => { :bearing => (search_bearing - 35)..(search_bearing + 35) } )
        end
      else 
        if !params[:search_dest].blank?
          flash[:notice] = "Please enter a start city."
        end
      end
      @rides ||= Ride.scoped
      @rides = @rides.scoped( :conditions => { :datetime => @start_date..@start_date + 14 } ) 
      @rides = @rides.reorder('rides.datetime ASC')
      if @rides.blank?
        flash[:notice] = "No rides matched your results. Try increasing the search radius."
      end
    # else 
      # user_loc = request.
      # @rides = Ride.scoped( :conditions => 
      # @rides = Ride.order('rides.datetime ASC').limit(50)
  end
  
  def make_date
    unless params[:date].nil?
      Date.civil(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
    else
      Date.today
    end
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