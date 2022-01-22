Rails.application.routes.draw do
  devise_for :users
  resources :contacts, only: %i[index] do
    # collection do
    #   get 'bulk_import'
    # end
  end
  resources :contact_files, only: %i[index new create]
end
