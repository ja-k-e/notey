Rails.application.routes.draw do
  scope path: 'users' do
    get    '/'          => 'users#index'
    post   '/'          => 'users#create'
    get    '/:username' => 'users#show'
    put    '/:username' => 'users#update'
    patch  '/:username' => 'users#update'
    delete '/:username' => 'users#destroy'
  end

  scope path: 'notes' do
    get    '/'        => 'notes#index'
    post   '/'        => 'notes#create'
    get    '/:hashid' => 'notes#show'
    put    '/:hashid' => 'notes#update'
    patch  '/:hashid' => 'notes#update'
    delete '/:hashid' => 'notes#destroy'
  end
end