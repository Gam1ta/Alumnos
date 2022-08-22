class CalendarioExamenesController < ApplicationController
 include SendDoc
  def index
    @ciclos=Ciclo.where("actual=?",true).first
    @alumnox = Alumno.where("user_id=?",current_user.id.to_i).first
    puts "id_alumno"
    puts @alumnox.id.to_s
    if @alumnox.blank?
      flash[:notice] = "No se encontró al alumno"
      redirect_to :controller =>:home, :action => :index
    else
      @todo= Inscripcion.joins(:carrera).joins(:alumno).joins(:grupo).joins(:ciclo).joins(:semestr).where('alumnos.id=? and actual=?',@alumnox.id,true)
      @x=0
      for j in @todo
        for i  in  j.inscripciones_cursos
          @examen =Examen.where("curso_id=?",i.curso_id)
          if !@examen.blank?
            @examen.each { |e|
               @x=@x+1
            }
          end
        end
      end
        if @todo.blank? or @x==0
          render  :action => :index
        else
          redirect_to :action => :reporte_calendario,:alumno_id=>@alumnox
        end
      end

    end

  def calendario_examen
    @calendario_exam=[]
    @alumno_id= params[:alumno_id]
    @todo= Inscripcion.joins(:carrera).joins(:alumno).joins(:grupo).joins(:ciclo).joins(:semestr).where('alumnos.id=? and actual=?',@alumno_id,true)
    @x=0
    if !@todo.blank?
      for j in @todo
        for i  in  j.inscripciones_cursos
          @examen =Examen.where("curso_id=?",i.curso_id).first
          @matricula=j.alumno.matricula.to_s
          @alumno= j.alumno.apellido_paterno.to_s + " " + j.alumno.apellido_materno.to_s + " " + j.alumno.nombre.to_s + " "
          @carrera=j.carrera.nombre_carrera.to_s
          if @examen !=nil

            @curso=Curso.where("id=?", @examen.curso_id.to_i).first
            @materias_planes = MateriasPlanes.where("id = ?", @curso.materias_planes_id).first
            @materia = Materia.where("id = ?", @materias_planes.materia_id.to_i).first
#            puts @materia.nombre_materia.to_s
            @parcial1 = Examen.where("curso_id = ? AND tipo = 'PARCIAL1'", @examen.curso_id.to_i).first

            if @parcial1!=nil
              @fecha_p1=@parcial1.fecha.to_s
              @hora_parcial1 = @parcial1.hora_inicio.to_s+"-"+@parcial1.hora_fin.to_s
              @aula_parcial1 =Aula.where("id = ?", @parcial1.aula_id.to_i).first.nombre.to_s
#              puts "parcial1"
#              puts @hora_parcial1
#              puts @aula_parcial1
            end

            @parcial2 = Examen.where("curso_id = ? AND tipo = 'PARCIAL2'", @examen.curso_id.to_i).first
            if @parcial2 != nil
              @fecha_p2=@parcial2.fecha.to_s
              @hora_parcial2 = @parcial2.hora_inicio.to_s+"-"+@parcial2.hora_fin.to_s
              @aula_parcial2 =Aula.where("id = ?", @parcial2.aula_id.to_i).first.nombre.to_s
#              puts "parcial2"
#              puts @hora_parcial2
#              puts @aula_parcial2
            end

            @parcial3 = Examen.where("curso_id = ? AND tipo = 'PARCIAL3'",@examen.curso_id.to_i).first
            if @parcial3!=nil
              @fecha_p3=@parcial3.fecha.to_s
              @hora_parcial3 = @parcial3.hora_inicio.to_s+"-"+@parcial3.hora_fin.to_s
              @aula_parcial3 =Aula.where("id = ?", @parcial3.aula_id.to_i).first.nombre.to_s
#              puts "parcial3"
#              puts @hora_parcial3
#              puts @aula_parcial3
            end

            @ordinario = Examen.where("curso_id = ? AND tipo = 'ORDINARIO'", @examen.curso_id.to_i).first
            if @ordinario!=nil
              @fecha_ord=@ordinario.fecha.to_s
              @hora_ordinario = @ordinario.hora_inicio.to_s+"-"+@ordinario.hora_fin.to_s
              @aula_ordinario =Aula.where("id = ?", @ordinario.aula_id.to_i).first.nombre.to_s
#              puts "ordinario"
#              puts @hora_ordinario
#              puts @aula_ordinario
            end
             @extra1=Examen.where("curso_id = ? AND tipo = 'EXTRAORDINARIO1'", @examen.curso_id.to_i).first
             if @extra1!=nil
              @fecha_ext1=@extra1.fecha.to_s
              @hora_ext1 = @extra1.hora_inicio.to_s+"-"+@extra1.hora_fin.to_s
              @aula_ext1 =Aula.where("id = ?", @extra1.aula_id.to_i).first.nombre.to_s
            end

            @extra2=Examen.where("curso_id = ? AND tipo = 'EXTRAORDINARIO2'", @examen.curso_id.to_i).first
             if @extra2!=nil
              @fecha_ext2=@extra2.fecha.to_s
              @hora_ext2 = @extra2.hora_inicio.to_s+"-"+@extra2.hora_fin.to_s
              @aula_ext2 =Aula.where("id = ?", @extra2.aula_id.to_i).first.nombre.to_s
            end
            @especial=Examen.where("curso_id = ? AND tipo = 'EXTRAORDINARIO1'", @examen.curso_id.to_i).first
             if @especial!=nil
              @fecha_esp=@especial.fecha.to_s
              @hora_esp = @especial.hora_inicio.to_s+"-"+@especial.hora_fin.to_s
              @aula_esp =Aula.where("id = ?", @especial.aula_id.to_i).first.nombre.to_s
            end


             @calendario_exam<<{
              
              :materia => @materia.nombre_materia.to_s,
              :hora_p1 => @hora_parcial1,
              :aula_p1 =>@aula_parcial1,
              :fecha_p1=>@fecha_p1,

              :hora_p2 => @hora_parcial2,
              :aula_p2 =>@aula_parcial2,
              :fecha_p2=>@fecha_p2,

              :hora_p3 => @hora_parcial3,
              :aula_p3 => @aula_parcial3,
              :fecha_p3=>@fecha_p3,

              :hora_Or => @hora_ordinario,
              :aula_Or =>@aula_ordinario,
              :fecha_or=> @fecha_ord,

              :hora_ext1 => @hora_ext1,
              :aula_ext1 =>@aula_ext1,
              :fecha_ext1=> @fecha_ext1,

              :hora_ext2 => @hora_ext2,
              :aula_ext2 =>@aula_ext2,
              :fecha_ext2=> @fecha_ext2,
              
              :hora_esp=>@hora_esp,
              :aula_esp=>@aula_esp,
              :fecha_esp=>@fecha_esp,




            }
            usuario= current_user
            if  usuario
              universidad= usuario.campus.universidad.nombre.to_s
            end
            @encabezado = []
            @encabezado = {
              :universidad => universidad.to_s,
              :alumno=>@alumno,
              :carrera=>@carrera,
              :matricula=>@matricula
            }
          end
        end
      end
      send_doc(render_to_string(:template => 'calendario_examenes/calendario_examen', :layout => false),
        '/reporte/informacion/calendario',
        'rep_calendario_exam',
        'Reporte de calendario de examenes',
        'pdf')
    end
  end

end
