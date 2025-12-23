class CreateExchangeRatesRaws < ActiveRecord::Migration[8.1]
  def change
    create_table :exchange_rates_raws do |t|
      t.string :currency_from
      t.datetime :fetched_at

      t.timestamps
    end
  end
end
