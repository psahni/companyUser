class ApisController < ApplicationController

  
  def login
    @user = User.authenticate(params[:username], params[:password])
    if @user && @user.already_logged_in?
     return render :json => { :status => :ok, :message => 'Already authentcated', :success => false, :srv_nounce => @user.srv_nounce }
    else
    if @user && @user.update_attributes({ last_login: Time.now, srv_nounce: SecureRandom.hex(10), skip_role: true })
       render :json => { :status => :ok, :message => "Authenticated", :success => true, :srv_nounce => @user.srv_nounce }
     else
      render :json => { :status => :error, :message => 'Not Authenticated', :success => false }
     end    
   end 
   rescue => e
     logger.error( e.message )
     return render :json => {:status => 500, :success => false}.to_json
  end
  
end
