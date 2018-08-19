class WeatherController < ApplicationController

  def today
    @message = today_weather
  end

  def tommorow
    @message = tommorow_weather
  end

  private

  def today_weather
    require 'selenium-webdriver'
    driver = Selenium::WebDriver.for :chrome, options: headless_chrome_options

    begin
      # Rakuten Infoseek 岡山市北区の天気
      driver.navigate.to 'https://infoseek.tenki.jp/forecast/7/36/6610/33101/'
      tenki_element = driver.find_element(:css, '#main-column > section > div.forecast-days-wrap.clearfix > section.today-weather > div.weather-wrap.clearfix > div.weather-icon > p')
      tenki_text = '本日の天気は、' + tenki_element.text + ''
      puts tenki_text
      message = tenki_text

    rescue => e
      puts 'エラー発生'
      puts e.message
      message = 'エラー発生'
    end

    driver.quit

    # 戻り値
    message
  end

  def tommorow_weather
    require 'selenium-webdriver'
    driver = Selenium::WebDriver.for :chrome, options: headless_chrome_options

    begin
      # Rakuten Infoseek 岡山市北区の天気
      driver.navigate.to 'https://infoseek.tenki.jp/forecast/7/36/6610/33101/'
      tenki_element = driver.find_element(:css, '#main-column > section > div.forecast-days-wrap.clearfix > section.tomorrow-weather > div.weather-wrap.clearfix > div.weather-icon > p')
      tenki_text = '明日の天気は、' + tenki_element.text + ''
      puts tenki_text
      message = tenki_text

    rescue => e
      puts 'エラー発生'
      puts e.message
      message = 'エラー発生'
    end

    driver.quit

    # 戻り値
    message
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
