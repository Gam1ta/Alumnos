module PortalAlumnos
  class CalificacionesClass
    #
    # ActiveRecord::Base, Objeto de la clase Inscripcion (modelo).
    #
    attr_accessor :inscripcion

    #
    # ActiveRecord::Base, Objeto de la clase Ciclo (modelo).
    #
    attr_accessor :periodo

    #
    # ActiveRecord::Base, Objeto de la clase Grupo (modelo).
    #
    attr_accessor :grupo

    #
    # ActiveRecord::Base, Objeto de la clase Semestr (modelo).
    #
    attr_accessor :semestre

    #
    # ActiveRecord::Base, Arreglo de objetos de la clase Calificacion (modelo) ordenados según descrito en el plan de estudios.
    #
    attr_accessor :calificaciones

    #
    # Constructor de la clase que inicializará los datos miembros.
    #
    def initialize(user, inscripcion)
      raise "No eres un alumno." unless user.is_alumno?
      raise "La información que intentas acceder es de uso restringido." unless Inscripcion.exists?(:id => inscripcion, :alumno_id => user.alumno)
      raise "La inscripción seleccionada no es válida." if inscripcion.nil?
      @inscripcion = inscripcion
      @periodo = inscripcion.ciclo
      @grupo = inscripcion.grupo
      @semestre = inscripcion.semestr
      @calificaciones = find_calificaciones
    end

    #
    # Devuelve el nombre del periodo.
    #
    def periodo_nombre
      @periodo.ciclo
    end

    #
    # Devuelve el nombre del semestre.
    #
    def semestre_nombre
      @semestre.clave_semestre
    end

    #
    # Devuelve el nombre del grupo.
    #
    def grupo_nombre
      @grupo.nombre
    end
      
    #
    # Devuelve el nombre de la carrera de acuerdo a la inscripción.
    #
    def carrera_nombre
      @inscripcion.carrera_nombre_carrera
    end

    #
    # Obtiene el encabezado para mostrar en cada tabla de calificaciones.
    #
    def header
      "Semestre: #{semestre_nombre}, Grupo: #{grupo_nombre}, Periodo: #{periodo_nombre}"
    end

    #
    # Busca las calificaciones de acuerdo con la inscripción proporcionada en el constructor.
    #
    def find_calificaciones
      Calificacion.select("materias_planes.clave, materias_planes.nombre, calificaciones.*").
        joins(:inscripcion_curso => [:inscripcion, {:curso => :asignatura}]).
        where(:inscripciones => {:id => @inscripcion}).
        order("materias_planes.orden")
    end

    #
    # Obtiene la lista de profesores y sus respectivas evaluaciones a las que fueron asignados.
    #
    def get_profesores
      profesores_array = Array.new
      profesores_tmp = Profesor.select("
            distinct examenes_profesores.profesor_id,
            examenes.curso_id,
            materias_planes.orden,
            materias_planes.nombre as asignatura_nombre,
            profesores.grado_de_estudios || ' ' || profesores.nombre || ' ' || profesores.apellido_paterno || ' ' || profesores.apellido_materno as profesor_nombre").
        joins(:examenes_profesores => {:examen => {:curso => [:inscripciones_cursos, :asignatura]}}).
        where(:examenes_profesores => {:tipo => ExamenProfesor::TITULAR}, :inscripciones_cursos => {:inscripcion_id => @inscripcion}).
        order("materias_planes.orden, materias_planes.nombre")

      profesores_tmp.each do |profesor|
        profesor_hash = Hash.new
        profesor_hash[:asignatura_nombre] = profesor.asignatura_nombre
        profesor_hash[:profesor_nombre] = profesor.profesor_nombre
        profesor_hash[:examenes] = Examen.joins(:examenes_profesores).where(:examenes => {:curso_id => profesor.curso_id}, :examenes_profesores => {:profesor_id => profesor.profesor_id}).order("examenes.tipo")

        profesores_array.push(profesor_hash)
      end

      profesores_array
    end
  end
end
