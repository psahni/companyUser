class Employee

  
  def self.create(db_name, user)
    p user.inspect
    status = false
    settings = config_settings
    settings['database'] = db_name 
    conn = ActiveRecord::Base.establish_connection(settings)
    
    sql= <<-SQL
      INSERT INTO employees (first_name, last_name, role, username, email, crypted_password, salt, mobile_no, device_info, address, created_at, updated_at ) 
      values ( '#{ user.first_name}', '#{ user.last_name }', 
                #{ user.role }, '#{ user.username}' , '#{ user.email }',
                '#{ user.crypted_password }', '#{ user.salt }', '#{ user.mobile_no }',
                '#{ user.device_info }', '#{ user.address }', '#{ user.created_at }', '#{ user.updated_at}'   
             )
    SQL
    conn.connection.execute(sql)
    status = true
  rescue => e
    puts "==============================="
    puts    e.message
    puts "==============================="
    status = false
  ensure
    conn.connection.close();  
    restore_establish_connection();
    return status
  end
  
end