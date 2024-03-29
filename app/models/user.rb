class User < ActiveRecord::Base

  authenticates_with_sorcery!
  restore_establish_connection()
   
  attr_accessor :user_role, :skip_role
  attr_accessible :company_id, :first_name, :last_name, :email, :username, :user_role, :address, :mobile_no, :device_info, :last_login, :srv_nounce, :skip_role
  
  # => Validations
  #---------------------------------------  
  validates_length_of :password, 
                      :minimum => 4, 
                      :message => "password must be at least 4 characters long", 
                      :if => :password
                      
  validates_confirmation_of :password, 
                            :message => "should match confirmation", 
                            :if => :password


  validates :first_name,:last_name, :username, :email , :presence => true
  
  validates :address, :mobile_no, :device_info, :presence => true, :unless => lambda{|u| ( u.admin? || u.superuser? )}
  
  validates :user_role, :presence => true, 
                        :unless => lambda{|u| u.skip_role == true }
  
  
  validates :email, :format => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    :unless => lambda{ |u| u.email.blank? }
  
  validates :email, :uniqueness => true,
                    :unless => lambda{ |u| u.email.blank? }
                    
  validates :username, :uniqueness => true,
                       :unless => lambda{ |u| u.username.blank? }                    

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
   
   def save_with_role_and_mapping
     self.role = self.user_role
     save && map_user_into_company_database 
   end

  def password_encryption
    encrypt_password
  end   
  
  def already_logged_in?
    last_login >= ( Time.now - 2.hours )   
  end
  
  def map_user_into_company_database
    restore_establish_connection()
    Employee.create(self.company.db_name, self)
  end
  
end
