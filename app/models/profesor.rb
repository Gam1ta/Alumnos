class Profesor < ActiveRecord::Base
  #Asociaciones
  belongs_to :user,
    :dependent => :destroy
  belongs_to :carrera
  belongs_to :area_adscripcion
  has_many :alumnos
  has_many :cursos
  has_many :materias_aspirantes
  has_many :examenes_profesores
  has_many :examenes, :through => :examenes_profesores
  
  accepts_nested_attributes_for :user,
    :allow_destroy => true
  
  #Validaciones
  validates :nombre,
    :presence => true,
    :length => { :minimum => 3 },
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚÜü()\s\-\/\_]{0,50}\Z/i }
  validates :apellido_paterno,
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚÜü()\s\-\/\_]{0,50}\Z/i }
  validates :apellido_materno,
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚÜü()\s\-\/\_]{0,50}\Z/i }
  validates :cedula_profesional,
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚÜü()\s\-\/\_]{0,50}\Z/i }
  validates :grado_de_estudios,
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚÜü().\s\-\/\_]{0,50}\Z/i }
  validates :grado_academico,
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚÜü().\s\-\/\_]{0,200}\Z/i }
  validates :rfc,
    :presence => true,
    :length => { :is => 15 },
    :uniqueness => true,
    :format => { :with => /\A([a-z]|[A-Z]){4}-\d{6}-(([a-z]|[A-Z])|\d){3}\Z/, :message => "El formato del RFC debe ser: AAAA-111111-AAA" }
  validates :curp,
    :presence => true,
    :length => { :is => 18 },
    :uniqueness => true,
    :format => { :with => /\A([a-z]|[A-Z]){4}\d{6}([a-z]|[A-Z]){6}\d{2}\Z/, :message => "El formato de la CURP debe ser: AAAA111111AAAAAA11" }
  validates :sexo,
    :presence => true
  validates :nacionalidad,
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚÜü()\s\-\/\_]{0,50}\Z/i }

  #Métodos

  #
  # Regresa el nombre completo del profesor empezando por nombre, apellidos paterno y materno
  #
  def full_name
    self.nombre.to_s + " " + self.apellido_paterno.to_s + " " + self.apellido_materno.to_s
  end

  def grado
    return !self.grado_de_estudios.blank? ? self.grado_de_estudios + " " : ""
  end

  #
  # Regresa el nombre completo y grado academico del profesor empezando por grado academico, nombre, apellidos paterno y materno
  #
  def full_name_with_grado
    self.grado + self.full_name
  end

  #
  # Regresa el nombre completo del profesor empezando por apellido paterno, materno y nombre
  #
  def full_name_apellido_paterno
    self.apellido_paterno.to_s + " " + self.apellido_materno.to_s + " " + self.nombre.to_s
  end

  #
  # Regresa el nombre completo del profesor para el curso seleccionado; si el curso no tiene profesor, regresa
  # el mensaje "SIN PROFESOR" indicando que el curso aún no tiene un profesor seleccionado.
  #
  def self.get_full_name_by_curso_id(curso_id)
    profesor = joins(:cursos).where(:cursos => {:id => curso_id}).first

    profesor.blank? ? "SIN PROFESOR" : profesor.full_name
  end

  #
  # Regresa el grado academico y nombre completo del profesor para el curso seleccionado; si el curso no tiene profesor, regresa
  # el mensaje "SIN PROFESOR" indicando que el curso aún no tiene un profesor seleccionado.
  #
  def self.get_full_name_with_grado_academico_by_curso_id(curso_id)
    profesor = joins(:cursos).where(:cursos => {:id => curso_id}).first

    profesor.blank? ? "SIN PROFESOR" : profesor.full_name_with_grado
  end
end
