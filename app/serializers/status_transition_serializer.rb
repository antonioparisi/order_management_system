class StatusTransitionSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :event, :from, :to

  has_one :order
end
