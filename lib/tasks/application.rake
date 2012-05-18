namespace :db do

  desc 'CREATE SUPER USER'

  task :superuser => :environment  do
    puts "=> creating super user"
    user = User.new
    user.first_name = "superuser"
    user.last_name = "website"
    user.username = "superuser"
    user.role = -1
    user.email = 'super@user.com'
    user.password = user.password_confirmation = 'superpass'
    
    if user.save
      puts "super user has been successfully created"
    end
  end
  
  
end