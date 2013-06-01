# DHL

[![Build Status](https://travis-ci.org/momitians/dhl.png?branch=master)](https://travis-ci.org/momitians/dhl)
[![Dependency Status](https://gemnasium.com/momitians/dhl.png)](https://gemnasium.com/momitians/dhl)
[![Code Climate](https://codeclimate.com/github/momitians/dhl.png)](https://codeclimate.com/github/momitians/dhl)

This gem will provide a wrapper to DHL SOAP API. Given DHL credentials and the addresses, will generate a shipping label.

It refers to the DHL test environment and cannot be used, as of yet, for production environments.

## Installation

Add this line to your application's Gemfile:

    gem 'dhl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dhl

## Usage

### Package Tracking

TBD

### Request Shipment

```ruby
# Start by creating a new shipment request
shipment_request = Dhl::ShipmentRequest.new

# Set sender info
shipment_request.shipper.name         = 'Package Sender'
shipment_request.shipper.company      = 'The Packs Inc'
shipment_request.shipper.phone        = '555-4321'
shipment_request.shipper.email        = 'ps@example.com'
shipment_request.shipper.address      = 'Geary Boulevard, 1234'
shipment_request.shipper.address2     = 'First floor, Apt 2'
shipment_request.shipper.postal_code  = '54321'
shipment_request.shipper.city         = 'San Francisco'
shipment_request.shipper.state_name   = 'CA'
shipment_request.shipper.country_code = 'USA'

# Set recipient info
shipment_request.recipient.name         = 'Package Receiver'
shipment_request.recipient.company      = 'Pack It Ltd'
shipment_request.recipient.phone        = '555-1234'
shipment_request.recipient.email        = 'pr@example.com'
shipment_request.recipient.address      = 'Times Square, 1234'
shipment_request.recipient.address2     = 'Third floor, Apt 5'
shipment_request.recipient.postal_code  = '12345'
shipment_request.recipient.city         = 'New York'
shipment_request.recipient.state_name   = 'NY'
shipment_request.recipient.country_code = 'USA'

# Set a pickup date and time
shipment_request.shipment.pickup_time = Time.new(2013, 05, 20, 10, 00, 00, "-08:00")

# Add Packages with weight, width, height, length and a reference string
shipment_request.packages.add(10, 15, 5, 20, 'Pack')

# Execute the reeuqest
result = Dhl.client.request_shipment(shipment_request)

```

If everything goes well, result will be a hash with:
* tracking_numbers: Shipment tracking number
* shipping_label: Path to the shipping label PDF

## Testing

For testing purposes please set the timezone to UTC

```shell
$ export TZ=UTC
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Licence

Released under the [MIT License](http://www.opensource.org/licenses/MIT). © 2013 [Momit S.r.l.](http://momit.it/)
