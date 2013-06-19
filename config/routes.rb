Graduation::Application.routes.draw do
  
  # scope "/:l", constraints: {l: /ar|en/} do
    devise_for :users
    resources :clients, except:[:edit] do
      collection do 
        get "/" => "clients#index"
        get "/page/:page" => "clients#index", as:"page"
        # post "/new_group" => "clients#create_group", as: "new_group"
        get "/search" => "clients#search", as:"search"
      end
      resources :plans, except:[:edit] do 
        post '/create' => 'plans#create_payment', as: 'new_payment'
        delete '/destroy/:id' => 'plans#destroy_payment', as: 'delete_payment'
        # get '/payments' => 'plans#payments', as:'payments'
        # get "/tmp" => "plans#tmp", as: "tmp"
      end
    end

    resources :groups do
      delete '/remove/:client_id' => 'groups#remove', as: 'remove'
      get '/add/:client_id' => 'groups#add', as:'add'
      get "/search_clients" => 'groups#search_clients', as: 'search_clients'
    end
    namespace :api do 
      get "clients.:format" => "main#clients"
      get "group_paid_sum/:group.:format" => "main#group_paid_sum"
      get "group_profit/:group.:format" => "main#group_profit"
      get "group_remaining/:group.:format" => "main#group_remaining"
      # get "search_clients.:format" => "main#search_clients", as: "search_clients"
    end

    get "/change_locale/:new_locale" => "application#change_locale", as: "change_locale"

  # end
  get '/' => "clients#index"
    root :to => "clients#index"

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
