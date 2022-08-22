class Universidad < ActiveRecord::Base

 validates :nombre, :length => { :maximum => 50 },
                    :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ()\s\-\_]{1,255}\Z/i },
                    :presence => true

 validates :nombre_vicerrector_academico, :nombre_jefe_servicios_escolares, :length => { :maximum => 50 },
                                                                            :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ()\s\-\_\.]{1,255}\Z/i },
                                                                            :presence => true
 validates :nombre, :siglas,:uniqueness => true
 validates :siglas , :length => { :maximum => 10 },
                     :format => {:with => /\A[0-9a-zA-ZñÑáéíóúÁÉÍÓÚ()\s\-\_]{1,255}\Z/i },
                     :presence => true
 has_many :campus##, :as => :universidad_id
  def self.find_universidad
    find(:all, :order => "nombre" )
  end
end
