Rails.application.routes.draw do
  resource :users
  
  root 'welcome#index'
end
