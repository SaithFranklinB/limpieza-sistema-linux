#!/bin/bash

# ==============================================================================
# Script de Limpieza y Mantenimiento de Sistema
# Uso: sudo ./limpieza_sistema.sh
# ==============================================================================

# Unir variables de control y trazabilidad
LOG_FILE="/var/log/mantenimiento_limpieza.log"
DIAS_RETENCION_TMP=7
FECHA=$(date '+%Y-%m-%d %H:%M:%S')

# Función para registrar logs en consola y archivo
log() {
    local NIVEL="$1"
    local MENSAJE="$2"
    echo "[$FECHA] [$NIVEL] $MENSAJE" | tee -a "$LOG_FILE"
}

# 1. Validar ejecución como superusuario (root)
if [ "$EUID" -ne 0 ]; then
    echo "Error: Este script debe ejecutarse con privilegios de root (sudo)."
    exit 1
fi

log "INFO" "=== Iniciando mantenimiento del sistema ==="

# 2. Medir espacio en disco antes de la limpieza
ESPACIO_ANTES=$(df -h / | awk 'NR==2 {print $4}')
log "INFO" "Espacio libre en raíz (/): $ESPACIO_ANTES"

# 3. Limpieza de paquetes y cachés según la distribución
log "INFO" "Limpiando archivos temporales del gestor de paquetes..."

if command -v dnf &> /dev/null; then
    dnf clean all &> /dev/null
    dnf autoremove -y &> /dev/null
    log "INFO" "Caché y paquetes obsoletos de DNF eliminados."
elif command -v apt-get &> /dev/null; then
    apt-get clean &> /dev/null
    apt-get autoremove -y &> /dev/null
    log "INFO" "Caché y paquetes obsoletos de APT eliminados."
elif command -v zypper &> /dev/null; then
    zypper clean -a &> /dev/null
    log "INFO" "Caché de Zypper eliminada."
fi

# 4. Limpieza de archivos temporales antiguos en /tmp
log "INFO" "Eliminando archivos en /tmp con más de $DIAS_RETENCION_TMP días de inactividad..."
find /tmp -type f -atime +$DIAS_RETENCION_TMP -delete 2>/dev/null
log "INFO" "Archivos antiguos en /tmp procesados."

# 5. Rotación / Limpieza de logs comprimidos viejos (.gz, .1, etc.)
log "INFO" "Removiendo logs comprimidos o rotados antiguos en /var/log..."
find /var/log -type f \( -name "*.gz" -o -name "*.old" -o -name "*.[0-9]" \) -mtime +15 -delete 2>/dev/null
log "INFO" "Logs antiguos depurados."

# 6. Medir espacio en disco después de la limpieza
ESPACIO_DESPUES=$(df -h / | awk 'NR==2 {print $4}')
log "INFO" "Espacio libre actual en raíz (/): $ESPACIO_DESPUES"

log "INFO" "=== Mantenimiento finalizado exitosamente ==="
exit 0
