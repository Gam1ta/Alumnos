// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require bootstrap
//= require_tree .




// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

   function remove_fields(link) {
     $(link).prev("input[type=hidden]").val("1");
     $(link).closest(".fields").hide();
   }

   function add_fields(link, association, content) {
     var new_id = new Date().getTime();
     var regexp = new RegExp("new_" + association, "g");
     var contenido = content;
     contenido = contenido.replace(new RegExp("&lt;","g"),"<");
     contenido = contenido.replace(new RegExp("&quot;","g"),"\"");
     contenido = contenido.replace(new RegExp("&gt;","g"),">");
     //contenido = contenido.replace(new RegExp("type=\"hidden\" />","g"),"type=\"hidden\" value=\""+$("#listbox_id").val() + "\" />" );
     //contenido = contenido.replace(new RegExp("type=\"text\" />","g"),"type=\"text\" value=\"" + $("#listbox_id option:selected").text() + "\" />" );
     contenido = contenido.replace(regexp, new_id)
     alert(contenido);
     $(link).parent().before(contenido);
   }
  
jQuery(function($) {
  // when the #carrera field changes
  $("select#calificacion_carrera_id").on('change', function() {
    var donde_estoy = $('div#carrera_select')[0].title;

    $("select#calificacion_semestre_id option[value='']").attr("selected", true);
    $("select#calificacion_grupo_id option[value='']").attr("selected", true)
    $("select#calificacion_curso_id option[value='']").attr("selected", true)
    $("div#alumno_list").css("display", "none");

    if(donde_estoy == "index")
      $("select#calificacion_ciclo_id option[value='']").attr("selected", true);
  });

  // when the #semestre field changes
  $("select#calificacion_semestre_id").on('change', function() {
    // make a POST call and replace the content
    var carrera = $('select#calificacion_carrera_id :selected').val();
    var semestre = $('select#calificacion_semestre_id :selected').val();
    var donde_estoy = $('div#carrera_select')[0].title;
    var ciclo = 0;

    if(carrera == ""){
      alert("Seleccione la carrera.");
      $("select#calificacion_semestre_id option[value='']").attr("selected", true);
      return;
    }

    $("select#calificacion_grupo_id option[value='']").attr("selected", true);
    $("select#calificacion_curso_id option[value='']").attr("selected", true);
    $("div#alumno_list").css("display", "none");

    if(donde_estoy == "new"){
      if(carrera != "" && semestre != ""){
        $("div#alumno_list").css("display", "none");
        jQuery.get('/calificaciones/update_grupos_select/' + carrera + '/' + semestre + '/' + ciclo, function(data){
          $("#grupo_select").html(data);
        })
      }
    }
    
    if(donde_estoy == "index"){
      $("select#calificacion_ciclo_id option[value='']").attr("selected", true);
    }
  });

  // when the #inscripcion_grupo field changes
  $("select#calificacion_grupo_id").on('change', function() {
    var carrera = $('select#calificacion_carrera_id :selected').val();
    var semestre = $('select#calificacion_semestre_id :selected').val();
    var grupo = $('select#calificacion_grupo_id :selected').val();
    var donde_estoy = $('div#carrera_select')[0].title;
    var ciclo = $('select#calificacion_ciclo_id :selected').val();
    var mensaje = "";

    $("select#calificacion_curso_id option[value='']").attr("selected", true)
    $("div#alumno_list").css("display", "none");

    if(carrera == "")
      mensaje = "Seleccione la carrera.\n";
    if(semestre == "")
      mensaje = mensaje + "Seleccione el semestre.\n";
    if(grupo == "")
      mensaje = mensaje + "Seleccione el grupo.\n"

    if(donde_estoy == "index"){
      if(ciclo == "")
        mensaje = mensaje + "Seleccione el ciclo.\n"
      if(carrera == "" || semestre == "" || ciclo == "" || grupo == ""){
        alert(mensaje);
        $("select#calificacion_grupo_id option[value='']").attr("selected", true)
        return;
      }
      if(carrera != "" && semestre != "" && ciclo != "" && grupo != ""){
        jQuery.get('/calificaciones/update_cursos_select/' + grupo + '/' + ciclo, function(data){
          $("div#curso_select").html(data);
        })
      }
    }

    if(donde_estoy == "new"){
      ciclo = 0;

      if(carrera == "" || semestre == "" || grupo == ""){
        alert(mensaje);
        $("select#calificacion_grupo_id option[value='']").attr("selected", true)
        return;
      }
      if(carrera != "" && semestre != "" && grupo != ""){
        jQuery.get('/calificaciones/update_cursos_select/' + grupo + '/' + ciclo, function(data){
          $("div#curso_select").html(data);
        })
      }
    }
  });

  // when the #inscripcion_curso field changes
  $("select#calificacion_curso_id").on('change', function() {
    var carrera = $('select#calificacion_carrera_id :selected').val();
    var semestre = $('select#calificacion_semestre_id :selected').val();
    var grupo = $('select#calificacion_grupo_id :selected').val();
    var ciclo = 0;
    var curso = $('select#calificacion_curso_id :selected').val();
    var donde_estoy = $('div#carrera_select')[0].title;
    var tipo_de_vista = 1;
    var mensaje = ""

    if(donde_estoy == "new"){
      tipo_de_vista = 0;
    }
    if(donde_estoy == "index"){
      tipo_de_vista = 1;
      ciclo = $('select#calificacion_ciclo_id :selected').val();
      if(ciclo == "")
        mensaje = mensaje + "Seleccione el ciclo.\n";
    }

    if(carrera == "")
      mensaje = mensaje + "Seleccione la carrera.\n";
    if(semestre == "")
      mensaje = mensaje + "Seleccione el semestre.\n";
    if(grupo == ""){
      mensaje = mensaje + "Seleccione el grupo.\n";
    }
    if(carrera == "" || semestre == "" || grupo == ""){
      alert(mensaje);
      $("select#calificacion_curso_id option[value='']").attr("selected", true)
    }
    //if(curso == ""){
      $("div#alumno_list").css("display", "none");
    //}
    if(carrera != "" && semestre != "" && grupo != "" && curso != ""){
      jQuery.get('/calificaciones/update_alumnos_list/' + carrera + '/' + semestre + '/' + grupo + '/' + curso + '/' + ciclo + '/' + tipo_de_vista, function(data){
        $("div#alumno_list").css("display", "block");
        $("div#alumno_list").html(data);
      })
    }
  });

  $("#calificacion_ciclo_id").on('change', function() {
    // make a POST call and replace the content
    var carrera = $('select#calificacion_carrera_id :selected').val();
    var semestre = $('select#calificacion_semestre_id :selected').val();
    var ciclo = $('select#calificacion_ciclo_id :selected').val();
    var mensaje = ""

    if(carrera == "")
      mensaje = "Seleccione la carrera.\n";
    if(semestre == "")
      mensaje = mensaje + "Seleccione el semestre.\n";
    if(ciclo == "")
      mensaje = mensaje + "Seleccione el ciclo.\n"

    $("select#calificacion_grupo_id option[value='']").attr("selected", true);
    $("select#calificacion_curso_id option[value='']").attr("selected", true);
    $("div#alumno_list").css("display", "none");

    if(carrera == "" || semestre == "" || ciclo == ""){
      alert(mensaje);
      $("select#calificacion_ciclo_id option[value='']").attr("selected", true);
    }
    if(carrera != "" && semestre != "" && ciclo != "")
      jQuery.get('/calificaciones/update_grupos_select/' + carrera + '/' + semestre + '/' + ciclo, function(data){
        $("div#grupo_select").html(data);
      })
  });

  //Busca el nombre del profesor através del curso
  $('select#seleccionar_curso').on('change', function(){
    var curso = $('select#seleccionar_curso').val();

    if(curso == "")
      curso = -1
    jQuery.get('/calificaciones/update_nombre_del_profesor/' + curso, function(data){
      $('div#nombre_del_profesor').html(data);
    });
  });

  //Se activa al dar enter en la búsqueda de calificaciones por alumno
  /*
  $('input#alumno_matricula').on('keypress', function(e) {
    if(e.keyCode == 13) {
      $("div#div_calificaciones_por_alumno").css("display", "none");
      var matricula;
      var alumno_seleccionado = $('input#alumno_matricula').val();
      alumno_seleccionado = alumno_seleccionado.toString();
      matricula = alumno_seleccionado.split(' ', 3)[0];
      jQuery.get('/calificaciones/buscar_calificaciones_por_matricula/' + matricula, function(data){
        $("div#div_calificaciones_por_alumno").css("display", "block");
        $("div#div_calificaciones_por_alumno").html(data);
      })
    }
  });
  */

  /*
   * INICIO: código javascript-JQuery para manejar los eventos 'change' de los selects para el módulo de
   * calificaciones extraordinarias y especial
   **/

  // Limpia todos los select al cambiar de carrera:
  $('select#extra_carrera').on('change', function() {
    var carrera = $('select#extra_carrera').val();

    if(carrera == "")
      alert("Seleccione la carrera.\n");
    $("select#extra_semestre option[value='']").attr("selected", true);
    $("select#extra_ciclo option[value='']").attr("selected", true);
    $("select#extra_grupo option[value='']").attr("selected", true);
    $("select#extra_curso option[value='']").attr("selected", true);
    $('input#extra_fecha_de_captura').val("");
    $("select#extra_tipo_de_calificacion option[value='']").attr("selected", true);
    $("div#extra_alumno_div").css("display", "none");
  });

  $('select#extra_semestre').on('change', function(){
    var carrera = $('select#extra_carrera :selected').val();
    var semestre = $('select#extra_semestre :selected').val();
    var mensaje = "";

    if(carrera == "")
      mensaje = "Seleccione la carrera.\n";
    if(semestre == "")
      mensaje = "Seleccione el semestre.\n";
    if(carrera == "" || semestre == ""){
      alert(mensaje);
      $("select#extra_semestre option[value='']").attr("selected", true);
    }
    $("select#extra_ciclo option[value='']").attr("selected", true);
    $("select#extra_grupo option[value='']").attr("selected", true);
    $("select#extra_curso option[value='']").attr("selected", true);
    $('input#extra_fecha_de_captura').val("");
    $("select#extra_tipo_de_calificacion option[value='']").attr("selected", true);
    $("div#extra_alumno_div").css("display", "none");
  });

  $('select#extra_ciclo').on('change', function(){
    var carrera = $('select#extra_carrera :selected').val();
    var semestre = $('select#extra_semestre :selected').val();
    var ciclo = $('select#extra_ciclo :selected').val();
    var mensaje = "";
    
    if(carrera == "")
      mensaje = "Seleccione la carrera.\n";
    if(semestre == "")
      mensaje = mensaje + "Seleccione el semestre.\n";
    if(ciclo == "")
      mensaje = mensaje + "Seleccione el ciclo.\n";
    if(carrera == "" || semestre == "" || ciclo == ""){
      alert(mensaje);
      $("select#extra_ciclo option[value='']").attr("selected", true);
    }
    $("select#extra_grupo option[value='']").attr("selected", true);
    $("select#extra_curso option[value='']").attr("selected", true);
    $('input#extra_fecha_de_captura').val("");
    $("select#extra_tipo_de_calificacion option[value='']").attr("selected", true);
    $("div#extra_alumno_div").css("display", "none");

    if(carrera != "" && semestre != "" && ciclo != ""){
      jQuery.get('/extraordinarios/lista_de_grupos/' + carrera + '/' + semestre + '/' + ciclo, function(data){
        $("div#extra_grupo_div").html(data);
      })
    }
  });

  $('select#extra_grupo').on('change', function(){
    var carrera = $('select#extra_carrera :selected').val();
    var semestre = $('select#extra_semestre :selected').val();
    var ciclo = $('select#extra_ciclo :selected').val();
    var grupo = $('select#extra_grupo :selected').val();
    var mensaje = "";

    if(carrera == "")
      mensaje = "Seleccione la carrera.\n";
    if(semestre == "")
      mensaje = mensaje + "Seleccione el semestre.\n";
    if(ciclo == "")
      mensaje = mensaje + "Seleccione el ciclo.\n";
    if(grupo == "")
      mensaje = mensaje + "Seleccione el grupo.\n";
    if(carrera == "" || semestre == "" || ciclo == "" || grupo == ""){
      alert(mensaje);
      $("select#extra_grupo option[value='']").attr("selected", true);
    }
    $("select#extra_curso option[value='']").attr("selected", true);
    $('input#extra_fecha_de_captura').val("");
    $("select#extra_tipo_de_calificacion option[value='']").attr("selected", true);
    $('div#extra_alumno_div').css("display", "none");

    if(carrera != "" && semestre != "" && ciclo != "" && grupo != ""){
      jQuery.get('/extraordinarios/lista_de_cursos/' + carrera + '/' + semestre + '/' + ciclo + '/' + grupo, function(data){
        $("div#extra_curso_div").html(data);
      })
    }
  });

  $('select#extra_curso').on('change', function(){
    var carrera = $('select#extra_carrera :selected').val();
    var semestre = $('select#extra_semestre :selected').val();
    var ciclo = $('select#extra_ciclo :selected').val();
    var grupo = $('select#extra_grupo :selected').val();
    var curso = $('select#extra_curso :selected').val();
    var mensaje = "";

    if(carrera == "")
      mensaje = "Seleccione la carrera.\n";
    if(semestre == "")
      mensaje = mensaje + "Seleccione el semestre.\n";
    if(ciclo == "")
      mensaje = mensaje + "Seleccione el ciclo.\n";
    if(grupo == "")
      mensaje = mensaje + "Seleccione el grupo.\n";
    if(curso == "")
      mensaje = mensaje + "Seleccione el curso.\n";
    if(carrera == "" || semestre == "" || ciclo == "" || grupo == "" || curso == ""){
      alert(mensaje);
      $("select#extra_curso option[value='']").attr("selected", true);
    }
    $("select#extra_tipo_de_calificacion option[value='']").attr("selected", true);
    $('div#extra_alumno_div').css("display", "none");
  });

  $('select#extra_tipo_de_calificacion').on('change', function(){
    var carrera = $('select#extra_carrera :selected').val();
    var semestre = $('select#extra_semestre :selected').val();
    var ciclo = $('select#extra_ciclo :selected').val();
    var grupo = $('select#extra_grupo :selected').val();
    var curso = $('select#extra_curso :selected').val();
    var fecha = $('input#extra_fecha_de_captura').val();
    var tipo_examen = $('select#extra_tipo_de_calificacion').val();
    var mensaje = "";

    $('div#extra_alumno_div').css("display", "none");

    if(carrera == "")
      mensaje = "Seleccione la carrera.\n";
    if(semestre == "")
      mensaje = mensaje + "Seleccione el semestre.\n";
    if(ciclo == "")
      mensaje = mensaje + "Seleccione el ciclo.\n";
    if(grupo == "")
      mensaje = mensaje + "Seleccione el grupo.\n";
    if(curso == "")
      mensaje = mensaje + "Seleccione el curso.\n";
    if(fecha == "")
      mensaje = mensaje + "Seleccione la fecha de captura.\n";
    if(tipo_examen == "")
      mensaje = mensaje + "Seleccione el tipo de examen.\n";
    if(carrera == "" || semestre == "" || ciclo == "" || grupo == "" || curso == "" || fecha == "" || tipo_examen == ""){
      $("select#extra_tipo_de_calificacion option[value='']").attr("selected", true);
      alert(mensaje);
    }
    
    if(carrera != "" && semestre != "" && ciclo != "" && grupo != "" && curso != "" && fecha != "" && tipo_examen != ""){
      jQuery.get('/extraordinarios/lista_de_alumnos/' + carrera + '/' + semestre + '/' + ciclo + '/' + grupo + '/' + curso + '/' + tipo_examen, function(data){
        $("div#extra_alumno_div").html(data);
        $('div#extra_alumno_div').css("display", "block");
      })
    }
  });
  /*
   * FIN: código javascript-JQuery para el manejo de las calificaciones extraordinarias y especial
   **/

  /*
   * INICIO: Código javascript-JQuery para el módulo de profesores, se muestra un select con los campus que existan
   * en la base de datos, dependiendo de que seleccionen, verán los profesores de diferentes campus.
   */

  $('select#profesor_campus_id').on('change', function() {
    var campus = $('select#profesor_campus_id').val();

    if(campus == ''){
      $("div#profesor_lista_div").css("display", "none");
      alert('Seleccione un campus.');
    }
    else
      jQuery.get('/profesores/update_profesores_list/' + campus, function(data){
        $("div#profesor_lista_div").html(data);
        $("div#profesor_lista_div").css("display", "block");
      })
  });

  /*
   * FIN: Código javascript-JQuery para el módulo de profesores, se muestra un select con los campus que existan
   * en la base de datos, dependiendo de que seleccionen, verán los profesores de diferentes campus.
   */

  /*
   * INICIO: código javascript-JQuery para manejar los eventos 'change' de los selects para el módulo de
   * examenes (consulta del calendario de examenes)
   **/

  // 1.- Cuando cambia el select de carreras.
  $("select#examen_carrera_index").on("change", function(){
    $("select#examen_semestre_index option[value='']").attr("selected", true);
    $("select#examen_periodo_index option[value='']").attr("selected", true);
    $("select#examen_grupo_index option[value='']").attr("selected", true);
    $("select#examen_curso_index option[value='']").attr("selected", true);

    $("div#examen_calendario_de_examenes_index_div").css("display", "none");
  });

  // 2.- Cuando cambia el select de semestres.
  $("select#examen_semestre_index").on("change", function(){
    var carrera = $('select#examen_carrera_index :selected').val();
    var semestre = $('select#examen_semestre_index :selected').val();
    var mensaje = '';

    $("select#examen_periodo_index option[value='']").attr("selected", true);
    $("select#examen_grupo_index option[value='']").attr("selected", true);
    $("select#examen_curso_index option[value='']").attr("selected", true);
    $("div#examen_calendario_de_examenes_index_div").css("display", "none");

    if(carrera == "")
      mensaje = "Seleccione la carrera.\n";
    if(semestre == "")
      mensaje = mensaje + "Seleccione el semestre.\n";

    if(carrera == "" || semestre == "") {
      alert(mensaje);
      $("select#examen_semestre_index option[value='']").attr("selected", true);
    }
/*    else{
      jQuery.get('/examenes/update_grupo_select_index', {carrera_id: carrera, semestre_id: semestre}, function(data){
        $("div#examen_grupo_select_index_div").html(data);
      });
    }*/
  });

  $("select#examen_periodo_index").on("change", function(){
    var carrera = $('select#examen_carrera_index :selected').val();
    var semestre = $('select#examen_semestre_index :selected').val();
    var ciclo = $('select#examen_periodo_index :selected').val();
    var mensaje = '';

    $("select#examen_grupo_index option[value='']").attr("selected", true);
    $("select#examen_curso_index option[value='']").attr("selected", true);
    $("div#examen_calendario_de_examenes_index_div").css("display", "none");

    if(carrera == "")
      mensaje = "Seleccione la carrera.\n";
    if(semestre == "")
      mensaje = mensaje + "Seleccione el semestre.\n";
    if(ciclo == "")
      mensaje = mensaje + "Seleccione el periodo.\n"

    if(carrera == "" || semestre == "" || ciclo == "") {
      alert(mensaje);
      $("select#examen_periodo_index option[value='']").attr("selected", true);
    }
    else{
      jQuery.get('/examenes/update_grupo_select_index', {carrera_id: carrera, semestre_id: semestre, ciclo_id: ciclo}, function(data){
        $("div#examen_grupo_select_index_div").html(data);
      });
    }
  });

  // 4.- Cuando cambia el select de grupos.
  $("select#examen_grupo_index").on('change', function() {
    var carrera = $('select#examen_carrera_index :selected').val();
    var semestre = $('select#examen_semestre_index :selected').val();
    var ciclo = $('select#examen_periodo_index :selected').val();
    var grupo = $('select#examen_grupo_index :selected').val();
    var mensaje = "";

    $("select#examen_curso_index option[value='']").attr("selected", true);
    $("div#examen_calendario_de_examenes_index_div").css("display", "none");

    if(carrera == "")
      mensaje = "Seleccione la carrera.\n";
    if(semestre == "")
      mensaje = mensaje + "Seleccione el semestre.\n";
    if(ciclo == "")
      mensaje = mensaje + "Seleccione el periodo.\n";
    if(grupo == "")
      mensaje = mensaje + "Seleccione el grupo.\n";

    if(carrera == "" || semestre == "" || ciclo == "" || grupo == ""){
      alert(mensaje);
      $("select#examen_grupo_index option[value='']").attr("selected", true)
    }
    else{
      jQuery.get('/examenes/update_curso_select_index', {carrera_id: carrera, semestre_id: semestre, ciclo_id: ciclo, grupo_id: grupo}, function(data){
        $("div#examen_curso_select_index_div").html(data);
      });
    }
  });

  // 5.- Cuando cambia el select de cursos.
  $("select#examen_curso_index").on('change', function() {
    var carrera = $('select#examen_carrera_index :selected').val();
    var semestre = $('select#examen_semestre_index :selected').val();
    var ciclo = $('select#examen_periodo_index :selected').val();
    var grupo = $('select#examen_grupo_index :selected').val();
    var curso = $('select#examen_curso_index :selected').val();
    var mensaje = ""

    $("div#examen_calendario_de_examenes_index_div").css("display", "none");

    if(carrera == "")
      mensaje = mensaje + "Seleccione la carrera.\n";
    if(semestre == "")
      mensaje = mensaje + "Seleccione el semestre.\n";
    if(ciclo == "")
      mensaje = mensaje + "Seleccione el periodo.\n";
    if(grupo == "")
      mensaje = mensaje + "Seleccione el grupo.\n";
    if(curso == "")
      mensaje = mensaje + "Seleccione el curso.\n";

    if(carrera == "" || semestre == "" || ciclo == "" || grupo == "" || curso == ""){
      alert(mensaje);
      $("select#examen_curso_index option[value='']").attr("selected", true)
    }
    else{
      jQuery.get('/examenes/update_calendario_de_examenes_index', {carrera_id: carrera, semestre_id: semestre, ciclo_id: ciclo, grupo_id: grupo, curso_id: curso}, function(data){
        $("div#examen_calendario_de_examenes_index_div").css("display", "block");
        $("div#examen_calendario_de_examenes_index_div").html(data);
      });
    }
  });

  /*
   * FIN: código javascript-JQuery para manejar los eventos 'change' de los selects para el módulo de
   * examenes (consulta del calendario de examenes)
   **/
})

  /*
   *Se agrega código en javascript para el módulo de alumnos
   */

//  function remove_fields(link) {
//     $(link).previous("input[type=hidden]").value = "1";
//     alert("remove_fields");
//     $(link).up(".fields").hide();
//  }
//
//  function add_fields(link, association, content) {
//   alert("add_fields");
//   var new_id = new Date().getTime();
//   var regexp = new RegExp("new_" + association, "g");
//   $(link).up().insert({
//     before: content.replace(regexp, new_id)
//   });
//  }
