class AdeudosController < ApplicationController

  before_filter :require_user, :except => []
  before_filter :require_alumno, :except => []

  def index
    info_alumno
    # consulta los adeudos del alumno
    @debits = Debit.debits_for_student(@usuario.alumno)
    puts "\n\n\n\n\n"
    @debits.each do |debit|
      puts "Concepto: " + debit.description
      puts "Monto: $" + debit.amount.to_s
      fecha = debit.created_at
      fecha = fecha.to_date
      month = fecha.strftime('%m')
      month = month.to_i
      year = fecha.strftime('%Y')
      month = Debit.get_human_date_and_type(month.to_s)
      puts "Mes: " + month[:mes]
      puts "Año: " + year.to_s
    end
    puts "\n\n\n\n\n"
  end

  def shows

  end

  def info_alumno
    @usuario = current_user
    @periodo_actual = current_ciclo.ciclo
    ciclo = Ciclo.get_ciclo_at_fecha(Date.today) || current_ciclo
    @inscripciones = @usuario.alumno.inscripciones.select{|item| item.ciclo_id == ciclo.id} if ciclo.present?
    @last_inscripcion = @inscripciones.sort_by{|i| i.semestr.clave}.last
    @last_inscripcion = @usuario.alumno.inscripciones.sort_by{|i| i.semestr.clave}.last if @last_inscripcion.blank?
    @profesor =  @usuario.alumno.profesor || Profesor.new
  end

end