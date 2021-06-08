require 'bcrypt'
require_relative 'helpers.rb'

users_input = {
    users: [
        {
            email: "adrian@gmail.com",
            password: "adriancrud",
            first_name: "adrian",
            last_name: "marotta"
        },
        {
            email: "john@gmail.com",
            password: "johncrud",
            first_name: "john",
            last_name: "doge"
        },        
        {
            email: "elon@gmail.com",
            password: "eloncrud",
            first_name: "elon",
            last_name: "musk"
        }
    ]
}

password_digest = BCrypt::Password.create(users_input[:users][0][:password])
password_digest1 = BCrypt::Password.create(users_input[:users][1][:password])
password_digest2 = BCrypt::Password.create(users_input[:users][2][:password])

sql = "INSERT INTO users (email, password_digest, first_name, last_name) VALUES (
    '#{users_input[:users][0][:email]}', 
    '#{password_digest}', 
    '#{users_input[:users][0][:first_name]}', 
    '#{users_input[:users][0][:last_name]}')
"

sql1 = "INSERT INTO users (email, password_digest, first_name, last_name) VALUES (
    '#{users_input[:users][1][:email]}', 
    '#{password_digest1}', 
    '#{users_input[:users][1][:first_name]}', 
    '#{users_input[:users][1][:last_name]}')
"

sql2 = "INSERT INTO users (email, password_digest, first_name, last_name) VALUES (
    '#{users_input[:users][2][:email]}', 
    '#{password_digest2}', 
    '#{users_input[:users][2][:first_name]}', 
    '#{users_input[:users][2][:last_name]}')
"

run_sql(sql)
run_sql(sql1)
run_sql(sql2)