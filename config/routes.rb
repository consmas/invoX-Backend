Rails.application.routes.draw do
  
  # Devise users
  devise_for :users,
    controllers: {
      sessions:      'users/sessions',
      registrations: 'users/registrations'
    },
    defaults: { format: :json }

  # Non-API user endpoint
  namespace :users do
    get 'me', to: 'me#show'
  end

  # JSON API v1
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :buyers, only: %i[index show create update destroy] do
        resources :programmes, only: %i[index show create update destroy]

        # ✱ keep this – buyer-scoped invoices
        resources :invoices, only: %i[index create]
      end

      # ✱ add programme-scoped invoices (optional, gives old behaviour)
      resources :programmes, only: [] do
        resources :invoices, only: %i[index create]
      end

      # ✱ flat routes for show / update / destroy
      resources :invoices, only: %i[show update destroy]

      resources :users,     only: %i[index show create update]
      resources :suppliers, only: %i[index show create update destroy]
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
