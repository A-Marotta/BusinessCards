# Business Card Exchanging Platform (CardEx)

Test user account:<br/>
Login: john@gmail.com <br/>
Password: johncrud

### Introduction and technologies.
A webapp built to store your own and other users business cards for life.  
Built in Ruby following CRUD operations this webapp makes use of a PostgreSQL database ontop of the sinatra DSL framework.   
Client-side programmed using HTML & CSS.   
API integration also seen through the below:
  - Google's reCAPTCHA: upon user sign up for verification of humanitiy. 
  - Cloudinary: used to upload user logo's to the cloud.
  - goQR.me: creates a qr code to point to the url of the users card.
<br/>

### Installation instructions
1) PSQL database must be created and named: business_card
2) Create tables following the schema.sql file stored in the db directory.
3) Optional: Make use of ruby files (dummy_cards.rb & dummy_users.rb) for import of dummy data.
4) Install gems as seen in Gemfile.
<br/>
 
### Design
  - Database: <br/>
    ![Alt text](/design-docs/DB-Diagram.png?raw=true "Database")

  - Wireframe (Homepage & CardList): <br/>
    ![Alt text](/design-docs/WF-index.png?raw=true "Homepage") <br/>
    ![Alt text](/design-docs/WF-CardList.png?raw=true "CardList")

  - Flowchart (Sign in / sign up): <br/>
    ![Alt text](/design-docs/Flow-User-SignIn.png?raw=true "Sign in / sign up")

 <br/>
 
### Future aspirations
1) Database to include a field which when true will make the card non-searchable to other users.
    - This will inturn allow users to have 'private' business cards only shareable via the QR code.
2) Pagination for card results over 10 items.
3) Responsive design for mobile.
