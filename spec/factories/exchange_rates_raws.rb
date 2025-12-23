# spec/factories/exchange_rates_raws.rb
FactoryBot.define do
  factory :exchange_rates_raw do
    currency_from { "USD" }
    fetched_at { Time.current }
    created_at { Time.current }
    updated_at { Time.current }
    rates { [{ "to" => "EUR", "rate" => 0.92 }, { "to" => "GBP", "rate" => 0.78 }] }
  end
end
