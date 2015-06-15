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

    root 'welcome#index', as: :welcome
  end
  
  constraints AuthenticatedConstraints.new do
    delete "/sign_out" => "sessions#destroy"

    root 'dashboard#index', as: :dashboard
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
