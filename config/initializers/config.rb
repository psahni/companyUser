def restore_establish_connection()
    ActiveRecord::Base.remove_connection
    settings = YAML::load(File.open( File.join(Rails.root, 'config', 'database.yml')))[Rails.env]
    ActiveRecord::Base.establish_connection(settings)
end

def config_settings
  settings =  YAML::load(File.open( File.join(Rails.root, 'config', 'config.yml')))
end

