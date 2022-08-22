class Materia < ActiveRecord::Base
  #----Relaciones---------------------------------------------------------------
  has_many :materias_planes

  accepts_nested_attributes_for :materias_planes,
    :allow_destroy => true
  
  #----Validaciones-------------------------------------------------------------
  validates :nombre_materia,
    :presence => true,
    :length => {:maximum => 70},
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ()\s\"\.\:\-\_]{1,255}\Z/i}
  validates :clave,
    :presence => true,
    :length => {:maximum => 10},
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ()\s\-\_]{1,255}\Z/i}

  public
  #
  # Regresa un objeto de tipo materia mediante el identificador del curso. Si el indentificador del curso no existe,
  # regresa un objeto nulo.
  #
  # Este método debe de regresar un sólo objeto, ya que un curso tiene y debe tener una sola materia. Se agrega el método first
  # debido a que sin él regresa un arreglo de objetos de tipo materia. Tomando en cuenta la unicidad de curso hacia materia es
  # preferible manejar un objeto a manejar un arreglo de objetos de longitud 1.
  #
  def self.get_materia_by_curso_id(curso_id)
    joins(:materias_planes => :cursos).where(:cursos => {:id => curso_id}).first
  end

  #
  # Regresa el nombre de la materia mediante el identificador del curso. Si no existiera el enlace desde curso hasta materia en
  # la base de datos, el sistema regresará la cadena "SIN NOMBRE".
  #
  # Es casi 100% probable que siempre devuelva el nombre de la materia, ya que para crear cursos se necesitan de las materias. Pero
  # en esta vida todo puede suceder =D
  #
  def self.get_nombre_by_curso_id(curso_id)
    materia = Materia.get_materia_by_curso_id(curso_id)

    return !materia.nil? ? materia.nombre_materia : "SIN NOMBRE"
  end
 
  #
  # Regresa la clave de la materia mediante el identificador del curso. Si no existiera el enlace desde curso hasta materia en
  # la base de datos, el sistema regresará la cadena "SIN CLAVE".
  #
  def self.get_clave_by_curso_id(curso_id)
    materia = Materia.get_materia_by_curso_id(curso_id)

    return !materia.nil? ? materia.clave : "SIN CLAVE"
  end

  #
  # Regresa el nombre de la materia  mediante el identificador de la materia.
  # Si no existiera en la base de datos, el sistema regresará la cadena "SIN NOMBRE".
  #
  def self.get_nombre_by_materia_id(materia_id)
    mat = Materia.where(:id => materia_id).first
    
    return !mat.nil? ? mat.nombre_materia : "SIN NOMBRE"
  end

  #
  # Regresa la clave de la materia mediante el identificador de la materia.
  # Si no existiera en la base de datos, el sistema regresará la cadena "SIN CLAVE".
  #
  def self.get_clave_by_materia_id(materia_id)
    mat = Materia.find_by_id(materia_id)

    return !mat.nil? ? mat.clave : "SIN CLAVE"
  end

  #
  # Regresa los creditos de la materia mediante el identificador de la materia.
  # Si no existiera en la base de datos, el sistema regresará la cadena "".
  #
  def self.get_creditos_by_materia_clave(materia_clave)
    mat = Materia.find_by_clave(materia_clave)

    return !mat.nil? ? mat.creditos : ""
  end

  #
  # Regresa el identificador de la materia mediante la clave
  # Si no existiera en la base de datos, el sistema regresará la cadena "SIN CLAVE".
  #
  def self.get_materia_id_by_clave_materia(materia_id)
    mat = Materia.find_by_id(materia_id)

    return !mat.nil? ? mat.clave : "SIN CLAVE"
  end
end
