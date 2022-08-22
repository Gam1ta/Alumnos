module HomeHelper
  
  def get_semester_name(clave)
    case (clave)
    when "PRIMERO", "TERCERO"
      name =  clave.chop
    else
      name = clave
    end
    return name
  end
end
