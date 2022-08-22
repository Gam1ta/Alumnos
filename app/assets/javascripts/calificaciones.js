$(function() {
    
    //Reportes -> Calificaciones -> Selecciona un periodo
    $('select#portal_inscripcion_id').on('change', function() {
        var inscripcion_id = $('select#portal_inscripcion_id').val();
        jQuery.get("/calificaciones/shows", {
            inscripcion_id: inscripcion_id
        },
        function(data) {
            $("div#calificaciones_div").html(data);
        }
        );
    });
  });
