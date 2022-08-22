class ResultadosFichasController < ApplicationController
  def index
    @alumnos = Alumno.joins(:fichas).order("apellido_paterno").where('fichas.status' => 'aprobado')
  end

  def show
    curp = params[:curp]
    alumnos = Alumno.joins(:fichas).where('fichas.status' => 'aprobado', :curp => curp)
    @alumno = alumnos[0]
  end

end
