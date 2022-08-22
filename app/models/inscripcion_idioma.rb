class InscripcionIdioma < ActiveRecord::Base
  establish_connection(:idiomas)
end