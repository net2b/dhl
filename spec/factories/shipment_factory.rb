FactoryGirl.define do
  factory :shipment, class: Dhl::Shipment do
    pickup_time Time.parse("31/12/2013 16:45:10 GMT")
    pieces 2
    description 'General goods'
  end
end
