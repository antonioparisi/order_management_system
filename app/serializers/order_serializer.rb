class OrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :reason, :order_date, :vat
end
