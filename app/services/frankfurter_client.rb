# app/clients/frankfurter_client.rb
require "faraday"
require "json"

class FrankfurterClient
  API_BASE = "https://api.frankfurter.app"

  def self.latest_rates(from:)
    response = Faraday.get("#{API_BASE}/latest", { from: from }) do |req|
      req.headers["Accept"] = "application/json"
      req.headers["User-Agent"] = "ExchangeRatesMS/1.0"
      req.options.timeout = 5       # read timeout
      req.options.open_timeout = 2  # connection timeout
    end

    if response.status == 200
      JSON.parse(response.body)
    else
      raise "API returned status #{response.status} for #{from}"
    end
  rescue Faraday::TimeoutError
    raise "API request timed out for #{from}"
  rescue Faraday::ConnectionFailed => e
    raise "Connection failed for #{from}: #{e.message}"
  end
end
