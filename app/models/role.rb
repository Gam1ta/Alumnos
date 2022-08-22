class Role < ActiveRecord::Base
  #
  # Constante para indentificar al rol <tt>ADMINISTRADOR</tt>.
  #
  ADMINISTRADOR = 'ADMINISTRADOR'

  #
  # Constante para indentificar al rol <tt>ESCOLAR</tt>.
  #
  ESCOLAR = 'ESCOLAR'

  #
  # Constante para identificar al rol <tt>PROFESOR</tt>.
  #
  PROFESOR = 'PROFESOR'

  #
  # Constante para identificar al rol <tt>ALUMNO</tt>.
  #
  ALUMNO = 'ALUMNO'


  # Associations
  has_many :users

  # Validations
  validates :name,
    :presence => true,
    :uniqueness => true,
    :length => {:maximum => 50}
end

