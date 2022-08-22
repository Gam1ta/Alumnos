class PasswordResetsController < ApplicationController
  before_filter :require_no_user_reset
  before_filter :load_user_using_perishable_token, :only => [ :edit, :update ]

  def new

  end

  def create
    @user = User.find_by_correo_adicional(params[:email])
    puts "\n\n\n\nINICICICICICICICIC"
    if @user
      puts "Entro viva "
      @user.deliver_password_reset_instructions!
      puts "fin "
      flash[:notice] = "Se te ha enviado un mensaje a tu dirección email. Haz clic en el enlace de dicho mensaje para establecer una nueva contraseña."
      redirect_to root_path
    else
      puts "No le entro"
      flash[:warning] = "No se encontró ningún usuario con la dirección de correo electrónico #{params[:email]}"
      render :action => :new
    end
  end

  def edit
    @user = User.find_by(perishable_token: params[:id])
  end

  def update
    @user.password = params[:password]
    @user.password_confirmation = params[:password]
    if @user.save
      flash[:success] = "Contraseña Actualizada Exitosamente"
      redirect_to "/"
    else
      render :action => :edit
    end
  end

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = "Lo sentimos, no pudimos encontrar su cuenta"
      redirect_to root_url
    end
  end

end