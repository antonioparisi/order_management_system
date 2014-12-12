module V1
  class LineItemsController < ApplicationController
    before_action :find_order!, :only => [:index, :show, :create, :update, :destroy]
    before_action :find_line_item!, :only => [:show, :update, :destroy]

    ##
    # GET /v1/orders/:order_id/line_items
    def index
      render :json => @order.line_items
    end

    ##
    # GET /v1/orders/:order_id/line_items/:id
    def show
      render :json => @line_item
    rescue => error
      render :json => { :error => error.message }, :status => 400
    end

    ##
    # POST /v1/orders/:order_id/line_items
    def create
      p = line_item_params

      begin
        line_item = LineItem.create!(p)
      rescue => error
        render :json => { :error => error.message }, :status => 412

        return
      end

      render :json => line_item, :status => 201
    end

    ##
    # PUT /v1/orders/:order_id/line_items/:id
    def update
      if !@order.editable?
        render :json => { :error => 'Order can\'t be update because is not in `DRAFT`' }, :status => 400

        return
      end

      begin
        p = line_item_params

        @line_item.update_attributes!(p)
      rescue ActionController::ParameterMissing
        render :json => { :error => 'Line item parameters missing' }, :status => 400

        return
      rescue => error
        render :json => { :error => error.message }, :status => 412

        return
      end

      render :json => @line_item
    end

    ##
    # DELETE /v1/orders/:order_id/line_items/:id
    def destroy
      @line_item.destroy

      render :json => { :success => true }
    rescue => error
      render :json => { :error => error.message }, :status => 412
    end



    private

    def line_item_params
      params.require(:line_item).permit([:quantity, :net_price, :order_id, :product_id])
    end

    def find_order!
      @order = Order.find(params[:order_id])
    rescue ActiveRecord::RecordNotFound
      render :json => { :error => 'Order not found' }, :status => 404

      return
    end

    def find_line_item!
      @line_item = @order.line_items.where(:id => params[:id]).first

      raise ActiveRecord::RecordNotFound if @line_item.blank?
    rescue ActiveRecord::RecordNotFound
      render :json => { :error => 'Line item not found' }, :status => 404

      return
    end
  end
end
