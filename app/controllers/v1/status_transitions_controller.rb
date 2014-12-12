module V1
  class StatusTransitionsController < ApplicationController
    before_action :find_order!, :only => [:index, :create]

    ##
    # GET /v1/orders/:order_id/status_transitions
    def index
      render :json => @order.status_transitions
    end

    ##
    # POST /v1/orders/:order_id/status_transitions
    def create
      p = status_transition_params.merge({
        :order_id => params[:order_id]
      })

      begin
        if @order.is_valid_transition?(p[:from], p[:to]) && @order.send("#{p[:event]}!", p[:event], p[:to])
          status_transition = StatusTransition.create!(p)
        else
          render :json => { :error => 'Not a valid transition' }, :status => 400

          return
        end
      rescue => error
        render :json => { :error => error.message }, :status => 412

        return
      end

      render :json => status_transition, :status => 201
    end


    private

    def status_transition_params
      params.require(:status_transition).permit([:event, :from, :to])
    end

    def find_order!
      @order = Order.find(params[:order_id])
    rescue ActiveRecord::RecordNotFound
      render :json => { :error => 'Order not found' }, :status => 404

      return
    end
  end
end
