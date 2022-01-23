Rails.application.routes.draw do
  root 'contacts#index'
  devise_for :users
  resources :contacts, only: %i[index]
  resources :contact_files, only: %i[index new create]
end
