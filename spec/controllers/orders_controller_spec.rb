require 'spec_helper'

describe V1::OrdersController, :type => :controller do
  describe 'GET /v1/orders' do
    it 'list all orders' do
      create_list(:order, 5)

      get :index

      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body.count).to eq(5)
    end
  end

  describe 'GET /v1/orders/:id' do
    let(:order) { create(:order) }

    it 'return order details' do

      get :show, { :id => order.id }

      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body['id']).to eq(order.id)
    end

    it 'return error' do

      get :show, { :id => -1 }

      body = JSON.parse(response.body)

      expect(response.status).to eq(404)
      expect(body['error']).to eq('Order not found')
    end
  end

  describe 'POST /v1/orders' do
    it 'create a order' do
      post :create, :order => {
        :order_date => Date.tomorrow,
        :vat => 0.2
      }

      body = JSON.parse(response.body)

      expect(response.status).to eq(201)
      expect(body['status']).to eq('draft')
      expect(body['vat']).to eq(0.2)
    end

    it 'return error' do

      post :create, :order => {
        :order_date => 'foo'
      }

      body = JSON.parse(response.body)

      expect(response.status).to eq(412)
      expect(body).to have_key('error')
    end
  end

  describe 'PUT /v1/orders/:id' do
    let(:order) { create(:order) }

    it 'update an order' do
      put :update, :id => order.id, :order => {
        :vat => 0.3,
      }

      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body['vat']).to eq(0.3)
    end

    it 'return error' do
      order.place!('place', 'placed')

      put :update, :id => order.id

      body = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(body).to have_key('error')
    end
  end

end
