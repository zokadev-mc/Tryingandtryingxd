#!/bin/bash

# ==========================================
# Instalador automático de PaperMC + Playit
# Entorno: GitHub Codespaces (Raíz del proyecto)
# ==========================================

echo "1. Limpiando archivos invisibles anteriores en /home..."
# Esto elimina de forma segura la carpeta vieja que no podías ver en el explorador
rm -rf "$HOME/minecraft_server"

echo "2. Actualizando repositorios e instalando dependencias (curl, jq, Java 21)..."
sudo apt-get update -y
sudo apt-get install -y curl jq openjdk-21-jre-headless

# Definir la carpeta del servidor en la raíz del proyecto (visible en el explorador)
SERVER_DIR="$(pwd)/server"
mkdir -p "$SERVER_DIR/plugins"
cd "$SERVER_DIR"

# Eliminar el archivo corrupto si existe en esta carpeta
rm -f server.jar

# Enlace directo de PaperMC
DOWNLOAD_URL="https://fill-data.papermc.io/v1/objects/1d70b1dab9cf4a6de615209a536f3a45a2186240253c428213ce2188ab95e5f7/paper-26.1.2-74.jar"

echo "3. Descargando el núcleo del servidor desde el enlace directo..."
curl -fsSL -o server.jar "$DOWNLOAD_URL"

# Verificar si el archivo se descargó correctamente
if [ ! -s server.jar ] || [ $(stat -c%s "server.jar") -lt 10000000 ]; then
    echo "ERROR: La descarga falló o el archivo server.jar está corrupto."
    exit 1
fi

echo "4. Aceptando el EULA automáticamente..."
echo "eula=true" > eula.txt

echo "5. Descargando el plugin de Playit.gg..."
PLAYIT_URL="https://github.com/playit-cloud/playit-minecraft-plugin/releases/latest/download/playit-minecraft-plugin.jar"
curl -fsSL -o plugins/playit.jar "$PLAYIT_URL"

echo "6. Creando el acceso directo 'start'..."
# Volvemos a la raíz del proyecto para crear el archivo ejecutable ahí
cd ..

# Creamos el archivo de arranque directo
cat << EOF > start
#!/bin/bash
cd "$SERVER_DIR"
java -Xms2G -Xmx4G -jar server.jar nogui
EOF

# Otorgar permisos de ejecución al comando
chmod +x start

# Configurar el alias en el sistema para poder escribir "start" a secas desde cualquier lado
if ! grep -q "alias start=" ~/.bashrc; then
    echo "alias start='$(pwd)/start'" >> ~/.bashrc
fi

echo "=========================================="
echo "¡Instalación completada con éxito!"
echo "Los archivos ahora están en la carpeta pública: $SERVER_DIR"
echo ""
echo "CRUCIAL: Para activar el comando 'start' por primera vez, ejecuta:"
echo "  source ~/.bashrc"
echo ""
echo "Después de eso, podrás iniciar el servidor simplemente escribiendo:"
echo "  start"
echo "=========================================="
