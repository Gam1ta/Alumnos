# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end


ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural /(r|n|d|l)$/i, '\1es'
  inflect.singular /(r|n|d|l)es$/i, '\1'

  inflect.irregular 'configuracion_aspirante', 'configuraciones_aspirantes'
  inflect.irregular 'ConfiguracionAspirante', 'ConfiguracionesAspirantes'
  
  
  inflect.irregular 'emergente', 'emergentes'
  inflect.irregular 'Emergente', 'Emergentes'

  inflect.irregular 'materia_aspirante_profesor', 'materias_aspirantes_profesores'
  inflect.irregular 'MateriaAspiranteProfesor', 'MateriasAspirantesProfesores'

  inflect.irregular 'dato_personal', 'datos_personales'
  inflect.irregular 'DatoPersonal', 'DatosPersonales'

  inflect.irregular 'materia_aspirante', 'materias_aspirantes'
  inflect.irregular 'MateriaAspirante', 'MateriasAspirantes'

  inflect.irregular 'calificacion_ficha', 'calificaciones_fichas'
  inflect.irregular 'CalificacionFicha', 'CalificacionesFichas'

  inflect.irregular 'calificacion_prope', 'calificaciones_prope'
  inflect.irregular 'CalificacionPrope', 'CalificacionesPrope'

  inflect.irregular 'configuracion_aspirante', 'configuraciones_aspirantes'
  inflect.irregular 'ConfiguracionAspirante', 'ConfiguracionesAspirantes'

  inflect.irregular 'pais', 'paises'
  inflect.irregular 'universidad', 'universidades'

  inflect.irregular 'antecedente_academico', 'antecedentes_academicos'
  inflect.irregular 'AntecedenteAcademico', 'AntecedentesAcademicos'

  inflect.irregular 'inscripcion_curso', 'inscripciones_cursos'
  inflect.irregular 'InscripcionCurso', 'InscripcionesCursos'

  inflect.irregular 'dato_personal', 'datos_personales'
  inflect.irregular 'DatoPersonal', 'DatosPersonales'

  inflect.irregular 'escuela_procedente', 'escuelas_procedentes'
  inflect.irregular 'EscuelaProcedente', 'EscuelasProcedentes'

  inflect.irregular 'plan_estudio', 'planes_estudio'
  inflect.irregular 'PlanEstudio', 'PlanesEstudio'

  inflect.irregular 'escolar', 'escolares'
  inflect.irregular 'Escolar', 'Escolares'

  inflect.irregular 'user', 'users'
  inflect.irregular 'User', 'Users'
  
  inflect.irregular 'revalidacion', 'revalidaciones'
  inflect.irregular 'Revalidacion', 'Revalidaciones'

  inflect.irregular 'lengua_indigena', 'lenguas_indigenas'
  inflect.irregular 'LenguaIndigena', 'LenguasIndigenas'

  inflect.irregular 'materia', 'materias'
  inflect.irregular 'Materia', 'Materias'

  inflect.irregular 'materias_planes', 'materias_planes'
  inflect.irregular 'MateriasPlanes', 'MateriasPlanes'

  inflect.irregular 'pracserv_usuario', 'pracserv_usuario'
  inflect.irregular 'PracservUsuario', 'PracservUsuario'

  inflect.irregular 'pracserv_login', 'pracserv_login'
  inflect.irregular 'PracservLogin', 'PracservLogin'

  inflect.irregular 'grupos_cursos', 'grupos_cursos'
  inflect.irregular 'GruposCursos', 'GruposCursos'

  inflect.irregular 'examen_profesor', 'examenes_profesores'
  inflect.irregular 'ExamenProfesor', 'ExamenesProfesores'

  inflect.uncountable(%w(campus))

  #
  # Se agregan las lineas siguientes al agregar la tabla areas_conocimiento ; el resto del contenido se respeta.
  #
  inflect.irregular 'area_conocimiento', 'areas_conocimiento'
  inflect.irregular 'AreaConocimiento', 'AreasConocimiento'
  
  #
  #Se agregan las siguientes lineas al agregar Areas de Adscripción; el resto del contenido se respeta.
  #
  inflect.irregular 'area_adscripcion', 'areas_adscripcion'
  inflect.irregular 'AreaAdscripcion', 'AreasAdscripcion'

end