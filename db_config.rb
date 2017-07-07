require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'test_project2'
}

ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)
