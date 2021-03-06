AlfredMueller::Application.routes.draw do

  devise_for :users, :class_name => 'Cms::User'

  namespace :api do
    resources :real_estates, :only=>:index
  end

  namespace :cms do
    resource :dashboards
    resources :news_items, :except => :show

    resources :gallery_photos, :except => :show do
      post :sort, :on => :collection
    end

    resources :reference_projects, :except => :show do
      post :sort, :on => :collection
    end

    resources :real_estate_categories, only: :index

    resources :real_estates do
      get :copy, :on => :member
      resource :address
      resource :pricing, :except=>:destroy
      resource :figure, :except=>:destroy
      resource :information
      resources :media_assets, :only => :index
      resources :image_croppings
      resources :images, :except => :index
      resources :floor_plans, :except => :index
      resources :videos, :except => :index
      resources :documents, :except => :index
    end


    resources :jobs do
      post :sort, :on => :collection
    end

    resources :teasers do
      post :sort, :on => :collection
    end

    resources :pages do
      Brick::Base::TYPES.each do |type|
        resources "#{type}_bricks", :controller => :bricks, :type => type, :except => :index
      end

      post :sort, on: :collection
    end

    resources :employees
    resources :users
  end

  scope ':locale', locale: /#{I18n.available_locales.join('|')}/ do
    resources :real_estates, :only => [:index, :show] do
      resources :appointments, :only => [:new, :create]
      resources :handout_orders, :only => [:new, :create]
      resources :floorplans, :only => [:index, :show]

      get 'Printout_*name', to: 'handouts#show', as: :printout
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
    resources :reference_projects, :only => :index
  end

  scope ':locale' do
    match '/:name' => 'pages#show'
  end

  match '/eingabetool' => 'cms/dashboards#show'
  match '/cms' => 'cms/dashboards#show'

  root :to => 'homepage#index'

end
