class MateriaPropedeutico < ActiveRecord::Base
  belongs_to :carrera
  has_many  :calificaciones_propedeuticos
  has_many  :propedeuticos, :through => :calificaciones_propedeuticos
end
