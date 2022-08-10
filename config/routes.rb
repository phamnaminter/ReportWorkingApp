require "sidekiq/web"

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "departments#index"
    resources :departments do
      resources :reports
    end
    resources :reports do
      member do
        put :approve
      end
    end
    resources :relationships, only: %i(new create destroy update)
    resources :comments
    resources :notifies, only: :show
    devise_for :users
    resources :users
    mount Sidekiq::Web => "/sidekiq"
    get "charts", to: "chart#index"
  end
end
