AlfredMueller::Application.routes.draw do

  devise_for :users, :class_name => 'Cms::User'

  namespace :api do
    resources :real_estates, :only=>:index
  end

  namespace :cms do
    resource :dashboards
    resources :news_items, :except => :show
    resources :reference_projects, :except => :show do
      post :sort, :on => :collection
    end

    namespace :preview do
      resources :real_estates, :only => :show
    end

    resources :real_estates do
      get :copy, :on => :member
      resource :address
      resource :pricing, :except=>:destroy
      resource :figure, :except=>:destroy
      resource :information
      resource :infrastructure, :except=>:destroy
      resource :additional_description, :except=>:destroy

      resources :media_assets, :only => :index
      resources :images, :except => :index
      resources :floor_plans, :except => :index
      resources :videos, :except => :index
      resources :documents, :except => :index
    end

    resources :jobs
    resources :pages do
      Brick::Base::TYPES.each do |type|
        resources "#{type}_bricks", :controller => :bricks, :type => type, :except => :index
      end
    end

    resources :employees
    resources :users
  end

  scope ':locale' do
    resources :real_estates, :only => [:index, :show] do
      resources :appointments, :only => [:new, :create]
      resources :floorplans, :only => [:index, :show]
      # TODO: Implement redirect for legacy deep-links to handouts
      # e.g.: /real_estates/123/A-Fine-Property.pdf -> /real_estates/123/handout.pdf
      resource :handout, :only => :show do
        member do
          get 'footer'
        end
      end
      match '*name' => 'handouts#deprecated_route', :as => :object_documentation
    end
    resource :job_application, :only => [:new, :create]
    resource :contact, :only => [:new, :create]
    resources :news_items, :only => :index
  end

  scope ':locale' do
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

  match '/eingabetool' => 'cms/dashboards#show'
  root :to => 'homepage#index'

end
