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

puts User.count