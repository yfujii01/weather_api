# README

## URL

https://f01weather.herokuapp.com/

## doc

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## heroku

- 環境構築

以下のビルドパックを追加する必要がある
```
$ heroku buildpacks:set heroku/ruby
$ heroku buildpacks:add https://github.com/heroku/heroku-buildpack-chromedriver.git
$ heroku buildpacks:add https://github.com/heroku/heroku-buildpack-google-chrome.git
```