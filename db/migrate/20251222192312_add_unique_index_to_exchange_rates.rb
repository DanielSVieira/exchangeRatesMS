class AddUniqueIndexToExchangeRates < ActiveRecord::Migration[7.0]
  def change
    add_index :exchange_rates, [:currency_from, :currency_to], unique: true
  end
end
