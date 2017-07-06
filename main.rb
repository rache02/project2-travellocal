
require 'sinatra'
# require 'sinatra/reloader'
require 'pry'
require 'PG'

require_relative 'db_config'
require_relative 'models/user'
# require_relative 'models/review'
require_relative 'models/event'
require_relative 'models/event_type'
# require_relative 'models/comment'
# require_relative 'models/event_participant'

def run_sql(sql)
  db = PG.connect(dbname: 'test_project2')
  result = db.exec(sql)
  db.close
  return result
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

get '/profile' do
  # sql = "SELECT * FROM users WHERE id = #{params[:id]}"
  @user = User.find(1)
  erb :profile
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
  user.profile_image = params[:profile_image]
  user.age = params[:age]
  user.location = params[:location]
  if user.save
    erb :login
  else
    erb :index
  end
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
  user.location = params [:location]
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
  @events = Event.all
  erb :index
end

get '/events' do
  erb :event_details
end

get '/events/new' do
  @event_type = EventType.all
  erb :new_event
end

post '/events' do
  event = Event.new
  event.name = params[:name]
  event.image_url = params[:image_url]
  event.event_type_id = params[:event_type_id]
  event.highlights = params[:highlights]
  event.description = params[:description]
  if event.save
    redirect "/events/#{ params[:event_id]}"
  else
    erb :new_event
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

get '/events/:id' do
  @event = Event.find(params[:id])
  # @user =
  @event_type = EventType.all
  # @comment = Comment.where(event_id: params[:id])
  erb :event_details
end

post '/comments' do
  redirect '/login' if !logged_in?
  comment = Comment.new
  comment.event_id = params[:event_id]
  comment.description = params[:description]
  comment.save
  redirect "/events/#{ params[:event_id]}"
end
