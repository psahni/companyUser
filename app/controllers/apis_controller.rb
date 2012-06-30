class InvalidParams < StandardError
end

class ApisController < ApplicationController

  #-------------------------------------------------------------------------------------
  # => Example of curl request
  #  curl -d "json="{\"username\":\"psahni\",\"password\":\"pass123\"}" " http://localhost:3344/apis/login
  #-------------------------------------------------------------------------------------
    
  def login
    user_params = JSON.parse(params[:json])
    @user = User.authenticate(user_params['username'], user_params['password'])
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
    server_side_digest = digest_of(@user.crypted_password, @user.srv_nounce, @user_params['client_nounce'])
    if server_side_digest.eql?(@user_params['digest'])
      render :json => { :status => :ok, :success => true, :message  => 'Valid Request...Lets move ahead' }
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
    @user_params = JSON.parse(params[:json])
    raise ArgumentError, "Invalid Arguments" if ( @user_params['digest'].blank? || @user_params['client_nounce'].blank? || @user_params['username'].blank? )
  end
  
  def find_user
    @user = User.find_by_username(@user_params['username'])
    raise InvalidParams, 'Invalid Data' unless @user
    @user
  end
  
  def digest_of(*arguments)
    args = arguments.join('')
    Digest::MD5.hexdigest(args)
  end
  
end
