class Company < ActiveRecord::Base

  
  restore_establish_connection()
  
  attr_accessible :address, :business_type, :contact_number, :db_name, 
                  :description, :name, :no_of_employees, :stock_symbol, 
                  :users_attributes, :admin_attributes
  
  
  # => Validations
  
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
  
  ##before_create :create_database_of_company##

  #after_create :insert_admin_into_company_database  
  
  
  def save_with_backend_infrastructure
    if valid?
     create_status = transaction do 
          create_database_of_company && save && create_tables && insert_admin_into_company_database 
      end 
     return create_status
    else
      return false
    end  
  end



 #protected
   
  def create_database_of_company
    database_name = self.db_name
    logger.info("\n\n==> CREATING DATABASE FOR #{ name }============ ")
    ActiveRecord::Base.connection.create_database(database_name, mysql_config)
    return true
  rescue ActiveRecord::StatementInvalid => ex
    logger.error("ERROR: ActiveRecord::StatementInvalid DATABASE COULD NOT BE CREATED BECAUSE #{ ex.message }\n\n")
     if ex.message.match(/database exists/)
       self.errors.add(:base, 'Database already exists') 
     end
    return false
  rescue  Mysql2::Error => ex
     logger.error("ERROR: Mysql::Error DATABASE COULD NOT BE CREATED BECAUSE #{ ex.message }\n\n")
     return false
   rescue => ex
     logger.error("ERROR: DATABASE COULD NOT BE CREATED BECAUSE #{ ex.message }\n\n")
     return false
  end
    
  def create_tables
    begin
    settings = config_settings
    settings['database'] = self.db_name
    conn = ActiveRecord::Base.establish_connection(settings)
    logger.info "==============================================================="
    logger.info "=> Connection to #{ settings['database'] } has been established"
    logger.info "==============================================================="
    
    transaction do
      
      logger.info "============================================================="
      logger.info " CREATING contacts table "
      logger.info "============================================================="
      
      ## =>  CONTACTS TABLE
      conn.connection.create_table :contacts do |t|
        t.string   :first_name, :null => false
        t.string   :middle_name
        t.string   :last_name
        t.string   :email,      :null => false
        t.string   :mobile
        t.string   :landline
        t.string   :mailing_address, :null => false
        t.string   :billing_address
        t.integer  :customer_company_id
        t.integer  :change_id
        t.timestamps
      end 
      
      
      logger.info "============================================================="
      logger.info " CREATING employees table "
      logger.info "============================================================="

      ## =>  EMPLOYEES TABLE
      conn.connection.create_table :employees do |t|
        t.integer :status,     :null => false, :default => false 
        t.string  :username,   :null => false
        t.string  :crypted_password, :null => false
        t.string  :salt, :null => false   
        t.string  :first_name
        t.string  :last_name
        t.string  :email, :null => false
        t.integer :role
        t.string  :address, :limit => 255
        t.string  :mobile_no,  :limit => 20
        t.string  :device_info,  :limit => 100
        t.decimal :cost
        t.integer :change_id     
        t.timestamps
      end

    end
    conn.connection.close()
    restore_establish_connection()
    return true
   rescue => e
     logger.info "==============================================="
     logger.info           e.message
     logger.info "================================================"
     conn.connection.close()
     restore_establish_connection()
     return false
   end
  end

  def insert_admin_into_company_database
   created = Employee.create(self.db_name, self.admin)
   return created  
  end
  
  
  
  
  private
  
  def mysql_config
    @charset   = ENV['CHARSET']   || 'utf8'
    @collation = ENV['COLLATION'] || 'utf8_unicode_ci'
    {:charset =>  @charset, :collation => @collation, :adaptor => 'mysql2' }
  end
    
    
end
