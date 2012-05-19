class ApplicationController < ActionController::Base

  protect_from_forgery




  
  protected

  def require_superuser_login
    require_login
    if current_user && !current_user.superuser?
      render :file => 'public/404.html'
    end
  end

#--------------------------------------------------------------------------------------------------

  def require_company_admin_login
    require_login
    if current_user && ( current_user.superuser? || current_user.admin? )
      return 
    else
     render :file => 'public/404.html'
    end
  end

#--------------------------------------------------------------------------------------------------
  
  def not_authenticated
    redirect_to root_path, :alert => "Please login first."
  end

#--------------------------------------------------------------------------------------------------
  
  
  helper_method :current_company, :current_company_user?
  
  def current_company
    current_user.company  
  end
  
  
  def current_company_user?
    @user && ( @user.company == current_company )
  end
  

end
