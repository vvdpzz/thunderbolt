Thunderbolt::Application.routes.draw do
  
  match '/mail/to/:id' => 'mail#new', :via => 'get'
  match '/mail' => 'mail#create', :via => 'post'

  match '/free' => 'questions#free', :via => 'get', :as => :free_questions
  match '/watch' => 'questions#watch', :via => 'get', :as => :watch_questions
  
  match '/inbox' => 'inbox#notification'
  match '/notification' => 'inbox#notification'
  match '/pm' => 'inbox#pm'
  
  resources :questions do
    resources :answers do
      member do
        get 'accept'
      end
      resources :votes, :only => [] do
        collection do
          get 'up'
          get 'down'
        end
      end
    end
    resources :votes, :only => [] do
      collection do
        get 'up'
        get 'down'
      end
    end
    member do
      get 'follow'
      get 'favorite'
    end
  end

  devise_for :users
  
  resources :users, :only => [:show] do
    member do
      get 'follow'
      get 'asked'
      get 'answered'
    end
  end
  
  resources :activity, :only => [:index]

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
  root :to => 'questions#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
