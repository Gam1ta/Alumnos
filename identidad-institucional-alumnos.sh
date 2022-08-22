#! /bin/bash
# identidad-institucional-alumnos       Actualiza la identidad institucional de acuerdo a la universidad
#
# Author: 
# description: Reemplaza archivos para identidad de acuerdo a cada universidad
#
#

usage ()
{
        echo $"Uso: $0 {utm|unsij|unsis|nova|unicha|uncos|unistmo|unca|umar|unpa}"
	exit 1
}

replace_aplica_todos()
{
	echo -e "Iniciando el copiado de los archivos generales de identidad para la ${UNIVERSIDAD}...\n"

	cp app/identidad_suneo/"$UNIVERSIDAD"/logotipos/logo_utm-03.jpg app/assets/images/logo_utm-03.jpg
	echo "Copiando logo_utm-03.jpg ${UNIVERSIDAD}"

	echo -e "\nProceso terminado ${UNIVERSIDAD}"
}

replace_unca()
{
	echo -e "Iniciando el copiado de los archivos específicos para la ${UNIVERSIDAD}...\n"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_documentacion_estancias.erb app/views/estancias_profesionales/_documentacion_estancias.erb
	echo "Copiando _documentacion_estancias.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_formatos.erb app/views/estancias_profesionales/_formatos.erb
	echo "Copiando _formatos.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_modelo_estancias.erb app/views/estancias_profesionales/_modelo_estancias.erb
	echo "Copiando _modelo_estancias.erb ${UNIVERSIDAD}"

	echo -e "\nProceso terminado ${UNIVERSIDAD}"
	exit 1
}

replace_uncos()
{
	echo -e "Iniciando el copiado de los archivos específicos para la ${UNIVERSIDAD}...\n"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_documentacion_estancias.erb app/views/estancias_profesionales/_documentacion_estancias.erb
	echo "Copiando _documentacion_estancias.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_formatos.erb app/views/estancias_profesionales/_formatos.erb
	echo "Copiando _formatos.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_modelo_estancias.erb app/views/estancias_profesionales/_modelo_estancias.erb
	echo "Copiando _modelo_estancias.erb ${UNIVERSIDAD}"

	echo -e "\nProceso terminado ${UNIVERSIDAD}"
	exit 1
}

replace_utm()
{
	echo -e "Iniciando el copiado de los archivos específicos para la ${UNIVERSIDAD}...\n"
	echo -e "\nProceso terminado ${UNIVERSIDAD}"
	exit 1
}

replace_unsij()
{
	echo -e "Iniciando el copiado de los archivos específicos para la ${UNIVERSIDAD}...\n"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_documentacion_estancias.erb app/views/estancias_profesionales/_documentacion_estancias.erb
	echo "Copiando _documentacion_estancias.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_formatos.erb app/views/estancias_profesionales/_formatos.erb
	echo "Copiando _formatos.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_modelo_estancias.erb app/views/estancias_profesionales/_modelo_estancias.erb
	echo "Copiando _modelo_estancias.erb ${UNIVERSIDAD}"

	echo -e "\nProceso terminado ${UNIVERSIDAD}"
	exit 1
}

replace_nova()
{
	echo -e "Iniciando el copiado de los archivos específicos para la ${UNIVERSIDAD}...\n"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_documentacion_estancias.erb app/views/estancias_profesionales/_documentacion_estancias.erb
	echo "Copiando _documentacion_estancias.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_formatos.erb app/views/estancias_profesionales/_formatos.erb
	echo "Copiando _formatos.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_modelo_estancias.erb app/views/estancias_profesionales/_modelo_estancias.erb
	echo "Copiando _modelo_estancias.erb ${UNIVERSIDAD}"

	echo -e "\nProceso terminado ${UNIVERSIDAD}"
	exit 1
}

replace_unicha()
{
	echo -e "Iniciando el copiado de los archivos específicos para la ${UNIVERSIDAD}...\n"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_documentacion_estancias.erb app/views/estancias_profesionales/_documentacion_estancias.erb
	echo "Copiando _documentacion_estancias.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_formatos.erb app/views/estancias_profesionales/_formatos.erb
	echo "Copiando _formatos.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_modelo_estancias.erb app/views/estancias_profesionales/_modelo_estancias.erb
	echo "Copiando _modelo_estancias.erb ${UNIVERSIDAD}"

	echo -e "\nProceso terminado ${UNIVERSIDAD}"
	exit 1
}

replace_unistmo()
{
	echo -e "Iniciando el copiado de los archivos específicos para la ${UNIVERSIDAD}...\n"
	echo -e "\nProceso terminado ${UNIVERSIDAD}"
	exit 1
}

replace_umar()
{
	echo -e "Iniciando el copiado de los archivos específicos para la ${UNIVERSIDAD}...\n"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_documentacion_estancias.erb app/views/estancias_profesionales/_documentacion_estancias.erb
	echo "Copiando _documentacion_estancias.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_formatos.erb app/views/estancias_profesionales/_formatos.erb
	echo "Copiando _formatos.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_modelo_estancias.erb app/views/estancias_profesionales/_modelo_estancias.erb
	echo "Copiando _modelo_estancias.erb ${UNIVERSIDAD}"

	echo -e "\nProceso terminado ${UNIVERSIDAD}"
	exit 1
}

replace_unpa()
{
	echo -e "Iniciando el copiado de los archivos específicos para la ${UNIVERSIDAD}...\n"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_documentacion_estancias.erb app/views/estancias_profesionales/_documentacion_estancias.erb
	echo "Copiando _documentacion_estancias.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_formatos.erb app/views/estancias_profesionales/_formatos.erb
	echo "Copiando _formatos.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_modelo_estancias.erb app/views/estancias_profesionales/_modelo_estancias.erb
	echo "Copiando _modelo_estancias.erb ${UNIVERSIDAD}"
	
	echo -e "\nProceso terminado ${UNIVERSIDAD}"
	exit 1
}

replace_unsis()
{
	echo -e "Iniciando el copiado de los archivos específicos para la ${UNIVERSIDAD}...\n"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_documentacion_estancias.erb app/views/estancias_profesionales/_documentacion_estancias.erb
	echo "Copiando _documentacion_estancias.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_formatos.erb app/views/estancias_profesionales/_formatos.erb
	echo "Copiando _formatos.erb ${UNIVERSIDAD}"

	cp app/identidad_suneo/"$UNIVERSIDAD"/app/views/estancias_profesionales/_modelo_estancias.erb app/views/estancias_profesionales/_modelo_estancias.erb
	echo "Copiando _modelo_estancias.erb ${UNIVERSIDAD}"

	echo -e "\nProceso terminado ${UNIVERSIDAD}"
	exit 1
}

case "$1" in
    unca|UNCA) 
	UNIVERSIDAD="${1^^}"
	replace_aplica_todos
	replace_unca ;;
    uncos|UNCOS) 
	UNIVERSIDAD="${1^^}"
	replace_aplica_todos
	replace_uncos ;;
    utm|UTM)
	UNIVERSIDAD="${1^^}"
	replace_aplica_todos
	replace_utm ;;
    unsij|UNSIJ)
	UNIVERSIDAD="${1^^}"
	replace_aplica_todos
	replace_unsij ;;
    unsis|UNSIS)
	UNIVERSIDAD="${1^^}"
	replace_aplica_todos
	replace_unsis ;;
    nova|NOVA)
	UNIVERSIDAD="${1^^}"
	replace_aplica_todos
	replace_nova ;;
    unicha|UNICHA)
	UNIVERSIDAD="${1^^}"
	replace_aplica_todos
	replace_unicha ;;
    unistmo|UNISTMO)
	UNIVERSIDAD="${1^^}"
	replace_aplica_todos
	replace_unistmo ;;
    umar|UMAR)
	UNIVERSIDAD="${1^^}"
	replace_aplica_todos
	replace_umar ;;
    unpa|UNPA)
	UNIVERSIDAD="${1^^}"
	replace_aplica_todos
	replace_unpa ;;
    *) usage ;;
esac

exit 0



