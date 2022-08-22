class LenguaIndigena < ActiveRecord::Base
  has_and_belongs_to_many :dato_personals

    validates :nombre, :presence => true, :uniqueness => true,
    :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ(),.:;'"-_\s\-\_]{1,255}\Z/i },
    :length => { :maximum => 100 }

end
