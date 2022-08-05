Rails.application.routes.draw do
  jsonapi_resources :users
  post '/confirmations/email/token', to: 'confirmations#email', param: :confirmation_token
end
