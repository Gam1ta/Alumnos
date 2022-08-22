class ApplicationController < ActionController::Base
 protect_from_forgery
  helper_method :current_user_session, :current_user
=begin
  rescue_from ActiveRecord::StatementInvalid, :with => :invalid_statement
  rescue_from ActionController::RoutingError, :with => :route_not_found
  rescue_from ActionController::MethodNotAllowed, :with => :invalid_method
  rescue_from ActionView::TemplateError, :with => :general_db_error
=end

  private
  def current_user_session
    logger.debug "ApplicationController::current_user_session"
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_campus
    @usuario = User.where("id=?", current_user.id.to_i).first
    @campus = Campus.where("id=?", @usuario.campus_id.to_i).first
    return @campus
  end

 
  def current_user
    logger.debug "ApplicationController::current_user"
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def current_ciclo
    @ciclo_actual = Ciclo.where("actual = TRUE").first

    return @ciclo_actual
  end
  
  def require_user
    logger.debug "ApplicationController::require_user"
    unless current_user
      store_location
      flash[:notice] = "Necesita loguearse para acceder a la página solicitada"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    logger.debug "ApplicationController::require_no_user"
    if current_user
      store_location
      # flash[:notice] = "NO necesita loguearse para acceder a la página solicitada"
      redirect_to "/"
      return false
    end
  end

  def require_no_user_reset
    logger.debug "ApplicationController::require_no_user_reset"
    unless current_user
      store_location

      flash[:notice] = "Escribe tu correo electronico y presiona 'Reestablecer Contraseña'"
      logger.debug "NO necesita loguearse para acceder a la página solicitada"
      return false
    end

  end

  def store_location
    #session[:return_to] = request.request_uri
    session[:return_to] = request.url
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def require_admin
    unless current_user.role.name == "ADMINISTRADOR"
      section = controller_name
      redirect_to :controller => "restricts", :action => "access_denied", :required => "Administrador", :section => section
      return false
    end
  end

  def require_escolar
    unless current_user.role.name == "ESCOLAR"
      section = controller_name
      redirect_to :controller => "restricts", :action => "access_denied", :required => "Escolar", :section => section
      return false
    end
  end
  
    def require_alumno
    unless current_user.role.name == "ALUMNO"
      section = controller_name
      redirect_to :controller => "restricts", :action => "access_denied", :required => "Alumno", :section => section
      return false
    end
  end
  
  
  def admin?
    return true if current_user.role.name == "ADMINISTRADOR"
    return false
  end

  def escolar?
    return true if current_user.role.name == "ESCOLAR"
    return false
  end

 
  def invalid_statement
    @error = "Error en la conexión a la base de datos"
    redirect_to :controller => :home, :action => :error, :error=> @error
  end

  def route_not_found
    @error = "La ruta especificada no se encuentra"
    redirect_to :controller => :home, :action => :error, :error=> @error
  end

  def invalid_record
    @error = "Registro inválido o no se encuentra"
    redirect_to :controller => :home, :action => :error, :error=> @error
  end

  def invalid_method
    @error = "Método inválido o no se encuentra"
    redirect_to :controller => :home, :action => :error, :error=> @error
  end

  def general_db_error
    @error = "Error en la conexión a la base de datos"
    redirect_to :controller => :home, :action => :error, :error=> @error
  end
  
  def current_periodo_estancias
	usuario = current_user  
    ciclo = Ciclo.get_ciclo_at_fecha(Date.today) || current_ciclo
    inscripciones = usuario.alumno.inscripciones.select{|item| item.ciclo_id == ciclo.id} if ciclo.present?
    last_inscripcion = inscripciones.sort_by{|i| i.semestr.clave}.last 
    last_inscripcion = usuario.alumno.inscripciones.sort_by{|i| i.semestr.clave}.last if last_inscripcion.blank?
	
	periodo = 0
	if last_inscripcion.semestre_id == 6
		periodo = 1
	end
	
	if last_inscripcion.semestre_id >= 8
		periodo = 2
	end
	
	return periodo
  end
end
