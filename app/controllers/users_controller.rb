class UsersController < ApplicationController
 
  before_filter :require_user, :except => []
  before_filter :require_admin, :except => [:editar_datos,:actualizar1,:mostrar]

  def index
    @users = User.where('role_id != ?',4).order("login")
  end

  def new
    @user = User.new
    @roles = Role.all
    @role = 1
  end

  def create
    if params[:commit] == nil
      redirect_to users_url
    else
      @users = User.all
      @roles = Role.all
      begin
        User.transaction do
          @user = User.new params[:user]
          @user.email = @user.email.strip
          @user.role_id = params[:role_ids]

          if @user.save
            # enviando email para aviso de creación
            NesEscolaresMailer.registration_confirmation(@user).deliver
            flash[:notice] = "Usuario #{@user.login} creado satisfactoriamente"
            redirect_to users_url
          else
            @role = params[:role_ids].to_i
            render :action => :new
          end
        end
      rescue notException => error
        puts error.to_s + "-----------------------------"
        @role = params[:role_ids].to_i
        render :action => :new
      end
    end
  end


  def editar_datos
    @user =current_user#  User.find params[:id]
    @role = @user.role_id
    # @roles = Role.all
  end

  def mostrar
    @user =current_user#  User.find params[:id]
    @role = @user.role_id
    # @roles = Role.all
  end


  def edit
    @user = User.find params[:id]
    @role = @user.role_id
    @roles = Role.all
  end

  def actualizar1

    @user = current_user
    #@user.role_id = params[:role_ids]
    begin
      User.transaction do
        if params[:user][:password].strip.length == 0 # contraseña en blanco
          if @user.update_attributes(:login => params[:user][:login], :email=> params[:user][:email])
            flash[:notice] = "Usuario #{@user.login} actualizado satisfactoriamente"
            redirect_to  :controller=>:users,:action => :mostrar
          else
            render :action => :editar_datos
          end
        else # contraseña cambiada
          if @user.update_attributes(params[:user])
            flash[:notice] = "Usuario #{@user.login} y su contraseña actualizados satisfactoriamente"
            redirect_to :controller=> :users,:action =>  :mostrar
          else
            render :action => :editar_datos
          end
        end
      end
    rescue Exception => error
      flash[:error] = error
      render :action => :editar_datos
    end

  end

  def update
    if params[:commit] == nil
      redirect_to users_url
    else
      @user = User.find params[:id]
      # @user.role_id = params[:role_id]
      begin
        User.transaction do
          if params[:user][:password].strip.length == 0 # contraseña en blanco
            if @user.update_attributes(:login => params[:user][:login], :email=> params[:user][:email])
              flash[:notice] = "Usuario #{@user.login} actualizado satisfactoriamente"
              redirect_to users_url
            else
              #              @role = params[:role_ids].to_i
              #              @roles = Role.all
              render :action => :edit
            end
          else # contraseña cambiada
            if @user.update_attributes(params[:user])
              flash[:notice] = "Usuario #{@user.login} y su contraseña actualizados satisfactoriamente"
              redirect_to users_url
            else
              #              @role = params[:role_ids].to_i
              #              @roles = Role.all
              render :action => :edit
            end
          end
        end
      rescue Exception => error
        flash[:error] = error
        render :action => :edit
      end
    end
  end

  def destroy
    @user = User.find params[:id]
    login = @user.login
    begin
      User.transaction do
        if @user != current_user
          @user.destroy
          flash[:notice] = "Usuario #{login} eliminado satisfactoriamente"
          redirect_to users_url
        else
          flash[:error] = "No es posible eliminar al usuario actual"
          redirect_to users_url
        end
      end
    rescue Exception => error
      flash[:error] = error
      render :action => :new
    end
  end 
end
