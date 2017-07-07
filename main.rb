
require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'

require_relative 'db_config'
require_relative 'models/user'
require_relative 'models/review'
require_relative 'models/event'
require_relative 'models/event_type'


def run_sql(sql)
  db = PG.connect(dbname: 'test_project2')
  result = db.exec(sql)
  db.close
  return result
end

def current_user
  current user = User.find_by(id: session[:user_id])
end

helpers do
  def logged_in?
    if current_user
      true
    else
      false
    end
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
end

enable :sessions

get '/login' do
  erb :login
end

post '/session' do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/'
  else
    erb :login
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/'
end

get '/' do
  erb :index
end

get '/create_profile' do
  erb :create_profile
end

# create new profile
post '/create_profile' do
  user = User.new
  user.email = params[:email]
  user.username = params[:username]
  user.password = params[:password]
  if params[:profile_image] == ' '
    user.profile_image = params[:profile_image]
  else
    user.profile_image = "http://www.freeiconspng.com/uploads/profile-icon-9.png"
  end
  user.age = params[:age]
  if params[:location] == "SELECT location FROM cities"
    cities.location = "SELECT id FROM cities WHERE location = #{params[:location]}"
  else
    cities.location = params[:location]
    user.location = "SELECT id FROM cities WHERE location = #{params[:location]}"
  end
  if user.save
    erb :login
  else
    erb :index
  end
end

get '/profile' do
  # sql = "SELECT * FROM users WHERE id = #{params[:id]}"
  @user = User.find_by(email: params[:email])
  erb :profile
end

get '/profile/:id' do
  user = User.find(params[:id])
  erb :profile
end

# edit profile
patch '/profile/:id/edit' do
  user = User.find(params[:id])
  user.email = params[:email]
  user.username = params[:username]
  user.password = params[:password]
  user.profile_image = params[:profile_image]
  user.age = params[:age]
  if params[:location] == "SELECT location FROM cities"
    cities.location = "SELECT id FROM cities WHERE location = #{params[:location]}"
  else
    cities.location = params[:location]
    user.location = "SELECT id FROM cities WHERE location = #{params[:location]}"
  end
  if event.save
    redirect "/profile/#{params[:id]}"
  else
    erb :profile
  end
end

# delete profile
delete '/profile/:id' do
  user = User.find(params[:id])
  user.destory
  erb :index
end

get '/' do
  erb :index
end

get '/local_guide' do
  # @users = run_sql("SELECT * FROM users;")
  erb :local_guide
end

# search for local guide using location
post '/location_search' do
  sql = "SELECT * FROM users WHERE location = '#{params[:user_search]}'"
  @users_search = run_sql(sql)
  sql1 = "SELECT * FROM events WHERE location = '#{params[:user_search]}'"
  @event_search = run_sql(sql1)
  erb :location_search
end

# post '/search_for_user' do
#   sql = "SELECT * FROM users WHERE username = '#{params[:user_search]}'"
#   @users_search = run_sql(sql)
#   erb :location_search
# end

get '/events' do
  @events = Event.all
  erb :events
end

get '/events/:id' do
  @event = Event.find(params[:id])
  # @user =
  @event_type = EventType.all
  # @comment = Comment.where(event_id: params[:id])
  erb :event_details
end

# get '/event_details' do
#   erb :event_details
# end

get '/create_event' do
  @event_type = EventType.all
  erb :new_event
end

post '/create_event' do
  event = Event.new
  event.name = params[:name]
  event.image_url = params[:image_url]
  event.event_type_id = params[:event_type_id]
  event.highlights = params[:highlights]
  event.description = params[:description]
  event.location = params[:location]
  if event.save
    redirect "/events/#{ params[:event_id]}"
  else
    erb :events
  end
end

get '/events/:id/edit' do
  @event = Event.find(params[:id])
  @event_types = EventType.all
end

patch '/events/:id' do
  event = Event.find(params[:id])
  event.name = params[:name]
  event.image_url = params[:image_url]
  event.event_type_id = params[:event_type_id]
  event.highlights = params[:highlights]
  event.description = params[:description]
  event.location = params[:location]
  if event.save
    redirect "events/#{params[:event_id]}"
  else
    erb :index
  end
end

delete '/events/:id' do
  event = Event.find(params[:id])
  event.destroy
  erb :index
end

# post '/comments' do
#   redirect '/login' if !logged_in?
#   comment = Comment.new
#   comment.event_id = params[:event_id]
#   comment.description = params[:description]
#   comment.save
#   redirect "/events/#{ params[:event_id]}"
# end
