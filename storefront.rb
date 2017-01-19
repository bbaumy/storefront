require 'sqlite3'
require 'active_record'

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: '/Users/brian/src/assignments/storefront/store.sqlite3'
)

class User < ActiveRecord::Base
  has_many :orders
  has_many :addresses
end

class Address < ActiveRecord::Base
  belongs_to :user
end

class Item < ActiveRecord::Base
  has_many :orders
end

class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
end

# 1.  SELECT COUNT(*) FROM users
# puts User.count

# 2.  SELECT price FROM items ORDER BY price DESC LIMIT 5
# puts Item.order(price: :desc).limit(5).pluck(:title, :price)

# 3. SELECT price FROM items WHERE category LIKE "%book%" ORDER BY price ASC LIMIT 1
# puts Item.where("category LIKE '%book%'").order(price: :asc).limit(1).pluck(:title, :price)

# 4.  SELECT first_name, last_name FROM users
#     INNER JOIN addresses ON users.id = addresses.user_id
#     WHERE street = "6439 Zetta Hills"
# puts User.joins("INNER JOIN addresses ON users.id = addresses.user_id").where("street = '6439 Zetta Hills'").pluck(:first_name, :last_name)

# 5.  UPDATE addresses
#     SET city = "New York" , zip = "10108"
#     WHERE user_id IN (SELECT id FROM users
#     WHERE first_name = "Virginie AND last_name = "Mitchell"
# userVirginie = User.find_by(first_name: 'Virginie', last_name: 'Mitchell')
# userVirginie.addresses.first.update(city: 'New York', zip: 10708)
# puts userVirginie.addresses.first.inspect

# 6.  SELECT SUM(price) FROM items WHERE category LIKE "%tool%";
# puts Item.all.sum('price')

# 7.  SELECT SUM(quantity) FROM orders
# puts Order.all.sum('quantity')

# 8.  SELECT SUM(items.price * orders.quantity) FROM orders
#     INNER JOIN items ON items.id = orders.item_id
#     WHERE items.category LIKE "%book%"

puts Order.joins("INNER JOIN items ON items.id = orders.item_id").all.sum('items.price' * 'orders.quantity').where("category LIKE '%book%'")

