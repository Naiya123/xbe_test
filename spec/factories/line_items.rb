FactoryBot.define do
  factory :line_item do
    quantity { 10 }
    price { 200 }
    association :invoice
  end
end
