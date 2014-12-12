require 'spec_helper'

describe V1::StatusTransitionsController, :type => :controller do
  describe 'GET /v1/orders/:order_id/status_transitions' do
    let(:order) { create(:order) }

    it 'list all order\'s status transitions' do
      create(:status_transition, :order => order)

      get :index, :order_id => order.id

      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body.count).to eq(1)
    end
  end

  describe 'POST /v1/orders/:order_id/status_transitions' do
    let(:order) { create(:order) }

    it 'create a status transition' do
      post :create, {
        :order_id => order.id,
        :status_transition => {
          :event => 'place',
          :from => 'draft',
          :to => 'placed'
        }
      }

      body = JSON.parse(response.body)

      expect(response.status).to eq(201)
      expect(body['order_id']).to eq(order.id)
    end

    it 'return error' do
      post :create, {
        :order_id => order.id,
        :status_transition => {
          :event => 'pay',
          :from => 'draft',
          :to => 'paid'
        }
      }

      body = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(body['error']).to eq('Not a valid transition')
    end
  end
end
