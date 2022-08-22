$(function() {
    
    //Reportes -> Calificaciones -> Selecciona un periodo
    $('select#examenes_inscripcion_id').on('change', function() {
        var inscripcion_id = $('select#examenes_inscripcion_id').val();
        jQuery.get("/examenes/shows", {
            inscripcion_id: inscripcion_id
        },
        function(data) {
            $("div#examenes_list").html(data);
        }
        );
    });
  });
