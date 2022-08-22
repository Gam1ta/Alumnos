class TimeFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ /^(([0|1][0-9])|2[0-3]):([0-5][0-9])$/i
      object.errors[attribute] << (options[:mensage] || "no representa una hora válida. Formato => 'hh:mm'.")
    end
  end
end