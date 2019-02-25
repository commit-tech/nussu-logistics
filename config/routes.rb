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

  resources :item, except: %i[create new] do
    member do
      get 'guide', to: 'static_pages#guide'
      get 'item/list'
      get 'item/new'
      post 'item/create'
      get 'item/list'
      get 'item/show'
      get 'item/edit'
    end
  end
end
