class Ciudad < ActiveRecord::Base
  belongs_to :estado, :dependent => :destroy
  belongs_to :region,:dependent => :destroy
  belongs_to :distrito, :dependent => :destroy
  has_many :direcciones, :as => :ciudad
  accepts_nested_attributes_for :direcciones

  validates :nombre, :presence => true
 
  ##  validates :nombre,:estado_id, :presence => true
  validates :nombre,:format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{1,255}\Z/i },:length => { :maximum => 50 }
#  validates :region_id, :distrito_id , :presence => {:scope => [:estado_id => Estado.find(:first, :conditions=>['nombre = ?', "OAXACA"]).blank? ? 0:Estado.find(:first, :conditions=>['nombre = ?', "OAXACA"]).id ]}
#  validates :nombre, :uniqueness=> {:scope =>[:estado_id

#  private
#  def region_id_is_not_null
#    errors.add "La región", ' no puede estar vacío' if (self.region_id) == 0
#    errors.add "La región", ' inválido' if (self.region_id) == -1
#  end
#
#  def distrito_id_is_not_null
#    errors.add :distrito_id, ' no puede estar vacío' if (self.distrito_id) == 0
#    errors.add :distrito_id, ' inválido' if (self.distrito_id) == -1
#  end

end
