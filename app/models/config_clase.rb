class ConfigClase < ActiveRecord::Base
  establish_connection(:idiomas)
  belongs_to :grupos_nivel
  belongs_to :lugar
end