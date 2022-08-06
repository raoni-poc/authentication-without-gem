Rails.application.routes.draw do
  jsonapi_resources :users
  get '/confirmations/email/token', to: 'confirmations#email', param: :confirmation_token
  post '/auth/login', to: 'authentication#login'
end
