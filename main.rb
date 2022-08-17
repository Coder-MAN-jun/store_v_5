# Этот код необходим только при использовании русских букв на Windows
if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require_relative 'lib/product'
require_relative 'lib/book'
require_relative 'lib/film'
require_relative 'lib/disk'
require_relative 'lib/comics'
require_relative 'lib/pen'
require_relative 'lib/product_collection'
require_relative 'lib/cart'

#коллекция товаров
collection = ProductCollection.from_dir("#{__dir__}/data")
collection.sort!(by: :price, order: :asc)

#корзина покупок
cart = Cart.new

user_input = nil

loop do
  puts "Что хотите купить:\n\n"
  puts collection
  puts "0. Выход"

  user_input = STDIN.gets.to_i

  #если ввели отрицательное число завершим цикл покупки
  break unless user_input > 0

  #возьмем продукт
  product = collection.product_by_index(user_input - 1)

  if product
    cart.add(product)
    puts "\nВы выбрали: #{product}\n\n"
    puts "Всего товаров на сумму: #{cart.sum} руб.\n\n"
  end
end

puts "\n\nВы купили:\n\n"
puts cart

puts  "\nС Вас — #{cart.sum} руб. Спасибо за покупки!"

#после завершения покупки обновим коллекцию(если товары исчезли с продажи - удалим их)
#делать это нужно после завершения покупки
collection.update_products_in_stock!

puts "\nВ магазине оcтались такие товары"
puts collection
