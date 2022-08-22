class InscripcionCurso < ActiveRecord::Base
  #
  # Constante para indicar que la asignatura SI es aprobada
  #
  APROBADA = 1

  #
  # Constante para indicar que la asignatura NO es aprobada
  #
  REPROBADA = 2

  #
  # Constante para indicar que la inscripción a la asignatura es regular.
  #
  REGULAR = 'REGULAR'

  #
  # Constante para indicar que la inscripción a la asignatura es irregular.
  #
  IRREGULAR = 'IRREGULAR'

  #
  # Constante para indicar que la inscripción a la asignatura es repetidor.
  #
  REPETIDOR = 'REPETIDOR'

  belongs_to :inscripcion
  belongs_to :curso

  has_one :calificacion, :dependent => :destroy

  #
  # Determina si el alumno se encuentra inscrito a la asignatura en el periodo,
  # semestre proporcionados.
  #
  # Regresa verdadero en el caso de que el alumno <tt><b>SI</b></tt> se encuentre
  # asociado (inscrito) a la asignatura; falso en caso de que el alumno <tt><b>NO</b></tt>
  # ya se encuentre inscrito.
  #
  # Para determinar tal acción, se considera inscrito a la asignatura si existe
  # un registro en la base de datos en la tabla <tt>inscripciones_cursos</tt> con
  # las condiciones/parámetros dados.
  #
  def self.exist?(alumno, periodo, semestre, asignatura)
    !joins(:curso, :inscripcion => :semestr).
       where(:inscripciones => {:alumno_id => alumno, :ciclo_id => periodo},
       :semestres => {:clave => semestre},
       :cursos => {:ciclo_id => periodo, :materias_planes_id => asignatura}).
       blank?
  end

  #
  # Determina si el alumno se ha inscrito a la asignatura proporcionada.
  #
  # Regresa verdadero para el caso en el que el alumno <tt><b>SI</b></tt> se
  # encuentre asociado (inscrito) a la asignatura; falso para el caso en que el
  # alumno <tt><b>NO</b></tt> se encuentre inscrito.
  #
  # Se considera inscrito a la asignatura, sí y sólo sí existe al menos un registro
  # en la base de datos.
  #
  def self.is_inscrito?(alumno, asignatura)
    !joins(:curso, :inscripcion).
      where(:inscripciones => {:alumno_id => alumno},
      :cursos => {:materias_planes_id => asignatura}).
      blank?
  end
end
