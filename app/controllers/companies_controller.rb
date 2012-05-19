class CompaniesController < ApplicationController

  before_filter :require_superuser_login
  before_filter :company, :except => [:index, :new, :create]  
  
  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
    @admin  = @company.build_admin
  end
  
  def create
    @company = Company.new(params[:company]) 
    if @company.save
      redirect_to companies_path
    else
      render 'new'
    end
  end

  def edit
  end 
  
  def update
    if @company.update_attributes(params[:company])
      redirect_to companies_path, :notice => "Updated successfully"
    end    
  end
   
  
  def destroy
    @company.destroy
    redirect_to companies_path, :notice => "Deleted successfully"
  end
  
  private
  
  def company
    @company =  Company.find(params[:id])
  rescue
    (redirect_to companies_url, :alert => "Invalid url")
  end 
  
end
