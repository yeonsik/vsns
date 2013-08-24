BigPie::Application.routes.draw do

  root 'items#index'
  get 'users/:id/follow/:other_id' => 'users#follow', as: :follow_user
  get 'users/:id/unfollow/:other_id' => 'users#unfollow', as: :unfollow_user
  resources :relationships, only: [:create, :destroy]
  resources :items
  devise_for :users
  resources :users do
    member do
      get :followings, :followers
    end
  end

end
