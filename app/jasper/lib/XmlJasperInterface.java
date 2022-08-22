/*
 * An XML Jasper interface; Takes XML data from the standard input
 * and uses JRXmlDataSource to generate Jasper reports in the
 * specified output format using the specified compiled Jasper design.
 * 
 * Inspired by the xmldatasource sample application provided with
 * jasperreports-1.1.0
 */
//exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, request.getContextPath()+"/Informes/images/");
//javac XmlJasperInterface.java -cp jasperreports-2.0.2.jar -target 1.5


import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.view.JRViewer;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.export.JRPdfExporterParameter;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRXmlDataSource;
import net.sf.jasperreports.engine.export.JRCsvExporter;
import net.sf.jasperreports.engine.export.JRRtfExporter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.engine.JasperPrintManager;
import net.sf.jasperreports.engine.export.JExcelApiExporterParameter;
import net.sf.jasperreports.engine.export.JRHtmlExporterParameter;
import net.sf.jasperreports.engine.export.JRHtmlExporter;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.JasperCompileManager;






class XmlJasperInterface {
  private static final String TYPE_PDF = "pdf";
  private static final String TYPE_XML = "xml";
  private static final String TYPE_RTF = "rtf";
  private static final String TYPE_XLS = "xls";
  private static final String TYPE_CSV = "csv";
  private static final String TYPE_HTML= "html";
  
  private String outputType;
  private String compiledDesign;
  private String selectCriteria;  

  public static void main(String[] args) {
    String outputType = null;
    String compiledDesign = null;
    String selectCriteria = null;        

	

    if (args.length != 3) {
      printUsage();
      return;
    }

    for (int k = 0; k < args.length; ++k) {
      if (args[k].startsWith("-o"))
        outputType = args[k].substring(2);
      else if (args[k].startsWith("-f"))
        compiledDesign = args[k].substring(2);
      else if (args[k].startsWith("-x"))
        selectCriteria = args[k].substring(2);
    }
    
    XmlJasperInterface jasperInterface = new XmlJasperInterface(outputType, compiledDesign, selectCriteria);
    if (!jasperInterface.report()) {
      System.exit(1);
    }
  }
  
  public XmlJasperInterface(
      String outputType,
      String compiledDesign,
      String selectCriteria) {
    this.outputType = outputType;
    this.compiledDesign = compiledDesign;
    this.selectCriteria = selectCriteria;
  }
  


  public boolean report() {
    try {
      JasperPrint jasperPrint = JasperFillManager.fillReport(compiledDesign, null, new JRXmlDataSource(System.in, selectCriteria));	
      
      if (TYPE_PDF.equals(outputType)) {		


JRPdfExporter pdfExporter = new JRPdfExporter();
 
pdfExporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
 
pdfExporter.setParameter(JRExporterParameter.OUTPUT_STREAM, System.out);
pdfExporter.setParameter(JRExporterParameter.CHARACTER_ENCODING, "ISO-8859-9");
pdfExporter.setParameter(JRPdfExporterParameter.CHARACTER_ENCODING, "ISO-8859-9");
pdfExporter.setParameter(JRPdfExporterParameter.IS_COMPRESSED,Boolean.FALSE);
pdfExporter.setParameter(JRPdfExporterParameter.FORCE_SVG_SHAPES,Boolean.TRUE);


 
 pdfExporter.exportReport(); 
 



//       	  JasperExportManager.exportReportToPdfStream(jasperPrint, System.out);

      }
      else if (TYPE_XML.equals(outputType)) {
        JasperExportManager.exportReportToXmlStream(jasperPrint, System.out);
		System.out.println("Entra 2");
      }
      else if (TYPE_RTF.equals(outputType)) {
        JRRtfExporter rtfExporter = new JRRtfExporter();
        rtfExporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        rtfExporter.setParameter(JRExporterParameter.OUTPUT_STREAM, System.out);
        rtfExporter.exportReport();
	System.out.println("Entra 3");
      }
      else if (TYPE_XLS.equals(outputType)) {
        JRXlsExporter xlsExporter = new JRXlsExporter();
   
        xlsExporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        xlsExporter.setParameter(JRExporterParameter.OUTPUT_STREAM, System.out);    
	xlsExporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND,Boolean.FALSE);
	xlsExporter.setParameter(JRXlsExporterParameter.OFFSET_X, 0);
   	
	xlsExporter.setParameter(JExcelApiExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS,  Boolean.TRUE);
	xlsExporter.setParameter(JExcelApiExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_COLUMNS,  Boolean.TRUE);
        xlsExporter.setParameter(JExcelApiExporterParameter.IS_DETECT_CELL_TYPE,  Boolean.TRUE);
        xlsExporter.setParameter(JExcelApiExporterParameter.IS_ONE_PAGE_PER_SHEET,  Boolean.FALSE);
        xlsExporter.setParameter(JRXlsExporterParameter.IGNORE_PAGE_MARGINS,Boolean.TRUE);
	xlsExporter.setParameter(JRXlsExporterParameter.IS_IGNORE_CELL_BORDER, Boolean.FALSE);
	xlsExporter.setParameter(JRExporterParameter.CHARACTER_ENCODING, "UTF-8"); 


        xlsExporter.exportReport();	
      }
      else if (TYPE_CSV.equals(outputType)) {
        JRCsvExporter csvExporter = new JRCsvExporter();
        csvExporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        csvExporter.setParameter(JRExporterParameter.OUTPUT_STREAM, System.out);
        csvExporter.exportReport();
	System.out.println("Entra 5");
      } else if (TYPE_HTML.equals(outputType)) {
	    JRHtmlExporter htmlExporter = new JRHtmlExporter();
		htmlExporter.setParameter(JRHtmlExporterParameter.HTML_HEADER, 
		"<html><head><title></title></head> <SCRIPT LANGUAGE=\"JavaScript\"> "+
		"  function imprimir(){  "+
		//"  netscape.security.PrivilegeManager.enablePrivilege('UniversalBrowserWrite');"+		
		//"  netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');"+		
		//"  var pref = Components.classes[\"@mozilla.org/preferences-service;1\"].getService(Components.interfaces.nsIPrefBranch);"+
		//"  pref.setBoolPref(\"print.always_print_silent\", true);"+
		"  window.print();  this.close();  }"+		
		"  </SCRIPT> <body onLoad=\"imprimir();\">");

		htmlExporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		htmlExporter.setParameter(JRExporterParameter.OUTPUT_STREAM, System.out);
		htmlExporter.setParameter(JRHtmlExporterParameter.IS_USING_IMAGES_TO_ALIGN, false);	
		htmlExporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "");
		htmlExporter.setParameter(JRHtmlExporterParameter.CHARACTER_ENCODING, "ISO-8859-9");

		
		htmlExporter.exportReport();	    
	  }else {
	System.out.println("Entra 6");
        printUsage();
      }
    } catch (JRException e) {
      e.printStackTrace();
      return false;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
    return true;
  }
  
  private static void printUsage() {
    System.out.println("XmlJasperInterface usage by Said:");
    System.out.println("\tjava XmlJasperInterface -oOutputType -fCompiledDesign -xSelectExpression < input.xml > report\n");
    System.out.println("\tOutput types:\t\tpdf | xml | rtf | xls | csv");
    System.out.println("\tCompiled design:\tFilename of the compiled Jasper design");
    System.out.println("\tSelect expression:\tXPath expression that specifies the select criteria");
    System.out.println("\t\t\t\t(See net.sf.jasperreports.engine.data.JRXmlDataSource for further information)");
    System.out.println("\tStandard input:\t\tXML input data");
    System.out.println("\tStandard output:\tReport generated by Jasper");
  }
}
