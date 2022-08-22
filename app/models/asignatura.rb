class Asignatura < ActiveRecord::Base
  self.table_name = "materias_planes"

  belongs_to :especialidad
  belongs_to :plan_estudio
  has_many :cursos,
    :foreign_key => 'materias_planes_id'
  has_many :optativas,
    :foreign_key => 'materias_planes_id',
    :dependent => :destroy
  has_many :seriadas,
    :foreign_key => 'materias_planes_id',
    :dependent => :destroy

  accepts_nested_attributes_for :seriadas,
    :allow_destroy => true,
    :reject_if => proc { |seriada| seriada[:materia_seriada_id].blank? }

  validates :nombre,
    :presence => true,
    :length => {:maximum => 70}
  validates :clave,
    :presence => true,
    :length => {:maximum => 10}
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

  validates_associated :seriadas

  after_update :save_seriadas

  def new_seriada_attributes=(seriada_attributes)
    seriada_attributes.each do |attributes|
      seriadas.build(attributes) unless attributes[:materia_seriada_id].blank?
    end
  end

  def existing_seriada_attributes=(seriada_attributes)
    seriadas.reject(&:new_record?).each do |seriada|
      attributes = seriada_attributes[seriada.id.to_s]
      if attributes
        seriada.attributes = attributes
      else
        seriadas.delete(seriada)
      end
    end
  end

  def save_seriadas
    seriadas.each do |seriada|
      seriada.save(false)
    end
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
    self.seriadas.each {|seriada| claves_seriadas += seriada.get_clave + " " }

    claves_seriadas
  end

  #
  # Obtiene un arreglo con los identificadores de las asignaturas seriadas para
  # la asignatura actual
  #
  def get_ids_seriadas
    ids_array = Array.new
    self.seriadas.each {|seriada| ids_array << seriada.get_id_seriada}

    ids_array
  end

  #
  # Determina si una asignatura es optativa
  #
  def is_optativa?
    #!self.optativas.blank?
    self.optativa
  end

  #
  # Obtiene un arreglo con los identificadores de las asignaturas optativas para
  # la asignatura actual.
  #
  def get_ids_optativas
    ids_array = Array.new
    self.optativas.each {|optativa| ids_array << optativa.get_id_optativa}

    ids_array
  end

  #
  # Obtiene el nombre de la asignatura y si es optativa, le concatena la palabra
  # <tt>" - (OPT)"</tt> al final del nombre para indicar que es una asignatura optativa
  #
  def get_nombre
    self.nombre.to_s + (self.optativa_hija.eql?(true) ? " - (OPT)" : "")
  end

  #
  # Obtiene la clave y el nombre de la asignatura separados por una barra (pipe)
  #
  def get_clave_and_nombre
    self.clave + ' | ' + get_nombre
  end
end
