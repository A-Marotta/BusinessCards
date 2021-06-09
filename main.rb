require 'cloudinary'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'bcrypt'
require 'httparty'

require_relative 'db/helpers.rb'

captcha_secret = ENV['GOOGLE_CAPTCHA_SECRET']
captcha_site = ENV['GOOGLE_CAPTCHA_SITE']
cloudinary_key = ENV['CLOUDINARY_KEY']
cloudinary_secret = ENV['CLOUDINARY_SECRET']
cloudinary_name = ENV['CLOUDINARY_NAME']

options = {
  cloud_name: cloudinary_name,
  api_key: cloudinary_key,
  api_secret: cloudinary_secret
}

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

def check_email_not_exists?(email)
  sql = "SELECT * FROM users WHERE email = $1"
  res = run_sql(sql, [email])

  if res.to_a.length == 0
    true
  else
    false
  end
end

def create_qr_code
  sql = "SELECT last_value FROM card_info_id_seq;"
  id = run_sql(sql)
  id = id[0]["last_value"].to_i

  qr_code = "https://api.qrserver.com/v1/create-qr-code/?data=http://localhost:4567/cards/#{id}"

  return [qr_code, id]
end

get '/' do
  cards = run_sql("SELECT * FROM card_info;")

  erb :index, :layout => false, locals: { cards:cards } 
end

get '/login' do

  erb :login, :layout => false
end

post '/session' do
  sql = ("SELECT * FROM users WHERE email = $1")
  users = run_sql(sql, [params["email"]])

  if users.count > 0 && BCrypt::Password.new(users[0]['password_digest']) == params["password"]
    session[:user_id] = users[0]["id"]
    redirect '/'
  else
    redirect '/login'
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

  if params['card_logo'] != nil
    res = Cloudinary::Uploader.upload(params['card_logo']['tempfile'], options)
    url = res["url"]
  else 
    url = ''
  end
  
  sql = "INSERT INTO card_info (users_id, email, full_name, logo, mobile, website, business_address) values ($1, $2, $3, $4, $5, $6, $7);"

  run_sql(sql, [
    current_user()['id'],
    params["card_email"],
    params["card_fullname"],
    url,
    params["card_mobile"],
    params["card_website"],
    params["card_address"]
  ])

  qr = create_qr_code
  sql_qr_insert = "UPDATE card_info SET qr_code = '#{qr[0]}' WHERE id = $1"
  run_sql(sql_qr_insert, [qr[1]])
  
  redirect '/cards'
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

  redirect '/cards'
end

get '/cards/:id/edit' do
  sql = "SELECT * FROM card_info WHERE id = $1"
  cards = run_sql(sql, [params["id"]])
  card = cards[0]

  erb :edit_card_form, locals: { card:card }
end

put '/cards/:id' do

  if params['card_logo'] != nil
    res = Cloudinary::Uploader.upload(params['card_logo']['tempfile'], options)
    url = res["url"]
  else 
    url = ''
  end

  sql = ("UPDATE card_info SET email = $1, full_name = $2, logo = $3, mobile = $4, website = $5, business_address = $6 WHERE id = $7;")

  run_sql(sql, [
    params['card_email'], 
    params['card_fullname'],
    url, 
    params['card_mobile'],
    params['card_website'],
    params['card_business_address'],
    params['id']
  ])

  redirect "/cards/#{params["id"]}"
end

get '/saved_cards' do

  saved_cards = run_sql("SELECT saved_cards FROM users WHERE id = #{current_user()['id']}")
  saved_cards = saved_cards.to_a
  saved_cards = saved_cards[0]["saved_cards"]

  if saved_cards.to_s.length > 0
    results = run_sql("SELECT * FROM card_info WHERE id = ANY('#{saved_cards}'::int[]);")
    results = results.to_a
    erb :saved_cards, locals: { results:results }
  else
    erb :no_saved_cards
  end
end

put '/cards/:id/save' do
  sql = ("UPDATE users SET saved_cards = array_append(saved_cards, $1) WHERE id = #{current_user()['id']};")

  run_sql(sql, [params['id']])

  redirect "/saved_cards"
end

get '/sign_up' do

  erb :sign_up_form, :layout => false, locals: { captcha_site:captcha_site }
end

post '/sign_up' do
  captcha_response = params["g-recaptcha-response"]
  google_response = HTTParty.post("https://www.google.com/recaptcha/api/siteverify?secret=#{captcha_secret}&response=#{captcha_response}")

  if google_response["success"] && check_email_not_exists?(params["email"])
    password_digest = BCrypt::Password.create(params["password"])

    sql = "INSERT INTO users (email, password_digest, first_name, last_name) VALUES ($1, $2, $3, $4)"

    run_sql(sql, [
      params["email"],
      password_digest,
      params["first_name"],
      params["last_name"]
    ])

    redirect '/'
  else
    redirect '/sign_up'
  end
end 

get '/search' do

  erb :search
end

get '/list_cards' do
  sql = "SELECT * FROM card_info WHERE full_name ILIKE $1"
  name = params["search-name"] += '%'
  cards = run_sql(sql, [name])

  erb :card_list, locals: { cards:cards }
end