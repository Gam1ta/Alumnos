class Propedeutico < ActiveRecord::Base
  belongs_to :alumno
  belongs_to :carrera
  belongs_to :ciclo

  has_many :calificacion_propes
  has_many :materias_aspirantes, :through => :calificacion_propes

  validates :numero, :presence => true
  validates :carrera_id, :presence => true
  validates :ciclo_id, :presence => true
  validates :alumno_id, :presence => true
  validates :grupo, :presence => true,:format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ\s\-\_]{1,255}\Z/i },:length => { :maximum => 10 }
  validates :alumno_id, :uniqueness => {:scope => [:ciclo_id,:alumno_id]}
  validates :numero, :uniqueness => {:scope => [:numero, :ciclo_id]}
end
