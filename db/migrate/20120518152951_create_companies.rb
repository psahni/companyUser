class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :db_name
      t.text :address
      t.string :contact_number
      t.integer :no_of_employees
      t.string :stock_symbol
      t.text :description
      t.string :business_type

      t.timestamps
    end
  end
end
