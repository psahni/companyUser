class AddNeededFieldsIntoUser < ActiveRecord::Migration
  def up
    add_column :users, :address,     :text, :limit => 150
    add_column :users, :mobile_no,   :string, :limit => 10
    add_column :users, :device_info, :string
    add_column :users, :srv_nounce,  :string
    add_column :users, :last_login,  :datetime 
  end

  def down
    remove_column :users, :address
    remove_column :users, :mobile_no
    remove_column :users, :device_info
    remove_column :users, :srv_nounce
    remove_column :users, :last_login
  end
end
