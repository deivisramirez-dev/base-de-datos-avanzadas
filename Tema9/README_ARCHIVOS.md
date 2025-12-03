# 📁 Guía de Archivos SQL - Tema 9
## Base de Datos: MySQL 8.0+

## Descripción de Archivos

Este directorio contiene varios archivos SQL relacionados con el esquema de base de datos. A continuación se explica la diferencia y uso de cada uno:

**IMPORTANTE:** Todos los archivos están adaptados para **MySQL 8.0+**

---

## 📄 `schema.sql` - **Documentación del Esquema**

**Propósito:** Archivo de referencia y documentación del esquema de base de datos.

**Características:**
- ✅ Contiene comentarios explicativos extensos
- ✅ Documenta cada tabla y su propósito
- ✅ Incluye `COMMENT ON TABLE` para documentación en la BD
- ✅ Muestra la estructura completa del esquema
- ⚠️ **NO está diseñado para ejecutarse directamente**
- ⚠️ El orden de creación puede no ser óptimo

**Cuándo usarlo:**
- Para entender la estructura del esquema
- Como referencia de documentación
- Para estudiar las relaciones entre tablas
- Para ver comentarios y explicaciones

**Ejemplo de uso:**
```bash
# Solo para lectura/referencia
cat schema.sql
# O abrirlo en un editor para estudiar
```

---

## 🔧 `create_tables.sql` - **Script Ejecutable**

**Propósito:** Script SQL listo para ejecutar que crea todas las tablas.

**Características:**
- ✅ **Crea la base de datos automáticamente** (`CREATE DATABASE IF NOT EXISTS`)
- ✅ Incluye `DROP TABLE IF EXISTS` para limpieza
- ✅ Orden correcto de creación (respetando dependencias)
- ✅ Foreign keys definidas directamente en las tablas
- ✅ Índices básicos incluidos
- ✅ Listo para ejecutar sin errores
- ✅ Sin comentarios extensos (más limpio)

**Cuándo usarlo:**
- Para crear las tablas en la base de datos
- Para recrear el esquema desde cero
- En scripts automatizados
- En entornos de desarrollo/pruebas

**Ejemplo de uso:**
```bash
# Ejecutar en MySQL (crea la BD y las tablas en un solo paso)
mysql -u root -p < create_tables.sql

# O desde mysql (sin necesidad de crear la BD primero)
mysql> SOURCE create_tables.sql;
```

**Nota:** Este script crea la base de datos `gestion_ventas` automáticamente si no existe, por lo que no necesitas crearla manualmente.

---

## 📊 `insert_data.sql` - **Datos de Prueba**

**Propósito:** Inserta datos de ejemplo para las actividades.

**Características:**
- ✅ Datos de ejemplo para todas las tablas
- ✅ Volumen suficiente para análisis de rendimiento
- ✅ Actualiza estadísticas con `ANALYZE`
- ✅ Actualiza totales de pedidos automáticamente

**Cuándo usarlo:**
- Después de ejecutar `create_tables.sql`
- Para poblar la base de datos con datos de prueba
- Para realizar las actividades de refuerzo

**Ejemplo de uso:**
```bash
# Ejecutar después de create_tables.sql
mysql -u root -p gestion_ventas < insert_data.sql

# O desde mysql
mysql> USE gestion_ventas;
mysql> SOURCE insert_data.sql;
```

---

## 📚 `soluciones_actividades.md` - **Soluciones Paso a Paso**

**Propósito:** Guía completa con soluciones de las 3 actividades.

**Contenido:**
- Soluciones detalladas de cada actividad
- Código SQL completo
- Explicaciones paso a paso
- Comparaciones antes/después de optimización

---

## 🔄 Flujo de Trabajo Recomendado

### Opción 1: Todo en un solo paso (Recomendado)
```bash
# Paso 1: Crear BD y tablas (todo en uno)
mysql -u root -p < create_tables.sql

# Paso 2: Insertar datos
mysql -u root -p gestion_ventas < insert_data.sql
```

### Opción 2: Pasos separados
```sql
-- Paso 1: Crear la base de datos (opcional, ya que create_tables.sql lo hace)
CREATE DATABASE gestion_ventas CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gestion_ventas;
```

```bash
# Paso 2: Crear las tablas
mysql -u root -p gestion_ventas < create_tables.sql

# Paso 3: Insertar datos
mysql -u root -p gestion_ventas < insert_data.sql
```

### Paso 4: Realizar las Actividades
Seguir las soluciones en `soluciones_actividades.md`

---

## 📋 Resumen de Diferencias

| Característica | `schema.sql` | `create_tables.sql` |
|----------------|--------------|---------------------|
| **Propósito** | Documentación | Ejecución |
| **DROP TABLE** | ❌ No | ✅ Sí |
| **Orden correcto** | ⚠️ Parcial | ✅ Sí |
| **Comentarios** | ✅ Extensos | ⚠️ Mínimos |
| **COMMENT ON** | ✅ Sí | ❌ No |
| **Índices** | Básicos | Básicos + extras |
| **Ejecutable** | ⚠️ Puede fallar | ✅ Listo |

---

## ⚠️ Notas Importantes

1. **Siempre usa `create_tables.sql` para crear las tablas**
2. **Usa `schema.sql` solo como referencia/documentación**
3. **Ejecuta `insert_data.sql` después de crear las tablas**
4. **Consulta `soluciones_actividades.md` para las actividades**

---

## 🎯 Recomendación

Para las actividades de refuerzo:
1. ✅ Ejecuta `create_tables.sql` (crear tablas)
2. ✅ Ejecuta `insert_data.sql` (insertar datos)
3. ✅ Consulta `soluciones_actividades.md` (realizar actividades)
4. 📖 Lee `schema.sql` (entender estructura)

---

**¡Listo para comenzar con las actividades!** 🚀

