class Seriada < ActiveRecord::Base
  #--Relaciones-----------------------------------------------------------------
  belongs_to :asignatura,
    :foreign_key => 'materias_planes_id'

  #
  # Obtiene la clave de la asignatura seriada. <tt>Cadena vacía</tt> en caso contrario.
  #
  def get_clave
    clave_seriada = Asignatura.find_by_id(self.materia_seriada_id)

    return !clave_seriada.nil? ? clave_seriada.clave : ""
  end

  #
  # Obtiene el identificador de la materia seriada.
  #
  def get_id_seriada
    self.materia_seriada_id
  end
end
