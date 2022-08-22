class Optativa < ActiveRecord::Base
  #
  # Obtiene el indentificador de la materia optativa.
  #
  def get_id_optativa
    self.materia_optativa_id
  end
end
