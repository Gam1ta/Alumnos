class  Debit < ActiveRecord::Base
  establish_connection :development_sec
  ACTIVO = "ALIVE"
  PAGADO = "PAID"
  ANULADO = "CANCELED"
  CONVENIO = "AGREEMENT"
  ESTADOS = {:ALIVE => "ACTIVO", :PAID => "PAGADO", :CANCELED => "CANCELADO", :AGREEMENT => "ASIGNADO A CONVENIO" }
  IMPUESTO = 1.12

  # genera la busqueda de los adeudos activos de un alumno
  def self.debits_for_student(alumno)
    debits = Debit.select("debits.description, debits.amount, debits.created_at").where(:alumno_id => alumno, :status => ACTIVO)
    debits
  end

  def self.get_human_date_and_type(month)
    date=Hash.new
    case month
      when '1'
        date[:mes]='ENERO'
        date[:tipo]='A'
      when '2'
        date[:mes]='FEBRERO'
        date[:tipo]='A'
      when '3'
        date[:mes]='MARZO'
        date[:tipo] = 'B'
      when '4'
        date[:mes]='ABRIL'
        date[:tipo] = 'B'
      when '5'
        date[:mes]='MAYO'
        date[:tipo] = 'B'
      when '6'
        date[:mes]='JUNIO'
        date[:tipo] = 'B'
      when '7'
        date[:mes]='JULIO'
        date[:tipo] = 'B'
      when '8'
        date[:mes]='AGOSTO'
        date[:tipo] = 'V'
      when '9'
        date[:mes]='SEPTIEMBRE'
        date[:tipo] = 'V'
      when '10'
        date[:mes]='OCTUBRE'
        date[:tipo] ='A'
      when '11'
        date[:mes]='NOVIEMBRE'
        date[:tipo]='A'
      when '12'
        date[:mes]='DICIEMBRE'
        date[:tipo]='A'
    end
    date
  end
end