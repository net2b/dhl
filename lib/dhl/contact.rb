module Dhl
  class Contact

    attr_accessor :name, :company, :phone, :email, :address, :address2, :address3,
      :street_name, :street_number, :state_name, :city, :postal_code, :country_code

    def to_hash
      {
        contact: {
          person_name: @name,
          company_name: @company,
          phone_number: @phone,
          email_address: @email # Optional
        }.remove_empty,
        address: {
          street_lines: @address,
          street_lines_2: @address2, # Optional
          street_lines_3: @address3, # Optional
          city: @city,
          postal_code: @postal_code,
          country_code: @country_code,
          street_name: @street_name, # Optional
          street_number: @street_number, # Optional
          state_or_province_code: @state_name # Optional
        }.remove_empty
      }
    end

  end
end
