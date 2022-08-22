class EscuelaProcedente < ActiveRecord::Base
  has_many :antecedentes_academicos
  has_one :direccion, :as => :tabla
  accepts_nested_attributes_for :direccion

  validates :nombre, :presence => true, :uniqueness => true,
    :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ(),.:;'"-_\s\-\_]{1,255}\Z/i },
    :length => { :maximum => 100 }
  
end
