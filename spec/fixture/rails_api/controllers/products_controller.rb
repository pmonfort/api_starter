# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: [:destroy, :show, :update]

  # GET /products
  def index
    @products = Product.all

    render json: @products
  end

  # GET /products/1
  def show
    render json: @product
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    rescue
      render json: { error: 'not-found' }, status: :not_found
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:first_day_on_market, :name, :price)
    end
end
