# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  devise_for :users
  root 'plans#index'

  namespace :api do
    namespace :v1 do
      resources :plans, only: [:show]
    end
  end

  resources :plans do
    member do
      get :authorization_options
      get :generate_app
    end

    resources :authentications, except: [:show]
    resources :resources, only: [:index, :create]

    namespace :database_schema do
      resources :database_schema_models, path: 'models' do
        resources :database_schema_columns, path: 'columns', except: [:index]
        resources :database_schema_indices, path: 'indices', except: [:index, :update, :edit]
        resources :database_schema_associations, path: 'associations', except: [:index, :update, :edit]
        resources :resources, except: [:show, :index]
      end
    end
  end
end
