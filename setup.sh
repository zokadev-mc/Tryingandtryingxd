#!/bin/bash
# setup.sh

echo "Actualizando paquetes..."
sudo apt-get update

echo "Instalando Java 21 (requerido para las versiones recientes de Minecraft) y utilidades..."
sudo apt-get install -y openjdk-21-jre-headless wget curl jq

echo "Creando la carpeta del servidor..."
mkdir -p mc_server
cd mc_server

echo "Aceptando el EULA de Minecraft automáticamente..."
echo "eula=true" > eula.txt

echo "Descargando la última versión de PaperMC (1.21)..."
# Usamos la API de Paper para obtener siempre la build más reciente de la 1.21
VERSION="1.21.1"
BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$VERSION/builds | jq '.builds[-1].build')
wget -O server.jar "https://api.papermc.io/v2/projects/paper/versions/$VERSION/builds/$BUILD/downloads/paper-$VERSION-$BUILD.jar"

echo "Descargando el agente independiente de Playit.gg..."
wget -O playit https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64
chmod +x playit

echo "=================================================="
echo "¡Entorno preparado con éxito!"
echo "=================================================="
