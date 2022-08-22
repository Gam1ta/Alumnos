class Campus < ActiveRecord::Base
  #----ASOCIACIONES--------------------------------------------------------------
  belongs_to :universidad
  has_many :direcciones, :as => :tabla
  has_many :carreras
  accepts_nested_attributes_for :direcciones

  #----VALIDACIONES--------------------------------------------------------------
  validates :nombre, :presence => true
  validates :universidad_id, :presence => true
  validates :nombre, 
    :uniqueness => true,
    :length => { :maximum => 50 },
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ()\s\-\_]{1,255}\Z/i, :message => "es inválido. Caracteres aceptados: 0-9 A-Z(vocales acentuadas) ( ) - _" }

end
