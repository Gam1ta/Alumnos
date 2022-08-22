class GruposNivel < ActiveRecord::Base
  establish_connection(:idiomas)
  
  has_many :alumnos_grupos
  belongs_to :config_clase
  belongs_to :hora
end