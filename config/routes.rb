Rails.application.routes.draw do

  resources :posts
  devise_for :users, controllers: {registrations: 'users/registrations'}

  get '/results' => 'results#index'
  get '/results/by_year_and_month/:year/:month' => 'results#by_year_and_month', :as=> :results_by_year_and_month
  get '/results/by_year_and_month/:year/:month/:day' => 'results#by_year_and_month_and_day', :as=> :results_by_year_and_month_and_day
  get '/results/admin' => 'results#admin'
  get '/results/by_sport/:sport' => 'results#by_sport', :as => :results_by_sport

  get '/payments' => 'payments#index'
  get '/payments/confirmation' => 'payments#confirmation'
  get '/payments/checkout', to: 'payments#checkout'
  get '/payments/success', to: 'payments#success'
  get '/payments/cancelled_payment', to: 'payments#cancelled_payment'

  resources :bets
  resources :contacts
  resource :package
  get '/bettingguide' => 'home#betting_guide'

  get '/analysis' => 'home#analysis'

  resources :meets

  # Mount route for Maktoub
  mount Maktoub::Engine => '/maktoub'

  root 'home#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
