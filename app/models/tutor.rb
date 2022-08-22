class Tutor < ActiveRecord::Base
  has_and_belongs_to_many :alumnos #relacion muchos a muchos
  has_one :direccion, :as => :tabla
  accepts_nested_attributes_for :direccion

  validates :nombre, :presence => true,:format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{1,255}\Z/i },:length => { :maximum => 50 }
  validates :parentezco, :presence => true,:format =>{:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{1,255}\Z/i },:length => { :maximum => 50 }
  validates :ocupacion,:format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{0,255}\Z/i },:length => { :maximum => 50 }

  validate  :apellido_is_null

  def apellido_is_null
    errors.add :apellido_paterno, :apellido_is_null if (self.apellido_materno.blank? and self.apellido_paterno.blank? )
  end

end
