  module PortalAlumnos
    class ConsultaExamenesClass
      #
      # ActiveRecord::Base, Objeto de la clase Alumno (modelo).
      #
      attr_accessor :alumno

      #
      # ActiveRecord::Base, Arreglo de objetos la clase Inscripcion (modelo) que contiene
      # únicamente el identificador de la clase y una cadena con el periodo, semestre y grupo
      #
      attr_accessor :inscripciones

      #
      # Constructor de la clase que inicializará los datos miembros.
      #
      def initialize(user)        
        raise "No eres un alumno." unless user.is_alumno?
        @alumno = user.alumno
        @inscripciones = load_inscripciones
      end

      #
      # Obtendrá una lista de todas las inscripciones que el alumno tenga registradas en el sistema y las mostrará ordenadamente de acuerdo al periodo de inscripción.
      #
      def load_inscripciones
        Inscripcion.select("
            inscripciones.id as inscripcion_id,
            ciclos.ciclo,
            ciclos.ciclo || ' | ' || semestres.clave_semestre || ' | ' || grupos.nombre as full_inscripcion").
          joins(:grupo, :ciclo, :semestr).
          where(:inscripciones => {:alumno_id => @alumno}).
          order("ciclos.ciclo desc")
      end
    end
  end