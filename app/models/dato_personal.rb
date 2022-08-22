class DatoPersonal < ActiveRecord::Base
   belongs_to :alumno
   belongs_to :ciudad
   has_and_belongs_to_many :lengua_indigenas
   accepts_nested_attributes_for :lengua_indigenas, :allow_destroy => true, :reject_if => lambda { |a| a[:nombre].blank? }

#attr_accessor :nested

  #validaciones
  validates :sexo, :presence => true
  validates :nacionalidad,:allow_blank => true,:format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{1,255}\Z/i },:length => { :maximum => 30 }
  validates :tipo_sangre, :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\+\_]{0,255}\Z/i },:length => { :maximum => 10 }
  validates :enfermedad,  :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{0,255}\Z/i },:length => { :maximum => 100 }
  validates :alergia, :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{0,255}\Z/i },:length => { :maximum => 100 }
 
end
