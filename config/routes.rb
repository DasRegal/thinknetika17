Rails.application.routes.draw do
  concern :voteable do 
    member do 
      post :vote_up
      post :vote_down
      delete :vote_delete
    end
  end

  devise_for :users
  resources :questions, concerns: [:voteable] do 
    resources :answers, concerns: [:voteable] do 
      patch 'set_as_best', on: :member
    end
  end

  delete '/attachment/:id', to: 'attachments#destroy', as: :destroy_attachment

  root to: 'questions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
