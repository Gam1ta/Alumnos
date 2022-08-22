class Empresa < ActiveRecord::Base
	def self.search(params)
	  empresas = Empresa.all 
	  empresas = empresas.where("upper(nombre) like ? AND status = 1", "%#{params[:search].upcase}%") if params[:search]
	  empresas
	end	
end
