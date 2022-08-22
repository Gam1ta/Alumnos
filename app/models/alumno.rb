class Alumno < ActiveRecord::Base
  #s
  # Constante que hará la consulta a la base de datos para obtener el nombre completo de los alumnos, de tal forma que
  # el nombre completo se manejará como un solo campo de nombre <tt>full_name_as_string</tt>, el objetivo es que la lista de
  # alumnos ya venga ordenada desde la base de datos, independientemente si le hace falta un apellido o no.
  #
  # Si el alumno no tiene apellido paterno, la base de datos hará que el alumno se ordene por su apellido materno en el
  # lugar que le corresponda, como si tuviera apellido paterno.
  #
  ORDER_FULL_NAME = "alumnos.id as alumno_id,
    alumnos.tipo,
    alumnos.matricula,
    trim(
      case
        when alumnos.apellido_paterno is null then ''
        when length(alumnos.apellido_paterno) = 0 then ''
        else alumnos.apellido_paterno || ' '
      end ||
      case
        when alumnos.apellido_materno is null then ''
        when length(alumnos.apellido_materno) = 0 then ''
        else alumnos.apellido_materno || ' '
      end ||
      alumnos.nombre)
    as full_name_as_string"

  #
  # Constante para indicar que el alumno es del tipo NUEVO.
  #
  NUEVO = "NUEVO"

  #
  # Constante para indicar que el alumno es del tipo FICHA.
  #
  FICHA = "FICHA"

  #
  # Constante para indicar que el alumno es del tipo PROPE.
  #
  PROPE = "PROPE"

  #
  # Constante para indicar que el alumno es del tipo ALUMNO.
  #
  ALUMNO = "ALUMNO"

  #
  # Constante para indicar que el alumno es del tipo BAJA TEMPORAL.
  #
  BAJA_TEMP = "BAJA_TEMP"

  #
  # Constante para indicar que el alumno es del tipo BAJA DEFINITIVA.
  #
  BAJA_DEF = "BAJA_DEF"
  #
  # Constante para indicar que el alumno es del tipo EGRESADO.
  #
  EGRESADO = "EGRESADO"

  #
  #Constante para representar que un adeudo de otras áreas está aun activo (Estado Válido V)
  #
  ADEUDO_ACTIVO = "V"

  #
  #Constante para representar que un adeudo de otras áreas ya está pagado (Estado Histórico H)
  #
  ADEUDO_PAGADO = "H"

  has_one :dato_personal, :dependent => :destroy
  has_one :antecedente_academico, :dependent => :destroy
  has_one :escuela_procedente, :through => :antecedente_academico
  has_many :adeudos, :dependent => :destroy
  has_many :direcciones, :as => :tabla, :dependent => :destroy

  has_and_belongs_to_many :tutores

  belongs_to :carrera
  belongs_to :profesor
  has_many :fichas
  has_many :ciclos, :through => :fichas
  has_many :propedeuticos
  has_many :ciclos, :through => :propedeuticos
  has_many :inscripciones
  has_many :grupos, :through => :inscripciones
  belongs_to :user

  # conexion con sirefi
  has_many :debits

  accepts_nested_attributes_for :dato_personal#, :reject_if => lambda { |a| a[:content].blank? }
  accepts_nested_attributes_for :tutores, :allow_destroy => true #, :reject_if => lambda { |a| a[:parentezco].blank? }
  accepts_nested_attributes_for :antecedente_academico#, :reject_if => lambda { |a| a[:content].blank? }
  accepts_nested_attributes_for :direcciones
  #validaciones
  
  validates :nombre,
    :presence => true,
    :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{1,50}\Z/i},
    :length => {:maximum => 50}
  validates :apellido_paterno,
    :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{0,50}\Z/i},
    :length => {:maximum => 50}
  validates :apellido_materno,
    :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{0,50}\Z/i},
    :length => {:maximum => 50}
  validates :curp, 
    :presence => true,
    :uniqueness => true,
    :format => {:with => /\A([A-Z]){4}\d{6}(H|M)([A-Z]){5}([A-Z]|[0-9])\d{1}\Z/, :message => "El formato de la curp debe ser: AAAA111111AAAAAA11" },
    :length => {:is => 18}
  validates :matricula,
    :format => {:with => /\A[0-9]{0,20}/},
    :length => {:maximum => 20},
    :uniqueness => true,
    :allow_blank => true
  validates :tipo, 
    :presence => true,
    :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\s\-\_]{1,255}\Z/i}
  validates :nss,
    :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\s\-\/\_]{0,20}\Z/i},
    :length => {:maximum => 20}
  validates :motivo_temporal,
    :length => {:maximum => 100},
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ()\s\"\.\:\-\_]{0,100}\Z/i}
  validates :motivo_definitiva,
    :length => {:maximum => 100},
    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ()\s\"\.\:\-\_]{0,100}\Z/i}

  validate  :apellido_is_null

  delegate :nombre_carrera, :to => :carrera, :prefix => true, :allow_nil => true

  def apellido_is_null
    errors.add :apellido_paterno, :apellido_is_null if (self.apellido_materno.blank? and self.apellido_paterno.blank? )
  end
  
  #
  # Determina si el alumno tiene el <tt>tipo</tt> EGRESADO registrado en la base de datos, el cual
  # indica que ya es un EGRESADO.
  #
  def is_egresado?
    tipo.eql?(EGRESADO)
  end

  #
  # Verifica si existen alumnos con calificaciones para una carrera, periodo, grupo y curso en particular.
  # Regresa verdadero para caso de haber alumnos con calificaciones; falso en caso contrario.
  #
  def self.are_there_alumnos_with_calificaciones?(carrera, periodo, grupo, curso)
    !joins(:inscripciones => {:inscripciones_cursos => :calificacion}).
      where(:inscripciones => {:carrera_id => carrera, :ciclo_id => periodo, :grupo_id => grupo}, :inscripciones_cursos => {:curso_id => curso}).blank?
  end

  #
  # Obtiene la lista de alumnos que correspondan a un grupo y periodo, sin tomar
  # en cuenta si tiene o no calificaciones ordenados por apellido paterno, apellido materno y nombres.
  #
  # Este método es usado para obtener la lista de los alumnos y crear suis cuentas para acceso al sistema
  # nes alumnos.
  #
  def self.get_all_by_grupo_and_periodo(grupo, periodo)
    select(Alumno::ORDER_FULL_NAME + ", user_id, correo_electronico, alumnos.carrera_id, inscripciones.*").
      joins(:inscripciones).
      where(:inscripciones => {:ciclo_id => periodo, :grupo_id => grupo}).order("full_name_as_string")
  end

  def self.get_list_by_carrera_and_periodo_and_grupo(carrera, periodo, grupo)
    select(ORDER_FULL_NAME + ", inscripciones.id as alumno_inscripcion_id").
      joins(:inscripciones).
      where(:inscripciones => {:carrera_id => carrera, :ciclo_id => periodo, :grupo_id => grupo}).order("full_name_as_string")
  end

  #
  # Obtiene la lista de alumnos que correspondan a un grupo y curso, sin tomar
  # en cuenta si tiene o no calificaciones ordenados por apellido paterno, apellido materno y nombres.
  #
  # Útil cuando se van a dar de alta calificaciones a alumnos y aún no hay registros en calificaciones
  # con los parámetros seleeccionados.
  #
  def self.get_all_by_grupo_and_curso_without_calificaciones(grupo, curso)
    select(ORDER_FULL_NAME + ", inscripciones_cursos.id as inscripcion_curso_id").
      joins(:inscripciones => :inscripciones_cursos).
      where(:inscripciones => {:grupo_id => grupo}, :inscripciones_cursos => {:curso_id => curso}).
      order("full_name_as_string")
  end

  #
  # Obtiene la lista de alumnos que correspondan a una carrera, periodo, grupo y curso, sin tomar
  # en cuenta si tiene o no calificaciones ordenados por apellido paterno, apellido materno y nombres.
  #
  # Útil cuando se van a dar de alta calificaciones a alumnos y aún no hay registros en calificaciones
  # con los parámetros seleeccionados.
  #
  def self.get_list_by_carrera_and_periodo_and_grupo_and_curso_without_calificaciones(carrera, periodo, grupo, curso)
    select(ORDER_FULL_NAME + ", inscripciones_cursos.id as inscripcion_curso_id, inscripciones.id as alumno_inscripcion_id, inscripciones_cursos.status").
      joins(:inscripciones => :inscripciones_cursos).
      where(:inscripciones => {:carrera_id => carrera, :ciclo_id => periodo, :grupo_id => grupo}, :inscripciones_cursos => {:curso_id => curso}).
      order("full_name_as_string")
  end

  #
  # Obtiene la lista de alumnos que correspondan a una carrera, periodo, grupo y curso, siempre y cuando
  # los alumnos cuenten con calificaciones. La lista la trae ordenada por apellido paterno, apellido materno y nombre.
  # 
  # Útil para mostrar las calificaciones de los alumnos.
  #
  def self.get_list_by_carrera_and_periodo_and_grupo_and_curso_with_calificaciones(carrera, periodo, grupo, curso)
    select(ORDER_FULL_NAME + ", calificaciones.*, calificaciones.promedio as calif , calificaciones.asistencia_final as asistencia").
      joins(:inscripciones => {:inscripciones_cursos => :calificacion}).
      where(:inscripciones => {:carrera_id => carrera, :ciclo_id => periodo, :grupo_id => grupo}, :inscripciones_cursos => {:curso_id => curso}).
      order("full_name_as_string")
  end

  #
  # Obtiene el promedio del alumno en el curso seleccionado.
  #
  def self.get_promedio_by_curso(alumno_id, curso_id)
    calificaciones_alumno = select("calificaciones.promedio").
      joins(:inscripciones => {:inscripciones_cursos => :calificacion}).
      where(:inscripciones => {:alumno_id => alumno_id}, :inscripciones_cursos => {:curso_id => curso_id}).first
    return calificaciones_alumno.blank? ? "-" : calificaciones_alumno.promedio.to_s
  end

  #
  #Obtiene las calificaciones del alumno por el curso seleccionado.
  #
  def self.get_calificaciones_by_curso(alumno_id, curso_id)
    select("calificaciones.*").
      joins(:inscripciones => {:inscripciones_cursos => :calificacion}).
      where(:inscripciones => {:alumno_id => alumno_id}, :inscripciones_cursos => {:curso_id => curso_id}).first
  end

  #
  # Obtiene la lista de alumnos que tienen calificaciones mediante los dos apellidos
  # ordernados alfabéticamente por apellido paterno, apellido materno y nombre,
  # independientemente de qué periodo y carrera.
  #
  # Los alumnos que aparecerán en la lista seleccionable, serán aquellos que pertenezcan
  # al campus del usuario que en ese momento se encuentre loggeado.
  #
  # El único requisito es que tengan calificaciones.
  #
  def self.get_all_by_apellidos(apellido_paterno, apellido_materno, campus)
    select("distinct alumnos.id, curp || ' | ' || apellido_paterno || ' ' || apellido_materno || ' ' || nombre as curp_full_name").
      joins(:inscripciones => [{:inscripciones_cursos => :calificacion}, :carrera]).
      where("apellido_paterno ilike ? and apellido_materno ilike ? and campus_id = ?",
      apellido_paterno + '%', apellido_materno + '%', campus).
      order("curp_full_name")
  end

  #
  # Obtiene la lista de alumnos que tienen calificaciones mediante el apellido
  # paterno o el nombre ordenados alfabéticamente por apellido paterno, apellido
  # materno y nombre, independientemente de qué periodo, carrera.
  #
  # Los alumnos que aparecerán en la lista seleccionable, serán aquellos que pertenezcan
  # al campus del usuario que en ese momento se encuentre loggeado.
  #
  # El único requisito es que tengan calificaciones.
  #
  def self.get_all_by_apellido_paterno_or_nombre(apellido_paterno_or_nombre, campus)
    select("distinct alumnos.id, curp || ' | ' || apellido_paterno || ' ' || apellido_materno || ' ' || nombre as curp_full_name").
      joins(:inscripciones => [{:inscripciones_cursos => :calificacion}, :carrera]).
      where("(apellido_paterno ilike ? or nombre ilike ?) and campus_id = ?",
      apellido_paterno_or_nombre + '%', apellido_paterno_or_nombre + '%', campus).
      order("curp_full_name")
  end

  def self.get_all_by_apellido_paterno_or_nombre_or_curp_or_matricula(apellido_paterno_or_nombre, campus)
    select("distinct alumnos.id, curp || ' | ' || apellido_paterno || ' ' || apellido_materno || ' ' || nombre as curp_full_name").
      joins(:inscripciones => [{:inscripciones_cursos => :calificacion}, :carrera]).
      where("(curp ilike ?  or nombre ilike ? or  apellido_paterno ilike ? or  matricula ilike ?) and campus_id = ?",
      apellido_paterno_or_nombre + '%', apellido_paterno_or_nombre + '%', apellido_paterno_or_nombre + '%', apellido_paterno_or_nombre + '%', campus).
      order("curp_full_name")
  end


  #
  # Obtiene las lista de todos los alumnos que han sacado ficha para una carrera y periodo en particular. La lista se encuentra
  # ordenada por apellidos y nombre.
  #
  def self.get_all_with_fichas_by_carrera_and_periodo(carrera, periodo)
    select("alumnos.*, fichas.*").joins(:fichas).where(:fichas => {:carrera_id => carrera, :ciclo_id => periodo}).
      order("alumnos.apellido_paterno, alumnos.apellido_materno, alumnos.nombre")
  end
  
  #
  # Obtiene todos los alumnos de a cuerdo su TIPO (status), ordena por apellidos y nombre
  #
  def self.get_all_by_status_and_campus(status,campus)
    select(ORDER_FULL_NAME).joins(:carrera).
      where(:alumnos => {:tipo => status}, :carreras => {:campus_id => campus}).
      order("alumnos.carrera_id, full_name_as_string")
  end

  #
  # Consulta a la base de datos para saber si el alumno seleccionado cuanta con calificaciones.
  #
  # Regresa <tt>true</tt> tanto si tuviera una sola calificación como si tuviera todo el historial, <tt>false</tt> en caso
  # contrario.
  #
  def self.has_calificaciones?(alumno_id)
    !joins(:inscripciones => {:inscripciones_cursos => :calificacion}).
      where(:inscripciones => {:alumno_id => alumno_id}).blank?
  end

  #
  # Consulta a la base de datos para saber si el alumno seleccionado cuanta con calificaciones para el curso seleccionado.
  #
  # Regresa <tt>true</tt> si tuviera una sola calificación o todas (parciales, ordinario, extraordinarios o especial),
  # <tt>false</tt> en caso contrario.
  #
  def self.has_calificaciones_by_curso?(alumno_id, curso_id)
    !joins(:inscripciones => {:inscripciones_cursos => :calificacion}).
      where(:inscripciones => {:alumno_id => alumno_id}, :inscripciones_cursos => {:curso_id => curso_id}).blank?
  end

  #
  # Verifica si existen alumnos que se han reinscrito después del primer parcial, para una carrera, periodo, grupo y curso en particular
  #
  # Regresa <tt>true</tt> en caso de que existan reinscripciones después del primer parcial, <tt>false</tt> en caso contrario.
  #
  def self.exist_reinscripciones_posteriores?(carrera, periodo, grupo, curso)
    # Obtenemos el número de alumnos que ya tienen calificaciones para el curso seleccionado.
    alumnos_with_calificaciones = get_list_by_carrera_and_periodo_and_grupo_and_curso_with_calificaciones(carrera, periodo, grupo, curso).count
    # Obtenemos el número de alumnos que están inscritos o reinscritos para el curso seleccionado.
    alumnos_without_calificaciones = get_list_by_carrera_and_periodo_and_grupo_and_curso_without_calificaciones(carrera, periodo, grupo, curso).count

    # Si los dos números son iguales, indica que no hubo reinscripciones después del primer parcial. Al ser diferentes,
    # indica que existen alumnos que se han inscrito o reinscrito tarde.
    return !alumnos_with_calificaciones.eql?(alumnos_without_calificaciones)
  end

  #
  # Obtiene el apellido paterno del alumno concatenado con un espacio vacío en caso de que el apellido materno no esté vacío.
  # Regresa una cadena vacía en caso de que el apellido paterno esté vacío.
  #
  def get_apellido_paterno
    self.apellido_paterno.blank? ? '' : self.apellido_paterno.to_s + ' '
  end

  #
  # Obtiene el apellido materno del alumno concatenado con un espacio vacío en caso de que el apellido materno no esté vacío.
  # Regresa una cadena vacía en caso de que el apellido materno esté vacío.
  #
  def get_apellido_materno
    self.apellido_materno.blank? ? '' : self.apellido_materno.to_s + ' '
  end

  #
  # Obtiene el nombre del alumno concatenado con un espacio vacío en caso de que el nombre esté vacío.
  # Regresa una cadena vacía en caso de que el apellido materno esté vacío.
  #
  def get_nombre
    self.nombre.blank? ? '' : self.nombre.to_s + ' '
  end

  #
  # Regresa el nombre completo del alumno, empezando por apellido paterno, materno y nombres
  #
  def full_name
    self.get_apellido_paterno + self.get_apellido_materno + self.nombre.to_s
  end

  #
  # Obtiene la edad del alumno
  #
  def self.get_edad(alumno_id)
    edad = Alumno.select("date_part('year',age(fecha_nacimiento )) AS edad").joins(:dato_personal).where("alumno_id = ?", alumno_id).first
    return edad.edad.to_s
  end


  #
  # Regresa una cadena con la curp y el nombre del alumno.
  #
  def get_curp_with_full_name
    self.curp + " | " + self.full_name
  end

  #
  #Regresa el numero con letra
  #
  def numero_with_letra(numero)
    case(numero.to_i)
    when numero = 0 then return "CERO"
    when numero = 1 then return "UNO"
    when numero = 2 then return "DOS"
    when numero = 3 then return "TRES"
    when numero = 4 then return "CUATRO"
    when numero = 5 then return "CINCO"
    when numero = 6 then return "SEIS"
    when numero = 7 then return "SIETE"
    when numero = 8 then return "OCHO"
    when numero = 9 then return "NUEVE"
    when numero = 10 then return "DIEZ"
    end
  end

  #
  # Se encarga de regresar la calificación con letra, este campo se debe llamar calif, sea cual sea
  # la calificación.
  #
  def get_calificacion_with_letra
    promedio = self.calif.split '.'
    return self.numero_with_letra(promedio[0]) + " PUNTO " + self.numero_with_letra(promedio[1])
  end

  #
  # Obtiene todaas las materias que el alumno debe cursar de acuerdo a la carrera en la qu esta inscrito
  #
  def self.get_total_credits_by_alumno_id_carrera_id(alumno, carrera)
    select("DISTINCT materias_planes.id, materias_planes.nombre, materias_planes.clave, materias_planes.orden").
      joins(:inscripciones => {:inscripciones_cursos => {:curso => :asignatura}}).
      where("inscripciones.carrera_id = ? and inscripciones.alumno_id = ?", carrera, alumno).order("materias_planes.orden")
  end

  #
  # Obtiene todas las materias que no a aprobado de acuerdo l listado de materias que de aceurdo a su carrera debe llevar
  #
  def self.get_all_credits_no_aprobados_by_alumno_id_materia_id(alumno, materia)
    select("materias_planes.id").
      joins(:inscripciones => {:inscripciones_cursos => :calificacion}).
      joins(:inscripciones => {:inscripciones_cursos => {:curso => :asignatura}}).
      where("materias_planes.id = ? and inscripciones.alumno_id = ? and
            (calificaciones.promedio > 5.9 or
             calificaciones.extra1 > 5.9 or
             calificaciones.extra2 > 5.9 or
             calificaciones.especial > 5.9)
      ",materia, alumno).first
  end
  
  #
  # retorna los creditos que aun no cumple de acuerdo al plan de estudios de la carrera a la que el alumno esta inscrito
  #
  def self.creditos_no_obtenidos_by_alumno_id_carrera_id(alumno, carrera)
    materias_no_aprobadas = ""
    alumnos = Alumno.get_total_credits_by_alumno_id_carrera_id(alumno, carrera)
    alumnos.each do |mat|
      materia_estado = Alumno.get_all_credits_no_aprobados_by_alumno_id_materia_id(alumno, mat.id)
      if materia_estado.blank?
        materias_no_aprobadas += mat.clave.to_s + " - " + mat.nombre.to_s + ", "
      end
    end
    return materias_no_aprobadas
  end
  
  def get_nombre_carrera
    carrera =  self.carrera
    carrera.present? ? carrera.nombre_carrera : 'Sin carrera registrada'
  end

end
