# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  devise_for :users
  root 'home#index'

  resources :leads, path: 'subscribers', only: [:create, :new, :index]

  namespace :api do
    namespace :v1 do
      resources :plans, only: [:show]
    end
  end

  resources :plans do
    member do
      get :start
      post :progress
      post :generate
    end

    resources :authentications, except: [:show]

    namespace :database_schema do
      resources :database_schema_models, path: 'models' do
        resources :database_schema_columns, path: 'columns', except: [:index]
        resources :database_schema_indices, path: 'indices', except: [:index, :update, :edit]
        resources :database_schema_associations, path: 'associations', except: [:index, :update, :edit]
      end
    end
  end
end
