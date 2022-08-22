require 'portal_alumnos/examenes_module'
require 'portal_alumnos/examenes_class'
require 'portal_alumnos/consulta_examenes_class'

class ExamenesController < ApplicationController
  before_filter :require_user, :except => []
  before_filter :require_alumno, :except => []
  
  include PortalAlumnos

  #
  # Acción principal que mostrará la lista de inscripciones que el alumno tenga registrados en el sistema.
  #
  def index
    info_alumno
    begin
      @consulta_examenes = ConsultaExamenesClass.new(current_user)
    rescue Exception => mensaje
      @mensaje = mensaje
    end
  end

  # Acción que muestra el horario del calendario de exámenes según la inscripción que el alumno haya seleccionado.
  #
  # Se toma este nombre porque hace alusión al método ''show'' del resorces de rails, pues el objeto es mostrar el contenido
  # de los horarios para el calendario de exámenes dado un identificador, además de que es llamado desde javascript y éste
  # está enviando el parámetro en formato ''json''. El Método show no recebe el parámetro bajo este formato.
  def shows
    info_alumno
    begin
      @user = current_user
      @examenes = ExamenesModule::load_examenes(@user, params[:inscripcion_id])
    rescue Exception => mensaje
      @mensaje = mensaje
    end

=begin
    ciclo_id = Inscripcion.find(params[:inscripcion_id]).ciclo_id
    inscri_idiomas = InscripcionIdioma.where("alumno_id = ? AND ciclo_id = ?",current_user.alumno.id,ciclo_id)

    unless inscri_idiomas.blank?
      tmp_calen = []
      inscri_idiomas.each do |i|
        alu = get_calendario(i.idioma_id, i.alumno_id, i.ciclo_id)
        unless alu.blank?
          tmp_calen << alu
        end
      end

      if tmp_calen.blank?
        @mensaje_idiomas = "NO EXISTE CALENDARIO PARA IDIOMAS"
      else
        @calendario_idiomas = tmp_calen
      end
      puts "¡?¡?¡?¡?¡?¡?¡?¡?¡?¡?¡?¡?¡?¡"
      puts @calendario_idiomas.to_s
    else
      @mensaje_idiomas = "NO EXISTE INSCRIPCIONES EN IDIOMAS"
    end
=end

    render :partial => 'examenes_partial'
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

  def get_calendario(idioma_id, alumno_id,ciclo_id)
    alu = AlumnosGrupo.find_by(idioma_id: idioma_id, alumno_id: alumno_id, ciclo_id: ciclo_id)
    arr_calen = []
    unless alu.blank?
      gn = alu.grupos_nivel 
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

      examens = ExamenIdioma.where("ciclo_id =? AND subnivel_id = ?", ciclo_id, subnivel.id)
      
      unless examens.blank?
        examenes = []
        exams_fi = [] #Examenes finales
        exams_ex = [] #Examenes extraordinario
        
        examens.each do |e|
          if e.evaluacion.to_s == "Final" || e.evaluacion.to_s == "Extraordinario"
            lugar = e.lugar_id.blank? ? "---" : Lugar.find(e.lugar_id).nombre
            hora = e.hora_inicio.blank? ? "---" : e.hora_inicio.strftime("%H:%M").to_s+":"+e.hora_fin.strftime("%H:%M").to_s
            if e.evaluacion.to_s == "Final" && gn.id == e.grupos_nivel_id
              exams_fi << {habilidad: e.habilidad, hora: hora, lugar: lugar, fecha: e.fecha.strftime("%Y-%m-%d")}
            elsif gn.id == e.grupos_nivel_id
              exams_ex << {habilidad: e.habilidad, hora: hora, lugar: lugar, fecha: e.fecha.strftime("%Y-%m-%d")}
            end

          else
            examenes << { examen: e.evaluacion ,profesor: profesor, fecha: e.fecha.strftime("%Y-%m-%d")}
          end          

        end

        unless exams_fi.blank?
          examenes << { examen: "Final" ,detalles: exams_fi}
        end

        unless exams_ex.blank?
          examenes << { examen: "Extraordinario" ,detalles: exams_ex}
        end


        return { idioma: idioma, nivel: niv, examenes: examenes}
      else
        return nil
      end
    else
      return nil
    end

  end

end
