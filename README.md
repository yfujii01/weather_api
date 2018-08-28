# README

## URL

https://f01weather.herokuapp.com/

## USAGE

- 今日の天気取得

curl https://f01weather.herokuapp.com/today 

- 明日の天気取得

curl https://f01weather.herokuapp.com/tommorow 

## heroku

- 環境構築

以下のビルドパックを追加する必要がある
```
$ heroku buildpacks:set heroku/ruby
$ heroku buildpacks:add https://github.com/heroku/heroku-buildpack-chromedriver.git
$ heroku buildpacks:add https://github.com/heroku/heroku-buildpack-google-chrome.git
```
