require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'bcrypt'
require_relative 'db/helpers.rb'

enable :sessions

def current_user
  if session[:user_id] == nil 
    return {}
  end

  sql = ("SELECT * FROM users WHERE id = $1")
  run_sql(sql, [session[:user_id]])[0]
end

def logged_in?
  !!session[:user_id]
end

def saved_cards?
  if session[:user_id] == nil 
    return {}
  end

  sql = ("SELECT saved_cards FROM users WHERE id = $1")
  run_sql(sql, [session[:user_id]])[0] 
end

get '/' do
  cards = run_sql("SELECT * FROM card_info;")

  erb :index, locals: { cards:cards }
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

get '/cards' do
  cards = run_sql("SELECT * FROM card_info WHERE users_id = #{session[:user_id].to_i}")

  erb :cards, locals: { cards:cards }
end

get '/cards/new' do

  erb :new_card_form
end

post '/cards' do
  redirect '/login' unless logged_in?

  sql = "INSERT INTO card_info (users_id, email, full_name, logo, mobile, website, business_address) values ($1, $2, $3, $4, $5, $6, $7);"

  run_sql(sql, [
    current_user()['id'],
    params["card_email"],
    params["card_fullname"],
    params["card_logo"],
    params["card_mobile"],
    params["card_website"],
    params["card_address"]
  ])

  

  redirect '/'
end

get '/cards/:id' do
  sql = "SELECT * FROM card_info WHERE id = $1;"
  
  res = run_sql(sql, [
    params['id']
  ])
  
  card = res[0]

  erb :show_card, locals: { card: card }
end

delete '/cards/:id' do
  redirect '/login' if !logged_in? 

  sql = "DELETE FROM card_info WHERE id = $1;"
  run_sql(sql, [params["id"]])

  redirect '/'
end

get '/cards/:id/edit' do
  sql = "SELECT * FROM card_info WHERE id = $1"
  cards = run_sql(sql, [params["id"]])
  card = cards[0]

  erb :edit_card_form, locals: { card:card }
end

put '/cards/:id' do
  sql = ("UPDATE card_info SET email = $1, logo = $2 WHERE id = $3;")

  run_sql(sql, [
    params['email'], 
    params['logo'], 
    params['id']
  ])

  redirect "/cards/#{params["id"]}"
end

get '/saved_cards' do

  saved_cards = run_sql("SELECT saved_cards FROM users WHERE id = #{current_user()['id']}")
  saved_cards = saved_cards.to_a
  saved_cards = saved_cards[0]["saved_cards"]

  results = run_sql("SELECT * FROM card_info WHERE id = ANY('#{saved_cards}'::int[]);")
  results = results.to_a
  erb :saved_cards, locals: { results:results }
end

put '/cards/:id/save' do
  sql = ("UPDATE users SET saved_cards = array_append(saved_cards, $1) WHERE id = #{current_user()['id']};")

  run_sql(sql, [params['id']])

  redirect "/saved_cards"
end