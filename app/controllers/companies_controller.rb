class CompaniesController < ApplicationController
  
  
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
  
end
