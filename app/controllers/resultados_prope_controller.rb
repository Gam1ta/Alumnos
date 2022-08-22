class ResultadosPropeController < ApplicationController
  def index
    @alumnos = Alumno.joins(:propedeuticos).order("apellido_paterno").where('propedeuticos.status' => 'aprobado')
  end

  def show
    curp = params[:curp]
    alumnos = Alumno.joins(:propedeuticos).where('propedeuticos.status' => 'aprobado', :curp => curp)
    @alumno = alumnos[0]
  end

end
