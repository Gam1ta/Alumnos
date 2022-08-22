class Calificacion < ActiveRecord::Base
  #
  # Define la constante carrera
  #
  CARRERA = 1

  #
  # Define la constante semestre
  #
  SEMESTRE = 2

  #
  # Define la constante grupo
  #
  GRUPO = 3

  #
  # Define la constante curso
  #
  CURSO = 4

  #
  # Define la constante profesor
  #
  PROFESOR = 5

  #
  # Define la constante todos
  #
  TODOS = 6

  #
  # Define la constante para parcial 1
  #
  PARCIAL_1 = 7

  #
  # Define la constante para parcial 2
  #
  PARCIAL_2 = 8

  #
  # Define la constante para parcial 3
  #
  PARCIAL_3 = 9

  #
  # Define la constante para ordinario
  #
  ORDINARIO = 10

  #
  # Define la constante para extraordinario 1
  #
  EXTRAORDINARIO_1 = 11

  #
  # Define la constante para extraordinario 2
  #
  EXTRAORDINARIO_2 = 12

  #
  # Define la constante para especial
  #
  ESPECIAL = 13
  
  #Asociaciones
  belongs_to :inscripcion_curso

  #Validaciones
  validates :inscripcion_curso_id,
    :presence => true,
    :uniqueness => true
  validates :parcial1,
    :numericality => { :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 10.0 },
    :allow_blank => true
  validates :parcial2,
    :numericality => { :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 10.0 },
    :allow_blank => true
  validates :parcial3,
    :numericality => { :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 10.0 },
    :allow_blank => true
  validates :final,
    :numericality => { :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 10.0 },
    :allow_blank => true
  validates :extra1,
    :numericality => { :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 10.0 },
    :allow_blank => true
  validates :extra2,
    :numericality => { :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 10.0 },
    :allow_blank => true
  validates :especial,
    :numericality => { :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 10.0 },
    :allow_blank => true
  validates :asistencia_p1,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 },
    :allow_blank => true
  validates :asistencia_p2,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 },
    :allow_blank => true
  validates :asistencia_p3,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 },
    :allow_blank => true
  validates :asistencia_final,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 },
    :allow_blank => true

  #
  # Guarda la calificación a la base de datos. Si no está, la crea; si está, la actualiza.
  #
  # Si en la calificación, el usuario colocó un 'N.P.' o un 'S.D.', en la columna calificación se
  # colocará un 0.0 y en la columna de descripción se agregará la nota que haya introducido. Sólo
  # se permite introducir las dos notas anteriores. Si el valor es numérico, pasará como tal a la
  # columna correspondiente y en la columna descripción, quedará vacía.
  # Si el porcentaje de asistencia es menor a 85, el sistema colocará una calificación de 0.0 y
  # agregará la nota 'S.D.'
  #
  def self.save_calificacion(tipo_id, parcial, asistencia, inscripcion_curso_id, fecha)
    descripcion_parcial = nil;
    tipo_id = tipo_id.to_i
    
    if asistencia.eql?('')
      asistencia = nil
    elsif asistencia.to_i > 100 or asistencia.to_i < 0
      raise 'El porcentaje de asistencia debe estar entre 0 y 100, verifique la información.'
    end
    
    if parcial.eql?('') or asistencia.blank?
      calificacion_parcial = nil
      descripcion_parcial = nil
    elsif parcial.eql?('0') or parcial.eql?('0.0')
      calificacion_parcial = 0.0
      descripcion_parcial = nil
    elsif parcial =~/\An.?p.?\Z/i
      calificacion_parcial = 0.0
      descripcion_parcial = 'N.P.'
    elsif parcial =~/\As.?d.?\Z/i
      calificacion_parcial = 0.0
      descripcion_parcial = 'S.D.'
    elsif parcial.to_i > 10.0 or parcial.to_i < 0.0 or parcial !~ /\A1?\d?\.?\d?\Z/
      raise 'La calificación debe estar entre 0.0 y 10.0, verifique la información.'
    else
      calificacion_parcial = parcial.to_f
      descripcion_parcial = nil
    end

    if !asistencia.blank? and asistencia.to_i < 85 and (tipo_id.eql?(PARCIAL_1) or tipo_id.eql?(PARCIAL_2) or tipo_id.eql?(PARCIAL_3))
      calificacion_parcial = 0.0
      descripcion_parcial = 'S.D.'
    end

    calificacion = Calificacion.find_by_inscripcion_curso_id(inscripcion_curso_id.to_i) || Calificacion.new(:inscripcion_curso_id => inscripcion_curso_id)

    if [PARCIAL_1, PARCIAL_2, PARCIAL_3, ORDINARIO].include?(tipo_id.to_i)
      case(tipo_id)
      when PARCIAL_1
        return if calificacion.parcial1.eql?(calificacion_parcial) and calificacion.asistencia_p1.eql?(asistencia) and calificacion.descripcion_parcial1.eql?(descripcion_parcial)
        calificacion.parcial1 = calificacion_parcial
        calificacion.asistencia_p1 = asistencia
        calificacion.fecha_parcial1 = fecha
        calificacion.descripcion_parcial1 = descripcion_parcial
      when PARCIAL_2
        return if calificacion.parcial2.eql?(calificacion_parcial) and calificacion.asistencia_p2.eql?(asistencia) and calificacion.descripcion_parcial2.eql?(descripcion_parcial)
        calificacion.parcial2 = calificacion_parcial
        calificacion.asistencia_p2 = asistencia
        calificacion.fecha_parcial2 = fecha
        calificacion.descripcion_parcial2 = descripcion_parcial
      when PARCIAL_3
        return if calificacion.parcial3.eql?(calificacion_parcial) and calificacion.asistencia_p3.eql?(asistencia) and calificacion.descripcion_parcial3.eql?(descripcion_parcial)
        calificacion.parcial3 = calificacion_parcial
        calificacion.asistencia_p3 = asistencia
        calificacion.fecha_parcial3 = fecha
        calificacion.descripcion_parcial3 = descripcion_parcial
      when ORDINARIO
        return if calificacion.final.eql?(calificacion_parcial) and calificacion.descripcion_ordinario.eql?(descripcion_parcial)
        calificacion.final = calificacion_parcial
        calificacion.fecha_final = fecha
        calificacion.descripcion_ordinario = descripcion_parcial
      end

      calificacion.promedio_parciales = Calificacion.get_promedio_parciales(calificacion.parcial1, calificacion.parcial2, calificacion.parcial3)
      calificacion.asistencia_final = Calificacion.get_promedio_asistencias(calificacion.asistencia_p1, calificacion.asistencia_p2, calificacion.asistencia_p3)
      calificacion.promedio = Calificacion.get_promedio_final(calificacion.promedio_parciales, calificacion.final)
    else
      case(tipo_id)
      when EXTRAORDINARIO_1
        return if calificacion.extra1.eql?(calificacion_parcial) and calificacion.descripcion_extra1.eql?(descripcion_parcial)
        calificacion.extra1 = calificacion_parcial
        calificacion.fecha_extra1 = fecha
        calificacion.descripcion_extra1 = descripcion_parcial
      when EXTRAORDINARIO_2
        return if calificacion.extra2.eql?(calificacion_parcial) and calificacion.descripcion_extra2.eql?(descripcion_parcial)
        calificacion.extra2 = calificacion_parcial
        calificacion.fecha_extra2 = fecha
        calificacion.descripcion_extra2 = descripcion_parcial
      when ESPECIAL
        return if calificacion.especial.eql?(calificacion_parcial) and calificacion.descripcion_especial.eql?(descripcion_parcial)
        calificacion.especial = calificacion_parcial
        calificacion.fecha_especial = fecha
        calificacion.descripcion_especial = descripcion_parcial
      end
    end
    calificacion.save
  end

  #
  # Obtiene el promedio de asistencias de los tres parciales. Por cada evaluación que se agrega (parcial1, parcial2
  # o parcial3 al sistema, el promedio de asistencias se recalculará y se asignará al campo correspondiente
  #
  def self.get_promedio_asistencias(asistencia_parcial1, asistencia_parcial2, asistencia_parcial3)
    c = (asistencia_parcial1.to_i + asistencia_parcial2.to_i + asistencia_parcial3.to_i) / 3
    c.floor.to_i
  end

  #
  # Obtiene el promedio de los parciales. Por cada evaluación introducida (parcial1, parcial2 o parcial3)
  # el sistema recalcula el valor y lo asigna al campo correspondiente promedio_parciales.
  #
  def self.get_promedio_parciales(parcial1, parcial2, parcial3)
    parcial1 = parcial1.to_f * 10.0
    parcial2 = parcial2.to_f * 10.0
    parcial3 = parcial3.to_f * 10.0
    c = (parcial1 + parcial2 + parcial3) / 3
    c.floor.fdiv(10)
  end

  #
  # Obtiene el promedio final del curso. Por cada evaluación introducida, el sistema recalcula el valor.
  # Sólo toma en cuenta el promedio de parciales (calculado previamente) y el la calificación del ordinario.
  #
  def self.get_promedio_final(promedio_parciales, final)
    promedio_parciales = promedio_parciales.to_f * 10.0
    final = final.to_f * 10.0

    c = (promedio_parciales + final) / 2
    c.floor.fdiv(10)
  end

  #
  # Cambia la bandera 'calificaciones_guardadas' del modelo de Examen a verdadero, siempre y cuando todas las calificaciones
  # el tipo de evaluación ya estén almacenadas.
  #
  def self.change_calificaciones_guardadas_to_true(curso_id, tipo_id)
    # Se identifica el tipo de evaluación en cuestión
    case(tipo_id.to_i)
    when Calificacion::PARCIAL_1
      examen = Examen.find_by_curso_id_and_tipo(curso_id, 'PARCIAL1')
    when Calificacion::PARCIAL_2
      examen = Examen.find_by_curso_id_and_tipo(curso_id, 'PARCIAL2')
    when Calificacion::PARCIAL_3
      examen = Examen.find_by_curso_id_and_tipo(curso_id, 'PARCIAL3')
    when Calificacion::ORDINARIO
      examen = Examen.find_by_curso_id_and_tipo(curso_id, 'ORDINARIO')
    end

    # Si no existe calendario de examen del tipo seleccionado regresa nulo
    return nil if examen.nil?

    curso = Curso.find_by_id(curso_id)
    
    if curso.grupos.count.eql?(1)
      # Si sólo hay un grupo con el curso, inmediatamente se pone a true, indicando que las calificaciones
      # ya han sido almacenadas.
      examen.calificaciones_guardadas = true
    else
      # El curso tiene asociado más de un grupo, si es el la primera vez que se guardan calificaciones
      # del curso, no se puede poner a true hasta que todos los alumnos de todos los grupos para el mismo curso,
      # tengan guardada la calificacion.
      # Hay que revisar todas las calificaciones del curso para poder determinar si ya se puede colocar la bandera
      # para todos los grupos el curso.
      calificaciones = Calificacion.joins(:inscripcion_curso).where(:inscripciones_cursos => {:curso_id => curso_id})
      total_de_alumnos_en_el_curso = Alumno.joins(:inscripciones => :inscripciones_cursos).where(:inscripciones_cursos => {:curso_id => curso_id}).count
      cont = 0
      calificaciones.each do |calificacion|
        case(tipo_id)
        when Calificacion::PARCIAL_1
          break if calificacion.parcial1.blank?
        when Calificacion::PARCIAL_2
          break if calificacion.parcial2.blank?
        when Calificacion::PARCIAL_3
          break if calificacion.parcial3.blank?
        when Calificacion::ORDINARIO
          break if calificacion.final.blank?
        end
        cont += 1
      end

      examen.calificaciones_guardadas = total_de_alumnos_en_el_curso.eql?(cont)
    end

    # Se guarda el cambio en el registro.
    examen.save!
  end

  #
  # Obtiene todos los datos de las calificaciones que el alumno haya tenido en la inscripción proporcionada,
  # así como el nombre y la clave de la materia, el status de la inscripción al curso.
  #
  def self.get_all_by_inscripcion_id(inscripcion_id)
    select("calificaciones.*,
        materias_planes.id as asignatura_id,
        materias_planes.clave,
        materias_planes.nombre,
        inscripciones_cursos.status,
        materias_planes.orden").
      joins(:inscripcion_curso => {:curso => :asignatura}).
      where(:inscripciones_cursos => {:inscripcion_id => inscripcion_id}).
      order("materias_planes.orden")
  end
  #
  # Obtiene todas las calificaciones que tiene la materia seleccionada, así como el nombre y la clave de la materia,
  # el status de la inscripcion al curso.
  #
  def self.get_by_inscripcion_curso_id(inscripcion_curso_id)
    select("calificaciones.*, materias_planes.clave, materias_planes.nombre, inscripciones_cursos.status, inscripciones_cursos.curso_id").
      joins(:inscripcion_curso => {:curso => :asignatura}).
      find_by_inscripcion_curso_id(inscripcion_curso_id)
  end

  #
  # Regresa el numero con letra
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
  # Regresa cualquier calificación dada en formato Letra
  # recibe la calificaicon en flotante
  #
  def self.get_calificacion_with_letra(calif)
    promedio = calif.split '.'
    return self.numero_with_letra(promedio[0]) + " PUNTO " + self.numero_with_letra(promedio[1])
  end

  #
  # Busca el o los registros de calificaciones para el alumno y asignatura
  # en particular, independientemente en qué periodo la haya cursado.
  #
  def self.get_all_by_alumno_and_asignatura(alumno, asignatura)
    select("calificaciones.*, ciclos.ciclo").
      joins(:inscripcion_curso => [:inscripcion => :ciclo, :curso => :asignatura]).
      where(:inscripciones => {:alumno_id => alumno}, :materias_planes => {:id => asignatura}).
      order("ciclos.ciclo")
  end

  #
  # Obtiene la calificación del <tt><i>parcial1</i></tt> o la notas <b>N.P.</b>
  # o <b>S.D.</b> según sea el caso.
  #
  def get_parcial1_sd_or_np
    get_np_or_sd(self.parcial1, self.descripcion_parcial1)
  end

  #
  # Obtiene la calificación del <tt><i>parcial2</i></tt> o la notas <b>N.P.</b>
  # o <b>S.D.</b> según sea el caso.
  #
  def get_parcial2_sd_or_np
    get_np_or_sd(self.parcial2, self.descripcion_parcial2)
  end

  #
  # Obtiene la calificación del <tt><i>parcial3</i></tt> o la notas <b>N.P.</b>
  # o <b>S.D.</b> según sea el caso.
  #
  def get_parcial3_sd_or_np
    get_np_or_sd(self.parcial3, self.descripcion_parcial3)
  end

  #
  # Obtiene la calificación del <tt><i>ordinario</i></tt> o la notas <b>N.P.</b>
  # o <b>S.D.</b> según sea el caso.
  #
  def get_ordinario_sd_or_np
    get_np_or_sd(self.final, self.descripcion_ordinario)
  end

  #
  # Obtiene la calificación del <tt><i>extra1</i></tt> o la notas <b>N.P.</b>
  # o <b>S.D.</b> según sea el caso.
  #
  def get_extra1_sd_or_np
    get_np_or_sd(self.extra1, self.descripcion_extra1)
  end

  #
  # Obtiene la calificación del <tt><i>extra2</i></tt> o la notas <b>N.P.</b>
  # o <b>S.D.</b> según sea el caso.
  #
  def get_extra2_sd_or_np
    get_np_or_sd(self.extra2, self.descripcion_extra2)
  end

  #
  # Obtiene la calificación del <tt><i>especial</i></tt> o la notas <b>N.P.</b>
  # o <b>S.D.</b> según sea el caso.
  #
  def get_especial_sd_or_np
    get_np_or_sd(self.especial, self.descripcion_especial)
  end

  #
  # Determina si las calificaciones de esa asignatura ha sido aprobada; para determinar
  # esto, únicamente se necesita conocer si la ha acreditado ordinariamente, en
  # extras o en especial.
  #
  def is_aprobada?
    is_promedio_approved? or is_extra1_approved? or is_extra2_approved? or is_especial_approved?
  end

  #
  # Determina si la calificación del parcial 1 está aprobada.
  #
  def is_parcial1_approved?
    self.parcial1.to_f.between?(6.0, 10.0)
  end

  #
  # Determina si la calificación del parcial 2 está aprobada.
  #
  def is_parcial2_approved?
    self.parcial2.to_f.between?(6.0, 10.0)
  end

  #
  # Determina si la calificación del parcial 3 está aprobada.
  #
  def is_parcial3_approved?
    self.parcial3.to_f.between?(6.0, 10.0)
  end

  #
  # Determina si el promedio de parciales está aprobada.
  #
  def is_promedio_parciales_approved?
    self.promedio_parciales.to_f.between?(6.0, 10.0)
  end

  #
  # Determina si la calificación del ordinario está aprobada.
  #
  def is_ordinario_approved?
    self.final.to_f.between?(6.0, 10.0)
  end

  #
  # Determina si el promedio final está aprobada.
  #
  def is_promedio_approved?
    self.promedio.to_f.between?(6.0, 10.0)
  end

  #
  # Determina si la calificación del extraordinario 1 está aprobada.
  #
  def is_extra1_approved?
    self.extra1.to_f.between?(6.0, 10.0)
  end

  #
  # Determina si la calificación del extraordinario 2 está aprobada.
  #
  def is_extra2_approved?
    self.extra2.to_f.between?(6.0, 10.0)
  end

  #
  # Determina si la calificación del especial está aprobada.
  #
  def is_especial_approved?
    self.especial.to_f.between?(6.0, 10.0)
  end

  #
  # Determina si la calificación del parcial 1 NO está aprobada.
  #
  def is_parcial1_not_approved?
    !is_parcial1_approved?
  end

  #
  # Determina si la calificación del parcial 2 NO está aprobada.
  #
  def is_parcial2_not_approved?
    !is_parcial2_approved?
  end

  #
  # Determina si la calificación del parcial 3 NO está aprobada.
  #
  def is_parcial3_not_approved?
    !is_parcial3_approved?
  end

  #
  # Determina si el promedio de parciales NO está aprobada.
  #
  def is_promedio_parciales_not_approved?
    !is_promedio_parciales_approved?
  end

  #
  # Determina si la calificación del ordinario NO está aprobada.
  #
  def is_ordinario_not_approved?
    !is_ordinario_approved?
  end

  #
  # Determina si el promedio final NO está aprobada.
  #
  def is_promedio_not_approved?
    !is_promedio_approved?
  end

  #
  # Determina si la calificación del extraordinario 1 NO está aprobada.
  #
  def is_extra1_not_approved?
    !is_extra1_approved?
  end

  #
  # Determina si la calificación del extraordinario 2 NO está aprobada.
  #
  def is_extra2_not_approved?
    !is_extra2_approved?
  end

  #
  # Determina si la calificación del especial NO está aprobada.
  #
  def is_especial_not_approved?
    !is_especial_approved?
  end
  
  #
  # Determina si el alumno en cuestión NO presentó el extraordinario 1.
  # Si el alumno tiene:
  # * N.P. quiere decir que no lo presentó.
  # * S.D. quiere decir que no tuvo derecho (probablemente porque tiene un promedio de 
  # asistencias menor a 65%)
  # * Si no tiene una calificación registrada. El 0.0 cuenta como que sí presentó
  # el extraordinario 1.
  # 
  # Devuelve verdadero si no lo presentó. Falso en caso contrario.
  #
  def is_extra1_presented?
    descripcion_extra1.eql?('N.P.') or descripcion_extra1.eql?('S.D.') or extra1.blank?
  end
  
  #
  # Determina si el alumno en cuestión NO presentó el extraordinario 2.
  # Si el alumno tiene:
  # * N.P. quiere decir que no lo presentó.
  # * S.D. quiere decir que no tuvo derecho (probablemente porque tiene un promedio de 
  # asistencias menor a 65%)
  # * Si no tiene una calificación registrada. El 0.0 cuenta como que sí presentó
  # el extraordinario 2.
  # 
  # Devuelve verdadero si no lo presentó. Falso en caso contrario.
  #
  def is_extra2_presented?
    descripcion_extra2.eql?('N.P.') or descripcion_extra2.eql?('S.D.') or extra2.blank?
  end

  private
  #
  # Devuelve el valor de la descripción 'N.P.' o 'S.D.' si el valor de la calificación es 0.0, si la calificación
  # es mayor a cero, el valor devuelto será la calificación.
  #
  def get_np_or_sd(calificacion, descripcion)
    return nil if calificacion.blank?
    return calificacion.to_f == 0.0 ? (descripcion.blank? ? 0.0 : descripcion) : calificacion
  end
end
