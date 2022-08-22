Rails.application.routes.draw do

  get 'admin/index'
  get 'admin/crear_cuenta'
  get 'admin/reiniciar_cuenta'
  get 'admin/reset_password'
  post 'admin/setear_datos_del_alumno'
  post 'admin/actualizar_password'

  resources :password_resets, :only => [ :new, :create, :edit, :update ]

  resources :examenes, :only => :index do
    get :shows, :on => :collection
  end

  resources :horarios, :only => :index do
    get :shows, :on => :collection
  end
  
  resources :historiales, :only => :index do
    get :shows, :on => :collection
  end
      
  resources :calificaciones, :only => :index do
    get :shows, :on => :collection
  end 
  
  resources :home , :only => :index do
    get :alumnos_tabla, :on => :collection    
    get :error, :on => :collection
    get :show_inscripciones, :on => :collection
    get :user_data, :on => :collection
    get :password_change, :on => :collection
    get :save_password, :on => :collection
    post :save_password, :on => :collection
  end
  #  match 'home/alumnos_tabla', :controller => 'alumnos', :action => 'alumnos_tabla'


  resources :users do
    get :editar_datos , :on => :collection
    get :mostrar , :on => :collection
    get :actualizar1 , :on => :collection
  end

  resources :estancias_profesionales , :only => :index do
    get :shows, :on => :collection
	get :download, :on => :collection
	get :download_guia, :on => :collection
	get :show_empresa, :on => :collection
	post :index, :on => :collection
	get :documentos_registrados, :on => :collection
	get :add_empresa, :on => :collection
	get :del_empresa, :on => :collection
	get :send_opcion, :on => :collection
	get :select_opcion, :on => :collection
  end


  resources :adeudos , :only => :index do
    get :shows, :on => :collection
  end
  
  get "restricts/access_denied"


  resources :users do
    get :editar_datos , :on => :collection
    get :mostrar , :on => :collection
    get :actualizar , :on => :collection
  end
  get 'users/actualizar', :controller => 'users', :action => 'actualizar'


  #  resources :home

  resources :user_sessions do 
    get :user_data, :on => :collection
  end
#  get "user_sessions/new", to: "user_sessions#new" , as: :login
#  get "user_sessions/destroy", to: "user_sessions#destroy" , as: :logout




 
  root :to => 'home#index'
    
end
