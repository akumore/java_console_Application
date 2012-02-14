AlfredMueller::Application.routes.draw do

  devise_for :users, :class_name => 'Cms::User'

  resources :real_estates, :only=> [:index, :show]

  namespace :cms do
    resource :dashboards
    resources :real_estates do
      resource :address
      resource :pricing
      resource :figure
      resource :information
      resource :infrastructure
      resource :description
      resources :media_assets
      resources :images, :controller => :media_assets, :media_type => :image, :only => :new
      resources :videos, :controller => :media_assets, :media_type => :video, :only => :new
      resources :documents, :controller => :media_assets, :media_type => :document, :only => :new
    end

    resources :jobs
    resources :pages do
      Brick::Base::TYPES.each do |type|
        resources "#{type}_bricks", :controller => :bricks, :type => type, :except => :index
      end
    end
  end

  scope '/:locale' do
    match '/:name' => 'pages#show'
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  root :to => 'homepage#index'
end
