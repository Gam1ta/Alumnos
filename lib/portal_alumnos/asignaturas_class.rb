require 'portal_alumnos/horarios_class'

  module PortalAlumnos
    class AsignaturasClass
      #
      # int, identificador de la tabla Cursos para la asignatura dada.
      #
      attr_accessor :curso_id

      #
      # String, nombre de la asignatura.
      #
      attr_accessor :nombre

      #
      # String, nombre completo del profesor con grado académico abreviado.
      #
      attr_accessor :profesor

      #
      # Array, Arreglo de objetos la clase HorariosClass que contiene la información para mostrar en el vista. Día, hora y aula.
      #
      attr_accessor :horarios

      #
      # Constructor de la clase que inicializará los datos miembros.
      #
      def initialize(asignatura)
        @curso_id = asignatura.id
        @nombre = asignatura.nombre
        @profesor = get_profesor_name
        @horarios = Array.new

        @horarios.push(HorariosClass.new(Horario::LUNES, @curso_id))
        @horarios.push(HorariosClass.new(Horario::MARTES, @curso_id))
        @horarios.push(HorariosClass.new(Horario::MIERCOLES, @curso_id))
        @horarios.push(HorariosClass.new(Horario::JUEVES, @curso_id))
        @horarios.push(HorariosClass.new(Horario::VIERNES, @curso_id))
      end

      #
      # Busca y obtiene el nombre del profesor en la base de datos que sea del tipo TITULAR y además el que esté asignado al parcial 1.
      #
      def get_profesor_name
        profesor_name = Profesor.joins(:examenes_profesores => :examen).where(:examenes_profesores => {:tipo => ExamenProfesor::TITULAR}, :examenes => {:curso_id => @curso_id}).first

        unless profesor_name.nil?
          profesor_name.full_name_with_grado
        else
          "SIN PROFESOR"
        end
      end
    end
  end
