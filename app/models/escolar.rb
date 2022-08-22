class Escolar < ActiveRecord::Base
  belongs_to :user

  validates :nombre,
    :presence => true,
    :length => { :minimum => 3,:maximum => 50 },:format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚÜü()\s\_]{1,255}\Z/i }
  validates :apellido_paterno,
    :length => {:maximum => 50  },:format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚÜü()\s\_]{0,255}\Z/i }
  validates :apellido_materno,
    :length => {:maximum => 50  },:format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚÜü()\s\_]{0,255}\Z/i }
  validates :rfc,
    :presence => true,

    :length => { :is => 15 },
    :uniqueness => true,
    :format => { :with => /\A([a-z]|[A-Z]){4}-\d{6}-(([a-z]|[A-Z])|\d){3}\Z/, :message => "El formato del RFC debe ser: AAAA-111111-AAA" }
  validates :curp,
    :presence => true,
    :length => { :is => 18 },
    :uniqueness => true,
    :format => { :with => /\A([a-z]|[A-Z]){4}\d{6}([a-z]|[A-Z]){6}\d{2}\Z/, :message => "El formato de la CURP debe ser: AAAA111111AAAAAA11" }
    
  validates :edad,
    :presence => true,
    :numericality =>  { :greater_than_or_equal_to => 15, :less_than_or_equal_to => 90 },
    :format => {:with => /\A[0-9]{2}/ }
  validates :sexo,
    :presence => true
  validates :nacionalidad,
    :presence => true,
    :length => { :minimum => 5, :maximum => 50  },:format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚÜü()\s\-\_]{1,255}\Z/i }
   validate  :apellido_is_null

  def full_name
    if !self.apellido_paterno.nil? and !self.apellido_materno.nol?
    self.nombre + " " + self.apellido_paterno + " " + self.apellido_materno
    end
  end

   def apellido_is_null
    errors.add :apellido_paterno, :apellido_is_null if (self.apellido_materno.blank? and self.apellido_paterno.blank? )
  end

end
