# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 30101026173718) do

  create_table "alumnos", :force => true do |t|
    t.string   "curp",               :limit => 18, :null => false
    t.string   "matricula",          :limit => 20
    t.string   "nombre",             :limit => 20, :null => false
    t.string   "apellido_paterno",   :limit => 15, :null => false
    t.string   "apellido_materno",   :limit => 15, :null => false
    t.string   "tipo",               :limit => 15, :null => false
    t.string   "nss",                :limit => 20
    t.string   "correo_electronico", :limit => 40
    t.integer  "carrera_id",                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alumnos_semestres", :id => false, :force => true do |t|
    t.integer  "alumno_id",   :null => false
    t.integer  "semestre_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alumnos_semestres", ["alumno_id", "semestre_id"], :name => "index_alumnos_semestres_on_alumno_id_and_semestre_id", :unique => true

  create_table "alumnos_tutores", :id => false, :force => true do |t|
    t.integer "alumno_id", :null => false
    t.integer "tutor_id",  :null => false
  end

  create_table "antecedentes_academicos", :force => true do |t|
    t.decimal  "anio_inicio",                         :precision => 4, :scale => 0
    t.decimal  "anio_fin",                            :precision => 4, :scale => 0
    t.string   "especialidad",          :limit => 30
    t.string   "area",                  :limit => 30
    t.decimal  "promedio",                            :precision => 4, :scale => 2, :null => false
    t.integer  "alumno_id",                                                         :null => false
    t.integer  "escuela_procedente_id",                                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calificaciones", :force => true do |t|
    t.decimal  "parcial1",             :precision => 4, :scale => 1
    t.decimal  "parcial2",             :precision => 4, :scale => 1
    t.decimal  "parcial3",             :precision => 4, :scale => 1
    t.decimal  "final",                :precision => 4, :scale => 1
    t.decimal  "promedio",             :precision => 4, :scale => 1
    t.decimal  "extra1",               :precision => 4, :scale => 1
    t.decimal  "extra2",               :precision => 4, :scale => 1
    t.decimal  "especial",             :precision => 4, :scale => 1
    t.integer  "asistencia_p1"
    t.integer  "asistencia_p2"
    t.integer  "asistencia_p3"
    t.integer  "asistencia_final"
    t.integer  "inscripcion_curso_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calificaciones_fichas", :force => true do |t|
    t.decimal  "calificacion",         :precision => 4, :scale => 1
    t.integer  "materia_aspirante_id",                               :null => false
    t.integer  "ficha_id",                                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calificaciones_prope", :force => true do |t|
    t.decimal  "calificacion",         :precision => 4, :scale => 1
    t.integer  "materia_aspirante_id",                               :null => false
    t.integer  "propedeutico_id",                                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campus", :force => true do |t|
    t.string   "nombre",         :limit => 50, :null => false
    t.integer  "universidad_id",               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campus", ["nombre"], :name => "index_campus_on_nombre", :unique => true

  create_table "carreras", :force => true do |t|
    t.string   "codigo_carrera", :limit => 20, :null => false
    t.string   "nombre_carrera", :limit => 50, :null => false
    t.integer  "campus_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ciclos", :force => true do |t|
    t.string   "ciclo",      :null => false
    t.integer  "inicio"
    t.integer  "fin"
    t.string   "tipo"
    t.boolean  "actual"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ciudades", :force => true do |t|
    t.string   "nombre"
    t.integer  "estado_id",   :null => false
    t.integer  "region_id",   :null => false
    t.integer  "distrito_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configuracion_ciclos", :force => true do |t|
    t.date     "fecha_inicio"
    t.date     "fecha_fin"
    t.date     "inicio_parcial1"
    t.date     "fin_parcial1"
    t.date     "inicio_parcial2"
    t.date     "fin_parcial2"
    t.date     "inicio_parcial3"
    t.date     "fin_parcial3"
    t.date     "inicio_final"
    t.date     "fin_final"
    t.date     "inicio_extra1"
    t.date     "fin_extra1"
    t.date     "inicio_extra2"
    t.date     "fin_extra2"
    t.date     "inicio_especial"
    t.date     "fin_especial"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ciclo_id"
  end

  create_table "configuraciones_aspirantes", :force => true do |t|
    t.string   "proceso",      :limit => 5
    t.string   "tipo",         :limit => 11
    t.date     "fecha_inicio"
    t.date     "fecha_fin"
    t.integer  "ciclo_id",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cursos", :force => true do |t|
    t.integer  "profesor_id",                          :null => false
    t.integer  "materias_planes_id",                   :null => false
    t.boolean  "disponible",         :default => true, :null => false
    t.integer  "contador",           :default => 0
    t.integer  "ciclo_id",                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "datos_personales", :force => true do |t|
    t.string   "lugar_nacimiento", :limit => 40, :null => false
    t.date     "fecha_nacimiento"
    t.string   "sexo",             :limit => 6,  :null => false
    t.integer  "edad",             :limit => 2,  :null => false
    t.string   "estado_civil",     :limit => 11, :null => false
    t.string   "nacionalidad",     :limit => 15, :null => false
    t.string   "tipo_sangre",      :limit => 10
    t.string   "enfermedad",       :limit => 40
    t.string   "alergia",          :limit => 40
    t.integer  "alumno_id",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "direcciones", :force => true do |t|
    t.string   "calle",         :limit => 50
    t.string   "numero",        :limit => 10
    t.string   "colonia",       :limit => 50
    t.integer  "codigo_postal"
    t.string   "telefono",      :limit => 15
    t.integer  "tabla_id",                    :null => false
    t.string   "tabla_type",                  :null => false
    t.integer  "ciudad_id",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "distritos", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "escuelas_procedentes", :force => true do |t|
    t.string   "nombre",     :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "estados", :force => true do |t|
    t.string   "nombre"
    t.integer  "pais_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fichas", :force => true do |t|
    t.string   "numero",          :limit => 4
    t.string   "status",          :limit => 11
    t.string   "grupo",           :limit => 10
    t.date     "fecha_solicitud"
    t.integer  "alumno_id",                     :null => false
    t.integer  "ciclo_id",                      :null => false
    t.integer  "carrera_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grupos", :force => true do |t|
    t.string   "nombre",     :null => false
    t.integer  "contador"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grupos_cursos", :id => false, :force => true do |t|
    t.integer "grupo_id", :null => false
    t.integer "curso_id", :null => false
  end

  create_table "horarios", :force => true do |t|
    t.integer  "curso_id",                  :null => false
    t.string   "dia_semana",  :limit => 10, :null => false
    t.string   "hora_inicio", :limit => 10, :null => false
    t.string   "hora_fin",    :limit => 10, :null => false
    t.string   "aula",        :limit => 30, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inscripciones", :force => true do |t|
    t.integer  "alumno_id",   :null => false
    t.integer  "grupo_id"
    t.integer  "semestre_id", :null => false
    t.integer  "ciclo_id",    :null => false
    t.integer  "carrera_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inscripciones_cursos", :force => true do |t|
    t.string   "status",         :limit => 9, :null => false
    t.integer  "inscripcion_id",              :null => false
    t.integer  "curso_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "materias", :force => true do |t|
    t.string   "clave",             :limit => 10, :null => false
    t.string   "nombre_materia",    :limit => 50, :null => false
    t.integer  "horas_clase",                     :null => false
    t.integer  "horas_laboratorio",               :null => false
    t.integer  "creditos",                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "materias", ["clave"], :name => "index_materias_on_clave", :unique => true
  add_index "materias", ["nombre_materia"], :name => "index_materias_on_nombre_materia", :unique => true

  create_table "materias_admision", :force => true do |t|
    t.string   "nombre",     :null => false
    t.string   "clave"
    t.integer  "carrera_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "materias_aspirantes", :force => true do |t|
    t.string   "clave",      :limit => 10
    t.string   "nombre",     :limit => 50
    t.string   "proceso",    :limit => 5
    t.boolean  "visible"
    t.integer  "carrera_id",               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "materias_aspirantes_profesores", :force => true do |t|
    t.string   "grupo",                :limit => 10
    t.integer  "materia_aspirante_id",               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "materias_planes", :force => true do |t|
    t.integer  "plan_estudio_id",                   :null => false
    t.integer  "materia_id",                        :null => false
    t.integer  "materia_seriada_id", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "materias_planes", ["plan_estudio_id", "materia_id", "materia_seriada_id"], :name => "materias_planes_seriadas", :unique => true

  create_table "paises", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planes_estudio", :force => true do |t|
    t.string   "clave_plan",  :limit => 10, :null => false
    t.integer  "carrera_id",                :null => false
    t.integer  "semestre_id",               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profesores", :force => true do |t|
    t.string   "nombre",             :limit => 30, :null => false
    t.string   "apellido_paterno",   :limit => 15, :null => false
    t.string   "apellido_materno",   :limit => 15, :null => false
    t.string   "cedula_profesional", :limit => 15, :null => false
    t.string   "grado_de_estudios",  :limit => 20, :null => false
    t.string   "rfc",                :limit => 15, :null => false
    t.string   "curp",               :limit => 18, :null => false
    t.integer  "edad",                             :null => false
    t.string   "sexo",                             :null => false
    t.string   "nacionalidad",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "propedeuticos", :force => true do |t|
    t.string   "tipo",       :limit => 5
    t.string   "status",     :limit => 11
    t.string   "grupo",      :limit => 10
    t.integer  "alumno_id",                :null => false
    t.integer  "ciclo_id",                 :null => false
    t.integer  "carrera_id",               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regiones", :force => true do |t|
    t.string   "nombre",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "semestres", :force => true do |t|
    t.string   "clave_semestre", :limit => 50,                   :null => false
    t.boolean  "visible",                      :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "semestres", ["clave_semestre"], :name => "index_semestres_on_clave_semestre", :unique => true

  create_table "tutores", :force => true do |t|
    t.string   "nombre",           :limit => 20, :null => false
    t.string   "apellido_paterno", :limit => 15, :null => false
    t.string   "apellido_materno", :limit => 15, :null => false
    t.string   "ocupacion",        :limit => 30
    t.string   "parentezco",       :limit => 20, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "universidades", :force => true do |t|
    t.string   "nombre",                          :limit => 50
    t.string   "siglas",                          :limit => 10
    t.string   "nombre_vicerrector_academico",    :limit => 50
    t.string   "nombre_jefe_servicios_escolares", :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "role_id",                           :null => false
    t.integer  "campus_id"
    t.string   "login",                             :null => false
    t.string   "email",                             :null => false
    t.string   "crypted_password",                  :null => false
    t.string   "password_salt",                     :null => false
    t.string   "persistence_token",                 :null => false
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true

end
