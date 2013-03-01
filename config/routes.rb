Voltrak::Application.routes.draw do
  
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config


  resources :plants do
    resources :frames do
      get :get_cell_reports, on: :member
      
      resources :cells do 
        get :get_report, on: :member

        resources :reports
      end
    end
  end

  resources :reports, only: [:index]

  root :to => 'plants#index'


end
