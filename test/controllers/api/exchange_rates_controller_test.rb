require "test_helper"

class Api::ExchangeRatesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_exchange_rates_index_url
    assert_response :success
  end
end
