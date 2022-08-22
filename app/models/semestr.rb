class Semestr < ActiveRecord::Base
  #
  # Constante que define la clave del <tt>PRIMER</tt> semestre
  #
  PRIMERO = 1

  #
  # Constante que define la clave del <tt>SEGUNDO</tt> semestre
  #
  SEGUNDO = 2

  #
  # Constante que define la clave del <tt>TERCER</tt> semestre
  #
  TERCERO = 3

  #
  # Constante que define la clave del <tt>CUARTO</tt> semestre
  #
  CUARTO = 4

  #
  # Constante que define la clave del <tt>QUINTO</tt> semestre
  #
  QUINTO = 5

  #
  # Constante que define la clave del <tt>SEXTO</tt> semestre
  #
  SEXTO = 6

  #
  # Constante que define la clave del <tt>SÉPTIMO</tt> semestre
  #
  SEPTIMO = 7

  #
  # Constante que define la clave del <tt>OCTAVO</tt> semestre
  #
  OCTAVO = 8

  #
  # Constante que define la clave del <tt>NOVENO</tt> semestre
  #
  NOVENO = 9

  #
  # Constante que define la clave del <tt>DÉCIMO</tt> semestre
  #
  DECIMO = 10

  #Relaciones
  has_many :planes_estudio,
    :foreign_key => "semestre_id"
  has_many :inscripciones,
    :foreign_key => "semestre_id"

  #Validaciones
  validates :clave_semestre,
    :presence => true,
    :uniqueness => true,
    :length => {:maximum => 15}

  #
  # Regresa un objeto de tipo semestr mediante el identificador del curso. Si el indentificador del curso no existe,
  # regresa un objeto nulo.
  #
  # Este método debe de regresar un sólo objeto, ya que un curso tiene y debe estar es un único semestre. Se agrega el método first
  # debido a que sin él regresa un arreglo de objetos de tipo semestr. Tomando en cuenta la unicidad de curso hacia semestr es
  # preferible manejar un objeto a manejar un arreglo de objetos de longitud 1.
  #
  def self.get_semestre_by_curso_id(curso_id)
    joins(:planes_estudio => {:asignaturas => :cursos}).where(:cursos => {:id => curso_id}).first
  end

  #
  # Regresa el nombre del semestre mediante el identificador del curso. Si no existiera el enlace desde curso hasta semestr en
  # la base de datos, el sistema regresará la cadena "SIN SEMESTRE".
  #
  # Es casi 100% probable que siempre devuelva el nombre del semestre, ya que para crear cursos se necesitan de los semestres. Pero
  # en esta vida todo puede suceder =D
  #
  # Se pone clave semestre, ya que así se llama el campo de la tabla semestres en donde se almacena el nombre.
  #
  def self.get_nombre_by_curso_id(curso_id)
    semestre = Semestr.get_semestre_by_curso_id(curso_id)

    return !semestre.nil? ? semestre.clave_semestre : "SIN SEMESTRE"
  end

  #
  # Regresa la clave del semestre mediante la carrera , periodo y curso seleccionado
  # siempre y cuando existan inscripciones con estos parametros
  #  
  def self.get_clave_semestre_by_carrera_and_periodo_and_grupo(carrera,periodo,grupo)
    select("distinct semestres.clave_semestre").
      joins(:inscripciones).
      where(:inscripciones => {:carrera_id => carrera, :ciclo_id => periodo, :grupo_id => grupo}).first
  end

  #
  # Regresa el identificador del semestre de acuerdo a la clave del mismo
  # esto es porque no siempre se encuentran en orden , como primer semester id = 1 , etc etc
  #
  def self.get_id_by_clave(clave)
    semestre = Semestr.where("clave = ?" , clave)
    return !semestre.nil? ? semestre.id : nil
  end

  #
  # Regresa la clave del semestre dado el identificador
  # para poder hacer una busqeda eb irden de los semetsres
  #
  def self.get_clave_by_semestre_id(id)
    semestre = Semestr.where("id = ?" , id).first
    return !semestre.nil? ? semestre.clave : nil
  end

  def self.has_inscripciones_by_alumno_and_clave_semestre(alumno,clave)
    select("distinct semestr.clave ").
      joins(:inscripciones).
      where("inscripciones.alumno_id = ? and semestr.clave = ?", alumno, clave)
  end

  #
  # Determina si el semestre es el <tt>primer</tt> o <tt>primero</tt>.
  #
  def is_first?
    self.clave.eql?(PRIMERO)
  end
end
