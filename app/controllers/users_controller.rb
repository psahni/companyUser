class UsersController < ApplicationController
  
  before_filter :require_company_admin_login
  before_filter :user, :only => [ :edit, :update, :destroy ]
  before_filter :verify_current_company_user, :only => [ :edit, :update, :destroy ]
  
  def index
    @users = current_company.users
  end
  
  
  def new
    @user  = current_company.users.build
  end

  
  def create
    @user = current_company.users.build(params[:user])
    if @user.valid? && @user.save_with_role_and_mapping
      redirect_to users_path, :notice => "User has been successfully created"
    else
      render 'new'
    end  
  end
  
  def edit
  end
    
    
  def update
    @user.attributes = params[:user]
    if @user.save_with_role
      redirect_to users_path, :notice => "User has been successfully updated"
    else
      render 'edit'
    end
  end
  
  
  def destroy
    @user.destroy 
    redirect_to users_path, :notice => "User has been deleted successfully"
  end
  
  private
  
  def user
    @user  = User.find(params[:id])
    rescue
      return redirect_to users_path, :alert => "User not found"  
  end
  
  def verify_current_company_user
    return redirect_to users_path, :alert => "User not found" unless current_company_user?
  end
  
end
