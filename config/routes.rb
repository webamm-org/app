# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  devise_for :users
  root 'plans#index'

  resources :plans do
    member do
      get :start
      post :progress
      post :generate
    end

    namespace :database_schema do
      resources :database_schema_models, path: 'models' do
        resources :database_schema_columns, path: 'columns', except: [:index]
        resources :database_schema_indices, path: 'indices', except: [:index, :update, :edit]
        resources :database_schema_associations, path: 'associations', except: [:index, :update, :edit]
      end
    end
  end
end
