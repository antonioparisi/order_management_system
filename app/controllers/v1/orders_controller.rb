module V1
  class OrdersController < ApplicationController
    before_action :find_order!, :only => [:show, :update]

    ##
    # GET /v1/orders
    def index
      render :json => Order.all
    end

    ##
    # GET /v1/orders/:id
    def show
      render :json => @order
    rescue => error
      render :json => { :error => error.message }, :status => 400
    end

    ##
    # POST /v1/orders
    def create
      p = order_params

      begin
        order = Order.create!(p)
      rescue => error
        render :json => { :error => error.message }, :status => 412

        return
      end

      render :json => order, :status => 201
    end

    ##
    # PUT /v1/orders/:id
    def update
      if !@order.editable?
        render :json => { :error => 'Order can\'t be update because is not in `DRAFT`' }, :status => 400

        return
      end

      begin
        p = order_params

        @order.update_attributes!(p)
      rescue ActionController::ParameterMissing
        render :json => { :error => 'Order parameters missing' }, :status => 400

        return
      rescue => error
        render :json => { :error => error.message }, :status => 412

        return
      end

      render :json => @order
    end

    private

    def order_params
      params.require(:order).permit([:order_date, :vat])
    end

    def find_order!
      @order = Order.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render :json => { :error => 'Order not found' }, :status => 404

      return
    end
  end
end
