require 'portal_alumnos/examenes_module'
require 'portal_alumnos/examenes_class'
require 'portal_alumnos/consulta_examenes_class'

class PortalAlumnos::ExamenesController < ApplicationController
  before_filter :require_user, :except => []



  include PortalAlumnos

  #
  # Acción principal que mostrará la lista de inscripciones que el alumno tenga registrados en el sistema.
  #
  def index
    begin
      @consulta_examenes = ConsultaExamenesClass.new(current_user)
    rescue Exception => mensaje
      @mensaje = mensaje
    end
  end

  # Acción que muestra el horario del calendario de exámenes según la inscripción que el alumno haya seleccionado.
  #
  # Se toma este nombre porque hace alusión al método ''show'' del resorces de rails, pues el objeto es mostrar el contenido
  # de los horarios para el calendario de exámenes dado un identificador, además de que es llamado desde javascript y éste
  # está enviando el parámetro en formato ''json''. El Método show no recebe el parámetro bajo este formato.
  def shows
    begin
      @examenes = ExamenesModule::load_examenes(current_user, params[:inscripcion_id])
    rescue Exception => mensaje
      @mensaje = mensaje
    end

    render :partial => 'examenes_partial'
  end
end
