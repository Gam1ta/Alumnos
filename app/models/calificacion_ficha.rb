class CalificacionFicha < ActiveRecord::Base

  belongs_to :materia_aspirante
  belongs_to :ficha  
    validates :calificacion, :presence => true,
            :numericality => { :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 10.0 }
#  validates :calificacion, :uniqueness => {:scope => [:materia_aspirante_id, :ficha_id]}
  validates :materia_aspirante_id, :uniqueness => {:scope => [:materia_aspirante_id,:ficha_id], :message=>"La calificacion de esta materia ya fue asignada"}

end
