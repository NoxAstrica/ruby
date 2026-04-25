Rails.application.routes.draw do
  resources :genres

  resources :movies do
    collection do
      get 'watched' 
    end
  end

  root "movies#index"
end



