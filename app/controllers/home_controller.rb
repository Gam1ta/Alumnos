class HomeController < ApplicationController
  before_filter :require_user

  def index
    if current_user.role_id == 1
      @usuario = current_user
    else
      user_data
      @periodo_actual = current_ciclo.ciclo
      @inscripciones = @usuario.alumno.inscripciones.select{|item| item.ciclo_id == current_ciclo.id}
    end
    @universidad = Universidad.first
  end
  
  def show_inscripciones
    user_data
     @usuario = current_user
     @inscripciones = @usuario.alumno.inscripciones
     @inscripciones_agrupadas = @inscripciones.group_by { |inscripcion| inscripcion.semestr.clave_semestre }
  end
  
  def user_data
    @usuario = current_user
    @periodo_actual = current_ciclo.ciclo
    @last_inscripcion = Inscripcion.get_last_user_data(Alumno.find_by_user_id(current_user.id).id)
    @profesor =  @usuario.alumno.profesor || Profesor.new
  end

  def password_change
    @usuario = current_user
    ciclo = Ciclo.get_ciclo_at_fecha(Date.today) || current_ciclo
    @inscripciones = @usuario.alumno.inscripciones.select{|item| item.ciclo_id == ciclo.id} if ciclo.present?
    @last_inscripcion = @inscripciones.sort_by{|i| i.semestr.clave}.last
    @last_inscripcion = @usuario.alumno.inscripciones.sort_by{|i| i.semestr.clave}.last if @last_inscripcion.blank?
  end

  def save_password
    puts "\n\n\n\nIniciando guardado...."
    begin
      User.transaction do
        usuario = User.find(params[:id].to_i)
        @usuario = usuario
        @usuario.role_id = (Role.find_by_name "ALUMNO").id
        @usuario.campus_id = usuario.campus_id
        @usuario.login = usuario.login
        @usuario.email = usuario.email
        @usuario.password = params[:password]
        @usuario.password_confirmation = params[:password_confirmation]
        @periodo_actual = current_ciclo.ciclo
        ciclo = Ciclo.get_ciclo_at_fecha(Date.today) || current_ciclo
        @inscripciones = @usuario.alumno.inscripciones.select{|item| item.ciclo_id == ciclo.id} if ciclo.present?
        @last_inscripcion = @inscripciones.sort_by{|i| i.semestr.clave}.last
        @last_inscripcion = @usuario.alumno.inscripciones.sort_by{|i| i.semestr.clave}.last if @last_inscripcion.blank?
        @profesor =  @usuario.alumno.profesor || Profesor.new
        respond_to do |format|
          if @usuario.save!
            format.html { render :action => 'user_data' }
            flash[:notice] = "Contraseña Actualizada"
          end
        end
      end
    rescue Exception => error
      @usuario = current_user
      ciclo = Ciclo.get_ciclo_at_fecha(Date.today) || current_ciclo
      @inscripciones = @usuario.alumno.inscripciones.select{|item| item.ciclo_id == ciclo.id} if ciclo.present?
      @last_inscripcion = @inscripciones.sort_by{|i| i.semestr.clave}.last
      @last_inscripcion = @usuario.alumno.inscripciones.sort_by{|i| i.semestr.clave}.last if @last_inscripcion.blank?
      flash[:error] = "La contraseña no coincide con la confirmación"
      respond_to do |format|
        format.html { render :action => 'password_change' }
        format.xml  { render :xml => @usuarior.errors, :status => :unprocessable_entity }
      end
    end
  end
end