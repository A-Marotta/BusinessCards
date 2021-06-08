require_relative 'helpers.rb'

email = "adrian.pro@gmail.com"
full_name = "Adrian Marotta"
logo = "http://pngimg.com/uploads/google/google_PNG19635.png"
mobile = '+61418249781'
website = "https://www.adrian.dev.com/"
business_address = "VIC"

sql = "INSERT INTO card_info (users_id, email, full_name, logo, mobile, website, business_address) VALUES ('1', '#{email}', '#{full_name}', '#{logo}', #{mobile}, '#{website}', '#{business_address}')"

run_sql(sql)