class Especialidad < ActiveRecord::Base
  #Relaciones----------------
  has_many :materias_planes

  #Validaciones-----------------------------------------------------------------
  validates :nombre, :presence => true, :uniqueness => true, :length => { :maximum => 100 }, :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ()\.\s\-\_]{1,255}\Z/i }
end
