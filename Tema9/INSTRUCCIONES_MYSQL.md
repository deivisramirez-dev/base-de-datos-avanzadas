# Instrucciones para MySQL - Tema 9

## 🎯 Configuración Inicial

### Requisitos
- MySQL 8.0 o superior
- Cliente MySQL (mysql, MySQL Workbench, o similar)

### Crear la Base de Datos y Tablas

**Opción 1: Automático (Recomendado)**
El archivo `create_tables.sql` crea la base de datos automáticamente, así que puedes ejecutarlo directamente:

```bash
# Desde la línea de comandos (crea BD y tablas en un solo paso)
mysql -u root -p < create_tables.sql
```

O desde el cliente MySQL:
```sql
SOURCE create_tables.sql;
```

**Opción 2: Manual**
Si prefieres crear la base de datos manualmente:

```sql
-- Conectar a MySQL
mysql -u root -p

-- Crear la base de datos
CREATE DATABASE gestion_ventas 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Usar la base de datos
USE gestion_ventas;

-- Ejecutar el script (aunque ya no es necesario crear la BD)
SOURCE create_tables.sql;
```

---

## 📝 Pasos de Ejecución

### Paso 1: Crear la Base de Datos y las Tablas

```bash
# Desde la línea de comandos (todo en uno)
mysql -u root -p < create_tables.sql
```

**Nota:** El script `create_tables.sql` ahora incluye la creación de la base de datos, por lo que no necesitas crearla manualmente.

### Paso 2: Insertar Datos

```bash
# Desde la línea de comandos
mysql -u root -p gestion_ventas < insert_data.sql
```

O desde el cliente MySQL:
```sql
USE gestion_ventas;
SOURCE insert_data.sql;
```

### Paso 3: Verificar la Instalación

```sql
-- Ver todas las tablas
SHOW TABLES;

-- Ver estructura de una tabla
DESCRIBE pedidos;

-- Contar registros
SELECT 
    'categorias' AS tabla, COUNT(*) AS registros FROM categorias
UNION ALL
SELECT 'productos', COUNT(*) FROM productos
UNION ALL
SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL
SELECT 'empleados', COUNT(*) FROM empleados
UNION ALL
SELECT 'departamentos', COUNT(*) FROM departamentos
UNION ALL
SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL
SELECT 'pedido_items', COUNT(*) FROM pedido_items
UNION ALL
SELECT 'ventas_diarias', COUNT(*) FROM ventas_diarias;
```

---

## 🔍 Verificar Triggers

Los triggers para calcular el subtotal se crean automáticamente. Para verificar:

```sql
-- Ver triggers
SHOW TRIGGERS FROM gestion_ventas;

-- Probar que el trigger funciona
INSERT INTO pedido_items (pedido_id, producto_id, cantidad, precio_unitario, descuento, subtotal)
VALUES (1, 1, 2, 100.00, 10, 0);

-- Verificar que el subtotal se calculó correctamente
SELECT item_id, cantidad, precio_unitario, descuento, subtotal
FROM pedido_items
WHERE item_id = LAST_INSERT_ID();
-- Debería mostrar: subtotal = 180.00 (2 * 100 * 0.9)
```

---

## 📚 Realizar las Actividades

Sigue las soluciones paso a paso en el archivo:
- `soluciones_actividades.md`

Todas las consultas están adaptadas para MySQL.

---

## ⚠️ Notas Importantes

1. **Triggers**: El subtotal se calcula automáticamente mediante triggers
2. **Charset**: Se usa utf8mb4 para soportar caracteres especiales
3. **Engine**: Se usa InnoDB para soportar transacciones y foreign keys
4. **CHECK constraints**: Disponibles desde MySQL 8.0.16+
5. **CTEs (WITH)**: Disponibles desde MySQL 8.0+

---

## 🐛 Solución de Problemas

### Error: "Unknown database 'gestion_ventas'"
```sql
CREATE DATABASE gestion_ventas;
USE gestion_ventas;
```

### Error: "Table already exists"
```sql
-- Eliminar todas las tablas
DROP TABLE IF EXISTS ventas_diarias;
DROP TABLE IF EXISTS pedido_items;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS departamentos;
DROP TABLE IF EXISTS clientes;
```

### Error: "Trigger already exists"
```sql
DROP TRIGGER IF EXISTS trg_calcular_subtotal_insert;
DROP TRIGGER IF EXISTS trg_calcular_subtotal_update;
```

---

**¡Listo para comenzar con las actividades!** 🚀

