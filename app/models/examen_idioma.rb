class ExamenIdioma < ActiveRecord::Base
  establish_connection(:idiomas)
  self.table_name = 'examenes'
end