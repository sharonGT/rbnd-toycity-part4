require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata < Module

@@data_path = File.expand_path("..", Dir.pwd) + "/data/data.csv"

 create_finder_methods :id, :brand, :name, :price

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
    	products = []

    	CSV.foreach( @@data_path, headers: true ) do |prod|
      		products << self.new( id: prod["id"], brand: prod["brand"], name: prod["product"], price: prod["price"] )
    	end
    	products
  	end

	def self.first(element = 1)
		products = self.all
		if element == 1
			return products.first(1)[0]
		else
			return products.first(element)
		end
	end

	def self.last(element = 1)
		products = self.all
		if element == 1
			return products.last(1)[0]
		else
			return products.last(element)
		end
	end

	def self.find(index)
		products = self.all
		products.select! { |product| product.id == index }
		if products.empty?
			raise ProductNotFoundError
		else
			return products[0]
		end
	end



end
