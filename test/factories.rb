FactoryGirl.define do
  factory :user do
    email "nour.fwh@gmail.com"
    password "mypass123"
  end
  factory :group do
    name "my group"
    user_id 1
  end
  factory :client do
    name "my client"
    user_id 1
  end
  factory :product do
    user_id 1
    name "my product"
    original_price 5.0
  end
  factory :plan do
    client_id 1
    product_id 1
    discount 0
    product_selling_price 5.0
  end
end