require (File.expand_path('./../../../spec_helper', __FILE__))
# For Ruby > 1.9.3, use this instead of require
# require_relative '../../spec_helper'

describe Dhl::Packages do

  let(:packages) { Dhl::Packages.new }

  describe '#to_hash' do
    it "should return the expected hash structure" do
      packages.add(50, 10, 15, 20, 'Ref 1')
      packages.add(100, 40, 45, 35, 'Ref 2')

      hash = packages.to_hash
      hash.should == {
        requested_packages: [
          {
            weight: 50,
            dimensions: {
              width: 10,
              height: 15,
              length: 20
            },
            customer_references: 'Ref 1'
          },
          {
            weight: 100,
            dimensions: {
              width: 40,
              height: 45,
              length: 35
            },
            customer_references: 'Ref 2'
          }
        ],
        :attributes! => { requested_packages: { number: [1, 2] } }
      }
    end

    it "should raise an exception if not all required fields are present"
  end

end
