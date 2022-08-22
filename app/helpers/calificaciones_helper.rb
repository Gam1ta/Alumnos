module CalificacionesHelper
    #
  # Obtiene el color rojo cuando la calificación sea reprobatoria.
  #
  def get_color_for_calificacion(calificacion)
    "style='color: red'" if calificacion.to_f < 6.0
  end

  #
  # Obtiene el color rojo cuando el porcentaje de asistencia sea no alcanzable
  # para los extras.
  #
  def get_color_for_asistencia(asistencia)
    "style='color: red'" if asistencia.to_i < 65
  end

  #
  # Obtiene el color rojo cuando el porcentaje de asistencia sea no alcanzable
  # para el ordinario.
  #
  def get_color_for_ordinario(asistencia)
    "style='color: red'" if asistencia.to_i < 85
  end
end
