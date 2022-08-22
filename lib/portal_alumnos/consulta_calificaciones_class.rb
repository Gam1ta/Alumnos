# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'portal_alumnos/carreras_class'

  module PortalAlumnos
    class ConsultaCalificacionesClass
      #
      # ActiveRecord::Base, Objeto de la clase Alumno (modelo).
      #
      attr_accessor :alumno

      #
      # Array, Arreglo de objetos de la clase CarrerasClass.
      #
      attr_accessor :carreras

      #
      # Constructor de la clase que inicializará los datos miembros.
      #
      def initialize(user)
        raise "No eres un alumno." unless user.is_alumno?
        @alumno = user.alumno
        raise "No existe el alumno con curp #{@alumno.curp} registrado en el sistema." if @alumno.nil?
        @carreras = load_carreras
      end

      #
      # Cargará todas las carreras que el alumno haya cursado parcialmente o totalmente.
      #
      def load_carreras
        @carreras = Array.new
        carreras_temporal = Inscripcion.select("distinct inscripciones.carrera_id, planes_estudio.numero_plan, planes_estudio.clave_plan").
          joins(:cursos => {:asignatura => :plan_estudio}).
          where(:inscripciones => {:alumno_id => @alumno}).
          order("planes_estudio.numero_plan")

        raise "Aún no estás inscrito en alguna carrera." if carreras_temporal.nil? or carreras_temporal.empty?

        carreras_temporal.each do |carrera|
          carrera_temporal = Carrera.find_by_id(carrera.carrera_id)
          plan_temporal = PlanEstudio.find_by_numero_plan_and_clave_plan(carrera.numero_plan, carrera.clave_plan)

          @carreras.push(CarrerasClass.new(@alumno, carrera_temporal, plan_temporal))
        end

        @carreras
      end

      #
      # Determina si existen carreras.
      #
      def exists_carreras?
        !(@carreras.nil? or @carreras.blank? or @carreras.empty?)
      end
    end
  end
