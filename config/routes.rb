Rails.application.routes.draw do
  namespace :v1 do
    resources :products, :except => [:new, :edit]

    resources :orders, :except => [:new, :edit, :destroy] do
      resources :status_transitions, :only => [:index, :create]
      resources :line_items, :except => [:new, :edit]
    end
  end
end
