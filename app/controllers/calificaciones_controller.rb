require 'portal_alumnos/consulta_examenes_class'
require 'portal_alumnos/calificaciones_class'

class CalificacionesController < ApplicationController
  before_filter :require_user, :except => []
  before_filter :require_alumno, :except => []
  
  include PortalAlumnos

  #
  # Acción que mostrará los periodos en los que el alumno tiene calificaciones.
  #
  def index
    info_alumno
    begin
      @user = current_user
      @consulta_examenes = ConsultaExamenesClass.new(@user)
    rescue Exception => error
      @mensaje = error
    end
  end
  
  #
  # Acción que mostrará las calificaciones del alumno de acuero al periodo que haya seleccionado.
  #
  def shows
    info_alumno
    begin
      @user = current_user
      inscripcion = Inscripcion.find_by_id(params[:inscripcion_id])
      @calificaciones = CalificacionesClass.new(@user, inscripcion)
    rescue Exception => error
      @mensaje = error
    end    

=begin    
    ciclo_id = Inscripcion.find(params[:inscripcion_id]).ciclo_id
    inscri_idiomas = InscripcionIdioma.where("alumno_id = ? AND ciclo_id = ?",current_user.alumno.id,ciclo_id)

    unless inscri_idiomas.blank?
      tmp_calif = []
      inscri_idiomas.each do |i|
        alu = get_calificaciones(i.idioma_id, i.alumno_id, i.ciclo_id, i.id)
        unless alu.blank?
          tmp_calif << alu
        end
      end

      if tmp_calif.blank?
        @mensaje_idiomas = "NO EXISTE CALIFICACIONES PARA IDIOMAS"
      else
        @calificaciones_idiomas = tmp_calif
      end
      puts "¡?¡?¡?¡?¡?¡?¡?¡?¡?¡?¡?¡?¡?¡"
      puts @calificaciones_idiomas.to_s
    else
      @mensaje_idiomas = "NO EXISTE INSCRIPCIONES EN IDIOMAS"
    end
=end

    render :partial => 'calificaciones_partial'
  end

  def info_alumno
    @usuario = current_user
    @periodo_actual = current_ciclo.ciclo
    ciclo = Ciclo.get_ciclo_at_fecha(Date.today) || current_ciclo
    @inscripciones = @usuario.alumno.inscripciones.select{|item| item.ciclo_id == ciclo.id} if ciclo.present?
    @last_inscripcion = @inscripciones.sort_by{|i| i.semestr.clave}.last
    @last_inscripcion = @usuario.alumno.inscripciones.sort_by{|i| i.semestr.clave}.last if @last_inscripcion.blank?
    @profesor =  @usuario.alumno.profesor || Profesor.new
  end

  private
  
  def get_calificaciones(idioma_id, alumno_id, ciclo_id, inscripcion_id)
    #Buscamos dentro de las inscripciones, si el alumno tiene una clase
    alu = AlumnosGrupo.find_by(idioma_id: idioma_id, alumno_id: alumno_id, ciclo_id: ciclo_id)
    arr_calen = []
    
    unless alu.blank?
      gn = alu.grupos_nivel #Buscamos que clase corresponde
      cc = ConfigClase.find_by(grupos_nivel_id: gn.id) 
      idioma = Idioma.find(alu.idioma_id).idioma
      subnivel = alu.subnivel
      nivel = subnivel.nivel
      niv = nivel.nombre.to_s+"-"+subnivel.nombre.to_s
      
      if cc.blank?
        profesor = "Sin Asignación"
      else
        profesor = Profesor.find(cc.profesor_id).blank? ? "Pendiente" : Profesor.find(cc.profesor_id).full_name
      end

      examens = ExamenIdioma.where("ciclo_id =? AND subnivel_id = ? AND grupos_nivel_id= ?", ciclo_id, subnivel.id, gn.id)
      #obtenemos sus examenes y buscamos la info de estos
      unless examens.blank?
        examenes = []
        exams_fi = [] #Examenes finales
        exams_ex = [] #Examenes extraordinario
        
        examens.each do |e|
          calif = CalificacionIdioma.find_by(examen_id: e.id, inscripcion_idioma_id: inscripcion_id)
          unless calif.blank?
            if e.evaluacion.to_s == "Final"
              exams_fi << {habilidad: e.habilidad, calificacion: calif.calificacion, profesor: profesor}
            else
              exams_ex << {habilidad: e.habilidad, calificacion: calif.calificacion, profesor: profesor}
            end
          end                           
        end

        unless exams_fi.blank?
          examenes << { examen: "Final" ,detalles: exams_fi}
        end
        unless exams_ex.blank?
          examenes << { examen: "Extraordinario" ,detalles: exams_ex}
        end

        if examenes.blank?
          nil
        else
          return { idioma: idioma, nivel: niv, examenes: examenes}
        end

        
      else
        return nil
      end
    else
      return nil
    end
  end

end
