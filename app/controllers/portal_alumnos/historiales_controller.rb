require 'portal_alumnos/calificaciones_class'
require 'portal_alumnos/carreras_class'
require 'portal_alumnos/consulta_calificaciones_class'

class PortalAlumnos::HistorialesController < ApplicationController
  before_filter :require_user, :except => []



  include PortalAlumnos

  #
  # Acción que mostrará las calificaciones del alumno en la vista.
  #
  def index
    begin
      @consulta_calificaciones = ConsultaCalificacionesClass.new(current_user)
    rescue Exception => error
      @mensaje = error
    end
  end
end
