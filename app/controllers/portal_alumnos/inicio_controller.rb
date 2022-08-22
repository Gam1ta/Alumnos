class PortalAlumnos::InicioController < ApplicationController
  before_filter :require_user, :except => []

  layout "portal_alumnos"

  def index
    user = current_user
    alumno = user.alumno

    @data = Hash.new
    @data[:matricula] = alumno.matricula
    @data[:nombre] = alumno.full_name
    @data[:carrera] = alumno.carrera_nombre_carrera
    @data[:seguro_social] = alumno.nss
  end
end
