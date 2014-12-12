require 'spec_helper'

describe V1::ProductsController, :type => :controller do
  describe 'GET /v1/products' do
    it 'list all products' do
      create_list(:product, 5)

      get :index

      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body.count).to eq(5)
    end
  end

  describe 'GET /v1/products/:id' do
    let(:product) { create(:product) }

    it 'return product details' do

      get :show, { :id => product.id }

      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body['id']).to eq(product.id)
    end

    it 'return error' do

      get :show, { :id => -1 }

      body = JSON.parse(response.body)

      expect(response.status).to eq(404)
      expect(body['error']).to eq('Product not found')
    end
  end

  describe 'POST /v1/products' do
    let(:name) { Faker::Name.name }

    it 'create a product' do
      post :create, :product => {
        :name => name,
        :net_price => 1.0
      }

      body = JSON.parse(response.body)

      expect(response.status).to eq(201)
      expect(body['name']).to eq(name)
    end

    it 'return error' do

      post :create, :product => {
        :name => 'foo'
      }

      body = JSON.parse(response.body)

      expect(response.status).to eq(412)
      expect(body).to have_key('error')
    end
  end

  describe 'PUT /v1/products/:id' do
    let(:product) { create(:product) }
    let(:new_product_name) { Faker::Name.name }

    it 'update a product' do
      put :update, :id => product.id, :product => {
        :name => new_product_name,
      }

      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body['name']).to eq(new_product_name)
    end

    it 'return error' do
      put :update, :id => product.id

      body = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(body).to have_key('error')
    end
  end

  describe 'DELETE /v1/products/:id' do
    let(:product) { create(:product) }

    it 'delete a product' do
      delete :destroy, :id => product.id

      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body['success']).to eq(true)
    end

    it 'return error' do
      order = create(:order)
      line_item = create(:line_item, :order => order, :product => product)

      delete :destroy, :id => product.id

      body = JSON.parse(response.body)

      expect(response.status).to eq(400)
      expect(body).to have_key('error')
      expect(body['error']).to eq("Product has some orders and can't be deleted")
    end
  end
end
