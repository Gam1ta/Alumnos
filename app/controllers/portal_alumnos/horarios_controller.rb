require 'portal_alumnos/horarios_module'
require 'portal_alumnos/horarios_class'
require 'portal_alumnos/asignaturas_class'
require 'portal_alumnos/consulta_horarios_class'

class PortalAlumnos::HorariosController < ApplicationController
  before_filter :require_user, :except => []

  include PortalAlumnos

  def index
    begin
      @user = current_user
      @consulta_horarios = ConsultaHorariosClass.new(@user)
    rescue Exception => mensaje
      @mensaje = mensaje
    end
  end
  #
  # Acción que muestra el horario del calendario de exámenes según la inscripción que el alumno haya seleccionado.
  #
  def shows
    begin
      @user = current_user
      @horarios = HorariosModule.load_horarios(@user, params[:inscripcion_id])
    rescue Exception => mensaje
      @mensaje = mensaje
    end

    render :partial => 'horarios_partial'
  end
end
