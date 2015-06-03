Bullcentury::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get '/:locale' => 'home#index'
  #get "home/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root  to: 'home#index'

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

  scope '(:locale)', locale: /ru|ua|en|hu/ do
    root  to: 'home#index'
    get 'how_it_works', :to => 'home#how_it_works'
    get 'quick_start', :to => 'home#quick_start'
    get 'university', :to => 'home#university'
    get 'faq', :to => 'home#faq'
    get 'rules', :to => 'home#rules'
    #TODO
    get 'company', :to => 'home#company', :as =>  :company
    get 'mentors', :to => 'home#mentors'
    # get 'feedback',:to => 'home#feedback'
    match '/feedbacks',     to: 'feedbacks#new', via: 'get'
    resources "feedbacks", only: [:new, :create]
    #end TODO 

    get 'receive_money', to: 'profiles#receive_money', as: 'receive_money'
    get 'receive_money_success', to: 'profiles#receive_money_success', as: 'receive_money_success' #temp
    get 'invest_project', to: 'profiles#invest_project', as: 'invest_project'
    get 'refunds', to: 'profiles#refunds', as: 'refunds'
    get 'activities_report', to: 'profiles#activities_report', as: 'activities_report'
    get 'my_project', to: 'profiles#my_project', as: 'my_project'
    get 'promote_project', to: 'profiles#promote_project', as: 'promote_project'
    get 'shipping', to: 'profiles#shipping', as: 'shipping'
    get 'profile_management', to: 'profiles#profile_management', as: 'profile_management'
    get 'update_cities', to: 'profiles#update_cities', as: 'update_cities'
    get 'receive_money_part2', to: 'profiles#receive_money_part2', as: 'receive_money_part2'

    get 'success', to: 'profiles#success'
    
    #get 'projects/start', :to => 'projects#start'
    #resources :profiles, :only =>[:edit, :update]
    get  'dashboard', to: 'profiles#dashboard', as: 'dashboard'
    get  'profiles/:id', :to => 'profiles#show', :as =>  :profile
    get  'profiles/:id/edit', :to => 'profiles#edit', :as =>  :edit_profile
    post 'profiles/update', :to => 'profiles#update'
    get 'categories/:key', :to => 'categories#show', :as => :category


    resources :pledge_transactions
    resources :projects do
      resources :rewards
      resources :authors

      member do
       get 'publish'
       get 'stop'
       get 'agreement_page'
     end
      collection do
        get 'leisure'
        get 'media'
        get 'art'
        get 'crazy'
        get 'innovation'
        get 'social'
      end
    end
    namespace :api, defauts: {format: :json} do
      resources :projects, only: [:index, :show, :update] do
        resources :rewards, only: [:index, :show, :update, :create, :destroy]
      end
      resources :currencies, only: [:index]
      resources :categories, only: [:index]
      resources :cities, only: [:show, :index]
      resources :countries, only: [:index]
      resources :profiles, only: [:show, :update]
    end

  end

  devise_for :users, :controllers => {  confirmations: 'confirmations', :omniauth_callbacks => "users/omniauth_callbacks" }
end
