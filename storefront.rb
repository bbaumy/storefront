require 'sqlite3'
require 'active_record'

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: '/Users/brian/src/assignments/storefront/store.sqlite3'
)

class User < ActiveRecord::Base
  has_many :orders
  has_many :addresses

  def full_name
    "#{first_name} #{last_name}"
  end

  def spent
    Order.joins(:item).sum("price * quantity")
  end
end

class Address < ActiveRecord::Base
  belongs_to :user

  def full_address
    "#{street}, #{city}, #{state}, #{zip}"
  end

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
# puts Item.order(price: :desc).limit(5)#.pluck(:title, :price)

# OR
# items = Item.order(price: :desc).limit(5)
# puts "Item   |   Price"
# items.each do |item|
#   puts "#{item.title}  |  #{item.price}"
# end

# 3. SELECT price FROM items WHERE category LIKE "%book%" ORDER BY price ASC LIMIT 1
# puts Item.where("category LIKE '%book%'").order(price: :asc).limit(1).pluck(:title, :price)

# OR
# book = Item.where(category: "Books").order(price: :asc).first
# puts "#{book.title} is our cheapest book."

# 4.  SELECT first_name, last_name FROM users
#     INNER JOIN addresses ON users.id = addresses.user_id
#     WHERE street = "6439 Zetta Hills"
# puts User.joins("INNER JOIN addresses ON users.id = addresses.user_id").where("street = '6439 Zetta Hills'").pluck(:first_name, :last_name)

# OR
# person = Address.find_by(
#     street: "6439 Zetta Hills",
#     city: "Willmouth",
#     state: "WY"
#   ).user
#
# puts "#{person.first_name} lives there"

# 5.  UPDATE addresses
#     SET city = "New York" , zip = "10108"
#     WHERE user_id IN (SELECT id FROM users
#     WHERE first_name = "Virginie AND last_name = "Mitchell"

# "#{userVirginie = User.find_by(first_name: 'Virginie', last_name: 'Mitchell')
# userVirginie.addresses.first.update(city: 'New York', zip: 10708)
# puts userVirginie.addresses.first.inspect
#
# userVirginie.addresses.each do |add|
#   puts add.full_address
# end}"

# 6.  SELECT SUM(price) FROM items WHERE category LIKE "%tool%";
# puts Item.all.sum('price')

#OR
# total = Item.where(category: "Tools").sum(:price)
# puts "It would cost #{total} to buy all the tools."

# 7.  SELECT SUM(quantity) FROM orders
#puts Order.all.sum('quantity')

#OR
# total_orders = Order.sum(:quantity)
# puts "We had #{total_orders} items ordered."

# 8.  SELECT SUM(items.price * orders.quantity) FROM orders
#     INNER JOIN items ON items.id = orders.item_id
#     WHERE items.category LIKE "%book%"

#revenue = Order.joins(:item).where("items.category" => "Books").sum("price * quantity")
#OR (less secure way)
#revenue = Order.joins(:item).where("items.category LIKE '%book%'").sum("price * quantity")

#puts "We made #{revenue} on books."

# 9.  INSERT INTO users (id, first_name, last_name, email) VALUES (51, "brian", "baumgartner", "b@b.com")
#     INSERT INTO orders (id, user_id, item_id, quantity, created_at) VALUES (378, 51, 91, 1, CURRENT_TIMESTAMP)

# me = User.create(
#              first_name: "Brian",
#              last_name: "Baumy",
#              email: "b@b.com"
#             )
# item = Item.find(42)
#
# #order = Order.create(user: me, item: item, quantity: 23)
# #OR
# me.orders << Order.new(item: item, quantity: 23)
#
# puts "I've ordered #{me.orders.last.item.title}."

# 10. SELECT id, price FROM items WHERE id IN (10, 46, 65) ORDER BY price DESC LIMIT 1
# Ordered most often:
# often = Order.group(:item).sum(:quantity).max_by{|key, value| value}
# puts "#{often.first.title} was ordered #{often.last} times."

# Grossed the most money:
# most = Order.group(:item).joins(:item).sum("price * quantity").max_by{|key, value| value}

# puts "#{most.first.title} made #{most.last} money."

# 11.  SELECT user_id, SUM(items.price * orders.quantity) orderPrice FROM orders
#      INNER JOIN items ON items.id = orders.item_id
#      GROUP BY user_id ORDER BY orderPrice DESC limit 1

# spender = User.joins(orders: :item)
#               .select("users.*, SUM(price * quantity) AS total")
#               .order("total desc").group(:id).first
#
# puts "#{spender.full_name} spent the most."

# 12. What were the top 3 highest grossing categories?

# categories = Item.joins(:orders)
#                  .group(:category)
#                  .order("sum_price_all_quantity DESC")
#                  .limit(3)
#                  .sum("price * quantity")
#
# categories.each do |category, revenue|
#   puts "#{category} made us #{revenue}"
# end