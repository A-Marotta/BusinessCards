require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'bcrypt'
require_relative 'db/helpers.rb'

enable :sessions

def current_user
  sql = ("SELECT * FROM users WHERE id = $1")
  run_sql(sql, [session[:user_id]])[0]
end

def logged_in?
  !!session[:user_id]
end

get '/' do


  erb :index
end

get '/login' do

  erb :login
end

post '/session' do
  sql = ("SELECT * FROM users WHERE email = $1")
  users = run_sql(sql, [params["email"]])

  if users.count > 0 && BCrypt::Password.new(users[0]['password_digest']) == params["password"]
    session[:user_id] = users[0]["id"]
    redirect '/'
  else
    erb :login
  end
end

delete '/session' do
  session[:user_id] = nil

  redirect '/'
end


