class Idioma < ActiveRecord::Base
  establish_connection(:idiomas)
  has_many :niveles
end