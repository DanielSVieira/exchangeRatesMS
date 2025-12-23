# spec/factories/exchange_rates.rb
FactoryBot.define do
  factory :exchange_rate do
    currency_from { "USD" }
    currency_to { "EUR" }
    rate { 0.92 }
    fetched_at { Time.current }
  end
end
