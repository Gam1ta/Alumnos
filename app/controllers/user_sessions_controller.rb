class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
   

    if @user_session.save
      current_user_session_role = (UserSession.find).user.role_id
      role = Role.find(current_user_session_role)
      case (role.name)
      when Role::ADMINISTRADOR#1 #ADMINISTRADOR
        puts "#########################"
        puts 'ADMINISTRADOR'
        puts "#########################"
        flash[:info] = ['¡Bienvenido Administrador!', 'Has iniciado sesión en el portal de Alumnos']
        redirect_to admin_index_path
      when Role::ALUMNO        #4 #ALUMNO
        current_user_session_id = (UserSession.find).user.id
        @alumno = Alumno.where("user_id = ?",current_user_session_id).first
        if @alumno.blank?
          flash[:error] = "El usuario no existe en la tabla alumnos"
          redirect_to :action => :destroy
        else
          esta_en_estancia =OpcionEstancia.where("alumno_id=? and estatus=?",@alumno.id,"APROBADA").last
          #esta_en_estancia = OpcionEstancia.find_all_by_alumno_id_and_estatus(@alumno.id,"APROBADA")
          fecha_fin = ""
          if !esta_en_estancia.blank?
              if esta_en_estancia.periodo.to_s == "1"
                fecha_fin = EstanciasConfig.first.fin_periodo_uno
              elsif esta_en_estancia.periodo.to_s == "2"
                fecha_fin = EstanciasConfig.first.fin_periodo_dos
              elsif esta_en_estancia.periodo.to_s == "3"
                fecha_fin = EstanciasConfig.first.fin_periodo_tre
              elsif esta_en_estancia.periodo.to_s == "4"
                fecha_fin = EstanciasConfig.first.fin_periodo_cuatro
              else
                fecha_fin = EstanciasConfig.first.fin_periodo_cinco
              end
              #fecha_fin = EstanciasConfig.first.fecha_opciones_fin
              fecha_resultado = fecha_fin + 10 #Se suman los 10 dias habiles a partir de la fecha fin de estancia 
              flash[:info] = ['¡Bienvenido!', 'Has iniciado sesión en el portal de Alumnos','El ultimo día de entrega documentos de culminación de estancias ' + fecha_resultado.to_s]
          else
              flash[:info] = ['¡Bienvenido!', 'Has iniciado sesión en el portal de Alumnos']
          end  
          redirect_back_or_default "/home#index"
        end
      else
        flash[:error] = " Nombre de Usuario y/o Contraseña inválidos. Inténtelo nuevamente"
        redirect_to :action => :destroy
      end
    else
      render :action => :new
    end
  end
  

  def destroy
    current_user_session.destroy
    flash[:notice] = "Cierre de sesión satisfactoria"
    redirect_back_or_default new_user_session_url
  end
end
