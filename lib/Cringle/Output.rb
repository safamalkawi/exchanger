require 'net/http'

module Cringle
  class Output
    def print(msg)
    end
  end

  class StdOutput < Output
    def print(msg)
      puts msg
    end
  end

  class SMSOutput < Output
    @@BASE_URL = URI.parse("https://rest.nexmo.com/sms/json")
    @@NEXMO_API_KEY = "8477f584"
    @@NEXMO_API_SECRET = "c19d21127bf7a611"
    def print(msg)
      number = ask("Please provide your number: ")
      response = Net::HTTP.post_form(@@BASE_URL, {
        "api_key" => @@NEXMO_API_KEY,
        "api_secret" => @@NEXMO_API_SECRET,
        "from": "Safa - Cringle",
        "to": number,
        "text": msg
      })
      if response.code.to_i != 200
        raise "Failed when sending result output"
      end
      puts "Message sent, you should be receiving an SMS with the following content:\n #{msg}"
    end
  end

end
