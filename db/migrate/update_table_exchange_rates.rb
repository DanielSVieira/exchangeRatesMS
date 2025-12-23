create_table :exchange_rates, id: false do |t|
  t.string :currency_from, null: false
  t.string :currency_to, null: false
  t.decimal :rate, precision: 12, scale: 6, null: false
  t.datetime :fetched_at, null: false
end

add_index :exchange_rates, [:currency_from, :currency_to], unique: true
