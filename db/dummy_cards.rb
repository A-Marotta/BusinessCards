require_relative 'helpers.rb'

emails = ["mhanoh@verizon.net", "aegreene@gmail.com", "ahuillet@aol.com", "ahuillet@aol.com", "skythe@me.com"]
names = ["Salvatore Frost", "Nia Bentley", "Fabian Webb", "Micaela Vincent", "Hannah Mathews"]
logos = ["https://www.causevox.com/wp-content/uploads/2011/05/logo-finished-1280x720.png", "https://toppng.com/uploads/preview/mario-mushroom-free-png-image-super-mario-mushroom-11562945955cv6up3e91x.png", "https://www.pinclipart.com/picdir/middle/306-3060913_png-file-clipart.png", "https://img.pngio.com/burning-fire-flame-fire-yellow-png-image-and-clipart-flame-png-260_270.png", "https://www.pikpng.com/pngl/m/140-1409929_red-butterfly-png-image-background-transparent-background-png.png"]
mobiles = ["0491570156", "0491570159", "+61491570558", "+61491570156", "0491570156"]
websites = ["https://itsadrian.me", "https://www.spacex.com/", "https://www.google.com/", "https://www.nasa.gov/", "https://news.ycombinator.com/"]
addresses = ["123 Fake St"]

5.times do
    sql = "INSERT INTO card_info (users_id, email, full_name, logo, mobile, website, business_address) VALUES ('1', '#{emails.sample}', '#{names.sample}', '#{logos.sample}', #{mobiles.sample}, '#{websites.sample}', '#{addresses.sample}')"

    run_sql(sql)
end

5.times do
    sql = "INSERT INTO card_info (users_id, email, full_name, logo, mobile, website, business_address) VALUES ('2', '#{emails.sample}', '#{names.sample}', '#{logos.sample}', #{mobiles.sample}, '#{websites.sample}', '#{addresses.sample}')"

    run_sql(sql)
end