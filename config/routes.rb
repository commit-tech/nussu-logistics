# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'users#index'
  # get 'users/new_user', to: 'registrations#new'
  devise_for :users, controllers: { registrations: 'registrations' }
  devise_scope :user do
    get "/users/new_public_user" => "registrations#public_new"
  end

  resources :users, except: %i[create new] do
    member do
      get 'allocate_roles', to: 'users#allocate_roles', as: 'allocate_roles'
      patch 'allocate_roles', to: 'users#update_roles'
      put 'allocate_roles', to: 'users#update_roles'
    end
  end

  get 'guide', to: 'static_pages#guide'
end
