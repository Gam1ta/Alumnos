class User < ActiveRecord::Base
  #acts_as_authentic
  acts_as_authentic do |c|
    c.login_field = 'login'
    c.merge_validates_length_of_password_confirmation_field_options({:minimum => 4})
    c.merge_validates_length_of_password_field_options({:minimum => 4})
    #c.validates_format_of_email_field_options = {:with => Authlogic::Regex.email_nonascii}    
  end  
  
  belongs_to :role
  belongs_to :campus
  has_and_belongs_to_many :modulos
  has_one :alumno
  has_one :profesor
  has_one :escolar

  validates :email,
    :presence => true,
    :uniqueness => true,
    :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
#  validates :correo_adicional,
#            :presence => true,
#            :uniqueness => true,
#            :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validates :campus_id,
    :presence => true
  validates :role_id,
    :presence => true
  validates :login,
    :presence => true,
    :format => {:with => /\A[@0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{1,255}\Z/i },
    :length => {:maximum => 255}
  validates :password, 
    :format => {:with => /\A[0-9a-zA-ZñÑ\-\_]{1,255}\Z/i, :multiline => true },
    :length => {:maximum => 255}


  delegate :nombre, :to => :campus, :prefix => true, :allow_nil => true
  delegate :name, :to => :role, :prefix => true, :allow_nil => true
  delegate :curp, :to => :alumno, :prefix => true, :allow_nil => true

  #
  # Determina si el usuario es <tt>ADMINISTRADOR</tt>, tiene super poderes.
  #
  def is_administrador?
    self.role.name.eql?(Role::ADMINISTRADOR)
  end

  #
  # Determina si el usuario es un <tt>TRABAJADOR ESCOLAR (SECRETARIA)</tt>.
  #
  def is_escolar?
    self.role.name.eql?(Role::ESCOLAR)
  end

  #
  # Determina si el usuario es un <tt>PROFESOR</tt>.
  #
  def is_profesor?
    self.role.name.eql?(Role::PROFESOR)
  end

  #
  # Determinar si el usuario es un <tt>ALUMNO</tt>.
  #
  def is_alumno?
    self.role.name.eql?(Role::ALUMNO)
  end

  #
  # Obtiene el login concatenado con el nombre completo del usuario
  #
  def get_login_with_full_name
    self.login.to_s + ' | ' + self.escolar.full_name.to_s
  end

  #
  # Determinar si el usuario loggeado tiene permiso de accesar al módulo (controlador)
  # seleccionado por el usuario.
  #
  def can?(controller)
    if ["home", "emergentes", "principal", "restrinct"].include?(controller)
      true
    else
      modulos.exists?(:modulos => {:controller_name => controller})
    end
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    PasswordResetMailer.reset_email(self).deliver_now
  end
end
