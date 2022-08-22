class Carrera < ActiveRecord::Base
  belongs_to :campus
  belongs_to :profesor
  has_many :profesores
  has_many :fichas
  has_many :inscripciones
  has_many :propedeuticos
  has_many :planes_estudio
  has_many :materia_admision
  has_many :materias_aspirantes
  has_many :inscripciones
  #
  # Se agrega las lineas siguiente al agregar la tabla areas_conocimiento; el resto del contenido se respeta.
  #
  belongs_to :area_conocimiento
  accepts_nested_attributes_for :area_conocimiento

  validates :codigo_carrera,
    :presence => true,
    :length => {:maximum => 4},
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ()\.\s\-\_]{1,255}\Z/i}
  validates :nombre_carrera, 
    :presence => true,
    :length => {:maximum => 50},
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ()\.\s\-\_]{1,255}\Z/i},
    :uniqueness => {:scope => [:campus_id, :codigo_carrera]}
  validates :campus_id,    :presence => true
  #
  #Valida que no tenga carreras asociadas antes de eliminar el area.
  #Se agregan dos lineas al agregar la tabla areas_conocimeintos, el rsto del contenido queda intacto.
  #
  
  before_destroy  :has_planes_estudio
  before_destroy  :has_inscripciones

  delegate :nombre, :to => :campus, :prefix => true, :allow_nil => true
  delegate :clave, :to => :campus, :prefix => true, :allow_nil => true


  protected

  #
  #Realiza la validación para la existencia de planes de estudio asociados a la carrera, si existen no se podra eliminar.
  #Se agregan has_planes_estudio al agregar la tabla areas_conocimeintos, el rsto del contenido queda intacto.
  #
  def has_planes_estudio
    errors.add :carrera , "La carrera ya cuenta con algún plan de estudios registrado." unless PlanEstudio.where(:carrera_id => self.id).blank?
  end

  #
  #Realiza la validación de la existencia de inscripciones a la carrera. si existen no se podra eliminar
  #Se agregan has_inscripciones al agregar la tabla areas_conocimeintos, el rsto del contenido queda intacto.
  #
  def has_inscripciones
    errors.add :carrera , "La carrera ya cuenta con inscripciones." unless Inscripcion.where(:carrera_id => self.id).blank?
  end

  public
  #
  # Regresa un objeto de tipo carrera mediante el identificador del curso. Si el indentificador del curso no existe,
  # regresa un objeto nulo.
  #
  # Este método debe de regresar un sólo objeto, ya que un curso tiene y debe tener una sola carrera. Se agrega el método first
  # debido a que sin él regresa un arreglo de objetos de tipo carrera. Tomando en cuenta la unicidad de curso hacia carrera es
  # preferible manejar un objeto a manejar un arreglo de objetos de longitud 1.
  #
  def self.get_carrera_by_curso_id(curso_id)
    joins(:planes_estudio => {:asignaturas => :cursos}).where(:cursos => {:id => curso_id}).first
  end

  #
  # Regresa el nombre de la carrera mediante el identificador del curso. Si no existiera el enlace desde curso hasta carrera en
  # la base de datos, el sistema regresará la cadena "SIN CARRERA".
  #
  # Es casi 100% probable que siempre devuelva el nombre de la carrera, ya que para crear cursos se necesitan de las carreras. Pero
  # en esta vida todo puede suceder =D
  #
  def self.get_nombre_by_curso_id(curso_id)
    carrera = Carrera.get_carrera_by_curso_id(curso_id)

    return !carrera.nil? ? carrera.nombre_carrera : "SIN CARRERA"
  end

  #
  # Regresa el identificador de la carrera mediante el identificador del curso. Si no existiera el enlace desde curso hasta carrera
  # en la base de datos, el sistema regresará nulo.
  #
  def self.get_id_by_curso_id(curso_id)
    carrera = Carrera.get_carrera_by_curso_id(curso_id)

    return !carrera.nil? ? carrera.id : nil
  end

  #
  # Obtiene el nombre de la carrera del último semestre al que se haya inscrito el alumno.
  #
  # Regresa <b>"SIN CARRERA"</b> para el caso en que el alumno no tenga ninguna inscripción.
  #
  def self.get_nombre_by_alumno_id(alumno_id)
    carrera = joins(:inscripciones => :semestr).where(:inscripciones => {:alumno_id => alumno_id}).order("semestres.clave").last

    return !carrera.nil? ? carrera.nombre_carrera : "SIN CARRERA"
  end

  #
  # Obtiene el identificadors de la carrera del último semestre al que se haya inscrito el alumno.
  #
  # Regresa nil para el caso en que el alumno no tenga ninguna inscripción.
  #
  def self.get_id_by_alumno_id(alumno_id)
    carrera = joins(:inscripciones => :semestr).where(:inscripciones => {:alumno_id => alumno_id}).order("semestres.clave").last

    return !carrera.nil? ? carrera.id : nil
  end

  #
  # Regresa la clave del semestre mediante el periodo y curso seleccionado
  # siempre y cuando existan inscripciones con estos parametros
  #
  def self.get_carrera_by_periodo_and_grupo(periodo,grupo)
    select("distinct carreras.id as id, carreras.nombre_carrera as nombre_carrera").
      joins(:inscripciones).
      where(:inscripciones => {:ciclo_id => periodo, :grupo_id => grupo}).first
  end

  #
  # Regresa los id's y nombre's de las carreras que presentaron
  # al menos una inscripcion en el 'periodo', donde periodo es el id del ciclo
  #
  def self.get_all_by_periodo_id(periodo)
    select("distinct carreras.id as id, carreras.nombre_carrera as nombre_carrera").
      joins(:inscripciones).
      where(:inscripciones => {:ciclo_id => periodo})
  end

  #
  #
  #
  def self.has_planes_de_estudio?
    !joins(:planes_estudio, :semestr).
      where(:semestres => {:clave => Semestr::PRIMERO}).blank?
  end

  #
  # Obtiene la clave con el nombre de la carrera separados por un guión.
  #
  def get_clave_with_nombre
    self.codigo_carrera.to_s + " - " + self.nombre_carrera.to_s
  end
end
