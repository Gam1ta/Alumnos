require 'time_format_validator'

class Horario < ActiveRecord::Base
  #
  # Constante para indicar el nombre según el día.
  #
  NOMBRES = ["LUNES", "MARTES", "MIERCOLES", "JUEVES", "VIERNES", "SABADO", "DOMINGO"]
  
  #
  # Constante para representar el día <tt>LUNES</tt>.
  #
  LUNES = 0
  
  #
  # Constante para representar el día <tt>MARTES</tt>.
  #
  MARTES = 1
  
  #
  # Constante para representar el día <tt>MIERCOLES</tt>.
  #
  MIERCOLES = 2
  
  #
  # Constante para representar el día <tt>JUEVES</tt>.
  #
  JUEVES = 3
  
  #
  # Constante para representar el día <tt>VIERNES</tt>.
  #
  VIERNES = 4
  
  #
  # Constante para representar el día <tt>SABADO</tt>.
  #  
  SABADO = 5
  
  #
  # Constante para representar el día <tt>DOMINGO</tt>.
  #
  DOMINGO = 6
  
  #--Asociaciones---------------------------------------------------------------
  belongs_to :curso

  #Validaciones-----------------------------------------------------------------
  validates :hora_inicio, 
    :presence => true,
    :time_format => true,
    :length => {:maximum => 5}
  validates :hora_fin, 
    :presence => true,
    :time_format => true,
    :length => {:maximum => 5}
  validates :dia_semana,
    :presence => true,
    :length => {:maximum => 10}
  validates :aula,
    :presence => true,
    :length => {:maximum => 20}
  
  validate :inicio_mayor_fin

  def inicio_mayor_fin
    errors.add :hora_inicio, " no puede ser mayor a la 'Hora Termino'" if self.hora_inicio > self.hora_fin
  end
  
  #
  # Concatena las horas de inicio y fin separados por un guión a modo de presentación de la información
  # al usuario.
  #
  def formated_hours
    hora_inicio.to_s + ' - ' + hora_fin.to_s
  end
end
