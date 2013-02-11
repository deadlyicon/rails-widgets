Rails.application.routes.draw do
  namespace :development do
    resources :widgets, only: [:index, :show]
  end
end
