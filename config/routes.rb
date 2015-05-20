Rails.application.routes.draw do
  root to: 'home#index'


  scope '/api/website', format: 'json' do
    devise_for :users, controllers: {sessions: 'api/website/sessions'}
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :website do
    end
  end

  namespace :api, defaults: {format: 'json'} do

    post :sessions, to: 'sessions#create', as: :login
    delete :sessions, to: 'sessions#destroy', as: :logout

  end

end
