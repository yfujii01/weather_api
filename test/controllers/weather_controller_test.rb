require 'test_helper'

class WeatherControllerTest < ActionDispatch::IntegrationTest
  test "should get today" do
    get weather_today_url
    assert_response :success
  end

end
