require 'bcrypt'
require_relative 'helpers.rb'

email = "adrian@gmail.com"
password = "crudapp"
first_name = "adrian"
last_name = "marotta"

password_digest = BCrypt::Password.create(password)

sql = "INSERT INTO users (email, password_digest, first_name, last_name) VALUES ('#{email}', '#{password_digest}', '#{first_name}', '#{last_name}')"

run_sql(sql)