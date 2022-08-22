class Direccion < ActiveRecord::Base
  belongs_to :ciudad
  belongs_to :tabla, :polymorphic => true


  validate :ciudad_id_is_not_null
  validates :ciudad_id, :presence => true
  validates :calle, :colonia, :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\'\"\s\-\_\.\,\/]{0,255}\Z/i }, :length => { :maximum => 100 }
  validates :codigo_postal, :format => {:with => /\d{0,5}/ },:length => { :maximum => 5 }
  validates :telefono, :length => { :maximum => 50 }
  validates :numero, :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_\/]{0,255}\Z/i }, :length => { :maximum => 50 }

  private
  def ciudad_id_is_not_null
    errors.add :ciudad_id, ' no puede estar vacío' if (self.ciudad_id.to_i) < 1
  end
end