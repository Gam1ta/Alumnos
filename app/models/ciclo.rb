class Ciclo < ActiveRecord::Base
  #
  # Constante que indicará que el periodo corresponde a semestre IMPAR
  #
  IMPAR = 0

  #
  # Constante que indicará que el periodo corresponde a semestre PAR
  #
  PAR = 1
  
  #
  # Constante que indicará que el periodo corresponde a cursos de VERANO
  #
  VERANO = 2

  #Asociaciones
  has_one :configuracion_ciclo, :dependent => :destroy
  has_many :cursos
  has_many :inscripciones
  has_many :grupos
  has_many :configuraciones_aspirantes
  has_many :propedeuticos
  has_many :fichas
  has_many :plan_estudios

  accepts_nested_attributes_for :configuracion_ciclo, :allow_destroy => true

  #Validaciones
  validates :ciclo,
    :presence => true,
    :uniqueness => true
  #
  validates :inicio,
    :presence => true,
    :uniqueness => {:scope => [:fin, :tipo]},
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 2000, :less_than => :fin },
    :length => { :minimum => 4 }

  validates :fin,
    :presence => true,
    :numericality => { :only_integer => true, :greater_than => :inicio, :less_than_or_equal_to => 9999 },
    :length => { :minimum => 4 }

  validates :tipo,
    :presence => true,
    :length => { :is => 1 },
    :format => { :with => /[A,B,V]/i }
  
  validate :are_years_valid?

  before_validation :set_ciclo
  before_validation :check_dates_for_type

  protected
  #
  # Realiza la validación en los años, de inicio y término del periodo escolar, los años tienen que diferir en 1,
  # Si la diferencia es mayor a 1, se le indicará al usuario y no se procederá a almacenar la información.
  #
  def are_years_valid?
    errors.add :fin, "debe ser consecutivo al Año de Inicio" if fin.to_i - 1 != inicio
  end

  #
  # Establece el nombre del periodo, el método es llamado antes de que el objeto
  # se crea o se actualice.
  #
  def set_ciclo
    self.ciclo = "#{inicio}-#{fin}#{tipo}"
  end

  #
  # Si el tipo de periodo es A o B, obliga a que el usuario agregue las fechas para los extraordinarios.
  #
  def check_dates_for_type
    unless self.configuracion_ciclo.nil? or is_tipo_v?
      errors[:base] << "Debe agregar la fecha de inicio del primer extraordinario." if self.configuracion_ciclo.inicio_extra1.blank?
      errors[:base] << "Debe agregar la fecha de término del primer extraordinario." if self.configuracion_ciclo.fin_extra1.blank?
      errors[:base] << "Debe agregar la fecha de inicio del segundo extraordinario." if self.configuracion_ciclo.inicio_extra2.blank?
      errors[:base] << "Debe agregar la fecha de término del segundo extraordinario." if self.configuracion_ciclo.fin_extra2.blank?
    end
  end

  public
  #
  # Regresa un objeto de tipo ciclo mediante el identificador del curso. Si el indentificador del curso no existe,
  # regresa un objeto nulo.
  #
  # Este método debe de regresar un sólo objeto, ya que un curso tiene y debe tener un solo periodo. Se agrega el método first
  # debido a que sin él regresa un arreglo de objetos de tipo ciclo. Tomando en cuenta la unicidad de curso hacia ciclo es
  # preferible manejar un objeto a manejar un arreglo de objetos de longitud 1.
  #
  def self.get_periodo_by_curso_id(curso_id)
    joins(:cursos).where(:cursos => {:id => curso_id}).first
  end

  #
  # Regresa el nombre del ciclo mediante el identificador del curso. Si no existiera el enlace desde curso hasta ciclo en
  # la base de datos, el sistema regresará la cadena "SIN PERIODO".
  #
  # Es casi 100% probable que siempre devuelva el nombre del periodo, ya que para crear cursos se necesitan de los periodos. Pero
  # en esta vida todo puede suceder =D
  #
  def self.get_nombre_by_curso_id(curso_id)
    periodo = Ciclo.get_periodo_by_curso_id(curso_id)

    return !periodo.blank? ? periodo.ciclo : "SIN PERIODO"
  end
  #
  # Verifica que el periodo sea VERANO. TRUE si es verano; FALSE en caso contrario.
  #
  def self.is_verano?(ciclo_id)
    exists?(:id => ciclo_id, :tipo => 'V')
  end

  #
  # Verifica si el periodo actual tiene configurado el calendario escolar.<br/>
  # Regresa <tt>true</tt> si tiene el calendario.<br/>
  # Regresa <tt>false</tt> en caso contrario.
  #
  def self.actual_has_calendario_escolar?
    !joins(:configuracion_ciclo).where(:actual => true).blank?
  end

  #
  # Retorna el ciclo dado el periodo
  #
  def self.get_ciclo_by_periodo(per)
    periodo = Ciclo.find_all_by_ciclo(per).first
  
    return !periodo.blank? ? periodo.inicio.to_s + "-" + periodo.fin.to_s : "SIN CICLO"
  end

  #
  #Retorna como String el dato ciclos.ciclo dado el alumno_id y semestre_id
  #
  ##
  def self.get_nombre_ciclo_by_alumno_id_and_semestre(alumno, semestre)
    periodo=Ciclo.joins(:inscripciones).where(:inscripciones => {:semestre_id => semestre, :alumno_id => alumno}).first
    return !periodo.blank? ? periodo.ciclo.to_s : "SIN PERIODO"
  end

  #
  # Determina si el periodo es para semestres del tipo A (impares)
  #
  def is_tipo_a?
    self.tipo.eql?('A')
  end

  #
  # Determina si el periodo es para semestres del tipo B (pares)
  #
  def is_tipo_b?
    self.tipo.eql?('B')
  end

  #
  # Determina si el periodo es para Verano
  #
  def is_tipo_v?
    self.tipo.eql?('V')
  end

  #
  # Determina si el periodo está relacionado con algún otro modelo.
  #
  def has_relations?
    (!self.inscripciones.empty? or
        !self.cursos.empty? or
        !self.grupos.empty? or
        !self.configuraciones_aspirantes.empty? or
        !self.propedeuticos.empty? or
        !self.fichas.empty?)
  end

  #
  # Determina si el periodo NO está relacionado con algún otro modelo.
  #
  def has_not_relations?
    !has_relations?
  end

  #
  # Obtiene el tipo de periodo formateado
  #
  def get_tipo_formated
    case tipo
    when 'A' then 'A (Impar)'
    when 'B' then 'B (Par)'
    when 'V' then 'V (Verano)'
    end
  end

  #
  # Obtiene el nombre del ciclo, conformado por el año de inicio y el año de
  # término separados por un guión.
  #
  # Ejemplo:
  # * 2009-2010
  # * 2010-2011
  # * 2012-2013
  #
  def get_nombre
    "#{self.inicio}-#{self.fin}"
  end

  #
  # Determina si el periodo en cuestión, tiene creado el calendario escolar.
  #
  def has_calendario_escolar?
    !self.configuracion_ciclo.nil?
  end
  
 
  def Ciclo.get_ciclo_actual
    return Ciclo.find_by_actual(true)
  end
  
  #obtiene el ciclo anterior al ciclo definido como actual, o en su caso el limite  inferior
  def Ciclo.get_ciclo_anterior(n=1)
    ciclos = Ciclo.where(:tipo => ["A", "B"]).order('ciclo').to_a
    actual_index = ciclos.index(Ciclo.get_ciclo_actual)
    index = actual_index - n
    if index > ciclos.count
     index = ciclos.count
    elsif index < 0
      index = 0
    end
    ciclos[index]
  end
  

  #obtiene el ciclo posterior al ciclo definido como actual, o en su caso el limite  posterior
  def Ciclo.get_ciclo_posterior(n=1)
    ciclos = Ciclo.where(:tipo => ["A", "B"]).order('ciclo').to_a
    actual_index = ciclos.index(Ciclo.get_ciclo_actual)
    index = actual_index + n
    if index > ciclos.count
     index = ciclos.count
    elsif index < 0
      index = 0
    end
    ciclos[index]
  end
  
  def self.get_ciclo_at_fecha(fecha)
    year, month, day  = String(fecha).split("-")
    mes = Integer(Float(month))
    year = Integer(Float(year))
    @tipo = nil
    case mes
    when 3..7 then @tipo = 'B'
    when 8..9 then @tipo = 'V'
    else @tipo = 'A'
    end
    if mes < 10 
      ciclo = Ciclo.find_by(:fin => year, :tipo => @tipo)
    else
      ciclo = Ciclo.find_by(:inicio => year, :tipo => @tipo)
    end
    ciclo
  end  

  
end
