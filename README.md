# README

Please read this file for the correct deployment for this project

# Setup

Run the commands: 

`` bundle install ``
`` rails s ``


Add here the rake task necessary for the correct funcionality of the project:

# Develop

### Permissions

To create permissions for each role, you must modify the file `app/models/ability.rb` and add your permission


# Commands for test 

p = Product.first.images.first
Rails.application.routes.url_helpers.rails_blob_url(p)