require 'pry'
require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'test_project2'
}

ActiveRecord::Base.establish_connection(options)

require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/review'
require_relative 'models/event'
require_relative 'models/event_type'

# binding.pry
