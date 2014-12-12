class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :net_price
end
