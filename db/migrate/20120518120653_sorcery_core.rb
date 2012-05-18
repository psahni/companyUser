class SorceryCore < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name, :limit => 25,  :null => false
      t.string :last_name,  :limit => 25,  :null => false
      t.integer :role,  :null => false
      t.string :username,         :null => false                   # if you use another field as a username, for example email, you can safely remove this field.
      t.string :email,            :default => nil,  :null => false # if you use this field as a username, you might want to make it :null => false.
      t.string :crypted_password, :default => nil,  :null => false
      t.string :salt            , :default => nil
      t.integer :company_id
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end