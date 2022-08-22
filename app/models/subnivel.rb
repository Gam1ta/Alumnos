class Subnivel < ActiveRecord::Base
  establish_connection(:idiomas)
  
  belongs_to :idioma
  belongs_to :nivel
end