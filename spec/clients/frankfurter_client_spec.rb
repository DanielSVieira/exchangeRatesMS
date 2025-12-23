# spec/clients/frankfurter_client_spec.rb
require "rails_helper"

RSpec.describe FrankfurterClient do
  describe ".latest_rates" do
    let(:response_body) do
      {
        "base" => "USD",
        "date" => "2025-12-22",
        "rates" => { "EUR" => 0.92, "GBP" => 0.78 },
      }.to_json
    end

    before do
      stub_request(:get, "https://api.frankfurter.app/latest")
        .with(query: { from: "USD" })
        .to_return(status: 200, body: response_body, headers: { "Content-Type" => "application/json" })
    end

    it "fetches the latest rates from Frankfurter" do
      result = FrankfurterClient.latest_rates(from: "USD")

      expect(result["base"]).to eq("USD")
      expect(result["rates"]["EUR"]).to eq(0.92)
      expect(result["rates"]["GBP"]).to eq(0.78)
    end
  end
end
