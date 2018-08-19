class WeatherController < ApplicationController


  def today
    @tenki = today_weather
  end

  def tommorow
    @tenki = tommorow_weather
  end

  def sample
    @tenki = Tenki.new
    @tenki.aaa = 'あいうえお'
    @tenki.day = '２月１２日'
    @tenki.tenki = 'いかずち'
    @tenki.max = '猛暑'
    @tenki.min = '極寒'
  end

  private

  def today_weather
    css_day = '#main-column > section > div.forecast-days-wrap.clearfix > section.today-weather > h3'
    css_tenki = '#main-column > section > div.forecast-days-wrap.clearfix > section.today-weather > div.weather-wrap.clearfix > div.weather-icon > p'
    css_max = '#main-column > section > div.forecast-days-wrap.clearfix > section.today-weather > div.weather-wrap.clearfix > div.date-value-wrap > dl > dd.high-temp.temp'
    css_min = '#main-column > section > div.forecast-days-wrap.clearfix > section.today-weather > div.weather-wrap.clearfix > div.date-value-wrap > dl > dd.low-temp.temp'

    get_weather(css_day, css_max, css_min, css_tenki)
  end

  def tommorow_weather
    css_day = '#main-column > section > div.forecast-days-wrap.clearfix > section.tomorrow-weather > h3'
    css_tenki = '#main-column > section > div.forecast-days-wrap.clearfix > section.tomorrow-weather > div.weather-wrap.clearfix > div.weather-icon > p'
    css_max = '#main-column > section > div.forecast-days-wrap.clearfix > section.tomorrow-weather > div.weather-wrap.clearfix > div.date-value-wrap > dl > dd.high-temp.temp'
    css_min = '#main-column > section > div.forecast-days-wrap.clearfix > section.tomorrow-weather > div.weather-wrap.clearfix > div.date-value-wrap > dl > dd.low-temp.temp'

    get_weather(css_day, css_max, css_min, css_tenki)
  end

  def get_weather(css_day, css_max, css_min, css_tenki)
    require 'selenium-webdriver'
    driver = Selenium::WebDriver.for :chrome, options: headless_chrome_options

    tenki = Tenki.new

    begin
      # Rakuten Infoseek 岡山市北区の天気
      driver.navigate.to 'https://infoseek.tenki.jp/forecast/7/36/6610/33101/'

      # 日付
      tenki.day = driver.find_element(:css, css_day).text

      # 天気
      tenki.tenki = driver.find_element(:css, css_tenki).text

      # 最高
      tenki.max = driver.find_element(:css, css_max).text

      # 最低
      tenki.min = driver.find_element(:css, css_min).text

    rescue => e
      puts 'エラー発生'
      puts e.message
      @error_message = 'エラー発生'
    end

    driver.quit

    # 戻り値
    tenki
  end

  def headless_chrome_options
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-gpu')
    options.add_argument('--hide-scrollbars')
    options.binary = '/app/.apt/usr/bin/google-chrome' if heroku?
    options
  end

  def heroku?
    Rails.env.production?
  end

end
