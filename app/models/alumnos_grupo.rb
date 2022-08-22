class AlumnosGrupo < ActiveRecord::Base
  establish_connection(:idiomas)
  
  belongs_to :grupos_nivel
  belongs_to :subnivel

end