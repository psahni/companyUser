class User < ActiveRecord::Base
  authenticates_with_sorcery!
 

  attr_accessible :company_id, :first_name, :last_name, :email, :username
  
  # => Validations
  #---------------------------------------  
  validates_length_of :password, 
                      :minimum => 3, 
                      :message => "password must be at least 3 characters long", 
                      :if => :password
                      
  validates_confirmation_of :password, 
                            :message => "should match confirmation", 
                            :if => :password


  validates :first_name,:last_name, :username, :email,  :presence => true

  # => Associations
  #---------------------------------------
  
  belongs_to :company_id
  
  # => Callbacks
  #----------------------------------------
  
  before_validation do
    self.password = self.password_confirmation = 'passw0rd'
  end

  # => ROLES
  #----------------------------------------
  ROLES = { 'superuser' => -1,  'worker' => 0 , 'manager' => 1, 'admin' => 2 }



  def superuser?
    self.role == ROLES['superuser']
  end
  
  def full_name
    first_name + " " + last_name
  end
  
end
