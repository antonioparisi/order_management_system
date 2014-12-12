module V1
  class ProductsController < ApplicationController
    before_action :find_product!, :only => [:show, :update, :destroy]

    ##
    # GET /v1/products
    def index
      render :json => Product.all
    end

    ##
    # GET /v1/products/:id
    def show
      render :json => @product
    rescue => error
      render :json => { :error => error.message }, :status => 400
    end

    ##
    # POST /v1/products
    def create
      p = product_params

      begin
        product = Product.create!(p)
      rescue => error
        render :json => { :error => error.message }, :status => 412

        return
      end

      render :json => product, :status => 201
    end

    ##
    # PUT /v1/products/:id
    def update
      begin
        p = product_params

        @product.update_attributes!(p)
      rescue ActionController::ParameterMissing
        render :json => { :error => 'Product parameters missing' }, :status => 400

        return
      rescue => error
        render :json => { :error => error.message }, :status => 412

        return
      end

      render :json => @product
    end

    ##
    # DELETE /v1/products/:id
    def destroy
      if @product.blank?
        render :json => { :error => 'Product not found' }, :status => 404

        return
      end

      if @product.orders.any?
        render :json => { :error => 'Product has some orders and can\'t be deleted' }, :status => 400

        return
      end

      @product.destroy

      render :json => { :success => true }

    end

    private

    def product_params
      params.require(:product).permit([:name, :net_price])
    end

    def find_product!
      @product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render :json => { :error => 'Product not found' }, :status => 404

      return
    end
  end
end

