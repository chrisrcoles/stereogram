Rails.application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root 'snippets#following'

  get '/callback', to: "pages#callback"

  resources :users do
    get 'following','followers', on: :member
  end

  resources :users, only: [:show]
  resources :tracks, only: [:index, :new, :create, :show, :destroy]
  resources :snippets, only: [:index, :show, :create, :destroy]

  post "tracks/upload", :as => :upload

  post "/share", to: 'facebook#post_to_facebook'

  resources :votes, only: [:create]
  resources :follows, only: [:create, :destroy]
end
