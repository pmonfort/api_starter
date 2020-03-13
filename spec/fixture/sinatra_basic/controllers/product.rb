# frozen_string_literal: true

require './api/base_controller'

module API
  Product controller
  class ProductController < BaseController
    get '/products' do
      Product.all
    end

    get '/products/:id' do
      product
    end

    post '/products', allows: %i[price], needs: %i[name] do
      if product.update(product_params)
        status 201
        { message: 'Product was successfully created.' }
      else
        halt 500, json({ message: product.errors.full_messages })
      end
    end

    put '/products/:id', allows: %i[name price] do
      if product.update(product_params)
        { message: 'Product was successfully updated.' }
      else
        halt 500, json({ message: product.errors.full_messages })
      end
    end

    delete '/products/:id' do
      product.destroy
      { message: 'Product has been deleted' }
    end

    def product
      @product ||= Product.find(params[:id])
    end
  end
end