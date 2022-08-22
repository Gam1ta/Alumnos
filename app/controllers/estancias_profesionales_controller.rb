class EstanciasProfesionalesController < ApplicationController
  before_filter :require_user, :except => []
  before_filter :require_alumno, :except => []

  def index
    @usuario = current_user
    @periodo_actual = current_ciclo.ciclo
    ciclo = Ciclo.get_ciclo_at_fecha(Date.today) || current_ciclo
    @inscripciones = @usuario.alumno.inscripciones.select{|item| item.ciclo_id == ciclo.id} if ciclo.present?
    @last_inscripcion = @inscripciones.sort_by{|i| i.semestr.clave}.last
    @last_inscripcion = @usuario.alumno.inscripciones.sort_by{|i| i.semestr.clave}.last if @last_inscripcion.blank?
		@profesor =  @usuario.alumno.profesor || Profesor.new
		@modelo_estancias = ModeloEstancias.first
	
	@tab = params[:tab]
	@search = params[:search]
	
	if params[:commit] == "Buscar"
		@empresas = Empresa.search(params).paginate(:page => params[:page], :per_page => 10)
	else
		@empresas = Empresa.where("status = 1").paginate(:page => params[:page], :per_page => 10)
		@search = ""
	end
	
	@empresas_opciones = []
	@existe_seleccionada = false
	
	for opcion in OpcionEstancia.where(:alumno_id => current_user.alumno.id)
		@empresas_opciones << {
			:empresa => Empresa.find(opcion.empresa_id), 
			:estatus => opcion.estatus, 
			:id => opcion.id,
			:fecha => opcion.updated_at - (3600 * 6)
		}
		if opcion.estatus == "SELECCIONADA"
			@existe_seleccionada = true
		end
	end
	
	@fecha_opciones_inicio = EstanciasConfig.first.fecha_opciones_inicio
	@fecha_opciones_fin = EstanciasConfig.first.fecha_opciones_fin

	#Fechas para estancias - periodo uno
	@inicio_periodo_uno = EstanciasConfig.first.inicio_periodo_uno
	@fin_periodo_uno = EstanciasConfig.first.fin_periodo_uno
	@entrega_documentos_periodo_uno = EstanciasConfig.first.entrega_documentos_periodo_uno

    #Fechas para estancias - periodo dos
    @inicio_periodo_dos = EstanciasConfig.first.inicio_periodo_dos
    @fin_periodo_dos = EstanciasConfig.first.fin_periodo_dos
		@entrega_documentos_periodo_dos = EstanciasConfig.first.entrega_documentos_periodo_dos

	#Fechas para estancias - periodo tres
    @inicio_periodo_tres = EstanciasConfig.first.inicio_periodo_tres
    @fin_periodo_tres = EstanciasConfig.first.fin_periodo_tres
		@entrega_documentos_periodo_tres = EstanciasConfig.first.entrega_documentos_periodo_tres
	
    #Fecha para estancias - periodo cuatro
    @inicio_periodo_cuatro = EstanciasConfig.first.inicio_periodo_cuatro
    @fin_periodo_cuatro = EstanciasConfig.first.fin_periodo_cuatro
		@entrega_documentos_periodo_cuatro = EstanciasConfig.first.entrega_documentos_periodo_cuatro

	#Fecha para estancias - periodo cinco
    @inicio_periodo_cinco = EstanciasConfig.first.inicio_periodo_cinco
    @fin_periodo_cinco = EstanciasConfig.first.fin_periodo_cinco
		@entrega_documentos_periodo_cinco = EstanciasConfig.first.entrega_documentos_periodo_cinco

	if(@fecha_opciones_inicio != nil && @fecha_opciones_fin != nil)
		@periodo_valido_opciones = (Date.today >= @fecha_opciones_inicio && Date.today <= @fecha_opciones_fin)
	else
		@periodo_valido_opciones = false
	end
	
	@periodo = current_periodo_estancias


	@alumno = Alumno.find(@usuario.alumno.id)
	documentos_estancias = EstanciasDocumento.where(:activo => true)
	@documentos = []
	for doc in documentos_estancias
		doc_alumno = EstanciasAlumnodoc.where(:alumno_id => @alumno.id, :documento_id => doc.id).first
		@documentos << {:documento => doc, :doc_alumno => doc_alumno}
	end

	documentos_estancias_inactivos = EstanciasDocumento.where(:activo => false)
	@documentos_inactivos = []
	for doc in documentos_estancias_inactivos
		doc_alumno = EstanciasAlumnodoc.where(:alumno_id => @alumno.id, :documento_id => doc.id).first
		@documentos_inactivos << {:documento => doc, :doc_alumno => doc_alumno}
	end
end

  def shows
  end

  def download
	begin
	  User.transaction do
		path = EstanciasConfig.first.estancias_docs_path
		send_file File.open(path + "#{params[:nombre_archivo]}.docx")
	  end
	rescue Exception => error
		flash[:warning] = "El archivo #{params[:nombre_archivo]} no ha sido registrado"
		redirect_to :action => :index, :tab => "formatos"
	end
	end

	def download_guia
		begin
			User.transaction do
				path = EstanciasConfig.first.estancias_docs_path
				send_file File.open(path + "#{params[:nombre_archivo]}.pdf")
			end
		rescue Exception => error
			flash[:warning] = "El archivo #{params[:nombre_archivo]} no ha sido registrado"
			redirect_to :action => :index, :tab => "formatos"
		end
	end
  
  def add_empresa
	empresa = Empresa.find(params[:id])
	opciones = OpcionEstancia.where(:alumno_id => current_user.alumno.id)

	fecha_opciones_inicio = EstanciasConfig.first.fecha_opciones_inicio
	fecha_opciones_fin = EstanciasConfig.first.fecha_opciones_fin
	periodo_valido_opciones = (Date.today >= fecha_opciones_inicio && Date.today <= fecha_opciones_fin)
	
	if periodo_valido_opciones == false
		flash[:warning] = "El periodo de registro de opciones ha terminado. No puedes agregar empresas"
		redirect_to :action => :index, :tab => "misempresas"
	else
		if opciones.size == 3
			flash[:warning] = "Ya cuentas con 3 empresas en tus opciones. No puedes agregar otra"
			redirect_to :action => :index, :tab => "misempresas"
		else
			if opciones.collect(&:empresa_id).include?(empresa.id)
				flash[:warning] = "La Empresa #{empresa.nombre} ya se encuentra en tus opciones"
				redirect_to :action => :index, :tab => "misempresas"	
			else
				OpcionEstancia.new(
					:alumno_id => current_user.alumno.id, 
					:empresa_id => empresa.id, 
					:periodo => current_periodo_estancias,
					:estatus => "REGISTRADA"
				).save	
				
				flash[:notice] = "Empresa #{empresa.nombre} ha sido registrada en tus opciones"
				redirect_to :action => :index, :tab => "misempresas"
			end
		end
	end
  end
  
  def del_empresa
	fecha_opciones_inicio = EstanciasConfig.first.fecha_opciones_inicio
	fecha_opciones_fin = EstanciasConfig.first.fecha_opciones_fin
	periodo_valido_opciones = (Date.today >= fecha_opciones_inicio && Date.today <= fecha_opciones_fin)
	
	if periodo_valido_opciones == false
		flash[:warning] = "El periodo de registro de opciones ha terminado. No puedes eliminar empresas"
		redirect_to :action => :index, :tab => "misempresas"
	else
		opcion = OpcionEstancia.find(params[:id])
		empresa_borrada = opcion.empresa.nombre
		OpcionEstancia.delete(opcion.id)
		
		flash[:notice] = "Empresa #{empresa_borrada} ha sido eliminada de tus opciones"
		redirect_to :action => :index, :tab => "misempresas"
	end
  end
  
  def send_opcion
    opcion = OpcionEstancia.find(params[:id])
	empresa = Empresa.find(opcion.empresa_id)
	
	fecha_opciones_inicio = EstanciasConfig.first.fecha_opciones_inicio
	fecha_opciones_fin = EstanciasConfig.first.fecha_opciones_fin
	periodo_valido_opciones = (Date.today >= fecha_opciones_inicio && Date.today <= fecha_opciones_fin)
	
	if opcion.estatus != "REGISTRADA"
		flash[:warning] = "No puedes enviar esta empresa. Su estatus no es REGISTRADA"
		redirect_to :action => :index, :tab => "misempresas"
	else
		if periodo_valido_opciones == false
			flash[:warning] = "El periodo de registro de opciones ha terminado. No puedes enviar empresas"
			redirect_to :action => :index, :tab => "misempresas"
		else
			opcion.update_attributes(:estatus => "ENVIADA")
			
			flash[:notice] = "Tu opción #{empresa.nombre} ha sido enviada"
			redirect_to :action => :index, :tab => "misempresas"
		end
	end
  end
  
  def select_opcion
	opcion = OpcionEstancia.find(params[:id])
	empresa = Empresa.find(opcion.empresa_id)
	
	if opcion.estatus != "APROBADA"
		flash[:warning] = "No puedes enviar esta empresa. No está APROBADA"
		redirect_to :action => :index, :tab => "misempresas"
	else
		opcion.update_attributes(:estatus => "SELECCIONADA")
			
		flash[:notice] = "Tu opción #{empresa.nombre} ha sido seleccionada como la definitiva"
		redirect_to :action => :index, :tab => "misempresas"
	end
  end


=begin
	def documentos_registrados
		@alumno = Alumno.find(@usuario.alumno.id)

		documentos_estancias = EstanciasDocumento.where(:activo => true)
		@documentos = []
		for doc in documentos_estancias
			doc_alumno = EstanciasAlumnodoc.where(:alumno_id => @alumno.id, :documento_id => doc.id).first
			@documentos << {:documento => doc, :doc_alumno => doc_alumno}
		end

		documentos_estancias_inactivos = EstanciasDocumento.where(:activo => false)
		@documentos_inactivos = []
		for doc in documentos_estancias_inactivos
			doc_alumno = EstanciasAlumnodoc.where(:alumno_id => @alumno.id, :documento_id => doc.id).first
			@documentos_inactivos << {:documento => doc, :doc_alumno => doc_alumno}
		end
	end
=end

	def alta_empresa
		OpcionEstancia.new(
			:alumno_id => current_user.alumno.id,
			:empresa_id => empresa.id,
			:periodo => current_periodo_estancias,
			:estatus => "REGISTRADA"
		).save
	end
end
