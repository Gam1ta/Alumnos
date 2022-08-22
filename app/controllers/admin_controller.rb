class AdminController < ApplicationController
  #before_filter :require_user
  before_filter :require_admin
  def index
    user_data
    @usuario = current_user
    @periodo_actual = current_ciclo.ciclo
    @bandera = true
    @universidad = Universidad.first
  end

  def user_data
    @usuario = current_user
    @periodo_actual = current_ciclo.ciclo
  end

  def crear_cuenta
    user_data
    alumnos = get_actual_alumnos.select{|a| a.user.blank?}
    puts ""
    flash[:info] = ['Procesando petición, espere un momento por favor ...']
    alumnos.each_with_index do |alumno, index|
      print "\n #{index}.- "
      u = create_alumno_user(alumno[:id], alumno[:curp], {})
    end
    puts '', '',  'FINALIZADO' , ''
    flash[:info] = ['¡Finalizado!', 'Cuentas creadas correctamente']
    redirect_to admin_index_path
  end

  def reiniciar_cuenta
    user_data
  end

  def setear_datos_del_alumno
    matricula = params[:matricula].upcase unless params[:matricula].blank?
    force_create = !([nil, false, 'false', ''].include?(true))
    if matricula.present?
      alumnos = get_actual_alumnos().where(:matricula => matricula)
      failed =  Array.new
      alumnos.each do |alumno|
        if alumno.present?
          def_password =  alumno.curp.to_s.strip.upcase
          def_login =  alumno.matricula.to_s.strip
          def_email = alumno.correo_electronico.to_s.strip
          u = alumno.user
          if u.present?
            #if u.update_attributes({:login => def_login, :password => def_password, :password_confirmation => def_password, :correo_adicional => def_email})
            if u.update_attributes({:login => def_login, :password => def_password, :password_confirmation => def_password})
              flash[:info] = ['¡Finalizado!', 'Se han reiniciado los datos con éxtio']
            else
              failed << " #{alumno.curp} error al actualizar"
              flash[:info] = ["#{alumno.curp}", 'error al actualizar']
            end
          elsif force_create
            u = create_alumno_user(nil, alumno[:curp], {} )
            if u.present? && u.persisted?
              puts  "    Usuario Creado:  #{alumno.curp} --- #{u.login} - #{def_password} >  #{alumno.user_id}, #{u.id}"
            else
              failed << " #{alumno.curp} no pudo guardarse el usuario"
            end
          else
            failed << " #{alumno.curp} no tiene un usuario asignado"
          end
        else
          flash[:info] = ['¡Error!', "no se encuentra al alumno con la curp #{matricula}"]
        end
      end
    else
      puts "", "Error, no se encuentra la curp #{matricula}. "
      flash[:info] = ['¡Error!', "no se encontró la curp #{matricula}"]
    end
    puts '', 'Failed: ',  failed   if failed.present?
    puts '', '',  'FINALIZADO' , ''
    redirect_to admin_index_path #una vez que termina la operacion que lleve al index
  end

  def get_actual_alumnos(params={})
    ciclo  = Ciclo.get_ciclo_actual
    ciclo_anterior  = Ciclo.get_ciclo_anterior
    ciclo_dos_anterior  = Ciclo.get_ciclo_anterior(2)
    ciclo_tres_anterior  = Ciclo.get_ciclo_anterior(3)
    ciclos = [ciclo.id, ciclo_anterior.id, ciclo_dos_anterior, ciclo_tres_anterior]
    conditions = {:ciclo_id => ciclos}
    #conditions = conditions.merge(params)
    Alumno.joins(:inscripciones).where(:inscripciones => conditions).distinct.order(:matricula)
  end

  def create_alumno_user(alumno_id=nil, curp=nil, user_attributes={})
    if alumno_id.blank? && curp.blank? && user_attributes[:alumno_id].blank?
      puts "No hay información sobre el alumno"
      return
    end
    a =  Alumno.find alumno_id if alumno_id.present?
    a =  Alumno.find_by_curp curp if a.blank? && curp.present?
    a =  Alumno.find user_attributes[:alumno_id] if a.blank? && user_attributes[:alumno_id].present?
    u =  nil
    if a.present?
      def_password = a.curp.to_s.upcase
      matricula = a.matricula.to_s.upcase
      campus = Campus.first
      extension = !campus.extension_correo_alumnos.blank? ? campus.extension_correo_alumnos : (!campus.nombre.blank? ? (campus.nombre.downcase + ".edu.mx"): "correo.edu.mx")
      extension.delete!('@')
      email =  a.matricula.to_s.downcase + "@" + extension
      default_attributes = {:campus_id => 1, :role_id => 4, :login => matricula, :email => email, :password => def_password, :password_confirmation => def_password }
      us_att =  {}
      us_att =  default_attributes.merge(us_att)
      us_att =  us_att.merge user_attributes.select{|att| (User.column_names + ['password', 'password_confirmation' ] ).include?(att.to_s)}
      u = a.user
      if u.present?
        print " %40s" %'Usuario existente, actualizando: '
        if u.update_attributes(us_att)
          print "  ... OK #{def_password}  #{u.login} "
        else
          print "  ... ERROR #{u.login} : ",   u.errors.full_messages
        end
      else
        print " %40s" %'Usuario nuevo, creando: '
        u = User.new(us_att)
        a.user =  u
        if a.save
          print "  ... OK #{def_password}  #{u.login} "
        else
          print "  ... ERROR #{u.login} : ",  u.errors.full_messages
        end
      end
    else
      puts "El alumno no se encuentra"
    end
    u
  end

  def reset_password
    user_data
  end

  def actualizar_password
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    def_login = current_user.login
    def_email = current_user.email
    usuario = User.where(:login => def_login).order('id').first() #  where(login: def_login).distinct.order(:id)
    if usuario.present?
      if password == password_confirmation
        #usuario.update_attributes({:login => def_login, :password => password, :password_confirmation => password, :correo_adicional => def_email})
        usuario.update_attributes({:login => def_login, :password => password, :password_confirmation => password})
        redirect_to admin_index_path
        flash[:info] = ['¡Finalizado!', 'La contraseña se ha actualizado exitósamente']
      else
        redirect_to admin_index_path
        flash[:info] = ['¡Error!', 'Las contraseñas no coinciden']
      end
    else
      redirect_to admin_index_path
      flash[:info] = ['¡Error!', 'Usuario no encontrado']
    end
  end
end