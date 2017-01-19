require 'sqlite3'
require 'active_record'

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: '/Users/brian/src/assignments/storefront/store.sqlite3'
)

class User < ActiveRecord::Base

end

class Address < ActiveRecord::Base

end


class Item < ActiveRecord::Base

end


class Order < ActiveRecord::Base

end





SELECT COUNT(*) FROM users