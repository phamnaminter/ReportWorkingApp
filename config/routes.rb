Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "sessions#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout" ,to: "sessions#destroy"
    resources :users
    resources :departments do
      resources :reports, only: %i(new index show)
    end
    resources :reports, only: %i(index create update destroy)
    resources :relationships, only: %i(new create destroy update)
  end
end
