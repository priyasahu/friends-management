Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'friends', to: 'friendships#create'
      get 'friends', to: 'friendships#show'
      post 'common', to: 'friendships#common'
      post 'subscribe', to: 'subscriptions#create'
    end
  end
end
