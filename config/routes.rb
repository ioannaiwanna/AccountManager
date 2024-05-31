Rails.application.routes.draw do
 get 'accounts/vat_lookup', to: 'accounts#vat_lookup', defaults: { format: :json }
 resources :accounts
 root 'accounts#index'
end
