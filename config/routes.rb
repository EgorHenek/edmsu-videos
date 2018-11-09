# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: 'auth', skip: :registrations, controllers: {sessions: 'sessions'}, defaults: { format: :json }
  devise_scope :user do
    resource :registration,
             only: [:create, :update],
             path: 'auth',
             path_names: { new: 'sign_up' },
             controller: 'devise/registrations',
             as: :user_registration,
             defaults: { format: :json }
    get 'auth/current', to: 'sessions#show'
  end
  resources :videos
  resources :channels do
    resources :videos, only: [:index]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
