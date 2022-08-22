class Nivel < ActiveRecord::Base
  establish_connection(:idiomas)
  
  belongs_to :idioma
  has_many :subniveles

end