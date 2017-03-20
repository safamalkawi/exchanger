require 'json'
require 'net/http'

module Cringle
  class CurrencyLayer
    @@BASE_URL = "http://apilayer.net/api/"
    @@API_KEY = "a67c29b1aa7e28ac18f000143065ec7d"

    def getRates()
      makeRequest("live?")
    end

    def getRatesByDate(date)
      makeRequest("historical?date=#{date}")
    end

    def makeRequest(uri)
      response = Net::HTTP.get_response(URI.parse("#{@@BASE_URL}/#{uri}&access_key=#{@@API_KEY}"))
      if response.code.to_i != 200
        raise "Failed when requesting #{uri}, response #{response.body}"
      end

      result = JSON.parse(response.body)

      if result['success'] == false
        raise "No data available for specified date. Date should be in format YYY-MM-DD.\n Current day rates might be unavailable yet"
      end
      result
    end

    private :makeRequest

  end
end
