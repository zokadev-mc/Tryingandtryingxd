#!/bin/bash

# ==========================================
# Instalador automático de PaperMC + Playit
# Entorno: GitHub Codespaces
# ==========================================

echo "Actualizando repositorios e instalando dependencias (curl, jq, Java 21)..."
sudo apt-get update -y
sudo apt-get install -y curl jq openjdk-21-jre-headless

# Crear el directorio base para el servidor y los plugins
SERVER_DIR="$HOME/minecraft_server"
mkdir -p "$SERVER_DIR/plugins"
cd "$SERVER_DIR"

# Eliminar el archivo corrupto si existe de un intento anterior
echo "Limpiando instalaciones anteriores..."
rm -f server.jar

# Enlace directo proporcionado
DOWNLOAD_URL="https://fill-data.papermc.io/v1/objects/1d70b1dab9cf4a6de615209a536f3a45a2186240253c428213ce2188ab95e5f7/paper-26.1.2-74.jar"

echo "Descargando el núcleo del servidor desde el enlace directo..."
# Usamos -fsSL para manejar la descarga limpiamente
curl -fsSL -o server.jar "$DOWNLOAD_URL"

# Verificar si el archivo se descargó correctamente y tiene un tamaño razonable (mayor a 10MB)
if [ ! -s server.jar ] || [ $(stat -c%s "server.jar") -lt 10000000 ]; then
    echo "ERROR: La descarga falló o el archivo server.jar está corrupto. Verifica el enlace."
    exit 1
fi

echo "Aceptando el EULA automáticamente..."
echo "eula=true" > eula.txt

echo "Descargando el plugin de Playit.gg..."
# Descargamos el release más reciente directamente desde el repositorio oficial
PLAYIT_URL="https://github.com/playit-cloud/playit-minecraft-plugin/releases/latest/download/playit-minecraft-plugin.jar"
curl -fsSL -o plugins/playit.jar "$PLAYIT_URL"

echo "Creando script de arranque (start.sh)..."
cat << 'EOF' > start.sh
#!/bin/bash
cd ~/minecraft_server
# Puedes ajustar la memoria RAM asignada cambiando los valores 2G
java -Xms2G -Xmx4G -jar server.jar nogui
EOF

# Dar permisos de ejecución al script de arranque
chmod +x start.sh

echo "=========================================="
echo "¡Instalación completada con éxito!"
echo "Ruta del servidor: $SERVER_DIR"
echo ""
echo "Para iniciar el servidor, ejecuta:"
echo "  ~/minecraft_server/start.sh"
echo ""
echo "IMPORTANTE: La primera vez que inicies el servidor, Playit imprimirá"
echo "un enlace en la consola. Ábrelo en tu navegador para reclamar el túnel"
echo "y obtener la IP/Puerto público con el que podrás conectarte."
echo "=========================================="
