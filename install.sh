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

echo "Consultando la API de PaperMC para obtener la última versión..."
# Extraer la última versión de Minecraft soportada por Paper
PAPER_VERSION=$(curl -s https://api.papermc.io/v2/projects/paper | jq -r '.versions[-1]')
echo "Versión de Minecraft encontrada: $PAPER_VERSION"

# Extraer el último build de esa versión específica
BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION} | jq -r '.builds[-1]')
echo "Último build de PaperMC: $BUILD"

# Construir la URL de descarga dinámica
JAR_NAME="paper-${PAPER_VERSION}-${BUILD}.jar"
DOWNLOAD_URL="https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds/${BUILD}/downloads/${JAR_NAME}"

echo "Descargando el núcleo del servidor ($JAR_NAME)..."
curl -s -o server.jar "$DOWNLOAD_URL"

echo "Aceptando el EULA automáticamente..."
echo "eula=true" > eula.txt

echo "Descargando el plugin de Playit.gg..."
# Descargamos el release más reciente directamente desde el repositorio oficial
PLAYIT_URL="https://github.com/playit-cloud/playit-minecraft-plugin/releases/latest/download/playit-minecraft-plugin.jar"
curl -s -L -o plugins/playit.jar "$PLAYIT_URL"

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
