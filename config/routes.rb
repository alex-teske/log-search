Rails.application.routes.draw do
  get 'logs/search', to: 'logs#show'
end
