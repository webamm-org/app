# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  devise_for :users
  root 'plans#index'

  resources :plans do
    namespace :database_schema do
      resources :models
    end
  end
end
