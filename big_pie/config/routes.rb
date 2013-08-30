BigPie::Application.routes.draw do

  root 'items#index'

  get 'users/:id/like/:item_id' => 'users#like', as: :like_item
  get 'users/:id/dislike/:item_id' => 'users#dislike', as: :dislike_item

  get 'users/:id/follow/:other_id' => 'users#follow', as: :follow_user
  get 'users/:id/unfollow/:other_id' => 'users#unfollow', as: :unfollow_user
  get 'tags/:tag', to: 'items#index', as: :tag

  get 'communities/:community_id', to: 'items#index', as: :community
  post 'communities/:community_id/join' => 'communities#join'
  resources :communities, only: [:create]
  resources :relationships, only: [:create, :destroy]
  resources :items do
    resources :comments
  end
  devise_for :users
  resources :users do
    member do
      get :followings, :followers
    end
  end

end
