class Grupo < ActiveRecord::Base
  #
  # Constante que mostrará la letra que le corresponda al grupo según se vayan creando, en inscripciones o reinscripciones.
  # La <tt>clave</tt> indicará el número de grupo que se ya se tienen registrados y el <tt>valor</tt> indiará la letra
  # que le corresponda a ese grupo.
  #
  LETRA = {
    '0' => 'A',
    '1' => 'B',
    '2' => 'C',
    '3' => 'D',
    '4' => 'E',
    '5' => 'F',
    '6' => 'G',
    '7' => 'H',
    '8' => 'I',
    '9' => 'J',
    '10' => 'K',
    '11' => 'L',
    '12' => 'M',
    '13' => 'N',
    '14' => 'O',
    '15' => 'P',
    '16' => 'Q',
    '17' => 'R',
    '18' => 'S',
    '19' => 'T',
    '20' => 'U',
    '21' => 'V',
    '22' => 'W',
    '23' => 'X',
    '24' => 'Y',
    '25' => 'Z'
  }

  #Asociaciones
  belongs_to :ciclo

  has_many :inscripciones
  
  has_many :grupos_cursos
  has_many :cursos,
    :through => :grupos_cursos

  validates :nombre,
    :presence => true
  
  #
  # Obtiene todos los grupos que pertenezcan a la carrera y periodo propocionados.
  # Para ello, deberán de existir alumnos que estén inscritos a cursos; de lo contrario, indicará que
  # no hay información a pesar de que en el tabla sí existan registros.
  #
  def self.get_all_by_carrera_and_periodo(carrera, periodo)
    select("distinct grupos.id, grupos.nombre").
      joins(:cursos, :inscripciones => :alumno).
      where(:grupos => {:ciclo_id => periodo}, 
      :cursos => {:ciclo_id => periodo},
      :inscripciones => {:carrera_id => carrera, :ciclo_id => periodo}).
      order("grupos.nombre")
  end

  #
  # Obtiene todos los grupos que pertenezcan a la carrera, periodo y semestre propocionados.

  #
  def self.get_all_by_carrera_and_periodo_and_semestre(carrera, periodo,semestre)
    select("distinct grupos.id, grupos.nombre, grupos.contador, carreras.nombre_carrera").
      joins(:cursos, :inscripciones => [:alumno, :carrera] ).
      where(:grupos => {:ciclo_id => periodo},
      :cursos => {:ciclo_id => periodo},
      :inscripciones => {:carrera_id => carrera, :ciclo_id => periodo,:semestre_id => semestre}).
      order("grupos.nombre")
  end

  #
  # Obtiene todos los grupos de acuerdo al nombre (semestre y carrera) y el periodo
  # proporcionados.
  #
  def self.get_all_by_nombre_and_periodo(nombre, periodo)
    where("ciclo_id = ? and nombre like ?", periodo.id, nombre + '%').
      order("nombre")
  end

  #
  # Obtiene el nombre del grupo con el número de alumnos que se encuentran
  # inscritos en este grupo.
  #
  def get_description_full
    self.nombre_carrera << ' | ' + ('%8.7s' % self.nombre.to_s) + ' | ' + ('%02d' % self.contador.to_s) + ' Alumno(s) inscritos(s)'
  end
  
  #
  # Obtiene el nombre del grupo con el número de alumnos que se encuentran
  # inscritos en este grupo, bajo el siguiente formato:
  # 
  # <tt>203-C | 5 Alumno(s) inscrito(s)</tt>
  #
  def get_description
    nombre + " | " + contador.to_s + " Alumno(s) inscrito(s)"
  end
end
