class MateriaAspirante < ActiveRecord::Base
  belongs_to :carrera
  belongs_to :profesor
  has_many  :calificacion_fichas
  has_many  :fichas, :through => :calificacion_fichas
  accepts_nested_attributes_for :calificacion_fichas, :allow_destroy => true
  has_many  :calificacion_propes
  has_many  :propedeuticos, :through => :calificacion_propes
  accepts_nested_attributes_for :calificacion_propes, :allow_destroy => true

  validates :nombre, :presence => true,:format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{1,255}\Z/i }
  validates :clave, :presence => true,:format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{1,255}\Z/i }
  validates :nombre, :uniqueness => {:scope => [:carrera_id,:proceso]}
  validates :clave, :uniqueness => {:scope => [:proceso,:carrera_id]}
 
  validates :carrera_id, :presence => true 
end
