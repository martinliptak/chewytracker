class AuthenticatedConstraints
  def matches?(request)
    request.session['user_id'].present?
  end
end

class UnauthenticatedConstraints
  def matches?(request)
    request.session['user_id'].nil?
  end
end

Rails.application.routes.draw do
  constraints UnauthenticatedConstraints.new do
    resources :users, only: [:new, :create]

    get "/sign_in" => "sessions#new"
    post "/sign_in" => "sessions#create"

    root 'welcome#index', as: :welcome
  end
  
  constraints AuthenticatedConstraints.new do
    resources :users, except: [:new, :create]

    get "/settings" => "users#settings"

    resources :meals do
      get :filter, on: :collection
      get :filter_all, on: :collection
    end

    delete "/sign_out" => "sessions#destroy"

    root 'meals#dashboard', as: :dashboard
  end

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resource :session
      resources :access_tokens, only: [:show, :create, :destroy], param: :name
      resources :users
      resources :meals
    end
  end
end
