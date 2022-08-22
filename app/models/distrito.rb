class Distrito < ActiveRecord::Base
#  has_many :ciudades, :as => :ditrito

  has_many :ciudades


  accepts_nested_attributes_for :ciudades
   validates :nombre , :presence => true,
                       :uniqueness => true,
                       :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{1,255}\Z/i },
                       :length => { :maximum => 50 }

end
