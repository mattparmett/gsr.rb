# gsr.rb: A Ruby gem for reserving Wharton GSRs #

gsr.rb is a simple Ruby gem that allows your application to easily book and cancel Wharton Group Study Room (GSR) reservations.

## Installation ##

gsr.rb is hosted on RubyGems, so to install, simply run:

```gem install gsr```

## How to use gsr.rb ##

*This section will change as gsr.rb is developed.  As such, this section may not be fully accurate, but I will try to keep the instructions as current as possible.*

### Make a reservation ###

To reserve a GSR for 60 minutes at noon on 9/18/2012 on the second floor:

```ruby
require 'gsr'
concierge = GSR.new(spike_username, spike_password)
concierge.reserve('floor' => '2', 'start_time' => Time.new(2012, 9, 18, 12, 0, 0), 'duration' => 60)
```

```floor``` takes strings ```""```, ```"F"```, ```"G"```, ```"2"```, or ```"3"```.  The empty string, to which ```floor``` defaults, means any floor is acceptable.

```start_time``` takes a Time object specifying the desired starting date and time (defaults to ```Time.now```).

```duration``` takes an integer with a value of ```30```, ```60```, or ```90```.  If another integer is given, gsr.rb rounds up to the next largest interval.  ```duration``` defaults to ```90```.

### Cancel a reservation ###

To cancel the reservation closest to the current time (more specific cancellation functionality may be added in the future):

```ruby
require 'gsr'
concierge = GSR.new(spike_username, spike_password)
concierge.cancel
```

## Warnings ##

Security-wise, this probably isn't the most secure way to handle the spike username and password.  The user/pass combo is sent through a form on a secure web page, but no additional encryption/hashing is done on the credentials.  Still, if gsr.rb is incorporated into a Heroku app, for example, the spike credentials could be stored securely as environment variables.

## TODO ##
*	More robust cancellation system