require 'portal_alumnos/horarios_module'
require 'portal_alumnos/horarios_class'
require 'portal_alumnos/asignaturas_class'
require 'portal_alumnos/consulta_horarios_class'

class HorariosController < ApplicationController
  before_filter :require_user, :except => []
  before_filter :require_alumno, :except => []

  include PortalAlumnos

  def index
    info_alumno
    begin
      @user = current_user
      @consulta_horarios = ConsultaHorariosClass.new(@user)
    rescue Exception => mensaje
      @mensaje = mensaje
    end
  end
  #
  # Acción que muestra el horario del calendario de exámenes según la inscripción que el alumno haya seleccionado.
  #
  def shows
    info_alumno
    begin
      @user = current_user
      @horarios = HorariosModule.load_horarios(@user, params[:inscripcion_id])
      @id_inscripcion=params[:inscripcion_id];
    rescue Exception => mensaje
      @mensaje = mensaje
    end

begin
    ciclo_id = Inscripcion.find(params[:inscripcion_id]).ciclo_id
    inscri_idiomas = InscripcionIdioma.where("alumno_id = ? AND ciclo_id = ?",current_user.alumno.id,ciclo_id)

    unless inscri_idiomas.blank?
      alumnos_grup = []
      
      inscri_idiomas.each do |i|
        alu = get_clase(i.idioma_id, i.alumno_id, i.ciclo_id)
        unless alu.blank?
          alumnos_grup << alu
        end
      end

      if alumnos_grup.blank?
        @mensaje_idiomas = "NO EXISTE CLASES EN IDIOMAS"
      else
        @horarios_idiomas = alumnos_grup
      end
      puts @horarios_idiomas.to_s
    else
      @mensaje_idiomas = "NO EXISTE INSCRIPCIONES EN IDIOMAS"
    end
end
    render :partial => 'horarios_partial'
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

  def get_clase(idioma_id, alumno_id,ciclo_id)
    alu = AlumnosGrupo.find_by(idioma_id: idioma_id, alumno_id: alumno_id, ciclo_id: ciclo_id)
    
    unless alu.blank?
      gn = alu.grupos_nivel 
      cc = ConfigClase.find_by(grupos_nivel_id: gn.id)
      idioma = Idioma.find(alu.idioma_id).idioma
      subnivel = alu.subnivel
      nivel = subnivel.nivel
      niv = nivel.nombre.to_s+"-"+subnivel.nombre.to_s
      hora_ini = gn.hora.hora_inicio
      clase = gn.nombre
      
      if cc.blank?
        lugar = "Sin Asignación"
        profesor = "Sin Asignación"
      else
        lugar = cc.lugar.nombre        
        profesor = Profesor.find(cc.profesor_id).blank? ? "pendiente" : Profesor.find(cc.profesor_id).full_name
      end
      {idioma: idioma, nivel: niv, clase: clase, hora: hora_ini, lugar: lugar, profesor: profesor}
    else
      nil
    end

  end

end

