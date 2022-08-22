class GruposCursos < ActiveRecord::Base
  belongs_to :curso
  belongs_to :grupo
end
