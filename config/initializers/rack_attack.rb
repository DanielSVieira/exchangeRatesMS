# config/initializers/rack_attack.rb
class Rack::Attack
  throttle("exchange_rates/ip", limit: 60, period: 1.minute) do |req|
    if req.path.start_with?("/api/exchange_rates")
      req.ip
    end
  end
end
