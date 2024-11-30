# config/initializers/stripe.rb
Rails.configuration.stripe = {
  publishable_key: ENV['pk_test_51Q8Pp1Rwv5wayz87gzmJP4I04D7GIMzEbdUhp2HcsksEWiaJ39d5BRV3BysSJJe86cP7HkjlTY2OFr11MpY56b8R00VDiWLCiz'],
  secret_key: ENV['sk_test_51Q8Pp1Rwv5wayz87A51dCZxirLsLfnFRA2Fe5W24nTmTsxHEaLPHwn5hIaHBJgCUripYkwmRsI97UDuRpsahKqAv008gbyOzc5']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
