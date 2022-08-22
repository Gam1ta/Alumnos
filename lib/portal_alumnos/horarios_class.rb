
  module PortalAlumnos
    class HorariosClass
      #
      # string, el nombre de la aula en la que será impartida la clase.
      #
      attr_accessor :dia

      #
      # string, el horario de la clase, hora inicio - hora de término.
      #
      attr_accessor :hora

      #
      # string, el nombre de la aula en la que será impartida la clase.
      #
      attr_accessor :aula

      #
      # Constructor de la clase que inicializará los datos miembros además de buscar en la base de datos
      # el registro correspondiente al día de la semana.
      #
      def initialize(day, curso_id)
        horario = Horario.find_by_tipo_and_curso_id(day, curso_id)

        @dia = day
        unless horario.nil?
          @hora = horario.formated_hours
          @aula = horario.aula
        else
          @hora = "S/H"
          @aula = "S/A"
        end
      end
    end
  end
