class ExamenProfesor < ActiveRecord::Base
  #
  # Constante para indicar que el profesor es titular de la asignatura
  #
  TITULAR = 1

  #
  # Constante para indicar que el profesor es co-titular de la asignatura.
  #
  CO_TITULAR = 2

  belongs_to :examen
  belongs_to :profesor

  validates :profesor_id,
    :presence => true

  #
  # Obtiene el nombre del tipo, según el tipo.
  #
  def get_nombre_for_tipo
    case(self.tipo)
    when TITULAR
      'TITULAR'
    when CO_TITULAR
      'CO-TITULAR'
    else
      'SIN TIPO'
    end
  end

  #
  # Determina si el profesor es titular de la asignaruta.
  #
  def is_titular?
    self.tipo.eql?(TITULAR)
  end

  #
  # Determina si el profesor es co-titular de la asignatura
  #
  def is_co_titular?
    self.tipo.eql?(CO_TITULAR)
  end
end
