class Pais < ActiveRecord::Base

#  has_many :estados, :as => :pais
#  accepts_nested_attributes_for :estados
  has_many :estados
  accepts_nested_attributes_for :estados

  validates :nombre , :presence => true,
    :uniqueness => true,
    :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{1,255}\Z/i },
    :length => { :maximum => 50 }

end
