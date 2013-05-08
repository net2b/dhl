FactoryGirl.define do
  factory :shipment, class: Dhl::Shipment do
    pickup_time Time.parse("16:45:10 31/12/2013 GMT+2")
    pieces 2
    description 'General goods'
  end
end
