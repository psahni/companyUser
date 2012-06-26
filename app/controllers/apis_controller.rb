class InvalidParams < StandardError
end

class ApisController < ApplicationController

  #-------------------------------------------------------------------------------------
  # => Example of curl request
  #  curl -d "username=psahni&password=pass13" http://localhost:3344/apis/login
  #-------------------------------------------------------------------------------------
    
  def login
    @user = User.authenticate(params[:username], params[:password])
    if @user && @user.already_logged_in?
     return render :json => { :status => :ok, :message => 'Already authenticated', :success => false, :srv_nounce => @user.srv_nounce, :salt => @user.salt }
    else
    if @user && @user.update_attributes({ last_login: Time.now, srv_nounce: SecureRandom.hex(10), skip_role: true })
       render :json => { :status => :ok, :message => "Authenticated", :success => true, :srv_nounce => @user.srv_nounce, :salt => @user.salt }
     else
      render :json => { :status => :error, :message => 'Not Authenticated', :success => false }
     end    
   end 
   rescue => e
     logger.error( "==> ERROR: " + e.message )
     return render :json => { :status => 500, :success => false }
  end
  
  #----------------------------------------------------------------------
  # => Test request 
  ## md5( crypted_password + srv_nounce + client_nounce )
  # => Example of curl request
  # curl -d "digest=605484384eac70fb97a3cd1d591c9ceb&client_nounce=abcd1234&username=psahni" http://localhost:3344/apis/get_contacts
  #----------------------------------------------------------------------
  
  
  def get_contacts
    validate_params
    find_user 
    server_side_digest = digest_of(User.last.crypted_password + User.last.srv_nounce, params[:client_nounce])
    if server_side_digest.eql?(params[:digest])
      render :json => { :status => :ok, :success => true, :message => 'Valid Request' }
    else
      render :json => { :status => :error, :success => true, :message => 'Invalid Request' }
    end   
    rescue InvalidParams => e
      logger.error( "==> ERROR: " + e.message )
      render :json => { :status => 500, :success => false, :message => e.message }
    rescue => e
     logger.error( "==> ERROR: " + e.message )
     render :json => { :status => 500, :success => false }
  end
  
#--------------------------------------------------------------------------------------------------
  
  private
  
  def validate_params
    raise ArgumentError, "Invalid Arguments" if ( params[:digest].blank? || params[:client_nounce].blank? || params[:username].blank? )
  end
  
  def find_user
    @user = User.find_by_username(params[:username])
    raise InvalidParams, 'Invalid Params' unless @user
    @user
  end
  
  def digest_of(*arguments)
    args = arguments.join('')
    Digest::MD5.hexdigest(args)
  end
  
end
