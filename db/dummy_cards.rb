require_relative 'helpers.rb'

email = "adrian@gmail.com"
full_name = "adrian marotta"
logo = "http://pngimg.com/uploads/google/google_PNG19635.png"
mobile = '+61418249781'
website = "https://www.google.com/"
business_address = "48 Pirrama Rd, Pyrmont NSW 2009, Australia"

sql = "INSERT INTO card_info (users_id, email, full_name, logo, mobile, website, business_address) VALUES ('1', '#{email}', '#{full_name}', '#{logo}', #{mobile}, '#{website}', '#{business_address}')"

run_sql(sql)