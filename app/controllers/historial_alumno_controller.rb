class HistorialAlumnoController < ApplicationController
before_filter :require_user, :except => []
include SendDoc

  def index
    @alumnox = Alumno.where("user_id=?",current_user.id.to_i).first
    puts "id_alumno"
    puts @alumnox.id.to_s
    if @alumnox.blank?
      flash[:notice] = "No se encontró al alumno"
      redirect_to :controller =>:home, :action => :index
      #return
    else
    @todo= Inscripcion.joins(:carrera).joins(:alumno).joins(:grupo).joins(:ciclo).joins(:semestr).where('alumnos.id=?',@alumnox.id)
    @x=0
      for j in @todo
       for i  in  j.inscripciones_cursos
         if !i.calificacion.blank?
            @x=@x+1
         end
       end
      end
      if @todo.blank? or @x==0
       render  :action => :index
      else
      redirect_to :action => :xml_historial,:alumno_id=>@alumnox
      end
    end
  end



 def xml_historial1
@alumno_id= params[:alumno_id]
puts "alumno_id----"
puts @alumno_id
  @materias = []
  @promedio1=0
  promedio1=0
  credito=0
  x=0
  @inscrip = Inscripcion.joins(:carrera).joins(:alumno).joins(:grupo).joins(:ciclo).joins(:semestr).where('alumnos.id=? ',@alumno_id).order('clave asc')
  if !@inscrip.blank?
    for j in @inscrip
      @matricula=j.alumno.matricula.to_s
      @alumno= j.alumno.apellido_paterno.to_s + " " + j.alumno.apellido_materno.to_s + " " + j.alumno.nombre.to_s + " "
      @estado=j.alumno.tipo.to_s
     if @estado.eql?('BAJA_TEMP')
        @estado="BAJA TEMPORAL"
      else
        if @estado.eql?('BAJA_DEF')
          @estado="BAJA DEFINITIVA"
        end
      end
      @fecha_temp=j.alumno.fecha_baja_temporal.to_s
      @mot_temp=j.alumno.motivo_temporal.to_s
      @fecha_def=j.alumno.fecha_baja_definitiva.to_s
      @mot_def=j.alumno.motivo_definitiva.to_s
      @grupo=j.grupo.nombre.to_s
      @carrera=j.carrera.nombre_carrera.to_s
      @semestre=j.semestr.clave_semestre.to_s + " SEMESTRE "
      for i  in  j.inscripciones_cursos
        if !i.calificacion.blank?
          promedio=0
          if (i.calificacion.promedio.to_f >= 6)
            promedio1= promedio1 + i.calificacion.promedio.to_f
            promedio=i.calificacion.promedio.to_f
            fecha= i.calificacion.fecha_final
            @tipo="Ordinario"
          else
            if i.calificacion.especial.blank?
              if i.calificacion.extra2.blank?
                if i.calificacion.extra1.blank?
                  promedio1= promedio1 + i.calificacion.promedio.to_f
                  promedio=i.calificacion.promedio.to_f
                  fecha= i.calificacion.fecha_final
                  @tipo="Ordinario"
                else
                  promedio1= promedio1 + i.calificacion.extra1.to_f
                  @tipo="Extraordinario 1"
                  fecha= i.calificacion.fecha_extra1
                  promedio= i.calificacion.extra1.to_f
                end
              else
                promedio1= promedio1 + i.calificacion.extra2.to_f
                @tipo="Extraordinario 2"
                promedio=i.calificacion.extra2.to_f
                fecha= i.calificacion.fecha_extra2
              end
            else
              promedio1= promedio1 + i.calificacion.especial.to_f
              promedio= i.calificacion.especial.to_f
              fecha= i.calificacion.fecha_especial
              @tipo="Especial"
            end
          end
          credito= credito + i.curso.materias_planes.materia.creditos.to_f
          @materias<<{:ciclo=>j.ciclo.ciclo.to_s,
            :grupo=>@grupo,
            :fecha=>fecha,
            :semestre=>@semestre,
            :materia=>i.curso.materias_planes.materia.clave + "  " + i.curso.materias_planes.materia.nombre_materia.to_s,
            :p1=>number_to_sd_or_np(i.calificacion.parcial1.to_s,i.calificacion.descripcion_parcial1.to_s),
            :p2=>number_to_sd_or_np(i.calificacion.parcial2.to_s,i.calificacion.descripcion_parcial2.to_s),
            :p3=>number_to_sd_or_np(i.calificacion.parcial3.to_s,i.calificacion.descripcion_parcial3.to_s),
            :final=>number_to_sd_or_np(i.calificacion.final.to_s,i.calificacion.descripcion_ordinario.to_s),
            :e1=>number_to_sd_or_np(i.calificacion.extra1.to_s,i.calificacion.descripcion_extra1.to_s),
            :e2=>number_to_sd_or_np(i.calificacion.extra2.to_s,i.calificacion.descripcion_extra2.to_s),
            :especial=>number_to_sd_or_np(i.calificacion.especial.to_s,i.calificacion.descripcion_especial.to_s),
            :creditos=>i.curso.materias_planes.materia.creditos.to_s,
            :promedio=>promedio.to_s,
            :tipo=>@tipo,
          }
          x=x+1
        end
      end
    end
    @promedio1 = promedio1.to_f/x
    usuario= current_user
    if  usuario
      universidad= usuario.campus.universidad.nombre.to_s
    end
    @encabezado = []
    @encabezado = {
      :universidad => universidad.to_s,
      :promedio1=>@promedio1,
      :alumno=>@alumno,
      :estado=>@estado,
      :fecha_temp=>@fecha_temp,
      :motivo_temp=>@mot_temp,
      :fecha_def=>@fecha_def,
      :motivo_def=>@mot_def,
      :carrera=>@carrera,
      :matricula=>@matricula
    }
    send_doc(
      render_to_string(:template => 'historial_alumno/xml_historial1', :layout => false),
      '/reporte/informacion/materias',
      'rep_estado_alumno',
      'Estado del alumno',
      'pdf')
  end
end
 def number_to_sd_or_np(calificacion, descripcion)
    return nil if calificacion.blank?

    if calificacion.to_f == 0.0
      if descripcion.blank?
        return 0.0
      else
        return descripcion
      end
    else
      return calificacion
    end
  end
end
