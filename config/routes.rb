Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/decrypt', to: 'decrypt#decrypt' 

  post '/encrypt', to: 'encrypt#encrypt'

  get '/', to: 'welcomes#index'

  post '/', to: 'welcomes#index'

  post '/crypto', to: 'welcomes#crypto'
end
