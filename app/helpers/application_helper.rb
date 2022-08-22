module ApplicationHelper
  
  
  #
  # Agrega directivas de archivos con código javascript en la etiqueta <tt>head</tt> del DOM de la página web
  # dinámicamente. En el Layout, existe una instrucción <tt><%= yield(:javascript) %></tt> la cual hace que
  # cargue dinámicamente los archivos .js que se necesitan en el módulo en específico.
  #
  # Modo de uso:
  # <% javascript 'edicion_extraordinarios/index' %>
  #
  # Para este ejemplo: carga el archivo con contenido javascript en la ruta /public/javascript/edicion_extraordinarios/index.js
  # En el DOM generado, mostraría la siguiente línea:
  # <script src="/javascripts/edicion_extraordinarios/index.js?1319670406" type="text/javascript"></script>
  #
  def javascript(*files)
    content_for(:javascript) { javascript_include_tag(*files) }
  end
  
  
  #
  # Convierte una fecha del tipo 2011-10-21 a "21 de Octubre de 2011". Para mostrar la fecha en alguna vista.
  #
  def convert_to_human_date(fecha)
    date = ""
    unless fecha.nil? or fecha.blank?
      f = fecha.to_s.split('-')

      f[1] = case f[1]
      when '01'
        'Enero'
      when '02'
        'Febrero'
      when '03'
        'Marzo'
      when '04'
        'Abril'
      when '05'
        'Mayo'
      when '06'
        'Junio'
      when '07'
        'Julio'
      when '08'
        'Agosto'
      when '09'
        'Septiembre'
      when '10'
        'Octubre'
      when '11'
        'Noviembre'
      when '12'
        'Diciembre'
      else
        'SIN MES'
      end

      date = (f[2] + ' de ' + f[1] + ' de ' + f[0])
    end

    date
  end
  
  def upcase_with_accents(word)
    dict = {"á" => "Á", "é" => "É", "í" => "Í", "ó" => "Ó", "ú" => "Ú" , "ñ" => "Ñ"} 
    word.blank? ? '' : word.upcase.gsub(/[#{dict.keys}]/){|match| dict[match] } #word.upcase.gsub('ó', 'Ó').gsub('í', 'Í') #word.gsub(/[áéíóú]/, 'á' => 'Á' , 'é' => 'É' , 'í' => 'Í' , 'ó' => 'Ó' , 'ú' => 'Ú' ).upcase
  end
    
  def downcase_with_accents(word)
    dict = {"Á" => "á", "É" => "é", "Í" => "í" , "Ó" => "ó", "Ú" => "ú" , "Ñ" => "ñ"}
    word.blank? ? '' :  word.downcase.gsub(/[#{dict.keys}]/){|match| dict[match] } 
  end  
  #  
  #  def capitalize_cancel_accents(word) #no toma en cuenta las primeras letras si estan acentuadas
  #    word.blank? ? '' : word.gsub(/[áéíóú]/, 'á' => 'a' , 'é' => 'e' , 'í' => 'i' , 'ó' => 'o' , 'ú' => 'u' ).upcase
  #  end  

  def capitalize_cancel_accents(words, *skip)
    dict1 = {"á" => "a", "é" => "e", "í" => "i", "ó" => "o", "ú" => "u"}
    dict2 = {"Á" => "A", "É" => "E", "Í" => "I", "Ó" => "O", "Ú" => "U"}
    skip_dict =  Hash.new
    skip.each{|s| skip_dict[s] =  s}
    dict = dict1.merge(dict2).merge(skip_dict)
    keys =  dict.keys
    res = words.gsub(/[#{keys}]/){|match| dict[match] }
    res
  end
  
  def capitalize_with_accents(word) #no toma en cuenta las primeras letras si estan acentuadas
    dict = {"Á" => "á", "É" => "é", "Í" => "í" , "Ó" => "ó", "Ú" => "ú" , "Ñ" => "ñ"}
    word.blank? ? '' :  word.capitalize.gsub(/[#{dict.keys}]/){|match| dict[match] } 
  end  
  
  def capitalize_each_word(words, tokenizer=' ')
    cad =  words.split(tokenizer).map{|w| capitalize_with_accents(w)}.join(tokenizer)
    return cad
  end
  
  def active(url, condition=false)
    ' active' if (url == params[:controller] || condition)
  end    

  
  def active(controller_name, condition=false, exclude_condition=false)
    return ' active' if ((controller_name.to_s == params[:controller] || condition) && !exclude_condition)
    return ''
  end   
end
