#! /bin/bash
# update-style-nes       update stylesheets'nes_alumnos for unsij
#
# Author: Ana Pérez <anaceci@kadasoftware.com> 
# description: Replace stylesheets'nes for each university
#
#

usage ()
{
        echo $"Uso: $0 {utm|unsij|unsis|nova|unicha|uncos|unistmo|unca}"
	exit 1
}

replace()
{
	echo -e "Iniciando el copiado de los archivos de Hoja de Estilos para la ${UNIVERSIDAD}...\n"

        cp "public/$UNIVERSIDAD/stylesheets/style_structure.css" public/stylesheets/style_structure.css
	echo 'Copiando style_structure.css'

	cp "public/$UNIVERSIDAD/stylesheets/alumnos_tabla.css" public/stylesheets/alumnos_tabla.css
	echo 'Copiando style_profesores.css'

	cp public/"$UNIVERSIDAD"/images/bg.jpg public/images/bg.jpg
	echo 'Copiando bg.jpg'

        cp public/"$UNIVERSIDAD"/images/closessesion.png public/images/closessesion.png
	echo 'Copiando closessesion.png'

        cp public/"$UNIVERSIDAD"/images/closessesion_hvr.png public/images/closessesion_hvr.png
	echo 'Copiando closessesion_hvr.png'

	echo -e '\nProceso terminado'
	exit 1
}


case "$1" in
    utm|unsij|unsis|nova|unicha|uncos|unistmo|unca) 
	UNIVERSIDAD="$1"
	replace ;;
    *) usage ;;
esac

exit 0



