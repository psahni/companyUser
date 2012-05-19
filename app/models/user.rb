class User < ActiveRecord::Base
  authenticates_with_sorcery!
 
  attr_accessor :user_role
  attr_accessible :company_id, :first_name, :last_name, :email, :username, :user_role
  
  # => Validations
  #---------------------------------------  
  validates_length_of :password, 
                      :minimum => 3, 
                      :message => "password must be at least 3 characters long", 
                      :if => :password
                      
  validates_confirmation_of :password, 
                            :message => "should match confirmation", 
                            :if => :password


  validates :first_name,:last_name, :username, :email, :user_role, :presence => true

  # => Associations
  #---------------------------------------
  
  belongs_to :company
  
  # => Callbacks
  #----------------------------------------
  
  before_validation(:on => :create) do
    self.password = self.password_confirmation = 'passw0rd'
  end

  # => ROLES
  #----------------------------------------
  ROLES = { 'superuser' => -1,  'worker' => 0 , 'manager' => 1, 'admin' => 2 }

  DISPLAY_ROLES = { 1 => 'Manager', 0 => 'Worker' }


  def superuser?
    self.role == ROLES['superuser']
  end
  
  
  def admin?
    self.role == ROLES['admin']  
  end 
  
  def full_name
    first_name + " " + last_name
  end
   
   def save_with_role
     self.role = self.user_role
     save
   end
   
end
