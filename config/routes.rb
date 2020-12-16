Rails.application.routes.draw do
  resources :comments
  resources :authors
  resources :posts
  get 'serwis', to: 'posts#serwis'
end
