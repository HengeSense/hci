Hci::Application.routes.draw do
  resources :transactions
  
  devise_for :users
  devise_scope :user do
    match "/users/:id/bills" => "users#bills", :as => 'user_bills', :via => :get
    match "/users/:id/paidbills" => "users#paidBills", :as => 'user_paidbills', :via => :get
    match "/users/:id/unpaidbills" => "users#unpaidBills", :as => 'user_unpaidbills', :via => :get
    
    match "/users/:id/invoices" => "users#invoices", :as => 'user_invoices', :via => :get
    match "/users/:id/paidInvoices" => "users#paidInvoices", :as => 'user_paidinvoices', :via => :get
    match "/users/:id/unpaidInvoices" => "users#unpaidInvoices", :as => 'user_unpaidinvoices', :via => :get    
    
    match "/users/:id/unpaidTransactions" => "users#unpaidTransactions", :as => 'user_unpaidTransactions', :via => :get
    match "/users/:id/paidTransactions" => "users#paidTransactions", :as => 'user_paidTransactions', :via => :get
  end
  
  match "/invoices/new" => "transactions#newInvoice", :as => "new_invoice", :via => :get
  match "/invoices" => "transactions#createInvoice", :via => :post
  
  resources :users, :only => [:show, :index, :edit]
  

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
  root :to => 'pages#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
