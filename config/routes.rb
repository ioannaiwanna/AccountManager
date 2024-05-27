Rails.application.routes.draw do
 get 'accounts/vat_lookup', to: 'accounts#vat_lookup'
 resources :accounts
 root 'accounts#index'
end
