# 🧹 Script de Limpieza y Mantenimiento de Sistema Linux

Un script en **Bash** automatizado para la depuración de paquetes huérfanos, limpieza de cachés, archivos temporales inactivos y rotación de logs antiguos en sistemas operativos basados en Linux.

---

## 📋 Características

* **Soporte Multi-Distribución:** Detecta e interactúa automáticamente con los gestores de paquetes más populares (`apt`, `dnf` y `zypper`).
* **Liberación de Espacio:**
  * Remueve paquetes automáticos obsoletos y limpia la caché de descarga de paquetes.
  * Elimina archivos en `/tmp` con más de **7 días** de inactividad.
  * Depura registros de log rotados o comprimidos (`*.gz`, `*.old`) con más de **15 días** de antigüedad en `/var/log`.
* **Métricas y Trazabilidad:** Mide y reporta el espacio libre en disco antes y después del mantenimiento.
* **Sistema de Logging:** Registra todas las actividades con marca de tiempo en `/var/log/mantenimiento_limpieza.log`.
* **Validación de Seguridad:** Verifica permisos de superusuario (`root`) antes de ejecutar cualquier acción destructiva.

---

## 🚀 Requisitos e Instalación

### Requisitos previos
* Sistema operativo Linux (Debian, Ubuntu, Fedora, RHEL, openSUSE, etc.).
* Permisos de administración (`sudo` o acceso a `root`).

### Clonar el repositorio

```bash
git clone [https://github.com/tu-usuario/limpieza-sistema-linux.git](https://github.com/tu-usuario/limpieza-sistema-linux.git)
cd limpieza-sistema-linux