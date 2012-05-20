namespace :db do

  desc 'CREATE SUPER USER'

  task :superuser => :environment  do
    if User.find_by_first_name('superuser')
      puts "Super user has already been created"
      exit(0)
    end
    puts "=> creating super user"
    user = User.new
    user.first_name = "superuser"
    user.last_name = "website"
    user.username = "superuser"
    user.role = -1
    user.email = 'super@user.com'
    user.password = user.password_confirmation = 'superpass'
    user.save(:validate => false)
    puts "super user has been successfully created"
    puts "Password: superpass"
  end
  
end