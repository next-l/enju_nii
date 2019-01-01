Rails.application.routes.draw do
  resources :nii_types
  resources :cinii_books, only: [:index, :create]
end
