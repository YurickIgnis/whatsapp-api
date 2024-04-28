#!/bin/bash

# Navegar al destino del despliegue
cd /home/portainer/aplicaciones

# Descargar la última versión del repositorio
git pull

# Ejecutar Docker Compose
docker compose up -d --build 