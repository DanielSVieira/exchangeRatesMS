module Api
  class ExchangeRatesController < ApplicationController
    protect_from_forgery with: :null_session

    before_action :validate_currency_param!
    before_action :validate_currency_exists!

    def index
      currency = params[:from].upcase # We know it's present because of before_action

      payload = Rails.cache.fetch("exchange_rates/#{currency}", expires_in: 5.minutes) do
        ExchangeRate.where(currency_from: currency).map do |rate|
          {
            from: rate.currency_from,
            to: rate.currency_to,
            rate: rate.rate.to_f,
            updated_at: rate.updated_at,
          }
        end
      end

      render json: { from: currency, rates: payload }
    end

    private

    def validate_currency_param!
      unless params[:from].present?
        render json: { error: "Parameter 'from' is required" }, status: :bad_request
      end
    end

    def validate_currency_exists!
      currency = params[:from].presence&.upcase
      unless ExchangeRate.exists?(currency_from: currency)
        render json: { error: "Unknown or unsupported currency: #{currency}" }, status: :not_found
      end
    end
  end
end
