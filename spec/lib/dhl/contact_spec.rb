require (File.expand_path('./../../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
# require_relative '../../spec_helper'

describe Dhl::Contact do

  let(:contact) { FactoryGirl.build(:contact) }

  describe '#to_hash' do
    it "should return the expected hash structure" do
      hash = contact.to_hash
      hash.should == {
        contact: {
          person_name: 'John Doe',
          company_name: 'ACME Inc',
          phone_number: '+391234567890',
          email_address: 'john@example.com' # Optional
        },
        address: {
          street_lines: 'Piazza Duomo, 1234',
          street_lines_2: 'Scala B', # Optional
          city: 'Milano',
          postal_code: '20100',
          country_code: 'IT',
          street_name: 'Piazza Duomo', # Optional
          street_number: '1234', # Optional
          state_or_province_code: 'MI' # Optional
        }
      }
      hash[:address].should_not have_key(:street_lines_3)
    end

    # it "should raise an exception if not all required fields are present"
  end

end
