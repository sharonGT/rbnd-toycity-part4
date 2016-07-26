require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata < Module

 create_finder_methods :id, :brand, :name, :price

  @@data_path = File.expand_path("..", Dir.pwd) + "/data/data.csv"

	def self.create(attributes = nil)
		list = CSV.read(@@data_path)

    	product_update = attributes[:id] ? true : false

    	product = Product.new(attributes)
    	CSV.open(@@data_path, 'wb') do |csv|
     		list.each do |data|
        		if product_update && data[0].to_i == product.id
          			csv << [product.id, product.brand, product.name, product.price]
        		else
          			csv << data
        		end
      		end
      		if !product_update
        		csv << [product.id, product.brand, product.name, product.price]
      		end
    	end

    	product
	end


	def self.all 
		product_array = []
			CSV.foreach( @@data_path, headers: true ) do |product|
				product_array << self.new(id: product["id"], brand: product["brand"], name: product["product"], price: product["price"])
			end
		product_array
	end 

	

	
end
