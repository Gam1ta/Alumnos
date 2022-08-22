class PlanEstudio < ActiveRecord::Base
  #Asociaciones-----------------------------------------------------------------
  belongs_to :carrera
  belongs_to :semestr, 
    :class_name => "Semestr",
    :foreign_key => 'semestre_id'
  belongs_to :ciclo
  has_many :asignaturas,
    :dependent => :destroy

  #Validaciones-----------------------------------------------------------------
  validates :carrera_id,
    :presence => true
  validates :semestre_id,
    :presence => true
  validates :clave_plan,
    :presence => true,
    :length => {:maximum => 11},
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ()\s\-\_]{1,255}\Z/i},
    :uniqueness => {:scope => [:carrera_id, :semestre_id]}
  validates :numero_plan,
    :presence => true,
    :length => {:maximum => 5}

  delegate :nombre_carrera, :to => :carrera, :prefix => true, :allow_nil => true
  delegate :ciclo, :to => :ciclo, :prefix => true, :allow_nil => true

  public
  #
  # Regresa un objeto de tipo plan_estudio mediante el identificador del curso. Si el indentificador del curso no existe,
  # regresa un objeto nulo.
  #
  # Este método debe de regresar un sólo objeto, ya que un curso tiene y debe tener un solo plan de estudio. Se agrega el método first
  # debido a que sin él regresa un arreglo de objetos de tipo plan_estudio. Tomando en cuenta la unicidad de curso hacia plan_estudio es
  # preferible manejar un objeto a manejar un arreglo de objetos de longitud 1.
  #
  def self.get_plan_estudio_by_curso_id(curso_id)
    joins(:materias_planes => :cursos).where(:cursos => {:id => curso_id}).first
  end

  #
  # Regresa el nombre del plan de estudios mediante el identificador del curso. Si no existiera el enlace desde curso hasta plan_estudio en
  # la base de datos, el sistema regresará la cadena "SIN PLAN DE ESTUDIO".
  #
  # Es casi 100% probable que siempre devuelva el nombre del plan de estudios, ya que para crear cursos se necesitan de planes de estudio. Pero
  # en esta vida todo puede suceder =D
  #
  def self.get_nombre_by_curso_id(curso_id)
    plan_estudio = PlanEstudio.get_plan_estudio_by_curso_id(curso_id)

    return !plan_estudio.nil? ? plan_estudio.clave_plan : "SIN PLAN DE ESTUDIOS"
  end

  #
  # Obtiene los planes correspondientes a la carrera dada la carrera y el plan de referencia.
  # LA restriccion es que regresa todos los planes excepto el plan que recibe.
  # Esto es usado para Cambio de Planes, para concsultar las opciones de cambio de plan,
  # claro que no sea el mimo que actualmente tiene el alumno
  #
  def self.get_other_planes_by_carrera_and_clave_plan(carrera_id,clave_plan)
    select("distinct clave_plan").where("clave_plan !=? and carrera_id = ?",clave_plan,carrera_id)
  end

  def self.get_all_by_carrera_id(carrera_id)
    select("distinct clave_plan, numero_plan").where(" carrera_id = ?",carrera_id)
  end

  def self.get_creditos_by_plan(clave_plan)
    select("sum (materias.creditos) as creditos").
      joins(:materias_planes => :materia).where(:clave_plan => clave_plan).first
  end

  #
  # Obtiene el periodo de inicio de vigencia para el plan de estudio.
  #
  def get_inicio_vigencia
    self.ciclo.nil? ? "No tiene un periodo de inicio de vigencia." : self.ciclo_ciclo
  end
end
