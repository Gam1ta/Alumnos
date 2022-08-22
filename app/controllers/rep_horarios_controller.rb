class RepHorariosController < ApplicationController
  include SendDoc
  def index
    
    @usuario = current_user
    @alumno = Alumno.where("user_id = ?", @usuario.id.to_i).first
    @inscripcion = Inscripcion.where("alumno_id =? and ciclo_id=?", @alumno.id.to_i,current_ciclo.id)
    
    @ciclo_actual = current_ciclo
    #@grupos= Grupo.where("ciclo_id=?",@ciclo_actual.id.to_i)
    if @inscripcion.blank?
    flash[:notice] =''
    else
      @grupos=[]
    for i in @inscripcion
       @g=Grupo.new()
       @g.nombre = i.grupo.nombre
       @grupos << i.grupo
       i.grupo.nombre
    end
    end
    
end

    

  def search
    @id_grupo = params[:grupo][:id]

    if @id_grupo.to_i > 0
      @grupos_cursos = GruposCursos.where("grupo_id = ?", @id_grupo)
    else
      flash[:notice] = "El campo 'Grupo' es necesario para poder realizar la consulta correctamente. Intentelo de nuevo!"
      redirect_to :action => :index
    end
  end

  def check_horarios hora, parametro
    if hora == nil
      return "-"
    else
      if parametro == 1
        return hora.hora_inicio.to_s
      else
        if parametro == 2
          return hora.hora_fin.to_s
        end
      end
    end
  end


  def xml_horarios
    @data = []
    @encabezado = []
    @id_grupo = params[:grupo_id].to_i
    #@id_ciclo = params[:ciclo_id].to_i
    @nomb_formato = "REPORTE DE HORARIOS"

    @grupos_cursos = GruposCursos.where("grupo_id = ?", @id_grupo)

    if @grupos_cursos.size > 0
      @campus = Campus.where("id=?", current_campus.id.to_i).first
      @nomb_university = "Nombre de la Universidad"

      if @campus != nil
        @universidad = Universidad.where("id=?", @campus.universidad_id.to_i).first
        @nomb_university = @universidad.nombre.to_s
      end

      @encabezado = {
        :nomb_univ => @nomb_university,
        :nomb_formato => @nomb_formato,
        :grupo => "Grupo: " + Grupo.where("id = ?", @id_grupo).first.nombre.to_s
      }

      @grupos_cursos.each do |gc|        
        @curso = Curso.where("id=?", gc.curso_id.to_i).first
        @profesor = Profesor.where("id = ?", @curso.profesor_id.to_i).first
        @materias_planes = MateriasPlanes.where("id = ?", @curso.materias_planes_id).first
        @materia = Materia.where("id = ?", @materias_planes.materia_id.to_i).first

        @lunes_horario = Horario.where("curso_id = ? AND dia_semana = 'Lunes'", gc.curso_id.to_i).first
        @lunes_hora1 = "-"
        @lunes_hora2 = "-"
        @lunes_aula = "-"
        if @lunes_horario != nil
          @lunes_hora1 = @lunes_horario.hora_inicio.to_s
          @lunes_hora2 = @lunes_horario.hora_fin.to_s
          @lunes_aula = Aula.where("id = ?", @lunes_horario.aula_id.to_i).first.nombre.to_s
        end

        @martes_horario = Horario.where("curso_id = ? AND dia_semana = 'Martes'", gc.curso_id.to_i).first
        @martes_aula = "-"
        if @martes_horario != nil
          @martes_aula = Aula.where("id = ?", @martes_horario.aula_id.to_i).first.nombre.to_s
        end

        @miercoles_horario = Horario.where("curso_id = ? AND dia_semana = 'Miercoles'", gc.curso_id.to_i).first
        @miercoles_aula = "-"
        if @miercoles_horario != nil
          @miercoles_aula = Aula.where("id = ?", @miercoles_horario.aula_id.to_i).first.nombre.to_s
        end

        @jueves_horario = Horario.where("curso_id = ? AND dia_semana = 'Jueves'", gc.curso_id.to_i).first
        @jueves_aula = "-"
        if @jueves_horario != nil
          @jueves_aula = Aula.where("id = ?", @jueves_horario.aula_id.to_i).first.nombre.to_s
        end

        @viernes_horario = Horario.where("curso_id = ? AND dia_semana = 'Viernes'", gc.curso_id.to_i).first
        @viernes_aula = "-"
        if @viernes_horario != nil
          @viernes_aula = Aula.where("id = ?", @viernes_horario.aula_id.to_i).first.nombre.to_s
        end

        @data << {
          :materia => @materia.nombre_materia.to_s,
          :nomb_profesor => @profesor.nombre.to_s + " " + @profesor.apellido_paterno.to_s + " " + @profesor.apellido_materno.to_s,
          
          :lunes_hora => @lunes_hora1.to_s + " - " + @lunes_hora2.to_s,
          :lunes_aula => @lunes_aula.to_s,

          :martes_hora => check_horarios(@martes_horario,1).to_s + " - " + check_horarios(@martes_horario,2).to_s,
          :martes_aula => @martes_aula.to_s,

          :miercoles_hora => check_horarios(@miercoles_horario,1).to_s + " - " + check_horarios(@miercoles_horario,2).to_s,
          :miercoles_aula => @miercoles_aula.to_s,

          :jueves_hora => check_horarios(@jueves_horario,1).to_s + " - " + check_horarios(@jueves_horario,2).to_s,
          :jueves_aula => @jueves_aula.to_s,

          :viernes_hora => check_horarios(@viernes_horario,1).to_s + " - " + check_horarios(@viernes_horario,2).to_s,
          :viernes_aula => @viernes_aula.to_s,
        }
      end

      send_doc(
        render_to_string(:template => 'rep_horarios/xml_horarios', :layout => false),
        '/reporte/informacion/datos',
        'reporte_horarios',
        'reporte_horarios',
        'pdf')
    else
      flash[:notice] = "No se encontrarón datos con dicha información de búsqueda"
      redirect_to :action => :index
    end
  end

  def notice

  end
end
