class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :signed_in_users, :only => [:new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  
  def index
    @users = User.paginate(:page => params[:page])
  end
  
  def show 
    @user = User.find(params[:id])
    @title = @user.name
    @rides = @user.rides.paginate(:page => params[:page])
  end
  
  def new
    # @title = "Sign up"
    @user = User.new
    @user.password = nil
  end
  
  def edit
    # @user = User.find(params[:id])
    # @title = "Edit"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "welcome to hitchr!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
      # @user.password = :password
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end
    
  
  private
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
      redirect_to(home_path) if User.find(params[:id]) == current_user
    end
    
    def signed_in_users
      redirect_to(root_path) if signed_in?
    end
end
