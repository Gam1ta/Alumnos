require 'time_format_validator'

class Examen < ActiveRecord::Base
  #
  # Constante para indicar el nombre según el tipo de evaluación.
  #
  NOMBRES = ['PARCIAL 1', 'PARCIAL 2', 'PARCIAL 3', 'ORDINARIO', 'EXTRAORDINARIO 1', 'EXTRAORDINARIO 2', 'ESPECIAL']

  #
  # Constante para el tipo de examen <tt>PARCIAL 1</tt>.
  #
  PARCIAL_1 = 0

  #
  # Constante para el tipo de examen <tt>PARCIAL 2</tt>.
  #
  PARCIAL_2 = 1

  #
  # Constante para el tipo de examen <tt>PARCIAL 3</tt>.
  #
  PARCIAL_3 = 2

  #
  # Constante para el tipo de examen <tt>ORDINARIO</tt>.
  #
  ORDINARIO = 3

  #
  # Constante para el tipo de examen <tt>EXTRAORDINARIO 1</tt>.
  #
  EXTRAORDINARIO_1 = 4

  #
  # Constante para el tipo de examen <tt>EXTRAORDINARIO 2</tt>.
  #
  EXTRAORDINARIO_2 = 5

  #
  # Constante para el tipo de examen <tt>ESPECIAL</tt>.
  #
  ESPECIAL = 6

  #Asociaciones
  belongs_to :curso
  has_many :examenes_profesores, :dependent => :destroy
  has_many :profesores, :through => :examenes_profesores

  accepts_nested_attributes_for :examenes_profesores,
    :allow_destroy => true,
    :reject_if => proc { |examen_profesor| examen_profesor[:profesor_id].blank? }
  
  #Validaciones
  validates :curso_id,
    :presence => true
  validates :aula,
    :presence => true,
    :length => {:maximum => 15}
  validates :fecha,
    :presence => true
  validates :tipo,
    :presence => true,
    :uniqueness => {:scope => :curso_id}
  validates :nombre,
    :presence => true,
    :length => {:maximum => 20}
  validates :hora_inicio,
    :presence => true,
    :time_format => true
  validates :hora_fin,
    :presence => true,
    :time_format => true

  #validate :fecha_esta_en_calendario
  validate :hora_inicio_menor_que_hora_fin
  validate :is_aula_avalible?, :on => :create

  validates_associated :examenes_profesores

  after_update :save_examenes_profesores

  def new_examen_profesor_attributes=(examen_profesor_attributes)
    examen_profesor_attributes.each do |attributes|
      examenes_profesores.build(attributes) unless attributes[:profesor_id].blank?
    end
  end

  def existing_examen_profesor_attributes=(examen_profesor_attributes)
    examenes_profesores.reject(&:new_record?).each do |examen_profesor|
      attributes = examen_profesor_attributes[examen_profesor.id.to_s]
      if attributes
        examen_profesor.attributes = attributes
      else
        examenes_profesores.delete(examen_profesor)
      end
    end
  end

  def save_examenes_profesores
    examenes_profesores.each do |examen_profesor|
      examen_profesor.save(false)
    end
  end

  private

  def hora_inicio_menor_que_hora_fin
    errors.add :hora_inicio, "debe ser menor en al menos 30 minutos de la hora de término." if Time.parse(hora_inicio) + 30.minutes > Time.parse(hora_fin)
  end

  #
  # Determina si un curso se traslapa en horas para la misma fecha y tipo de evaluación. Unicamente para los
  # cursos de un mismo grupo.
  #
  def is_aula_avalible?
    grupos = Grupo.joins(:cursos).where(:cursos => {:id => curso_id })
    examenes = Examen.joins(:curso => :grupos).where(:examenes => {:fecha => fecha, :tipo => tipo}, :grupos => {:id => grupos})

    examenes.each do |examen|
      if Time.parse(hora_inicio).between?(Time.parse(examen.hora_inicio), Time.parse(examen.hora_fin) - 1.minute) or Time.parse(hora_fin).between?(Time.parse(examen.hora_inicio) + 1.minute, Time.parse(examen.hora_fin))
        errors.add :hora_inicio, "ya se encuentra ocupada."
        break
      end
    end
  end

  public

  #
  # Obtiene el intervalo de tiempo de la hora de inicio y término del examen bajo el
  # formato: <tt>hora_inicio:hora_termino</tt>.
  # Ejemplo: <tt>08:00 - 10:00</tt>
  #
  def get_hora
    self.hora_inicio.to_s + ' - ' + self.hora_fin.to_s
  end

  #
  # Obtiene el nombre del profesor empezando con nombre, apellido paterno y materno
  # para el examen en cuestión.
  #
  def get_profesor_titular
    profesor = Profesor.joins(:examenes_profesores => :examen).
      where(:examenes_profesores => {:tipo => ExamenProfesor::TITULAR}, :examenes => {:id => self}).first

    profesor.nil? ? 'SIN PROFESOR' : profesor.full_name
  end

  #
  # Obtiene el nombre del profesor con el grado académico abreviado para el examen en custión
  #
  def get_profesor_titular_with_grado
    profesor = Profesor.joins(:examenes_profesores => :examen).
      where(:examenes_profesores => {:tipo => ExamenProfesor::TITULAR}, :examenes => {:id => self}).first

    profesor.nil? ? 'SIN PROFESOR' : profesor.full_name_with_grado
  end

  #
  # Obtiene el rango de fechas para las múltiples evaluaciones según el tipo de
  # examen dado.
  #
  def get_date_range
    fechas = self.curso.ciclo.configuracion_ciclo

    unless fechas.nil?
      case(self.tipo)
      when Examen::PARCIAL_1
        fechas.get_fechas_for_parcial_1
      when Examen::PARCIAL_2
        fechas.get_fechas_for_parcial_2
      when Examen::PARCIAL_3
        fechas.get_fechas_for_parcial_3
      when Examen::ORDINARIO
        fechas.get_fechas_for_ordinario
      when Examen::EXTRAORDINARIO_1
        fechas.get_fechas_for_extraordinario_1
      when Examen::EXTRAORDINARIO_2
        fechas.get_fechas_for_extraordinario_2
      when Examen::ESPECIAL
        fechas.get_fechas_for_especial
      end
    else
      "No tiene el calendario de exámenes para este periodo escolar."
    end
  end

  #
  # Determina si la configuración del examen, según el tipo, permita el ingreso
  # de múltiples profesores. Únicamente es válido para los extras y especial.
  #
  def is_valid_for_multiple_profesor?
    self.tipo.eql?(EXTRAORDINARIO_1) or self.tipo.eql?(EXTRAORDINARIO_2) or self.tipo.eql?(ESPECIAL)
  end

  #
  # Obtiene las fechas dentro del rango del periodo de evaluacione según el tipo
  # del examen. Si el periodo no contiene el calendario de examenes, regresará
  # un arreglo vacío
  #
  def get_dates_as_array
    fechas = self.curso.ciclo.configuracion_ciclo

    dates = Array.new
    unless fechas.nil?
      case(self.tipo)
      when Examen::PARCIAL_1
        date_tmp = fechas.inicio_parcial1
        while date_tmp <= fechas.fin_parcial1
          dates << date_tmp
          date_tmp += 1.day
        end
      when Examen::PARCIAL_2
        date_tmp = fechas.inicio_parcial2
        while date_tmp <= fechas.fin_parcial2
          dates << date_tmp
          date_tmp += 1.day
        end
      when Examen::PARCIAL_3
        date_tmp = fechas.inicio_parcial3
        while date_tmp <= fechas.fin_parcial3
          dates << date_tmp
          date_tmp += 1.day
        end
      when Examen::ORDINARIO
        date_tmp = fechas.inicio_final
        while date_tmp <= fechas.fin_final
          dates << date_tmp
          date_tmp += 1.day
        end
      when Examen::EXTRAORDINARIO_1
        date_tmp = fechas.inicio_extra1
        while date_tmp <= fechas.fin_extra1
          dates << date_tmp
          date_tmp += 1.day
        end
      when Examen::EXTRAORDINARIO_2
        date_tmp = fechas.inicio_extra2
        while date_tmp <= fechas.fin_extra2
          dates << date_tmp
          date_tmp += 1.day
        end
      when Examen::ESPECIAL
        if fechas.are_especial_dates_eql?
          dates << fechas.inicio_especial
        else
          date_tmp = fechas.inicio_especial
          while date_tmp <= fechas.fin_especial
            dates << date_tmp
            date_tmp += 1.day
          end
        end
      end
    end

    dates
  end

  #
  # Determina si existen calificaciones guardadas para el tipo de examen seleccionado
  # por el usuario.
  # 
  # Devuelve verdadero para el caso en que sí existe al menos una calificación. Falso
  # en caso contrario.
  #
  def has_calificaciones?
    !case(tipo)
    when PARCIAL_1
      Calificacion.joins(:inscripcion_curso).where(:inscripciones_cursos => {:curso_id => curso_id}, :calificaciones => {:parcial1 => 0.0..10.0}).blank?
    when PARCIAL_2
      Calificacion.joins(:inscripcion_curso).where(:inscripciones_cursos => {:curso_id => curso_id}, :calificaciones => {:parcial2 => 0.0..10.0}).blank?
    when PARCIAL_3
      Calificacion.joins(:inscripcion_curso).where(:inscripciones_cursos => {:curso_id => curso_id}, :calificaciones => {:parcial3 => 0.0..10.0}).blank?
    when ORDINARIO
      Calificacion.joins(:inscripcion_curso).where(:inscripciones_cursos => {:curso_id => curso_id}, :calificaciones => {:final => 0.0..10.0}).blank?
    when EXTRAORDINARIO_1
      Calificacion.joins(:inscripcion_curso).where(:inscripciones_cursos => {:curso_id => curso_id}, :calificaciones => {:extra1 => 0.0..10.0}).blank?
    when EXTRAORDINARIO_2
      Calificacion.joins(:inscripcion_curso).where(:inscripciones_cursos => {:curso_id => curso_id}, :calificaciones => {:extra2 => 0.0..10.0}).blank?
    when ESPECIAL
      Calificacion.joins(:inscripcion_curso).where(:inscripciones_cursos => {:curso_id => curso_id}, :calificaciones => {:especial => 0.0..10.0}).blank?
    else
      false
    end
  end
  
  def full_calificaciones?
    !case(tipo)
    when PARCIAL_1
      Calificacion.joins(:inscripcion_curso).where(:inscripciones_cursos => {:curso_id => curso_id}).exists?(:parcial1 => nil)
    when PARCIAL_2
      Calificacion.joins(:inscripcion_curso).where(:inscripciones_cursos => {:curso_id => curso_id}).exists?(:parcial2 => nil)
    when PARCIAL_3
      Calificacion.joins(:inscripcion_curso).where(:inscripciones_cursos => {:curso_id => curso_id}).exists?(:parcial3 => nil)
    when ORDINARIO
      Calificacion.joins(:inscripcion_curso).where(:inscripciones_cursos => {:curso_id => curso_id}).exists?(:final => nil)
    when EXTRAORDINARIO_1
      Calificacion.joins(:inscripcion_curso).where(:promedio => 0.0..5.9, :inscripciones_cursos => {:curso_id => curso_id}).exists?(:extra1 => nil)
    when EXTRAORDINARIO_2
      Calificacion.joins(:inscripcion_curso).where(:extra1 => 0.0..5.9, :inscripciones_cursos => {:curso_id => curso_id}).exists?(:extra2 => nil)
    when ESPECIAL
      Calificacion.joins(:inscripcion_curso).where(:extra2 => 0.0..5.9, :inscripciones_cursos => {:curso_id => curso_id}).exists?(:especial => nil)
    else
      false
    end
  end
  
end
