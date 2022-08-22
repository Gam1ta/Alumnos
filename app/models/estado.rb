class Estado < ActiveRecord::Base
  belongs_to :pais
  has_many :ciudades


  accepts_nested_attributes_for :ciudades
  
  validates_uniqueness_of :nombre, :scope => :pais_id

  validates :nombre,  :presence => true,
    :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\s\.\,]{1,255}\Z/i },
    :length => { :maximum => 50 }

end
