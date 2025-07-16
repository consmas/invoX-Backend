Rails.application.routes.draw do
  # ─── Authentication ──────────────────────────────────────────────────────────
  devise_for :users,
             defaults: { format: :json },
             controllers: {
               sessions:      'users/sessions',
               registrations: 'users/registrations'
             }

  # ─── Current‐User Endpoint ────────────────────────────────────────────────────
  namespace :users, defaults: { format: :json } do
    resource :me, only: [:show]
  end

  # ─── JSON API v1 ──────────────────────────────────────────────────────────────
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # Buyers with nested programmes & buyer‐scoped invoices
      resources :buyers, only: %i[index show create update destroy] do
        resources :programmes, only: %i[index show create update destroy]
        resources :invoices,  only: %i[index create]
      end

      # Legacy programme‐scoped invoices (optional)
      resources :programmes, only: [] do
        resources :invoices, only: %i[index create]
      end

      # Invoice routes + nested bids (CRUD + accept/reject)
      resources :invoices, only: %i[index show update destroy] do
        resources :bids, only: %i[index show create update destroy] do
          member do
            patch :accept
            patch :reject
          end
        end
      end

      # Top-level bids index for financers & platform_ops
      resources :bids, only: [:index]

      # Financers resource + portfolio action
      resources :financers, only: %i[index show create update destroy] do
        member do
          get :portfolio
          get :opportunities
        end

        # This gives you GET /api/v1/financers/:financer_id/bids
        resources :bids, only: [:index]

      end

      # Other resources
      resources :users,     only: %i[index show create update]
      resources :suppliers, only: %i[index show create update destroy]
    end
  end

  # ─── Health Check ─────────────────────────────────────────────────────────────
  get 'up', to: 'rails/health#show', as: :rails_health_check
end
