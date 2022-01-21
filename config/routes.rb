Rails.application.routes.draw do
  devise_for :users
  resources :contacts, only: %i[index] do
    collection do
      get 'bulk_import'
      post 'import'
    end
  end
end
