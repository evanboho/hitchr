class ProfilesController < ApplicationController
 
  def index
  
  end

  def show
    Profile.find(params[:id]) 
  end
  
  def find
  end
  
  def new
    @profile = Profile.new
    @profile.birthday = 1980
  end
  
  def edit
    @profile = current_user.profile(params[:profile])
    if @profile.save      
      flash[:success] = "Profile updated!"
    else
      render 'edit'
    end
  end

  def update
    if current_user.profile.update_attributes(params[:profile])
      flash[:success] = "Success!"
      redirect_to current_user
    else
      render 'edit'
    end
  end
  
  
  def create
    @profile = Profile.create(params[:profile])
    # @profile.cred = 0
    @profile.user_id = current_user.id
    #@profile.birthday = params[:birthday]
    #@profile.user_id = current_user.id
    # @profile.birthday = params[:birthday]
    # @profile.sex = params[:sex]
    # @profile.user_id = current_user.id
    if @profile.save
      flash[:success] = "profile created!"
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end
  
  def destroy
    Profile.find(params[:id]).destroy
    flash[:success] = "Profile deleted"
    redirect_to current_user
  end

  
end