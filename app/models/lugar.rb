class Lugar < ActiveRecord::Base
  establish_connection(:idiomas)
end