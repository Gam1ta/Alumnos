class PropeEstatusController < ApplicationController
  def index
    @ciclos= Ciclo.joins(:propedeuticos).select('distinct ciclo,propedeuticos.ciclo_id ').order('ciclo desc')
    @carreras=Carrera.all
  end

  def datos_prope
   @periodo = params[:ciclo][:id].to_s
   @carrera =params[:carrera][:id].to_s
   puts "periodo"
   puts @periodo
   puts "carrera"
   puts @carrera
    if @periodo.blank? or @carrera.blank?
      @ciclos= Ciclo.joins(:propedeuticos).select('distinct ciclo,propedeuticos.ciclo_id ').order('ciclo desc')
      @carreras=Carrera.all
      flash[:notice] = "Seleccione el periodo y la carrera"
      render :action => :index
    else
      @nombre_carre=Carrera.where("id=?",@carrera).first
      @id_ciclo=Ciclo.where('ciclo=?',@periodo).first
      @id_c=Propedeutico.where("ciclo_id=? and carrera_id=?",@id_ciclo,@carrera).first
      if(@id_c.nil? )
        @ciclos= Ciclo.joins(:propedeuticos).select('distinct ciclo,propedeuticos.ciclo_id ').order('ciclo desc')
        @carreras=Carrera.all
        flash[:notice] = "No hay información con los parámetros de búsqueda"
        render :action => :index
      else
        @datos = []
        @propes=Propedeutico.joins(:alumno).where("ciclo_id=? and propedeuticos.carrera_id=?",@id_ciclo,@carrera).order('apellido_paterno, apellido_materno,nombre')
        if !@propes.blank?
          @propes.each { |f|
            @datos << {
              :nom_alumno=>f.alumno.apellido_paterno.to_s+" "+f.alumno.apellido_materno.to_s+" "+f.alumno.nombre.to_s,
              :estatus=>f.status.to_s,
            }
          }
        end
      end
    end
  end

end
