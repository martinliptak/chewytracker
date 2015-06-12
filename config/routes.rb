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

    resources :meals, except: :index do
      post :filter, on: :collection
    end

    delete "/sign_out" => "sessions#destroy"

    root 'meals#index', as: :dashboard
  end
end
