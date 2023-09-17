Rails.application.routes.draw do
  root 'logs#show'

  get 'logs', to: 'logs#show'
  get 'logs/search', to: 'logs#show_api'
end
