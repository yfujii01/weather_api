Rails.application.routes.draw do
  get 'weather/sample'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'weather#home'

  # weather_today_url
  get 'weather/today'

  # weather_tommorow_url
  get 'weather/tommorow'
end
