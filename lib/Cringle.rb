require "Cringle/CurrencyLayer"
require "Cringle/Output"

module Cringle
  class Application
    @output = nil
    @cl = nil

    def initialize(outputer)
      @cl = CurrencyLayer.new
      @output = outputer
    end

    def reportBestRate(base, target)
      chackAvailability(base, target)
      targets = target.split(',')
      weekRates = {}
      dayRates = {}
      (1..7).each do |day|
        date = Date.today - day
        dayRates = @cl.getRatesByDate(date.to_s)
        dayRates = getBaseRates(base, normalizeRates(dayRates), targets)
        dayRates.shift
        weekRates = dayRates.merge(weekRates) { |key, oldValue, newValue| oldValue.to_s + ", " + newValue.to_s }
      end
      weekRates.each do |key, value|
        value = value.split(",").map {|i| i.to_f}
        maxRate = value.max
        weekRates[key] = [maxRate, "Date: "+(Date.today - value.index(maxRate)).to_s ]
      end
      @output.print(weekRates)
    end

    def chackAvailability(base, target)
      if not base or not target or base.strip! == '' or target.strip! == ''
        abort("Please specify at least the base and target currencies")
      end
    end

    def exchange(base, target, amount, date)
      chackAvailability(base, target)
      targets = target.split(',')

      if amount <= 0
        amount = 1
      end

      if  date != ''
        rates = @cl.getRatesByDate(date)
      else
        date =  Date.today
        rates = @cl.getRates()
      end

      rates = getBaseRates(base,normalizeRates(rates), targets)
      printRates(date, amount, rates)
    end

    def printRates(date, amount, rates)
      output = ""
      output += "Date:#{date}\n"
      rates.each_with_index do |(key, value), index|
        next if index == 0
        output += "#{amount} #{rates.keys[0]} = #{amount * value} #{key}\n"
      end
      @output.print(output)
    end

    def normalizeRates(rates)
        rates = rates['quotes']
        # Given that the response is always USD for base currency
        # Create a map of currencies and their exchange rates from USD with ommiting 'usd' prefix from the key.
        usdRates = {}
        rates.each do |key, value|
          target = key[3, 3]
          usdRates[target] = value
        end
        usdRates
    end

    def getBaseRates(baseCurrency, rates, targets)
        # Transform currency exchange rates into new rates
        # based on the base currency
        baseCurrencyRates = {}
        baseCurrencyRate = rates[baseCurrency]
        baseCurrencyRates[baseCurrency] = 1
        rates.each do |key, value|
          if (key == baseCurrency || !targets.include?(key))
            next
          else
            baseCurrencyRates[key] = value / baseCurrencyRate
          end
        end
        baseCurrencyRates
    end

  end
end
