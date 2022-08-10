Rails.application.routes.draw do
  jsonapi_resources :users
  get '/confirmations/email/token', to: 'confirmations#email', param: :confirmation_token
  post '/auth/login', to: 'authentication#login'
  post '/auth/request-password-change', to: 'authentication#request_password_change'
  post '/auth/recover-password', to: 'authentication#recover_password'
end
