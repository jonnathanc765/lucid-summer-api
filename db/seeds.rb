# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Role.destroy_all
User.destroy_all

super_admin_role = Role.create(name: "super-admin")
admin_role = Role.create(name: "admin")
employee_role = Role.create(name: "employee")
dispatcher_role = Role.create(name: "dispatcher")
delivery_man_role = Role.create(name: "delivery-man")
client_role = Role.create(name: "client")

super_admin = User.create(first_name: "Root", last_name: "User", email: "superadmin@htdevs.com", phone: "+571584455241", )
admin = User.create(first_name: "Admin", last_name: "User", email: "admin@htdevs.com", phone: "+5715884455241", )

admin.add_role :admin
# super_admin.add_role super_admin
# admin.add_role admin

case Rails.env
when 'development'
  # development-specific seeds ...
  # (anything you need to interactively play around with in the rails console)

when 'test'
  # test-specific seeds ...
  # (Consider having your tests set up the data they need
  # themselves instead of seeding it here!)

#   Role.create(name: 'super-admin')
#   Role.create(name: 'admin')
#   Role.create(name: 'employee')
#   Role.create(name: 'super-admin')
  

when 'production'
  # production seeds (if any) ...

end
