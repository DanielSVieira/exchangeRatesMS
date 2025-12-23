class AddRatesToExchangeRatesRaw < ActiveRecord::Migration[8.1]
  def change
    add_column :exchange_rates_raws, :rates, :jsonb
  end
end
