class Company < ActiveRecord::Base
  
  
  attr_accessible :address, :business_type, :contact_number, :db_name, 
                  :description, :name, :no_of_employees, :stock_symbol, 
                  :users_attributes, :admin_attributes
  
  
  # => validations
  validates :address, :business_type, :contact_number, :db_name, :description, :name, :no_of_employees, :stock_symbol, :presence => true

  validates :contact_number, :numericality => true, :unless => lambda{|c| c.contact_number.blank?}
  
  
  # => Associations
  
  has_many :users
  has_one :admin, :class_name => 'User'
  
  accepts_nested_attributes_for :users
  accepts_nested_attributes_for :admin
  
  before_validation(:on => :create) do
    self.admin.role =  User::ROLES['admin']
  end
  
end
