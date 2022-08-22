class Ficha < ActiveRecord::Base
  #
  # Constante para representar el status de la ficha como PENDIENTE. Es el status
  # que se le asigna al aspirante cuando se inscribe.
  #
  PENDIENTE = 'PENDIENTE'

  #
  # Constante para representar el status de la ficha como ACEPTADO. Indicará que
  # el aspirante aprobó el examen de admisión.
  #
  ACEPTADO = 'ACEPTADO'

  #
  # Constante para representar el status de la ficha como NO ACEPTADO. Indicará
  # que el aspirante NO aprobó el examen de admisión.
  #
  NO_ACEPTADO = 'NO ACEPTADO'

  #
  # Constante para manejar los status para un select que se empleé en la vista.
  #
  STATUS = [PENDIENTE, ACEPTADO, NO_ACEPTADO]
  
  belongs_to :alumno
  belongs_to :carrera
  belongs_to :ciclo
  belongs_to :configuracion_aspirante
  
  has_many :calificaciones_fichas, :dependent => :destroy
  has_many :materia_aspirantes,
    :through => :calificaciones_fichas

  validates :fecha_solicitud,
    :date => true
  validates :numero, 
    :presence => true,
    :format => {:with => /\d{4,4}/, :message => " debe contener 4 números "}
  validates :carrera_id,
    :presence => true
  validates :ciclo_id,
    :presence => true
  validates :alumno_id,
    :presence => true
  validates :alumno_id,
    :uniqueness => {:scope => [:configuracion_aspirante_id, :tipo], :message => ", ya cuenta con una inscripción a fichas en este periodo."}

  #before_validation :get_inscripcion_alumno
  #before_validation :get_inscripcion_prope

  delegate :ciclo,
    :to => :ciclo,
    :prefix => true,
    :allow_nil => true

  delegate :nombre_carrera,
    :to => :carrera,
    :prefix => true,
    :allow_nil => true

  #
  # Verifica si el alumno tiene inscripciones a semestre
  #
  def get_inscripcion_alumno
    errors.add(self.alumno.curp + " | " + self.alumno.full_name, ", ya cuenta con al menos una inscripción a semestre.")  unless !self.alumno.inscripciones.exists?
  end
  #
  # Verifica si el alumno tiene inscripciones a propedeutico
  #
  def get_inscripcion_prope
    errors.add(self.alumno.curp + " | " + self.alumno.full_name, ", ya cuenta con una inscripción a propedéutico en este periodo.")  unless !self.alumno.propedeuticos.exists?(:ciclo_id => self.ciclo_id)
  end

  #
  # Obtiene la lista de todas las fichas junto con los nombres de los alumnos ordenados por apellidos y nombre
  # de acuerdo al periodo y tipo de ficha proporcionados.
  #
  # La constante es empleada para tratar el nombre completo del alumno como una sola cadena y atributo del
  # resultado de la consulta a la base de datos.
  #
  def self.get_all_by_periodo_and_tipo(periodo, tipo)
    select(Alumno::ORDER_FULL_NAME + ", fichas.*").joins(:alumno).
      where(:fichas => {:ciclo_id => periodo, :tipo => tipo}).
      order("full_name_as_string")
  end

  #
  # Obtiene la lista de todas las fichas junto con los nombres de los alumnos ordenados por apellidos y nombre
  # de acuerdo a la carrera, periodo y tipo de ficha proporcionados.
  #
  # La constante es empleada para tratar el nombre completo del alumno como una sola cadena y atributo del
  # resultado de la consulta a la base de datos.
  #
  def self.get_all_by_carrera_and_periodo_and_tipo(carrera, periodo, tipo)
    select(Alumno::ORDER_FULL_NAME + ", fichas.*").joins(:alumno).
      where(:fichas => {:carrera_id => carrera, :ciclo_id => periodo, :tipo => tipo}).
      order("full_name_as_string")
  end

  #
  # Obtiene todos los alumnos en fichas agrupadas por lugar y ordenadas alfabeticamente por nombre
  # de acuerdo a la carrera y periodo proporcionados
  # full_name_as_string constante contiene el nombre completo del alumno desde la base de datos
  #
  def self.get_all_by_carrera_and_periodo_order_by_lugar(carrera, periodo,configuracion_id)
    if configuracion_id.blank?
      select(Alumno::ORDER_FULL_NAME + ", fichas.*").joins(:alumno,:configuracion_aspirante).
        where(:fichas => {:carrera_id => carrera, :ciclo_id => periodo}).
        order("configuraciones_aspirantes.fecha_examen,configuraciones_aspirantes.lugar,full_name_as_string")
    else
      select(Alumno::ORDER_FULL_NAME + ", fichas.*").joins(:alumno,:configuracion_aspirante).
        where(:fichas => {:carrera_id => carrera, :ciclo_id => periodo, :configuracion_aspirante_id => configuracion_id}).
        order("configuraciones_aspirantes.fecha_examen,configuraciones_aspirantes.lugar, full_name_as_string")
    end
  end

  #
  # Obtiene las fichas de todos los alumnos de acuerdo a la carrera y periodo proporcionados, ordenados alfabeticamente
  # full_name_as_string constante contiene el nombre completo del alumno desde la base de datos
  #
  def self.get_all_by_carrera_and_periodo(carrera, periodo)
    select(Alumno::ORDER_FULL_NAME + ", fichas.*").joins(:alumno).
      where(:fichas => {:carrera_id => carrera, :ciclo_id => periodo}).
      order("full_name_as_string")
  end
  
  #
  # Obtiene las fichas de todos los alumnos de acuerdo a la carrera, periodo y status proporcionados,
  # ademas por el tipo de proceso, CORTO, LARGO o TODOS ordenados alfabeticamente
  # full_name_as_string constante contiene el nombre completo del alumno desde la base de datos
  #
  def self.get_all_by_carrera_and_periodo_and_status_and_proceso(carrera, periodo, status, tipo_proceso)
    if tipo_proceso == 'TODOS'
      select(Alumno::ORDER_FULL_NAME + ", fichas.*").joins(:alumno).
        where(:fichas => {:carrera_id => carrera, :ciclo_id => periodo , :status => status}).
        order("full_name_as_string")
    else
      select(Alumno::ORDER_FULL_NAME + ", fichas.*").joins(:alumno).
        where(:fichas => {:carrera_id => carrera, :ciclo_id => periodo , :status => status, :tipo => tipo_proceso}).
        order("full_name_as_string")
    end

  end

  #
  # Obtiene el sexo y el total de alumnos que solicitaron ficha, correspondiente a ese sexo.
  #
  def self.get_sexo_and_total_alumnos_by_carrera_id_and_periodo_id(carrera,periodo)
    select("distinct datos_personales.sexo , count(datos_personales.alumno_id) as total").
      joins(:alumno => :dato_personal).
      where("fichas.carrera_id = ? and fichas.ciclo_id = ?",carrera, periodo).group("datos_personales.sexo")
  end  
  #
  # Buscar si existe algún hueco en la numeración consecutiva de fichas, para asignar este número-. 
  # 
  def self.get_number_available(periodo) 
   numero =Ficha.where("ciclo_id = ? and CAST(numero as integer) not in (select CAST(numero as integer)-1 from fichas where ciclo_id = ?)", periodo, periodo).order(:numero).first.numero.to_i + 1   
   '%04d' % (numero.nil? ? 1 : numero)
  end

  
end
