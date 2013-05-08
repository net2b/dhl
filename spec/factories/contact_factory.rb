FactoryGirl.define do
  factory :contact, class: Dhl::Contact do
    name "John Doe"
    company "ACME Inc"
    phone "+391234567890"
    email "john@example.com"
    address "Piazza Duomo, 1234"
    address2 "Scala B"
    address3 ""
    street_name "Piazza Duomo"
    street_number "1234"
    state_name "MI"
    city "Milano"
    postal_code "20121"
    country_code "IT"
  end
end
