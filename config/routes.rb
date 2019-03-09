# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'users#index'

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users, except: %i[create new] do
    member do
      get 'allocate_roles', to: 'users#allocate_roles', as: 'allocate_roles'
      patch 'allocate_roles', to: 'users#update_roles'
      put 'allocate_roles', to: 'users#update_roles'
    end
  end

  resources :items

  get 'guide', to: 'static_pages#guide'
end
