# app/controllers/exchange_rates_controller.rb
class ExchangeRatesController < ApplicationController
  def index
    rates = ExchangeRate.all
    render json: rates
  end
end
