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
    resources :comments, only: [:create], defaults: { commentable: 'questions' }
    resources :answers do 
      patch 'set_as_best', on: :member
    end
  end

  resources :answers, concerns: [:voteable], only: [:vote_up, :vote_down, :vote_delete] do
    resources :comments, only: [:create], defaults: { commentable: 'answers' }
  end
  
  delete '/attachment/:id', to: 'attachments#destroy', as: :destroy_attachment

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
