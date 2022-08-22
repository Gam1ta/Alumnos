class ConfiguracionAspirante < ActiveRecord::Base
  #
  # Constante para representar el proceso FICHA
  #
  FICHA = 'FICHA'

  #
  # Constante para representar el proceso PROPE
  #
  PROPE = 'PROPE'

  #
  # Constante para representar el tipo CORTO
  #
  CORTO = 'CORTO'
  
  #
  # Constante para representar el tipo LARGO
  #
  LARGO = 'LARGO'
  
  belongs_to :ciclo
  has_many :fichas
  has_many :propedeuticos

  validates :ciclo_id,
    :presence => true
  validates :fecha_inicio,
    :presence => true,
    :date => {:before_or_equal_to => :fecha_fin}
  validates :fecha_fin,
    :presence => true,
    :date => {:after_or_equal_to => :fecha_inicio}

  before_validation :set_nil_to_fichas , :on => :create

  delegate :ciclo,
    :to => :ciclo,
    :prefix => true,
    :allow_nil => true

  protected
  #
  # Antes de guardar (crear o actualizar) si el proceso es propedéutico, establece
  # todos los campos relacionados con fichas a nulo.
  #
  def set_nil_to_fichas
    if proceso.eql?(PROPE)
      self.hora_examen = nil
      self.fecha_examen = nil
      self.lugar = nil
      
      unless ConfiguracionAspirante.where(:ciclo_id => ciclo_id, :proceso => PROPE, :tipo => tipo).blank?
        errors.add :proceso, "Ya se encuentra registrado en el sistema."
      end
    end
    # Guarda el status de la nueva configuración.
    self.actual = !ConfiguracionAspirante.where(:actual => true, :ciclo_id => ciclo_id).blank?
    nil
  end
end
