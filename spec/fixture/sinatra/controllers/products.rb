# frozen_string_literal: true

require './api/base_controller'

module API
  class ProductsController < BaseController
    get '/products' do
      Product.all
    end

    get '/products/:id' do
      product
    end

    post '/products' do
      required_params product: %i[name]
      product = Product.new(product_params)
      if product.save
        status 201
        { message: 'Product was successfully created.' }
      else
        halt 400, json({ message: product.errors.full_messages })
      end
    end

    put '/products/:id' do
      if product.update(product_params)
        { message: 'Product was successfully updated.' }
      else
        halt 400, json({ message: product.errors.full_messages })
      end
    end

    delete '/products/:id' do
      product.destroy
      { message: 'Product has been deleted' }
    end

    def product
      @product ||= Product.find(params[:id])
    rescue
      halt 404
    end

    def product_params
      params['product'].slice(
        *%w[first_day_on_market name price]
      )
    end
  end
end
