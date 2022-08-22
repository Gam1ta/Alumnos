# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'portal_alumnos/examenes_class'

  module PortalAlumnos
    module ExamenesModule
      #
      # Cargará la lista de horarios para el calendario de exámenes según el identificador de la inscripción que se le proporcione y regresará un arreglo de objetos de la clase ExamenesClass.
      #
      def ExamenesModule.load_examenes(user, inscripcion_id)
        only_owner(user, inscripcion_id)
        examenes = Array.new
        examenes.push(ExamenesClass.new(Examen::PARCIAL_1, inscripcion_id))
        examenes.push(ExamenesClass.new(Examen::PARCIAL_2, inscripcion_id))
        examenes.push(ExamenesClass.new(Examen::PARCIAL_3, inscripcion_id))
        examenes.push(ExamenesClass.new(Examen::ORDINARIO, inscripcion_id))
        examenes.push(ExamenesClass.new(Examen::EXTRAORDINARIO_1, inscripcion_id))
        examenes.push(ExamenesClass.new(Examen::EXTRAORDINARIO_2, inscripcion_id))
        examenes.push(ExamenesClass.new(Examen::ESPECIAL, inscripcion_id))

        examenes
      end

      #
      # Determinará si existe información en la base de datos para obtener el horario para el calendario de exámenes.
      #
      def ExamenesModule.exists?(tipo, inscripcion_id)
        Examen.joins(:examenes_profesores => :profesor, :curso => [:inscripciones_cursos, :asignatura]).
          exists?(:inscripciones_cursos => {:inscripcion_id => inscripcion_id}, :examenes => {:tipo => tipo}, :examenes_profesores => {:tipo => ExamenProfesor::TITULAR})
      end
      
      #
      # Método que validará que el identificador de la inscripción corresponda al alumno que se encuentre loggeado, de lo contrario no mostrará
      # información del calendario y mostrará un mensaje haciendo la indicación que la información que intenta acceder está restringido.
      #
      def ExamenesModule.only_owner(user, inscripcion_id)
        raise "No eres un alumno." unless user.is_alumno?
        raise "La información que intentas acceder es de uso restringido." unless Inscripcion.exists?(:id => inscripcion_id, :alumno_id => user.alumno)
      end
    end
  end
