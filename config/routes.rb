RedditClone::Application.routes.draw do
  root to: 'users#new'
  resource :session, only: [:new, :create, :destroy]

  resources :users, only: [:new, :create, :show]
  resources :subs, except: [:destroy] do
    resources :posts, only: [:index]
  end
  resources :posts, except: [:index, :destroy] do
    resources :comments, only: [:new]
  end
  resources :comments, only: [:create, :show]
end
