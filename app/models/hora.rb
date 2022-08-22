class Hora < ActiveRecord::Base
  establish_connection(:idiomas)
  belongs_to :hora
end