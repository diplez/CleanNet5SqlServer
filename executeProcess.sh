#!/bin/bash

# Establece fecha de inicio de ejecicion
echo "`date +"%d/%m/%Y"` `date +"%H:%M:%S"` ### Inicia ejecución de scritp para levantar proyecto"

echo "`date +"%d/%m/%Y"` `date +"%H:%M:%S"` ### Cambia permisos de ejecucion en archivos sh"
# Este proceso debe ejecutarse al descargar por primera vez sobre el archivo del proyecto.
chmod +x executeProcess.sh 

LABEL=contarz.tempData=builder
echo "`date +"%d/%m/%Y"` `date +"%H:%M:%S"` Se inicia creacion de imagen docker"
docker pull diplez/net6contarz:latest

echo "`date +"%d/%m/%Y"` `date +"%H:%M:%S"` Al generar imagen docker, perciste imagen anterior, se procede a eliminar imagen type none"
docker image prune --filter label=$LABEL -f

echo "`date +"%d/%m/%Y"` `date +"%H:%M:%S"` : Actualizamos contenedores"
cd /opt/genus/genusV2/Genus.Infrastructure
docker-compose -f docker-compose.infrastructure.yml up -d --force-recreate genusacademicogradeapi