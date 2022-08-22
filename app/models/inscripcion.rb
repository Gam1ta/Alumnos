class Inscripcion < ActiveRecord::Base
  #
  # Constante para manipular si un alumno es aceptado para realizar la inscripción.
  #
  ACEPTADO = 1

  #
  # Constante para manipular si un alumno NO es aceptado para realizar la inscripción.
  #
  NO_ACEPTADO = 2

  #
  # Constante para indicar que la inscripcion al semestre SI es aprobada
  #
  APROBADO = 3

  #
  # Constante para indicar que la inscripcion al semestre NO es aprobada
  #
  REPROBADO = 4

  #
  # Constante para indicar que la inscripción al semestre es regular.
  #
  REGULAR = 'REGULAR'

  #
  # Constante para indicar que la inscripción al semestre es irregular.
  #
  IRREGULAR = 'IRREGULAR'

  #
  # Constante para indicar que la inscripción al semestre es repetidor.
  #
  REPETIDOR = 'REPETIDOR'

  belongs_to :alumno
  belongs_to :grupo
  belongs_to :ciclo
  belongs_to :carrera
  belongs_to :semestr,
    :class_name => "Semestr",
    :foreign_key => 'semestre_id'
  has_one :lectura,
    :dependent => :destroy
  has_many :inscripciones_cursos,
    :dependent => :destroy
  has_many :cursos,
    :through => :inscripciones_cursos

  #Validaciones
  validates :ciclo_id,
    :presence => true
  validates :semestre_id,
    :presence => true
  validates :carrera_id,
    :presence => true

  delegate :nombre,
    :to => :grupo,
    :prefix => true,
    :allow_nil => true
  delegate :nombre_carrera,
    :to => :carrera,
    :prefix => true,
    :allow_nil => true
  delegate :clave_semestre,
    :to => :semestr,
    :prefix => true,
    :allow_nil => true
  delegate :ciclo,
    :to => :ciclo,
    :prefix => true,
    :allow_nil => true

  #
  # Obtiene todas las inscripciones que el alumno haya tenido, así como el nombre del periodo, el nombre del semestre y el
  # nombre del grupo por cada semestre inscrito, ordernados por semestre y ciclo.
  #
  def self.get_all_by_alumno_id(alumno_id)
    select("inscripciones.*, ciclos.ciclo as nombre_ciclo, semestres.clave_semestre as nombre_semestre, grupos.nombre as nombre_grupo").
      joins(:ciclo, :semestr, :grupo).where(:inscripciones => {:alumno_id => alumno_id}).order("semestres.clave, ciclos.ciclo")
  end

  #
  # Obtiene todas las inscripciones que el alumno haya tenido en la carrera dada, así como el nombre del periodo, el nombre del semestre y el
  # nombre del grupo por cada semestre inscrito, ordernados por semestre y ciclo.
  #
  def self.get_all_by_alumno_id_and_carrera_id(alumno_id, carrera_id)
    select("inscripciones.*, ciclos.ciclo as nombre_ciclo, semestres.clave_semestre as nombre_semestre, grupos.nombre as nombre_grupo").
      joins(:ciclo, :semestr, :grupo).where(:inscripciones => {:alumno_id => alumno_id, :carrera_id => carrera_id}).order("semestres.clave, ciclos.ciclo")
  end

  #
  # Obtiene todas las inscripciones que el alumno haya tenido en la carrera dada en el 
  # semetsre indicado cpor la clave del mismo, así como el nombre del periodo, el nombre
  # del semestre y el  nombre del grupo por cada semestre inscrito, ordernados por ciclo.
  #
  def self.get_all_by_alumno_id_and_carrera_id_and_clave_semestre(alumno_id, carrera_id, clave_semestre)
    select("inscripciones.*, ciclos.ciclo as nombre_ciclo, semestres.clave_semestre as nombre_semestre, grupos.nombre as nombre_grupo").
      joins(:ciclo, :semestr, :grupo).where(:inscripciones => {:alumno_id => alumno_id, :carrera_id => carrera_id },:semestres => {:clave => clave_semestre}).order("ciclos.ciclo")
  end

  #
  # Obtiene el sexo y el total de alumnos que se inscribieron a primer semestre, correspondiente a ese sexo.
  #
  def self.get_sexo_and_total_alumnos_by_carrera_id_and_periodo_id_and_semestre_id(carrera,periodo,semestre)
    select("distinct datos_personales.sexo , count(datos_personales.alumno_id) as total").
      joins(:alumno => :dato_personal).
      where("inscripciones.carrera_id = ? and inscripciones.ciclo_id = ? and inscripciones.semestre_id = ?",carrera, periodo,semestre).group("datos_personales.sexo")
  end

  #
  # Obtiene la edad y el total de alumnos que se inscribieron a primer semestre, correspondiente a esa edad.
  #
  def self.get_edad_and_total_alumnos_by_carrera_id_and_periodo_id_and_semestre_id(carrera,periodo,semestre)
    select("distinct date_part('year',age(datos_personales.fecha_nacimiento )) AS edad, count(datos_personales.alumno_id) as total").
      joins(:alumno => :dato_personal).
      where("inscripciones.carrera_id = ? and inscripciones.ciclo_id = ? and inscripciones.semestre_id = ?",carrera, periodo,semestre).group("datos_personales.sexo")
  end

  #
  # Obtiene la edad , sexo y el total de alumnos que se inscribieron a primer semestre, correspondiente a esa edad.
  #
  def self.get_edad_and_sexo_and_total_alumnos_by_carrera_id_and_periodo_id_and_semestre_id(carrera,periodo,semestre)
    select("distinct date_part('year',age(datos_personales.fecha_nacimiento )) AS edad, datos_personales.sexo  , count(datos_personales.alumno_id) as total").
      joins(:alumno => :dato_personal).
      where("inscripciones.carrera_id = ? and inscripciones.ciclo_id = ? and inscripciones.semestre_id = ?",carrera, periodo,semestre).group("datos_personales.sexo")
  end

  #
  # Obtiene el registro de la última inscripción que se haya efectuado, teniendo
  # como restricción que el periodo sea de tipo A ó B. El periodo de verano no se
  # toma en cuenta, ya que es para regulación académica del alumno.
  #
  def self.get_last_by_alumno(alumno)
    joins(:ciclo).
      where(:inscripciones => {:alumno_id => alumno, :status =>['REGULAR','IRREGULAR','REPETIDOR']}, :ciclos => {:tipo => ['A', 'B']}).
      order("ciclos.ciclo desc").first
  end
  def self.get_last_verano_by_alumno(alumno)
    joins(:ciclo).
      where(:inscripciones => {:alumno_id => alumno, :status =>['REGULAR','IRREGULAR','REPETIDOR']}, :ciclos => {:tipo => 'V'}).
      order("ciclos.ciclo desc").first
  end

  def self.get_last_user_data(alumno)
    select("distinct ciclos.ciclo, ciclos.inicio, ciclos.fin, inscripciones.grupo_id, inscripciones.beca").
     joins(:ciclo).where(:inscripciones => {:alumno_id => alumno}).order("ciclos.ciclo").last
  end

  #
  # Obtiene el registro de la primera inscripción de acuerdo al semestre proporcionado,
  # independientemente si el alumno tenga dos o más inscripciones para el mismo semestre,
  # siempre devolverá la primera inscripción.
  #
  def self.get_first_by_carrera_and_alumno_and_semestre(carrera, alumno, semestre)
    joins(:semestr, :ciclo).
      where(:inscripciones => {:alumno_id => alumno, :carrera_id => carrera}, :semestres => {:clave => semestre}).
      order("ciclos.ciclo").
      first
  end

  #
  # Determina si existe una inscripcion en la tabla inscripciones, esto indicará
  # que el alumno ya ha cursado el semestre proporcinado, independientemente si
  # cursó o no todas las asignaturas correspondientes al semestre proporcionado.
  #
  def self.exist?(alumno, semestre)
    !joins(:semestr).
      where(:inscripciones => {:alumno_id => alumno}, :semestres => {:clave => semestre}).
      blank?
  end

  #
  # Devuelve el nombre del periodo en que se registró la inscripción. <tt>Cadena Vacía</tt>
  # en caso contrario.
  #
  def get_periodo
    return !self.ciclo.nil? ? self.ciclo.ciclo : ""
  end

  #
  # Devuelve el nombre del grupo  que se le asigno en esta inscripcion.
  #
  def get_grupo
    return !self.grupo.nil? ? self.grupo.nombre : "Sin grupo"
  end

  #
  # Obtiene la lista Estados de las escuelas procedentes y el numero de alumnos procedentes de cada
  # uno que se presentan en las inscripciones de determinado ciclo
  # y carrera
  #
  def self.get_list_bachilleratos_estado_procedencia_and_alumnos(ciclo,carrera,semestre)
    select("distinct estados.nombre as estado,  count(inscripciones.id) as total").
      joins(:alumno => { :antecedente_academico => {:escuela_procedente => {:direccion => { :ciudad => :estado }}}}).
      where(:inscripciones => {:ciclo_id => ciclo, :carrera_id =>carrera ,:semestre_id =>semestre}, :direcciones => {:tabla_type => "EscuelaProcedente"}).
      group("estados.nombre").
      order("estados.nombre")
  end

  #
  # Obtiene la lista de escuelas de procedencia y el total de alumnos de cada una
  #  
  def self.get_list_bachillerato_procedencia_and_num_alumnos_by_ciclo_and_carrera_and_semestre(ciclo,carrera,semestre)
    select("distinct escuelas_procedentes.nombre, count(alumnos.id) as total").
      joins(:alumno => {:antecedente_academico => :escuela_procedente}).
      where(:inscripciones => {:ciclo_id => ciclo, :carrera_id =>carrera ,:semestre_id =>semestre}).
      group("escuelas_procedentes.nombre").
      order("escuelas_procedentes.nombre")
  end
end
