class WeatherController < ApplicationController


  def today
    @tenki = today_weather
  end

  def tommorow
    @tenki = tommorow_weather
  end

  def sample
    @tenki = Tenki.new
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
    css_rainAM = '#main-column > section > div.forecast-days-wrap.clearfix > section.today-weather > div.precip-table > table > tbody > tr.rain-probability > td:nth-child(3)'
    css_rainPM = '#main-column > section > div.forecast-days-wrap.clearfix > section.today-weather > div.precip-table > table > tbody > tr.rain-probability > td:nth-child(4)'
    css_maxdif = '#main-column > section > div.forecast-days-wrap.clearfix > section.today-weather > div.weather-wrap.clearfix > div.date-value-wrap > dl > dd.high-temp.tempdiff'
    css_mindif = '#main-column > section > div.forecast-days-wrap.clearfix > section.today-weather > div.weather-wrap.clearfix > div.date-value-wrap > dl > dd.low-temp.tempdiff'

    tk = get_weather(css_day, css_max, css_min, css_tenki, css_rainAM, css_rainPM, css_maxdif, css_mindif)

    today = '今日'
    talktext = makeTalkText(tk, today)

    render :json => talktext
  end

  def makeTalkText(tk, today)
    talktext = 'ぴんぽん、' + today + 'の天気をお知らせします。'
    talktext += today + 'の天気は、' + tk.tenki + '。'
    talktext += tk.rain + '。'
    talktext += '気温は、' + tk.min + 'から' + tk.max + '。です。'
    talktext += '以上、' + today + 'の天気予報でした'
  end

  def tommorow_weather
    css_day = '#main-column > section > div.forecast-days-wrap.clearfix > section.tomorrow-weather > h3'
    css_tenki = '#main-column > section > div.forecast-days-wrap.clearfix > section.tomorrow-weather > div.weather-wrap.clearfix > div.weather-icon > p'
    css_max = '#main-column > section > div.forecast-days-wrap.clearfix > section.tomorrow-weather > div.weather-wrap.clearfix > div.date-value-wrap > dl > dd.high-temp.temp > span.value'
    css_min = '#main-column > section > div.forecast-days-wrap.clearfix > section.tomorrow-weather > div.weather-wrap.clearfix > div.date-value-wrap > dl > dd.low-temp.temp > span.value'
    css_rainAM = '#main-column > section > div.forecast-days-wrap.clearfix > section.tomorrow-weather > div.precip-table > table > tbody > tr.rain-probability > td:nth-child(3)'
    css_rainPM = '#main-column > section > div.forecast-days-wrap.clearfix > section.tomorrow-weather > div.precip-table > table > tbody > tr.rain-probability > td:nth-child(4)'
    css_maxdif = '#main-column > section > div.forecast-days-wrap.clearfix > section.tomorrow-weather > div.weather-wrap.clearfix > div.date-value-wrap > dl > dd.high-temp.tempdiff'
    css_mindif = '#main-column > section > div.forecast-days-wrap.clearfix > section.tomorrow-weather > div.weather-wrap.clearfix > div.date-value-wrap > dl > dd.low-temp.tempdiff'

    tk = get_weather(css_day, css_max, css_min, css_tenki, css_rainAM, css_rainPM, css_maxdif, css_mindif)

    today = '明日'
    talktext = makeTalkText(tk, today)

    render :json => talktext
  end

  def get_weather(css_day, css_max, css_min, css_tenki, css_rainAM, css_rainPM, css_maxdif, css_mindif)
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
      tenki.tenki = tenki.tenki.sub(/雨/, 'あめ')

      # 最高
      tenki.max = driver.find_element(:css, css_max).text
      tenki.max = tenki.max.sub(/℃/, '度')

      # 最低
      tenki.min = driver.find_element(:css, css_min).text
      tenki.min = tenki.min.sub(/℃/, '度')

      # 降水確率(AM)
      rainAM = driver.find_element(:css, css_rainAM).text

      # 降水確率(PM)
      rainPM = driver.find_element(:css, css_rainPM).text
      if rainAM == rainPM
        if rainAM == '---'
          tenki.rain = '降水確率は0%'
        else
          tenki.rain = '降水確率は、' + rainAM
        end
      else
        tenki.rain = '降水確率は、午前中が、' + rainAM + '、午後が、' + rainPM
      end

      # 前日との差(最高気温)
      tenki.maxdif = driver.find_element(:css, css_maxdif).text

      # 前日との差(最低気温)
      tenki.mindif = driver.find_element(:css, css_mindif).text

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
