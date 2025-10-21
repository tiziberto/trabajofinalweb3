#!/bin/bash

# --- 1. CONFIGURACIÓN DE RUTAS ---
BASE_DIR="/Users/tizianobertorello/Documents/WEB3/TpFinal"
PROJECT_DIR="$BASE_DIR/iw3_2025"
INFRA_DIR="$BASE_DIR/infra_iw32025"
DEPLOY_DIR="$INFRA_DIR/tomcat/webapps"
WAR_FILE="ROOT.war"

echo "Iniciando despliegue local para el proyecto: $PROJECT_DIR"
echo "------------------------------------------------------"


# --- 2. CONSTRUCCIÓN DEL PROYECTO (Maven dentro de Docker) ---
echo "⚙️ Paso 1/3: Compilando el proyecto Java/Maven..."

cd "$PROJECT_DIR" || { echo "Error: No se puede acceder a $PROJECT_DIR. Deteniendo el script."; exit 1; }

USER_ID=$(id -u)
GROUP_ID=$(id -g)

# Directorio donde se montará el repositorio .m2 dentro del contenedor.
# Usamos un directorio simple y genérico para asegurar que el usuario tenga permisos.
# Nota: La carpeta /home/$USER dentro del contenedor es un lugar seguro.
CONTAINER_M2_DIR="/tmp/m2-repo" 

# Ejecuta Maven en un contenedor de Docker
docker run --rm \
    -u "$USER_ID:$GROUP_ID" \
    -v "$HOME/.m2:$CONTAINER_M2_DIR" \
    -v "$(pwd)":/usr/src/mymaven \
    -w /usr/src/mymaven \
    maven:3.9.11-amazoncorretto-21-debian \
    mvn clean package -Dmaven.test.skip=true -Dbuild=war -Dspring.profiles.active=cli2 -Dmaven.repo.local=$CONTAINER_M2_DIR

if [ $? -ne 0 ]; then
    echo "❌ ERROR: Falló la compilación de Maven. Revisa los errores anteriores."
    exit 1
fi

echo "✅ Compilación exitosa. Archivo $WAR_FILE creado en target/."

# ... (Resto del script)

# --- 3. COPIA DEL WAR AL DIRECTORIO DE DESPLIEGUE DE TOMCAT ---
echo "📁 Paso 2/3: Moviendo el archivo $WAR_FILE a la carpeta de despliegue..."

mkdir -p "$DEPLOY_DIR"

cp "$PROJECT_DIR/target/$WAR_FILE" "$DEPLOY_DIR/$WAR_FILE"

if [ $? -ne 0 ]; then
    echo "❌ ERROR: Falló la copia del archivo. Verifica que la ruta $DEPLOY_DIR es correcta."
    exit 1
fi

echo "✅ Archivo $WAR_FILE copiado a $DEPLOY_DIR"


# --- 4. EJECUCIÓN CON DOCKER COMPOSE ---
echo "🐳 Paso 3/3: Desplegando la infraestructura con Docker Compose..."

cd "$INFRA_DIR" || { echo "Error: No se puede acceder a $INFRA_DIR. Deteniendo el script."; exit 1; }

# CAMBIO CRUCIAL: Usamos 'down -v' para detener y eliminar contenedores, redes Y VOLÚMENES anónimos.
# Usamos 'down --remove-orphans' para eliminar servicios que ya no están definidos.
docker compose down -v --remove-orphans 
docker compose up --build -d

if [ $? -ne 0 ]; then
    echo "❌ ERROR: Falló la ejecución de Docker Compose. Revisa tu archivo docker-compose.yml."
    # Opcional: Para más detalle en el error de compose:
    # docker compose logs
    exit 1
fi

echo "------------------------------------------------------"
echo "🎉 ¡Despliegue Completo!"
echo "La aplicación debería estar disponible en http://localhost:[PUERTO_TOMCAT]."
echo "Para verificar el estado, usa 'docker compose logs backend -f' dentro de la carpeta infra_iw32025."