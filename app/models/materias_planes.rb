class MateriasPlanes < ActiveRecord::Base
  #--Relaciones-----------------------------------------------------------------
  belongs_to :materia,
    :dependent => :destroy
  #belongs_to :plan_estudio
  #has_many :cursos
  #belongs_to :especialidad
  #has_many :seriadas
  #has_many :optativas
=begin
  validates :orden,
    :presence => true,
    :numericality => {:only_integer => true}
  validates :creditos,
    :presence => true,
    :numericality => {:only_integer => true}
  validates :horas_docente,
    :presence => true,
    :numericality => {:only_integer => true}
  validates :horas_independientes,
    :presence => true,
    :numericality => {:only_integer => true}

  delegate :nombre_materia,
    :to => :materia,
    :prefix => true,
    :allow_nil => true
  delegate :clave,
    :to => :materia,
    :prefix => true,
    :allow_nil => true

  #
  # Materias planes, recibe un identificador de curso y regresa un objeto de materias planes correspondietne a este.
  #
  def self.get_materias_planes_by_curso_id(curso_id)
    joins(:cursos).where(:cursos => {:id => curso_id}).first
  end

  #
  # Regresa (OPT) si una materia es optativa o "" si no,
  # Utulizada para los reportes de acta de evaluaciones y demas que requiera saber si una materia es
  # optativa, recibe el id del curso para realizar la consulta
  #
  def self.get_si_optativa_by_curso_id(curso_id)
    materia =  MateriasPlanes.get_materias_planes_by_curso_id(curso_id)
    return !materia.optativa_hija == false ? " - (OPT)" : " "    
  end

  #
  # Determina si una asignatura es seriada
  #
  def is_seriada?
    !self.seriadas.blank?
  end

  #
  # Obtiene las claves de las asignaturas seriadas para la asignatura actual.
  #
  def get_claves_seriadas
    claves_seriadas = ""
    self.seriadas.each do |seriada|
      claves_seriadas += seriada.get_clave + " "

    end
    return claves_seriadas
  end

  #
  # Obtiene un arreglo con los identificadores de las asignaturas seriadas para
  # la asignatura actual
  #
  def get_ids_seriadas
    ids_array = Array.new
    self.seriadas.each do |seriada|
      ids_array << seriada.get_id_seriada
    end

    return ids_array
  end

  #
  # Determina si una asignatura es optativa
  #
  def is_optativa_mp?
    !self.optativas.blank?
  end

  #
  # Obtiene un arreglo con los identificadores de las asignaturas optativas para
  # la asignatura actual.
  #
  def get_ids_optativas
    ids_array = Array.new
    self.optativas.each do |optativa|
      ids_array << optativa.get_id_optativa
    end

    ids_array
  end
=end
end
