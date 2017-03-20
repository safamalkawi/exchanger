# Cringle

This is a ruby a command line application which handles currency exchange rates using the free plan of the currencylayer API (https://currencylayer.com).

## Installation
1- Clone this code
2- Execute:

    $ bundle install

## Usage
### Command 1
command:  exchange =>  Shows exchange rates between specified base and target currencies with optional date and amount.
```
Options
 -b, --base BASE_CURRENCY, String, Specify base currency
 -t, --target TARGET_CURRENCY, String, Specify target currencies
 -o, --output OUTPUT, String, Specify output destination; It should be '-o stdout' to print output on console or '-o sms' to send a sms of the result. Default is sms
 -d, --date DATE, String, A specific date to fetch the currencies rates on. It should be in format YYY-MM-DD. Default is date = Date.today
 -a, --amount AMOUNT, Float, Specify an amount for conversion. Default is amount = 1
```
    
**Example**: 

```
./bin/er.rb exchange -b EUR -t AED,JPY,JOD -o stdout -d 2005-01-01
```

**Output**:

```
Date:2005-01-01
1 EUR = 4.988630497976039 AED
1 EUR = 0.9630932652340461 JOD
1 EUR = 139.43630090467008 JPY
```

**Example**

```
./bin/er.rb exchange -b JOD -t AED,JPY,EUR -o stdout -d 2017-01-01 -a 65.7876
```

**Output**

```
Date:2017-01-01
65.7876 JOD = 341.5104875841345 AED
65.7876 JOD = 88.25364073170525 EUR
65.7876 JOD = 10856.891182961366 JPY
```

### Command 2
command: report_best ==> Show the best exchange rates for the last 7 days for a specified base and target currencies

```
Options
 -b, --base BASE_CURRENCY, String, Specify base currency
 -t, --target TARGET_CURRENCY, String, Specify target currencies
 -o, --output OUTPUT, String, Specify output destination; It should be '-o stdout' to print output on console or '-o sms' to send a sms of the result. Default is sms
```

**Example**
```
./bin/er.rb report_best -b EUR -t AED,JPY,JOD -o stdout
```

**Output**

```
Highest exchange rate among the last 7 days for
AED = 3.956680361296885 has been recorded on 2017-03-17
JOD = 0.7633899758754705 has been recorded on 2017-03-17
JPY = 122.43234711272108 has been recorded on 2017-03-20
```

**Example**

```
./bin/er.rb report_best -b JOD -t USD -o stdout
```

**Output**

```
USD = 1.4120245183937374 has been recorded on 2017-03-14
```

**Example**

```
./bin/er.rb report_best -b JOD -t USD -o sms
```

**Output**

```
Please provide your number: XXXXXXXXXXX
Message sent, you should be receiving an SMS with the following content:
Highest exchange rate among the last 7 days for
USD = 1.4120245183937374 has been recorded on  2017-03-14
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/er.rb` to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/safamalkawi/Cringle.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

