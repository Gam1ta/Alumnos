# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Miscelaneos
  def self.create_alumno_user(alumno_id=nil, curp=nil, user_attributes={})
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
      email=  a.curp.to_s.downcase[0..9] + "@ndikandi.utm.mx"
      default_attributes = {campus_id: 1, role_id: 4, login: matricula, email: email, password: def_password, password_confirmation: def_password }
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
  
  def self.get_actual_alumnos(params={})
    ciclo  = Ciclo.get_ciclo_actual
    ciclo_anterior  = Ciclo.get_ciclo_anterior
    ciclos = [ciclo.id, ciclo_anterior.id]
    conditions = {ciclo_id: ciclos}
    conditions = conditions.merge(params)
    
    Alumno.joins(:inscripciones).where(inscripciones: conditions).distinct.order(:curp)
  end
end

