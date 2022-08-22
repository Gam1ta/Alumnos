class CalificacionIdioma < ActiveRecord::Base
  establish_connection(:idiomas)
  self.table_name = 'calificaciones'
end