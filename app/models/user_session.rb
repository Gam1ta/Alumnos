class UserSession < Authlogic::Session::Base
#  def to_key
#    new_record? ? nil : [ self.send(self.class.primary_key) ]
#  end
  attr_accessor :curp
  before_validation :strip_login

  def to_key
    #new_record? ? nil : [ self.send(self.class.primary_key) ]
    new_record? ? nil : [defined?(self.primary_key) ? self.primary_key : nil]
  end
   
  #elimina los espacios en blanco adelante  y atras del login
  def strip_login
    self.login.to_s.strip!
  end  

end
