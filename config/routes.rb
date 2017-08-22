Rails.application.routes.draw do
  devise_for :users
  resources :questions do 
    resources :answers do 
      patch 'set_as_best', on: :member
    end
  end

  delete '/attachment/:id', to: 'attachments#destroy', as: :destroy_attachment

  root to: 'questions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
