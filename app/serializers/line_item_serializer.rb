class LineItemSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :quantity, :net_price

  has_one :order
  has_one :product
end
