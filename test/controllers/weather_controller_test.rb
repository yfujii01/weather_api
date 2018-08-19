require 'test_helper'

class WeatherControllerTest < ActionDispatch::IntegrationTest
  test "should get today" do
    get weather_today_url
    assert_response :success
  end

  test "should get tommorow" do
    get weather_tommorow_url
    assert_response :success
  end

  test "should get sample" do
    get weather_sample_url
    assert_response :success
  end

end
