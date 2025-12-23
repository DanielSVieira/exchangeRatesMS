require "rails_helper"

RSpec.describe "Api::ExchangeRates", type: :request do
  let!(:usd_eur) { ExchangeRate.create!(currency_from: "USD", currency_to: "EUR", rate: 0.92) }
  let!(:usd_gbp) { ExchangeRate.create!(currency_from: "USD", currency_to: "GBP", rate: 0.78) }

  before { Rails.cache.clear }

  describe "GET /api/exchange_rates" do
    context "when 'from' param is missing" do
      it "returns 400" do
        get "/api/exchange_rates"
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to eq("Parameter 'from' is required")
      end
    end

    context "when currency is unknown" do
      it "returns 404" do
        get "/api/exchange_rates", params: { from: "XYZ" }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Unknown or unsupported currency: XYZ")
      end
    end

    context "when currency exists" do
      it "returns 200 with normalized data" do
        get "/api/exchange_rates", params: { from: "USD" }
        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)
        expect(body["from"]).to eq("USD")
        expect(body["rates"]).to match_array([
          a_hash_including("from" => "USD", "to" => "EUR", "rate" => 0.92),
          a_hash_including("from" => "USD", "to" => "GBP", "rate" => 0.78),
        ])
      end
    end
  end
end
