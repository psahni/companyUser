class Company < ActiveRecord::Base
  
  
  attr_accessible :address, :business_type, :contact_number, :db_name, 
                  :description, :name, :no_of_employees, :stock_symbol, 
                  :users_attributes, :admin_attributes
  
  
  # => validations
  validates :address, :business_type, :contact_number, :db_name, :description, :name, :no_of_employees, :stock_symbol, :presence => true

  validates :contact_number, :numericality => true, :unless => lambda{|c| c.contact_number.blank?}
  
  validates :db_name, :uniqueness => true, :unless => lambda{|c| c.db_name.blank?}  
  
  # => Associations
  
  has_many :users, :conditions => ['users.role!=?', User::ROLES['admin']], :dependent => :destroy
  has_one :admin, :class_name => 'User', :dependent => :destroy
  
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :admin
  
  before_validation do
    self.admin.role =  self.admin.user_role = User::ROLES['admin'] if ( self.admin.role.blank? || self.admin.user_role.blank? )
  end
  
  before_create :create_database_of_company
  before_destroy :drop_database_of_company
  
  
  
  def create_database_of_company
    database_name = self.db_name
    logger.info("\n\n==> CREATING DATABASE FOR #{ name }============ ")
    ActiveRecord::Base.connection.create_database(database_name, mysql_config)
    rescue => ex
    logger.error("ERROR: DATABASE COULD NOT BE CREATED BECAUSE #{ ex.message }\n\n")
    return
  end
    
    
  def drop_database_of_company
    database_name = self.db_name
    logger.info("\n\n==> DROPPING DATABASE FOR #{ name }============ ")
    ActiveRecord::Base.connection.drop_database(database_name)
    rescue => ex
    logger.error("ERROR: DATABASE COULD NOT BE DROPPED BECAUSE #{ ex.message }\n\n")
    return
  end
    
  private
  
  def mysql_config
    @charset   = ENV['CHARSET']   || 'utf8'
    @collation = ENV['COLLATION'] || 'utf8_unicode_ci'
    {:charset =>  @charset, :collation => @collation, :adaptor => 'mysql2' }
  end
    
    
end
