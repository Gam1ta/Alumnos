class Curso < ActiveRecord::Base 
  #--Asociaciones---------------------------------------------------------------
  belongs_to :profesor
  belongs_to :ciclo
  belongs_to :asignatura,
    :foreign_key => 'materias_planes_id'

  has_many :grupos_cursos
  has_many :grupos,
    :through => :grupos_cursos
  has_many :horarios,
    :dependent => :destroy
  has_many :inscripciones_cursos
  has_many :inscripciones, :through => :inscripciones_cursos
  has_many :examenes,
    :dependent => :destroy

  validate :ciclo_is_null

  def self.search(search)
    if search
      where('nombre LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

  private
  def profesor_is_null
    errors.add :profesor_id, :profesor_in_blank if (self.profesor_id.to_i) < 1
  end

  def ciclo_is_null
    errors.add :ciclo_id, :ciclo_in_blank if (self.ciclo_id.to_i) < 1
  end

  def self.en_grupos(id_profe, id_ciclo, id_materias_planes)
    where('profesor_id=? and ciclo_id=? and materias_planes_id=?', id_profe, id_ciclo, id_materias_planes)
  end

  #
  # Obtiene todos los cursos que pertenezcan a la carrera, periodo y grupo proporcionados.
  # Para ello, deberán de existir alumnos, inscripciones, grupos, carreras y sobre todo, cursos; de lo
  # contrario, indicará que no hay cursos, a pesar de que en la tabla si existan cursos.
  #
  def self.get_all_by_carrera_and_periodo_and_grupo(carrera, periodo, grupo)
    select("distinct cursos.id, materias_planes.nombre, materias_planes.orden, materias_planes.optativa_hija").
      joins(:asignatura, :inscripciones => :alumno).
      where(:inscripciones => {:carrera_id => carrera, :ciclo_id => periodo, :grupo_id => grupo}).
      order("materias_planes.orden")
  end

  #
  # Obtiene la informacion de la tabla examenes de acuerdo al id de asignatura y el tipo recibido
  #
  def self.get_examen_by_curso_and_tipo(curso, tipo)
    select("fecha").joins(:examenes).where(:examenes => {:curso_id => curso, :tipo => tipo}).first
  end

  #
  # Regresa la fecha de aplciaicon del examen ORDINARIO de un curso dado su identificador
  #
  def self.get_fecha_aplicacion_by_curso_and_tipo(curso, tipo)
    curso = self.get_examen_by_curso_and_tipo(curso, tipo)

    return !curso.nil? ? curso.fecha.to_s : nil
  end

  #
  # Obtiene el curso para el grupo, periodo y la asignatura que se encuentra en el
  # plan de estudio. Nulo en caso contrario.
  #
  def self.get_by_grupo_and_periodo_and_asignatura(grupo, periodo, asignatura)
    joins(:grupos).where(:grupos => {:nombre => grupo, :ciclo_id => periodo},
      :cursos => {:ciclo_id => periodo, :materias_planes_id => asignatura}).
      first
  end

  public
  #
  # Obtiene el nombre de la asignatura, además de concatenarle la palabra <tt>(OPT)</tt>
  # para indicar si la asignatura es una optativa.
  #
  def get_nombre
    self.asignatura.get_nombre
  end

  #
  # Obtiene la clave de la asignatura para este curso.
  #
  def get_clave
    self.asignatura.clave
  end

  #
  # Determina si el curso en cuestión tiene creado el calendario de exámenes hasta el especial.
  #
  def has_especial?
    Examen.exists?(:curso_id => self, :tipo => Examen::ESPECIAL)
  end
  
  #
  # Detemina si el curso en cuestión tiene creado el horario de clase hasta el día domingo.
  #
  def has_domingo?
    Horario.exists?(:curso_id => self, :tipo => Horario::DOMINGO)
  end
  
  #
  # Obtiene el nombre de profesor que designaron para el parcial 1 y será mostrado en la vista
  # de horarios.
  #
  def get_profesor_for_horario
    profesor = Profesor.joins(:examenes_profesores => :examen).
      where(:examenes_profesores => {:tipo => ExamenProfesor::TITULAR}, :examenes => {:tipo => Examen::PARCIAL_1, :curso_id => self}).
      first
    
    profesor.nil? ? "SIN PROFESOR" : profesor.full_name_with_grado
  end
end
