FactoryGirl.define do
  factory :product do
    sequence(:name) { |n| "Product ##{n}" }
    net_price 1.0
  end

  factory :order do
    order_date Date.today.to_time
  end

  factory :line_item do
    quantity 10
    net_price 1.0
  end

  factory :status_transition do
    event 'place'
    from 'draft'
    to 'placed'
  end
end
