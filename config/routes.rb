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
  resources :users
  resources :meals

  get "/settings" => "users#settings"

  constraints UnauthenticatedConstraints.new do
    get "/sign_in" => "sessions#new"
    post "/sign_in" => "sessions#create"

    root 'welcome#index', as: :welcome, via: :get
  end

  constraints AuthenticatedConstraints.new do
    delete "/sign_out" => "sessions#destroy"

    root 'dashboard#index', as: :dashboard, via: :get
  end

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :access_tokens, only: [:show, :create, :destroy], param: :name
      resources :users, only: [:index, :show, :create, :update, :destroy]
      resources :meals, only: [:index, :show, :create, :update, :destroy]
    end
  end

  get '/angular' => 'angular#index', as: :angular
end
