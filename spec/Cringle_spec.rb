require "spec_helper"
require "Cringle"

class TestOutputer < Cringle::Output
  attr_reader :last_msg
  def initialize
    @last_msg = nil
  end

  def print(msg)
    @last_msg = msg
  end
end

RSpec.describe Cringle do
  it "should Check Best Rate" do
    outputer = TestOutputer.new()
    app = Cringle::Application.new(outputer)
    app.reportBestRate("EUR", "JOD,AED,JPY", Date.parse("2017-03-19"))
    expect(outputer.last_msg).to eq("Highest exchange rate among the last 7 days for \nAED = 3.956680361296885 EUR has been recorded on 2017-03-17\nJOD = 0.7633899758754705 EUR has been recorded on 2017-03-17\nJPY = 122.43234711272108 EUR has been recorded on 2017-03-20\n")
  end

  it "should return rates for specified Base, Targets and amount 0" do
    outputer = TestOutputer.new()
    app = Cringle::Application.new(outputer)
    app.exchange("EUR", "AED,JPY,JOD",0 ,Date.parse("2005-01-01"))
    expect(outputer.last_msg).to eq("Date:2005-01-01\n1 EUR = 4.988630497976039 AED\n1 EUR = 0.9630932652340461 JOD\n1 EUR = 139.43630090467008 JPY\n")
  end

  it "should return rates for specified Base,Targets and handling negative amount" do
    outputer = TestOutputer.new()
    app = Cringle::Application.new(outputer)
    app.exchange("EUR", "AED,JPY,JOD",-10 ,Date.parse("2005-01-01"))
    expect(outputer.last_msg).to eq("Date:2005-01-01\n1 EUR = 4.988630497976039 AED\n1 EUR = 0.9630932652340461 JOD\n1 EUR = 139.43630090467008 JPY\n")
  end

  it "should return rates for specified Base, Targets and amount positive float number amount" do
    outputer = TestOutputer.new()
    app = Cringle::Application.new(outputer)
    app.exchange("EUR", "AED,JPY,JOD",30 ,Date.parse("2005-01-01"))
    expect(outputer.last_msg).to eq("Date:2005-01-01\n30 EUR = 149.65891493928117 AED\n30 EUR = 28.892797957021383 JOD\n30 EUR = 4183.089027140102 JPY\n")
  end
#
#  it "should return runtime error for unavailable date" do
#    outputer = TestOutputer.new()
#    app = Cringle::Application.new(outputer)
#    app.exchange("EUR", "AED,JPY,JOD",30 ,Date.parse("1000-01-01"))
#    expect().to raise_error("No data available for specified date. Date shoulf be in format YYY-MM-DD.\n Current day rates might be unavailable yet")
#  end

end

