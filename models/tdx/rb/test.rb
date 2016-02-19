require 'binary_struct/version'

signals_user_10_item = BinaryStruct.new([
  "C", :date,
  "e", :value
])


signals_user_10_item = signals_user_10_item.size
item = File.open("..\\data\\1_000001.dat", "rb") { |f| f.read(signals_user_10_item) }
puts signals_user_10_item.decode(item)
