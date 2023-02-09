Rails.application.routes.draw do

  root 'home#rankingslanding'
  get '/home' => 'home#index'
  get '/admin' => 'puppies#index'
  get '/admin/puppiesall' => 'puppies#puppiesall'
  get 'puppy/add' => 'puppies#add'
  get '/draft' => 'home#draft'
  get '/created' => 'home#created'
  get '/vote' => 'home#vote'
  post '/dovote' => 'home#dovote'
  get '/voted' => 'home#voted'
  get '/edit' => 'home#edit'
  get '/selfclose' => 'home#selfclose'
  get '/finalstats' => 'home#finalstats'
  #get '/edited' => 'home#edited'
  post '/createteam' => 'home#createteam'
  post '/editteam' => 'home#editteam'
  get '/rankings' => 'home#rankings'


  resources :users, only: :index
  scope '/admin' do
  resources :teams
  resources :puppies
  resources :settings
  end
  # root 'puppies#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
                                       :registrations => "registrations",
                                       :sessions => "sessions" }
                                       # do
    # get 'signout', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  # end

  # devise_scope :user do
  #   # get "/login" => "devise/sessions#new"
  #   delete "/logout" => "devise/sessions#destroy"
  # end

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
