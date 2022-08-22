class AntecedenteAcademico < ActiveRecord::Base  
  belongs_to :alumno
  belongs_to :escuela_procedente
  
  validates :anio_inicio,
    :format => {:with => /\d{0,4}/}
  validates :anio_fin,
    :allow_blank => true,
    :format => {:with => /\d{0,4}/},
    :numericality => {:greater_than_or_equal_to => :anio_inicio}
  validates :especialidad, 
    :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{0,255}\Z/i},
    :length => {:maximum => 50}
  validates :area, 
    :format => {:with => /\A[0-9a-zA-ZñÑäëïöüÄËÏÖÜáéíóúÁÉÍÓÚ()\\:\\.\,\s\-\_]{0,255}\Z/i},
    :length => {:maximum => 50}
  validates :promedio, 
    :numericality => {:greater_than_or_equal_to => 6.0, :less_than_or_equal_to => 10.0},
    :allow_blank => true
end
