# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'portal_alumnos/calificaciones_class'


  module PortalAlumnos
    class CarrerasClass
      #
      # ActiveRecord::Base, Objeto de la clase Alumno (modelo).
      #
      attr_accessor :alumno

      #
      # ActiveRecord::Base, Objeto de la clase Carrera (modelo).
      #
      attr_accessor :carrera

      #
      # ActiveRecord::Base, Objeto de la clase Campus (modelo).
      #
      attr_accessor :campus

      #
      # ActiveRecord::Base, Objeto de la clase PlanEstudio (modelo).
      #
      attr_accessor :plan

      #
      # Array, Arreglo de objetos de la clase CalificacionesClass que contienen las calificaciones agrupadas por periodo, semestre.
      #
      attr_accessor :calificaciones

      #
      # Constructor de la clase que inicializará los datos miembros.
      #
      def initialize(alumno, carrera, plan)
        @alumno = alumno
        @carrera = carrera
        @campus = carrera.campus
        @plan = plan
        @calificaciones = load_calificaciones
      end

      #
      # Devuelve el nombre de la carrera.
      #
      def carrera_nombre
        @carrera.nombre_carrera
      end

      #
      # Devuelve el nombre del campus.
      #
      def campus_nombre
        @campus.nombre
      end

      #
      # Devuelve el número del plan.
      #
      def plan_numero
        @plan.numero_plan
      end

      #
      # Devuelve la clave del plan.
      #
      def plan_clave
        @plan.clave_plan
      end

      #
      # Obtiene el encabezado para mostrar en cada carrera el nombre y el plan inscrito del alumno.
      #
      def header
        "Carrera: #{carrera_nombre}     Plan de Estudios: #{plan_clave}"
      end

      #
      # Cargará todas las calificaciones que el alumno tenga registradas.
      #
      def load_calificaciones
        calificaciones_tmp = Array.new
        inscripciones = Inscripcion.select("distinct inscripciones.*, ciclos.ciclo, semestres.clave").
          joins(:semestr, :ciclo, :carrera => :planes_estudio).
          where(:inscripciones => {:alumno_id => @alumno, :carrera_id => @carrera}, :planes_estudio => {:numero_plan => @plan.numero_plan, :clave_plan => @plan.clave_plan}).
          order("ciclos.ciclo, semestres.clave")

        raise "Aún no te has inscrito en algún semestre." if inscripciones.nil? or inscripciones.empty?

        inscripciones.each { |inscripcion| calificaciones_tmp.push(CalificacionesClass.new(inscripcion)) }

        raise "Aún no tienes calificaciones registradas." if calificaciones_tmp.empty?

        calificaciones_tmp
      end

      #
      # Indica si existen calificacines para el alumno o no.
      #
      def exists_calificaciones?
        !(@calificaciones.nil? or @calificaciones.blank? or @calificaciones.empty?)
      end
    end
  end
