class Aula < ActiveRecord::Base
  #--Asociaciones---------------------------------------------------------------
  has_many :horarios
  has_many :examenes

  
  #Validaciones-----------------------------------------------------------------
  validates :nombre,
    :presence => true,
    :uniqueness => true,
    :length => { :maximum => 50 },
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ()\.\s\-\_]{1,255}\Z/i, :message => "es inválido. Caracteres aceptados: 0-9 A-Z(vocales acentuadas) ( ) - _" }
end
