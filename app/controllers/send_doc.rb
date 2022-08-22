
require "document.rb"

module SendDoc

protected

def send_doc(xml, xml_start_path, report, filename, output_type)

#output_type = "html"
      case output_type
      when 'html'
        extension = 'html'
        mime_type = 'application/html'
        jasper_type = 'html'


      when 'pdf'
        extension = 'pdf'
        mime_type = 'application/pdf'
        jasper_type = 'pdf'

      when 'xls'
        extension = 'xls'
        mime_type = 'application/xls'
        jasper_type = 'xls'
      end

      send_data Document.generate_report(xml, report, jasper_type, xml_start_path),
          :filename => "#{filename}.#{extension}", :type => mime_type, :disposition => 'inline'



    end

end