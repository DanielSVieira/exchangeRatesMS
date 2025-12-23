# app/jobs/fetch_exchange_rates_job.rb
class FetchExchangeRatesJob
  include Sidekiq::Job

  sidekiq_options queue: :exchange_rates, retry: 3

  CURRENCIES = %w[USD EUR GBP].freeze

  def perform
    CURRENCIES.each do |currency|
      fetch_and_process(currency)
    end
  end

  private

  def fetch_and_process(currency)
    max_attempts = 3
    attempt = 0

    begin
      attempt += 1
      Rails.logger.info("[#{currency}] Fetching exchange rates (attempt #{attempt})")

      data = FrankfurterClient.latest_rates(from: currency)
      save_raw(data)
      normalize_and_upsert(data)
    rescue => e
      Rails.logger.error("[#{currency}] Failed attempt #{attempt}: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))

      if attempt < max_attempts
        sleep_time = (2 ** attempt) + rand(0..1)
        Rails.logger.info("[#{currency}] Retrying in #{sleep_time}s...")
        sleep(sleep_time)
        retry
      else
        Rails.logger.error("[#{currency}] All attempts failed.")
      end
    end
  end

  def save_raw(data)
    ExchangeRatesRaw.create!(
      currency_from: data["base"].to_s.strip,
      rates: data["rates"],
      fetched_at: Time.current,
    )
  end

  def normalize_and_upsert(data)
    rates_hash = data["rates"] || {}
    return if rates_hash.empty?

    rows = rates_hash.map do |to_currency, rate|
      {
        currency_from: data["base"].to_s.strip,
        currency_to: to_currency.to_s.strip,
        rate: rate.to_f,
        fetched_at: Time.current,
      }
    end

    ExchangeRate.upsert_all(
      rows,
      unique_by: %i[currency_from currency_to],
    )
  rescue => e
    Rails.logger.error("Failed to upsert rates for #{data["base"]}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
  end
end
