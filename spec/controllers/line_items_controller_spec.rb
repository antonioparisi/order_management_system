require 'spec_helper'

describe V1::LineItemsController, :type => :controller do
  describe 'GET /v1/orders/:order_id/line_items' do
    let(:order) { create(:order) }
    let(:product) { create(:product) }

    it 'list all line items' do
      create_list(:line_item, 5, :order => order, :product => product)

      get :index, :order_id => order.id

      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body.count).to eq(5)
    end
  end

  describe 'GET /v1/orders/:order_id/line_items/:id' do
    let(:order) { create(:order) }
    let(:product) { create(:product) }
    let(:line_item) { create(:line_item, :order => order, :product => product) }

    it 'return order details' do
      get :show, :order_id => order.id, :id => line_item.id

      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body['id']).to eq(line_item.id)
      expect(body['order_id']).to eq(order.id)
      expect(body['product_id']).to eq(product.id)
    end

    it 'return error' do
      get :show, :order_id => -1, :id => -1

      body = JSON.parse(response.body)

      expect(response.status).to eq(404)
      expect(body['error']).to eq('Order not found')
    end
  end

  describe 'POST /v1/orders/:order_id/line_items' do
    let(:order) { create(:order) }
    let(:product) { create(:product) }

    it 'create a line item' do
      post :create, {
        :order_id => order.id,
        :line_item => {
          :quantity => 2,
          :net_price => 1.0,
          :order_id => order.id,
          :product_id => product.id
        }
      }

      body = JSON.parse(response.body)

      expect(response.status).to eq(201)
      expect(body['quantity']).to eq(2)
      expect(body['net_price']).to eq('1.0')
      expect(body['order_id']).to eq(order.id)
      expect(body['product_id']).to eq(product.id)
    end

    it 'return error' do
      post :create, {
        :order_id => order.id,
        :line_item => {
          :quantity => 0
        }
      }

      body = JSON.parse(response.body)

      expect(response.status).to eq(412)
      expect(body).to have_key('error')
    end
  end

  describe 'PUT /v1/orders/:order_id/line_items/:id' do
    let(:order) { create(:order) }
    let(:product) { create(:product) }
    let(:line_item) { create(:line_item, :order => order, :product => product) }

    it 'update a line item' do
      put :update, {
        :id => line_item.id,
        :order_id => order.id,
        :line_item => {
          :id => line_item.id,
          :quantity => 5
        }
      }

      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body['quantity']).to eq(5)
    end

    it 'return error' do
      order.place!('place', 'placed')

      put :update, {
        :id => line_item.id,
        :order_id => order.id,
        :line_item => {
          :id => line_item.id,
          :quantity => 5
        }
      }

      body = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(body).to have_key('error')
    end
  end

  describe 'DELETE /v1/orders/:order_id/line_items/:id' do
    let(:order) { create(:order) }
    let(:product) { create(:product) }
    let(:line_item) { create(:line_item, :order => order, :product => product) }

    it 'delete a line item' do
      delete :destroy, {
        :id => line_item.id,
        :order_id => order.id
      }

      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body['success']).to eq(true)
    end

    it 'return error' do
      delete :destroy, {
        :id => -1,
        :order_id => order.id
      }

      body = JSON.parse(response.body)

      expect(response.status).to eq(404)
      expect(body).to have_key('error')
      expect(body['error']).to eq('Line item not found')
    end
  end
end
