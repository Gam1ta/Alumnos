# To change this template, choose Tools | Templates
# and open the template in the editor.

  module PortalAlumnos
    class ExamenesClass
      #
      # string. Indicará el tipo de evaluación, Parcial 1, parcial 2, ..., Especial.
      #
      attr_accessor :nombre

      #
      # bool, Booleando para indicar si existe o no el calendario de exámenes según el nombre.
      #
      attr_accessor :exist

      #
      # ActiveRecord::Base, Arreglo de objetos la clase Examen (modelo) que contiene la información
      # para mostrar en el vista. Nombre de la asignatura, fecha, horas, aula y profesor.
      #
      attr_accessor :examenes

      #
      # Constructor de la clase que inicializará los datos miembros.
      #
      def initialize(tipo, inscripcion_id)
        @nombre = Examen::NOMBRES[tipo]
        @examenes = query(tipo, inscripcion_id)
        @exist = !@examenes.empty?
      end

      #
      # Buscar la información en la base de datos para ser mostrada en la vista ante el usuario.
      #
      def query(tipo, inscripcion_id)
        Examen.select("
            materias_planes.orden,
            materias_planes.nombre,
            examenes.fecha,
            examenes.hora_inicio || ' - ' || examenes.hora_fin as horas,
            examenes.aula, profesores.grado_de_estudios || ' ' || profesores.nombre || ' ' || profesores.apellido_paterno || ' ' || profesores.apellido_materno as profesor_full_name").
          joins(:examenes_profesores => :profesor, :curso => [:inscripciones_cursos, :asignatura]).
          where(:inscripciones_cursos => {:inscripcion_id => inscripcion_id}, :examenes => {:tipo => tipo}, :examenes_profesores => {:tipo => ExamenProfesor::TITULAR}).
          order("materias_planes.orden")
      end

      #
      # Determina si existe el horario para el calendario de exámenes según sea el contenido del objeto @nombre.
      #
      def exists?
        !@examenes.empty?
      end
    end
  end
