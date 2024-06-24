Rails.application.routes.draw do
  resources :messages
  resources :conversations
  root to: "conversations#new"

  get "up" => "rails/health#show", as: :rails_health_check
end
