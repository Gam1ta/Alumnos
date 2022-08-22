class ConfiguracionCiclo < ActiveRecord::Base
  #Asociaciones
  belongs_to :ciclo

  #Validaciones
  #************************ fecha_inicio  -  fecha_fin **************************
  validates :fecha_inicio, 
    :presence => true,
    :date => {:before_or_equal_to => :fecha_fin}
  validates :fecha_fin,
    :presence => true,
    :date => {:after_or_equal_to => :fecha_inicio}

  #************************ inicio_parcial1  -  fin_parcial1 **************************
  validates :inicio_parcial1, 
    :presence => true,
    :date => {:after => :fecha_inicio, :before => :fin_parcial1}
  validates :inicio_parcial1,
    :presence => true,
    :date => {:before => :fecha_fin}
  validates :fin_parcial1, 
    :presence => true,
    :date => {:after => :inicio_parcial1, :before => :inicio_parcial2}
  validates :fin_parcial1,
    :presence => true,
    :date => {:before => :fecha_fin}

  #************************ inicio_parcial2  -  fin_parcial2 **************************
  validates :inicio_parcial2,
    :presence => true,
    :date => {:after => :fin_parcial1, :before => :fin_parcial2}
  validates :inicio_parcial2,
    :presence => true,
    :date => {:before => :fecha_fin}
  validates :fin_parcial2,
    :presence => true,
    :date => {:after => :inicio_parcial2, :before => :inicio_parcial3}
  validates :fin_parcial2,
    :presence => true,
    :date => {:before => :fecha_fin}

  #************************ inicio_parcial3  -  fin_parcial3 **************************
  validates :inicio_parcial3,
    :presence => true,
    :date => {:after => :fin_parcial2, :before => :fin_parcial3}
  validates :inicio_parcial3,
    :presence => true,
    :date => {:before => :fecha_fin}
  validates :fin_parcial3,
    :presence => true,
    :date => {:after_or_equal_to => :inicio_parcial3, :before => :inicio_final}
  validates :fin_parcial3,
    :presence => true,
    :date => {:before => :fecha_fin}

  #************************ inicio_final  -  fin_final **************************
  validates :inicio_final,
    :presence => true,
    :date => {:after => :fin_parcial3, :before_or_equal_to => :fin_final, :before => :fecha_fin}
  validates :fin_final,
    :presence => true,
    :date => {:after_or_equal_to => :inicio_final, :before_or_equal_to => :fecha_fin}
 
  #************************ inicio_extra1  -  fin_extra1 **************************
  validates :inicio_extra1,
    :allow_blank => true,
    :date => {:after => :fin_final, :before_or_equal_to => :fin_extra1}
  validates :fin_extra1,
    :allow_blank => true,
    :date => {:after => :fecha_fin, :after_or_equal_to => :inicio_extra1, :before => :inicio_extra2}

  #************************ inicio_extra2  -  fin_extra2 **************************
  validates :inicio_extra2, 
    :allow_blank => true,
    :date => {:after => :fin_extra1, :before_or_equal_to => :fin_extra2}
  validates :inicio_extra2,
    :allow_blank => true,
    :date => {:after => :fecha_fin}
  validates :fin_extra2,
    :allow_blank => true,
    :date => {:after => :fecha_fin, :after_or_equal_to => :inicio_extra2, :before => :inicio_especial}

  #************************ inicio_especial  -  fin_especial **************************
  validates :inicio_especial,
    :presence => true,
    :date => {:after => :fecha_fin, :before_or_equal_to => :fin_especial}

  validates :fin_especial,
    :presence => true,
    :date => {:after => :fecha_fin, :after_or_equal_to => :inicio_especial}

  ##  #************************ Lecturas Parciales **************************
  validates :inicio_lectura_1,
    :allow_blank => true,
    :date => {:after => :fecha_inicio, :before_or_equal_to => :fin_lectura_1}
  validates :fin_lectura_1,
    :allow_blank => true,
    :date => {:after_or_equal_to => :inicio_lectura_1, :before_or_equal_to => :inicio_parcial1}
  validates :inicio_lectura_2,
    :allow_blank => true,
    :date => {:after => :fin_parcial1, :before_or_equal_to => :fin_lectura_2}
  validates :fin_lectura_2,
    :allow_blank => true,
    :date => {:after_or_equal_to => :inicio_lectura_2, :before_or_equal_to => :inicio_parcial2}
  validates :inicio_lectura_3,
    :allow_blank => true,
    :date => {:after => :fin_parcial2, :before_or_equal_to => :fin_lectura_3}
  validates :fin_lectura_3,
    :allow_blank => true,
    :date => {:after_or_equal_to => :inicio_lectura_3, :before_or_equal_to => :inicio_parcial3}
  ##  #************************* fin validaciones lecturas parciales ********

  #
  # Obtiene el rango de fechas para el examen del tipo parcial 1 como una cadena.
  #
  def get_fechas_for_parcial_1
    "Del #{self.inicio_parcial1.to_s} al #{self.fin_parcial1.to_s}"
  end

  #
  # Obtiene el rango de fechas para el examen del tipo parcial 2 como una cadena.
  #
  def get_fechas_for_parcial_2
    "Del #{self.inicio_parcial2.to_s} al #{self.fin_parcial2.to_s}"
  end

  #
  # Obtiene el rango de fechas para el examen del tipo parcial 3 como una cadena.
  #
  def get_fechas_for_parcial_3
    "Del #{self.inicio_parcial3.to_s} al #{self.fin_parcial3.to_s}"
  end

  #
  # Obtiene el rango de fechas para el examen del tipo ordinario como un cadena
  #
  def get_fechas_for_ordinario
    "Del #{self.inicio_final.to_s} al #{self.fin_final.to_s}"
  end

  #
  # Obtiene el rango de fechas para el examen del tipo extraordinario 1 como una cadena.
  #
  def get_fechas_for_extraordinario_1
    "Del #{self.inicio_extra1.to_s} al #{self.fin_extra1.to_s}"
  end

  #
  # Obtiene el rango de fechas para el examen del tipo extraordinario 2 como una cadena.
  #
  def get_fechas_for_extraordinario_2
    "Del #{self.inicio_extra2.to_s} al #{self.fin_extra2.to_s}"
  end

  #
  # Obtiene el rango de fechas para el examen del tipo especial como una cadena.
  #
  def get_fechas_for_especial
    "Del #{self.inicio_especial.to_s} al #{self.fin_especial.to_s}"
  end

  #
  # Determina si la fecha del especial es la misma, falso en caso contrario.
  #
  def are_especial_dates_eql?
    self.inicio_especial.eql?(self.fin_especial)
  end
end
