Rails.application.routes.draw do

  namespace :foreman_chef do
    resources :environments do
      collection do
        get :auto_complete_search
        get :import
        post :synchronize
        get :environments_for_chef_proxy
      end
    end
  end

end
