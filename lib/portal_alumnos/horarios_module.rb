require 'portal_alumnos/asignaturas_class'

  module PortalAlumnos
    module HorariosModule
      #
      # Cargará la lista de horarios de clase el identificador de la inscripción que se le proporcione y regresará un arreglo de objetos de la clase AsignaturasClass.
      #
      def HorariosModule.load_horarios(user, inscripcion_id)
        only_owner(user, inscripcion_id)
        horarios = Array.new

        unless Curso.joins(:inscripciones_cursos, [:asignatura, :horarios]).exists?(:inscripciones_cursos => {:inscripcion_id => inscripcion_id})
          raise "No existe Horario de Clases para la inscripción seleccionada."
        end

        asignaturas = Curso.select("cursos.id, materias_planes.nombre, materias_planes.orden").
          joins(:inscripciones_cursos, :asignatura).
          where(:inscripciones_cursos => {:inscripcion_id => inscripcion_id}).
          order("materias_planes.orden")

        unless asignaturas.empty?
          asignaturas.each { |asignatura| horarios.push(AsignaturasClass.new(asignatura)) }
        else
          raise "No te encuentras inscrito para alguna asignatura."
        end

        horarios
      end

      #
      # Método que validará que el identificador de la inscripción corresponda al alumno que se encuentre loggeado, de lo contrario no mostrará
      # información del calendario y mostrará un mensaje haciendo la indicación que la información que intenta acceder está restringido.
      #
      def HorariosModule.only_owner(user, inscripcion_id)
        raise "No eres un alumno." unless user.is_alumno?
        raise "La información que intentas acceder es de uso restringido." unless Inscripcion.exists?(:id => inscripcion_id, :alumno_id => user.alumno)
      end
    end
  end
