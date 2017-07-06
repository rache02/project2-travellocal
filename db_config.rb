require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'travel_local'
}

ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)
