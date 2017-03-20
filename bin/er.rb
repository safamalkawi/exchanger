#!/usr/bin/env ruby

require "bundler/setup"
require 'commander/import'
require "Cringle"

never_trace!

program :name, 'er'
program :version, '0.0.1'
program :description, 'Convert currencies'

global_option '-b', '--base BASE_CURRENCY', String, 'Specify base currency'
global_option '-t', '--target TARGET_CURRENCY', String, 'Specify target currency'
global_option '-o', '--output OUTPUT', String, '[Optional] Specify output destination It should be -o stdout to print output on console or -o sms to send a sms of the result. Default is sms'

command :exchange do |c|
  c.syntax = 'exchange --base=X --target=Y'
  c.description = 'Show exchange rate between base and target currencies'
  c.option '-d', '--date DATE', String, '[Optional] A specific date to feth the currencies. Default is date = Date.today'
  c.option '-a', '--amount AMOUNT', Float, '[Optional] Specify an amount for conversion. Default is amount = 1'
  c.action do |args, options|
    options.default :amount => 1, :date => '', :output => 'sms'

    # Inject outputer dependency
    outputer = getOutputer(options.output)

    app = Cringle::Application.new(outputer)
    app.exchange(options.base, options.target, options.amount, options.date)
  end
end

command :report_best do |c|
  c.syntax = 'report_best --base=X --target=Y'
  c.description = 'Show the best exchange rates for the last 7 days'
  c.action do |args, options|
    options.default :output => 'stdout'
    outputer = getOutputer(options.output)
    app = Cringle::Application.new(outputer)
    app.reportBestRate(options.base, options.target, nil)
  end
end

def getOutputer(outputName)
  case outputName
    when "stdout"
      Cringle::StdOutput.new()
    when "sms"
      Cringle::SMSOutput.new()
    else
      raise 'No such outputer exists'
  end
end
