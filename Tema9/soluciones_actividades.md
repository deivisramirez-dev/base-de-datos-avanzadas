# Soluciones de las Actividades de Refuerzo - Tema 9
## Ejecución y Procesamiento de Consultas
## Base de Datos: MySQL 8.0+

---

## 📋 Índice

1. [Actividad 1: Análisis de Planes de Ejecución](#actividad-1-análisis-de-planes-de-ejecución)
2. [Actividad 2: Optimización de Consultas](#actividad-2-optimización-de-consultas)
3. [Actividad 3: Monitorización de Rendimiento](#actividad-3-monitorización-de-rendimiento)

---

## Actividad 1: Análisis de Planes de Ejecución

### 🎯 Objetivo
Aprender a analizar y optimizar planes de ejecución de consultas.

### ⏱️ Duración
20 minutos

### 📝 Tareas
1. Escribe una consulta SQL compleja con múltiples JOINs
2. Ejecuta EXPLAIN o EXPLAIN ANALYZE para ver el plan de ejecución
3. Identifica las operaciones más costosas
4. Crea índices apropiados y vuelve a analizar el plan
5. Compara los costes antes y después de la optimización

---

### 🔧 Solución Paso a Paso

#### Paso 1: Crear una Consulta SQL Compleja con Múltiples JOINs

Vamos a crear una consulta que obtenga información detallada de pedidos con múltiples tablas relacionadas:

```sql
-- Consulta compleja: Información completa de pedidos
SELECT 
    p.pedido_id,
    p.fecha_pedido,
    p.estado,
    p.total,
    CONCAT(c.nombre, ' ', c.apellido) AS cliente_nombre,
    c.ciudad AS cliente_ciudad,
    CONCAT(e.nombre, ' ', e.apellido) AS empleado_nombre,
    pr.nombre AS producto_nombre,
    pr.precio AS precio_actual,
    pi.cantidad,
    pi.precio_unitario,
    pi.descuento,
    pi.subtotal,
    cat.nombre AS categoria_nombre
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
LEFT JOIN empleados e ON p.empleado_id = e.empleado_id
INNER JOIN pedido_items pi ON p.pedido_id = pi.pedido_id
INNER JOIN productos pr ON pi.producto_id = pr.producto_id
INNER JOIN categorias cat ON pr.categoria_id = cat.categoria_id
WHERE p.fecha_pedido >= '2024-01-01'
  AND p.estado IN ('entregado', 'enviado')
  AND cat.activa = TRUE
ORDER BY p.fecha_pedido DESC, p.total DESC;
```

**📖 Explicación del Paso 1:**

En este paso, hemos creado una consulta SQL compleja que involucra múltiples operaciones que pueden ser costosas:

1. **Múltiples JOINs**: La consulta realiza 5 operaciones de JOIN (4 INNER JOIN y 1 LEFT JOIN), lo que significa que MySQL debe combinar datos de 6 tablas diferentes (`pedidos`, `clientes`, `empleados`, `pedido_items`, `productos`, `categorias`). Cada JOIN requiere buscar coincidencias entre tablas, lo cual puede ser costoso si no hay índices apropiados.

2. **Funciones de concatenación**: Usamos `CONCAT()` para combinar nombres y apellidos. Aunque esta operación no es extremadamente costosa, se ejecuta para cada fila del resultado.

3. **Filtros en WHERE**: Tenemos tres condiciones de filtrado:
   - `p.fecha_pedido >= '2024-01-01'`: Filtro por rango de fechas
   - `p.estado IN ('entregado', 'enviado')`: Filtro por valores específicos
   - `cat.activa = TRUE`: Filtro booleano

4. **ORDER BY**: Ordenamos por dos columnas (`fecha_pedido DESC, total DESC`), lo que requiere una operación de ordenación que puede ser costosa si no hay índices que soporten este orden.

Esta consulta es ideal para análisis porque:
- Combina información de múltiples entidades del negocio
- Permite identificar patrones de ventas por categoría, cliente y empleado
- Demuestra cómo las consultas complejas pueden beneficiarse de la optimización

#### Paso 2: Analizar el Plan de Ejecución

En MySQL, usamos `EXPLAIN` o `EXPLAIN ANALYZE` (MySQL 8.0.18+):

```sql
-- Análisis del plan de ejecución (formato tradicional)
EXPLAIN
SELECT 
    p.pedido_id,
    p.fecha_pedido,
    p.estado,
    p.total,
    CONCAT(c.nombre, ' ', c.apellido) AS cliente_nombre,
    c.ciudad AS cliente_ciudad,
    CONCAT(e.nombre, ' ', e.apellido) AS empleado_nombre,
    pr.nombre AS producto_nombre,
    pr.precio AS precio_actual,
    pi.cantidad,
    pi.precio_unitario,
    pi.descuento,
    pi.subtotal,
    cat.nombre AS categoria_nombre
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
LEFT JOIN empleados e ON p.empleado_id = e.empleado_id
INNER JOIN pedido_items pi ON p.pedido_id = pi.pedido_id
INNER JOIN productos pr ON pi.producto_id = pr.producto_id
INNER JOIN categorias cat ON pr.categoria_id = cat.categoria_id
WHERE p.fecha_pedido >= '2024-01-01'
  AND p.estado IN ('entregado', 'enviado')
  AND cat.activa = TRUE
ORDER BY p.fecha_pedido DESC, p.total DESC;

-- Análisis con formato JSON (más detallado)
EXPLAIN FORMAT=JSON
SELECT 
    p.pedido_id,
    p.fecha_pedido,
    p.estado,
    p.total,
    CONCAT(c.nombre, ' ', c.apellido) AS cliente_nombre,
    c.ciudad AS cliente_ciudad,
    CONCAT(e.nombre, ' ', e.apellido) AS empleado_nombre,
    pr.nombre AS producto_nombre,
    pr.precio AS precio_actual,
    pi.cantidad,
    pi.precio_unitario,
    pi.descuento,
    pi.subtotal,
    cat.nombre AS categoria_nombre
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
LEFT JOIN empleados e ON p.empleado_id = e.empleado_id
INNER JOIN pedido_items pi ON p.pedido_id = pi.pedido_id
INNER JOIN productos pr ON pi.producto_id = pr.producto_id
INNER JOIN categorias cat ON pr.categoria_id = cat.categoria_id
WHERE p.fecha_pedido >= '2024-01-01'
  AND p.estado IN ('entregado', 'enviado')
  AND cat.activa = TRUE
ORDER BY p.fecha_pedido DESC, p.total DESC;

-- Análisis con tiempo real (MySQL 8.0.18+)
EXPLAIN ANALYZE
SELECT 
    p.pedido_id,
    p.fecha_pedido,
    p.estado,
    p.total,
    CONCAT(c.nombre, ' ', c.apellido) AS cliente_nombre,
    c.ciudad AS cliente_ciudad,
    CONCAT(e.nombre, ' ', e.apellido) AS empleado_nombre,
    pr.nombre AS producto_nombre,
    pr.precio AS precio_actual,
    pi.cantidad,
    pi.precio_unitario,
    pi.descuento,
    pi.subtotal,
    cat.nombre AS categoria_nombre
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
LEFT JOIN empleados e ON p.empleado_id = e.empleado_id
INNER JOIN pedido_items pi ON p.pedido_id = pi.pedido_id
INNER JOIN productos pr ON pi.producto_id = pr.producto_id
INNER JOIN categorias cat ON pr.categoria_id = cat.categoria_id
WHERE p.fecha_pedido >= '2024-01-01'
  AND p.estado IN ('entregado', 'enviado')
  AND cat.activa = TRUE
ORDER BY p.fecha_pedido DESC, p.total DESC;
```

**Interpretación de EXPLAIN en MySQL:**

| Columna | Descripción |
|---------|-------------|
| `id` | Número de secuencia del SELECT |
| `select_type` | Tipo de SELECT (SIMPLE, PRIMARY, etc.) |
| `table` | Nombre de la tabla |
| `type` | Tipo de join (ALL, index, range, ref, etc.) |
| `possible_keys` | Índices que podrían usarse |
| `key` | Índice realmente usado |
| `key_len` | Longitud del índice usado |
| `ref` | Columnas comparadas con el índice |
| `rows` | Número estimado de filas a examinar |
| `Extra` | Información adicional (Using index, Using where, etc.) |

**Resultado esperado (ejemplo):**
```
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                                              |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
|  1 | SIMPLE      | cat   | NULL       | ALL  | NULL          | NULL | NULL    | NULL |   10 |    10.00 | Using where; Using temporary; Using filesort      |
|  1 | SIMPLE      | pr    | NULL       | ref  | idx_productos_categoria | idx_productos_categoria | 5 | gestion_ventas.cat.categoria_id |    2 |   100.00 | NULL                                               |
|  1 | SIMPLE      | pi    | NULL       | ref  | idx_pedido_items_producto | idx_pedido_items_producto | 5 | gestion_ventas.pr.producto_id |    1 |   100.00 | NULL                                               |
|  1 | SIMPLE      | p     | NULL       | ref  | idx_pedidos_cliente,idx_pedidos_fecha | idx_pedidos_cliente | 5 | gestion_ventas.pi.pedido_id |    1 |    50.00 | Using where                                        |
|  1 | SIMPLE      | c     | NULL       | eq_ref | PRIMARY       | PRIMARY | 4 | gestion_ventas.p.cliente_id |    1 |   100.00 | NULL                                               |
|  1 | SIMPLE      | e     | NULL       | ref  | PRIMARY       | PRIMARY | 5 | gestion_ventas.p.empleado_id |    1 |   100.00 | NULL                                               |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
```

**📖 Explicación del Paso 2:**

En este paso, utilizamos las herramientas de análisis de MySQL para entender cómo el motor de base de datos ejecutará nuestra consulta. Esto es crucial porque:

1. **EXPLAIN (formato tradicional)**: Proporciona una vista tabular del plan de ejecución. Cada fila representa una operación que MySQL realizará. Las columnas clave son:
   - `type`: Indica el tipo de acceso a los datos (ALL = escaneo completo, ref = búsqueda por índice, etc.)
   - `key`: Muestra qué índice se está usando (NULL significa que no se usa ningún índice)
   - `rows`: Número estimado de filas que MySQL examinará
   - `Extra`: Información adicional sobre operaciones especiales (Using filesort, Using temporary, etc.)

2. **EXPLAIN FORMAT=JSON**: Proporciona información más detallada en formato JSON, incluyendo:
   - Costos estimados de cada operación
   - Información sobre el orden de ejecución
   - Detalles sobre el uso de índices y buffers

3. **EXPLAIN ANALYZE** (MySQL 8.0.18+): Ejecuta la consulta realmente y proporciona:
   - Tiempos reales de ejecución (no estimados)
   - Número real de filas procesadas
   - Información sobre bucles y iteraciones

**Por qué es importante:**
- Nos permite identificar cuellos de botella antes de que la consulta se ejecute en producción
- Muestra si los índices existentes están siendo utilizados eficientemente
- Revela operaciones costosas como ordenaciones en disco (`Using filesort`) o tablas temporales (`Using temporary`)
- Ayuda a entender el orden en que MySQL procesa las tablas (de derecha a izquierda en el plan)

**Interpretación del resultado de ejemplo:**
- La primera fila muestra `type = ALL` en `categorias`, lo que significa un escaneo completo de la tabla (muy ineficiente)
- `Using temporary; Using filesort` indica que MySQL necesita crear una tabla temporal y ordenar en disco
- Los valores de `rows` nos dan una idea de cuántas filas se examinarán en cada paso

#### Paso 3: Identificar las Operaciones Más Costosas

**Análisis del plan:**

1. **type = ALL**: Escaneo completo de tabla (muy costoso)
   - Si aparece en `categorias` o `pedidos`, indica falta de índices

2. **Using filesort**: Ordenación en disco (costoso)
   - Aparece cuando se requiere ORDER BY sin índice apropiado

3. **Using temporary**: Uso de tabla temporal (costoso)
   - Aparece en GROUP BY o ORDER BY complejos

4. **rows**: Número alto indica muchas filas a examinar

**Operaciones más costosas identificadas:**
- `type = ALL` en cualquier tabla
- `Using filesort` en ORDER BY
- `Using temporary` en operaciones de agrupación
- Alto valor en `rows` sin uso de índices

**📖 Explicación del Paso 3:**

Este paso es crítico para la optimización porque identifica los problemas específicos que están ralentizando nuestra consulta:

1. **`type = ALL` (Escaneo completo de tabla)**:
   - **Qué significa**: MySQL debe leer TODAS las filas de la tabla, una por una, para encontrar las que coinciden con nuestros criterios
   - **Por qué es costoso**: Si una tabla tiene 10,000 filas, MySQL examinará las 10,000 filas, incluso si solo necesitamos 10
   - **Impacto**: En tablas grandes, esto puede tomar segundos o minutos
   - **Solución**: Crear índices apropiados para que MySQL pueda usar búsquedas directas en lugar de escaneos

2. **`Using filesort` (Ordenación en disco)**:
   - **Qué significa**: MySQL no puede usar un índice para ordenar, así que debe ordenar los resultados en memoria o disco
   - **Por qué es costoso**: La ordenación requiere tiempo O(n log n) y puede usar espacio temporal significativo
   - **Impacto**: En grandes conjuntos de resultados, esto puede ser muy lento
   - **Solución**: Crear índices que soporten el ORDER BY, o considerar si realmente necesitamos ordenar todos los resultados

3. **`Using temporary` (Tabla temporal)**:
   - **Qué significa**: MySQL necesita crear una tabla temporal para procesar la consulta (común en GROUP BY, DISTINCT, o ORDER BY complejos)
   - **Por qué es costoso**: Crear y poblar una tabla temporal requiere I/O adicional y memoria
   - **Impacto**: Puede ralentizar significativamente la consulta y aumentar el uso de memoria
   - **Solución**: Optimizar la consulta para evitar la necesidad de tablas temporales, o crear índices que permitan procesar sin ellas

4. **Alto valor en `rows` sin índices**:
   - **Qué significa**: MySQL estima que debe examinar muchas filas, pero no tiene índices para acelerar el proceso
   - **Por qué es costoso**: Más filas = más tiempo de procesamiento
   - **Impacto**: Directamente proporcional al número de filas examinadas
   - **Solución**: Crear índices en las columnas usadas en WHERE, JOIN, y ORDER BY

**Estrategia de optimización:**
- Priorizar la eliminación de `type = ALL` porque es la operación más costosa
- Luego abordar `Using filesort` si el ORDER BY es necesario
- Finalmente, reducir el número de filas examinadas con índices más específicos

#### Paso 4: Crear Índices Apropiados

Basándonos en el análisis, creamos índices estratégicos:

```sql
-- Índice compuesto para pedidos (fecha_pedido y estado)
CREATE INDEX idx_pedidos_fecha_estado ON pedidos(fecha_pedido, estado);

-- Índice para categorias activas (índice parcial)
CREATE INDEX idx_categorias_activa ON categorias(activa) WHERE activa = TRUE;
-- Nota: MySQL no soporta índices parciales con WHERE directamente
-- Alternativa: índice normal
CREATE INDEX idx_categorias_activa ON categorias(activa);

-- Índice para productos activos
CREATE INDEX idx_productos_activo ON productos(activo);

-- Índice compuesto para pedido_items (pedido_id y producto_id)
CREATE INDEX idx_pedido_items_pedido_producto ON pedido_items(pedido_id, producto_id);

-- Actualizar estadísticas después de crear índices
ANALYZE TABLE pedidos;
ANALYZE TABLE pedido_items;
ANALYZE TABLE categorias;
ANALYZE TABLE productos;
```

**📖 Explicación del Paso 4:**

En este paso, creamos índices estratégicos basados en el análisis del plan de ejecución. Los índices son estructuras de datos que permiten a MySQL encontrar datos rápidamente sin escanear toda la tabla:

1. **`idx_pedidos_fecha_estado` (Índice compuesto)**:
   - **Qué hace**: Crea un índice en las columnas `fecha_pedido` y `estado` de la tabla `pedidos`
   - **Por qué es útil**: Nuestra consulta filtra por ambas columnas (`fecha_pedido >= '2024-01-01'` y `estado IN ('entregado', 'enviado')`)
   - **Cómo funciona**: Un índice compuesto ordena primero por `fecha_pedido`, luego por `estado` dentro de cada fecha. Esto permite a MySQL:
     - Encontrar rápidamente todas las filas con `fecha_pedido >= '2024-01-01'`
     - Filtrar por `estado` sin examinar filas individuales
   - **Beneficio**: Cambia de `type = ALL` (escaneo completo) a `type = range` (búsqueda por rango usando índice)

2. **`idx_categorias_activa` (Índice simple)**:
   - **Qué hace**: Crea un índice en la columna `activa` de `categorias`
   - **Por qué es útil**: Filtramos por `cat.activa = TRUE`
   - **Cómo funciona**: Permite a MySQL encontrar rápidamente todas las categorías activas sin escanear todas las filas
   - **Nota sobre índices parciales**: MySQL no soporta índices parciales con `WHERE activa = TRUE` directamente, así que creamos un índice normal. En tablas con muchas categorías inactivas, esto sigue siendo eficiente

3. **`idx_productos_activo` (Índice simple)**:
   - **Qué hace**: Similar al anterior, pero para productos activos
   - **Por qué es útil**: Aunque no lo usamos directamente en esta consulta, es útil para futuras consultas que filtren por productos activos
   - **Beneficio preventivo**: Mejora el rendimiento de consultas futuras

4. **`idx_pedido_items_pedido_producto` (Índice compuesto)**:
   - **Qué hace**: Crea un índice en `pedido_id` y `producto_id`
   - **Por qué es útil**: Acelera los JOINs entre `pedido_items` y otras tablas
   - **Cómo funciona**: Permite búsquedas rápidas tanto por `pedido_id` como por combinaciones de `pedido_id` y `producto_id`
   - **Beneficio**: Reduce el tiempo de los JOINs, que son operaciones costosas

5. **`ANALYZE TABLE`**:
   - **Qué hace**: Actualiza las estadísticas que MySQL usa para tomar decisiones de optimización
   - **Por qué es importante**: Después de crear índices, MySQL necesita recalcular:
     - La cardinalidad de los índices (cuántos valores únicos hay)
     - La distribución de datos
     - El tamaño de las tablas
   - **Cuándo usarlo**: Siempre después de crear nuevos índices o después de cambios significativos en los datos
   - **Beneficio**: Permite al optimizador de consultas tomar mejores decisiones sobre qué índices usar

**Consideraciones importantes sobre índices:**
- **Trade-off**: Los índices mejoran las consultas de lectura (SELECT) pero ralentizan las operaciones de escritura (INSERT, UPDATE, DELETE) porque deben mantenerse actualizados
- **Espacio**: Los índices ocupan espacio en disco, aunque generalmente es mucho menor que los datos
- **Índices compuestos**: El orden de las columnas importa. Un índice en `(fecha, estado)` es diferente de `(estado, fecha)`. El orden debe coincidir con cómo se usan en las consultas

#### Paso 5: Comparar Costes Antes y Después

Ejecutamos nuevamente `EXPLAIN`:

```sql
-- Análisis del plan de ejecución después de optimización
EXPLAIN FORMAT=JSON
SELECT 
    p.pedido_id,
    p.fecha_pedido,
    p.estado,
    p.total,
    CONCAT(c.nombre, ' ', c.apellido) AS cliente_nombre,
    c.ciudad AS cliente_ciudad,
    CONCAT(e.nombre, ' ', e.apellido) AS empleado_nombre,
    pr.nombre AS producto_nombre,
    pr.precio AS precio_actual,
    pi.cantidad,
    pi.precio_unitario,
    pi.descuento,
    pi.subtotal,
    cat.nombre AS categoria_nombre
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
LEFT JOIN empleados e ON p.empleado_id = e.empleado_id
INNER JOIN pedido_items pi ON p.pedido_id = pi.pedido_id
INNER JOIN productos pr ON pi.producto_id = pr.producto_id
INNER JOIN categorias cat ON pr.categoria_id = cat.categoria_id
WHERE p.fecha_pedido >= '2024-01-01'
  AND p.estado IN ('entregado', 'enviado')
  AND cat.activa = TRUE
ORDER BY p.fecha_pedido DESC, p.total DESC;
```

**Comparación de resultados:**

| Métrica | Antes | Después | Mejora |
|---------|-------|---------|--------|
| type = ALL | X tablas | 0 tablas | ✅ Eliminado |
| Using filesort | Sí | No | ✅ Eliminado |
| Using temporary | Sí | No | ✅ Eliminado |
| rows examinadas | X | Y | -XX% |
| key usado | NULL | idx_pedidos_fecha_estado | ✅ Índice usado |

**Mejoras observadas:**
- Los `type = ALL` ahora usan `type = ref` o `type = range` con índices
- El filtro en `categorias` usa el índice `idx_categorias_activa`
- Menor número de filas examinadas
- Reducción significativa en tiempo de ejecución

**📖 Explicación del Paso 5:**

Este paso final es crucial para validar que nuestras optimizaciones realmente funcionaron. La comparación antes/después nos permite:

1. **Medir el impacto real**:
   - **Antes**: Sin índices, MySQL probablemente mostraba `type = ALL` en varias tablas, `Using filesort`, y `Using temporary`
   - **Después**: Con índices apropiados, deberíamos ver:
     - `type = ref` o `type = range`: Búsquedas eficientes usando índices
     - `key` mostrando los nombres de los índices usados
     - Valores más bajos en `rows`: Menos filas examinadas
     - Sin `Using filesort` o `Using temporary` (o al menos reducidos)

2. **Entender los tipos de acceso mejorados**:
   - **`type = ref`**: MySQL usa un índice para buscar valores iguales. Muy eficiente.
   - **`type = range`**: MySQL usa un índice para buscar un rango de valores (como `fecha >= '2024-01-01'`). Eficiente.
   - **`type = ALL` → `type = ref/range`**: Esta mejora puede reducir el tiempo de ejecución de minutos a milisegundos en tablas grandes

3. **Reducción de filas examinadas**:
   - **Antes**: Si `pedidos` tiene 10,000 filas, MySQL podría examinar todas para encontrar las que cumplen los criterios
   - **Después**: Con el índice `idx_pedidos_fecha_estado`, MySQL puede saltar directamente a las filas relevantes, examinando quizás solo 100-200 filas
   - **Impacto**: Reducción del 90-95% en filas examinadas = reducción proporcional en tiempo

4. **Eliminación de operaciones costosas**:
   - **`Using filesort` eliminado**: Si el índice soporta el ORDER BY, MySQL puede leer los datos ya ordenados del índice
   - **`Using temporary` eliminado**: Con índices apropiados, MySQL puede procesar la consulta sin crear tablas temporales

5. **Validación de la estrategia**:
   - Si vemos mejoras significativas, confirmamos que identificamos correctamente los problemas
   - Si no hay mejoras, puede significar que:
     - Los índices no se están usando (verificar con `EXPLAIN`)
     - Hay otros cuellos de botella que no identificamos
     - La tabla es demasiado pequeña para que los índices marquen diferencia

**Métricas de éxito típicas:**
- Reducción del 50-90% en tiempo de ejecución
- Reducción del 80-95% en filas examinadas
- Eliminación de `type = ALL`
- Uso visible de índices en la columna `key`

**Lecciones aprendidas:**
- El análisis del plan de ejecución es esencial antes de optimizar
- Los índices deben crearse estratégicamente, no al azar
- `ANALYZE TABLE` es necesario después de crear índices
- La comparación antes/después valida nuestras decisiones

---

## Actividad 2: Optimización de Consultas

### 🎯 Objetivo
Aplicar técnicas de optimización de consultas.

### ⏱️ Duración
30 minutos

### 📝 Tareas
1. Identifica consultas lentas en una base de datos de prueba
2. Analiza las estadísticas de las tablas involucradas
3. Reescribe las consultas para mejorar el rendimiento
4. Crea índices estratégicos
5. Mide la mejora en el tiempo de ejecución

---

### 🔧 Solución Paso a Paso

#### Paso 1: Identificar Consultas Lentas

Vamos a crear y ejecutar una consulta que puede ser lenta:

```sql
-- Consulta lenta: Reporte de ventas por categoría y región
SELECT 
    cat.nombre AS categoria,
    c.ciudad AS region,
    COUNT(DISTINCT p.pedido_id) AS total_pedidos,
    COUNT(pi.item_id) AS total_items,
    SUM(pi.subtotal) AS ingresos_totales,
    AVG(pi.subtotal) AS promedio_por_item,
    MIN(p.fecha_pedido) AS primera_venta,
    MAX(p.fecha_pedido) AS ultima_venta
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
INNER JOIN pedido_items pi ON p.pedido_id = pi.pedido_id
INNER JOIN productos pr ON pi.producto_id = pr.producto_id
INNER JOIN categorias cat ON pr.categoria_id = cat.categoria_id
WHERE p.fecha_pedido >= '2024-01-01'
  AND p.estado != 'cancelado'
GROUP BY cat.nombre, c.ciudad
HAVING SUM(pi.subtotal) > 500
ORDER BY ingresos_totales DESC;
```

Ejecutamos con `EXPLAIN` para medir el rendimiento:

```sql
EXPLAIN FORMAT=JSON
SELECT 
    cat.nombre AS categoria,
    c.ciudad AS region,
    COUNT(DISTINCT p.pedido_id) AS total_pedidos,
    COUNT(pi.item_id) AS total_items,
    SUM(pi.subtotal) AS ingresos_totales,
    AVG(pi.subtotal) AS promedio_por_item,
    MIN(p.fecha_pedido) AS primera_venta,
    MAX(p.fecha_pedido) AS ultima_venta
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
INNER JOIN pedido_items pi ON p.pedido_id = pi.pedido_id
INNER JOIN productos pr ON pi.producto_id = pr.producto_id
INNER JOIN categorias cat ON pr.categoria_id = cat.categoria_id
WHERE p.fecha_pedido >= '2024-01-01'
  AND p.estado != 'cancelado'
GROUP BY cat.nombre, c.ciudad
HAVING SUM(pi.subtotal) > 500
ORDER BY ingresos_totales DESC;
```

**📖 Explicación del Paso 1:**

En este paso, creamos intencionalmente una consulta que tiene varios problemas de rendimiento para poder identificarlos y optimizarlos:

1. **Consulta de reporte compleja**:
   - **Propósito**: Generar un reporte de ventas agrupado por categoría y región
   - **Complejidad**: Involucra 5 tablas, múltiples JOINs, agregaciones (COUNT, SUM, AVG, MIN, MAX), y filtros

2. **Problemas de rendimiento identificados**:
   
   a) **`COUNT(DISTINCT p.pedido_id)`**:
      - **Problema**: `COUNT(DISTINCT)` es una de las operaciones más costosas en SQL
      - **Por qué es costoso**: MySQL debe:
        1. Agrupar los resultados por `categoria` y `ciudad`
        2. Para cada grupo, contar los `pedido_id` únicos
        3. Esto requiere mantener en memoria un conjunto de valores únicos para cada grupo
      - **Impacto**: En grandes volúmenes de datos, esto puede ser extremadamente lento
      - **Alternativa**: Usar subconsultas o CTEs para pre-filtrar y evitar DISTINCT

   b) **Filtro `!= 'cancelado'`**:
      - **Problema**: El operador `!=` (o `<>`) no puede usar índices eficientemente
      - **Por qué es problemático**: MySQL no puede usar un índice para "no igual a", debe examinar todas las filas
      - **Mejor práctica**: Usar `IN` con valores específicos: `estado IN ('pendiente', 'procesando', 'enviado', 'entregado')`
      - **Impacto**: Puede forzar escaneos completos de tabla

   c) **Múltiples agregaciones**:
      - **Problema**: Calculamos 5 funciones de agregación diferentes (COUNT, SUM, AVG, MIN, MAX)
      - **Por qué puede ser costoso**: Cada agregación requiere procesar todas las filas del grupo
      - **Impacto**: Aumenta el tiempo de procesamiento proporcionalmente

   d) **HAVING con agregación**:
      - **Problema**: `HAVING SUM(pi.subtotal) > 500` filtra después de calcular las agregaciones
      - **Por qué es costoso**: MySQL debe calcular SUM para todos los grupos, luego filtrar
      - **Alternativa**: Si es posible, mover el filtro a WHERE (aunque no siempre es posible con agregaciones)

   e) **ORDER BY con alias**:
      - **Problema**: Ordenamos por `ingresos_totales` que es un alias de `SUM(pi.subtotal)`
      - **Por qué puede ser costoso**: Requiere calcular SUM primero, luego ordenar
      - **Impacto**: Puede requerir `Using filesort` si no hay índice apropiado

3. **Uso de EXPLAIN FORMAT=JSON**:
   - **Por qué JSON**: Proporciona información más detallada y estructurada que el formato tabular
   - **Información adicional**: Incluye costos estimados, información sobre el orden de ejecución, y detalles sobre el uso de índices
   - **Análisis**: Nos permite identificar exactamente dónde está el cuello de botella

**Problemas identificados:**
- Múltiples JOINs sin índices optimizados
- Uso de `COUNT(DISTINCT)` que es costoso
- Filtro `!=` que puede ser ineficiente
- Agregaciones complejas sin índices de soporte

#### Paso 2: Analizar Estadísticas de las Tablas

```sql
-- Ver estadísticas de las tablas involucradas
SELECT 
    TABLE_NAME AS tabla,
    TABLE_ROWS AS filas_estimadas,
    DATA_LENGTH AS tamaño_datos,
    INDEX_LENGTH AS tamaño_indices,
    DATA_LENGTH + INDEX_LENGTH AS tamaño_total
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gestion_ventas'
  AND TABLE_NAME IN ('pedidos', 'pedido_items', 'productos', 'categorias', 'clientes')
ORDER BY TABLE_ROWS DESC;

-- Ver información de índices
SELECT 
    TABLE_NAME AS tabla,
    INDEX_NAME AS indice,
    COLUMN_NAME AS columna,
    SEQ_IN_INDEX AS secuencia,
    CARDINALITY AS cardinalidad
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'gestion_ventas'
  AND TABLE_NAME IN ('pedidos', 'pedido_items', 'productos', 'categorias', 'clientes')
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;

-- Ver tamaño de las tablas (formato legible)
SELECT 
    TABLE_NAME AS tabla,
    ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024), 2) AS tamaño_mb,
    TABLE_ROWS AS filas_estimadas
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gestion_ventas'
  AND TABLE_NAME IN ('pedidos', 'pedido_items', 'productos', 'categorias', 'clientes')
ORDER BY (DATA_LENGTH + INDEX_LENGTH) DESC;
```

**📖 Explicación del Paso 2:**

Este paso es fundamental para entender el contexto de nuestra base de datos antes de optimizar:

1. **Estadísticas de tablas**:
   - **`TABLE_ROWS`**: Número estimado de filas. Nos dice el tamaño de cada tabla
   - **`DATA_LENGTH`**: Tamaño de los datos en bytes. Indica cuánto espacio ocupan los datos reales
   - **`INDEX_LENGTH`**: Tamaño de los índices en bytes. Muestra cuánto espacio adicional usan los índices
   - **`AUTO_INCREMENT`**: Próximo valor para claves auto-incrementales. Útil para entender el crecimiento

2. **Por qué es importante**:
   - **Tablas grandes** (>10,000 filas): Requieren índices más críticos. Un escaneo completo puede tomar mucho tiempo
   - **Tablas pequeñas** (<100 filas): Los índices pueden no ser necesarios, ya que un escaneo completo es rápido
   - **Relación datos/índices**: Si `INDEX_LENGTH` es muy grande comparado con `DATA_LENGTH`, puede indicar demasiados índices

3. **Información de índices**:
   - **`CARDINALITY`**: Número de valores únicos en el índice. Alta cardinalidad = índice más útil
   - **`SEQ_IN_INDEX`**: Orden de las columnas en índices compuestos
   - **Análisis**: Nos permite identificar:
     - Índices con baja cardinalidad (pocos valores únicos = menos útil)
     - Índices duplicados o redundantes
     - Índices que no se están usando

4. **Tamaño en formato legible**:
   - Convertir bytes a MB hace los números más comprensibles
   - Nos ayuda a identificar tablas que ocupan mucho espacio
   - Tablas grandes pueden beneficiarse de particionado o archiving

5. **Decisiones basadas en datos**:
   - Si `pedido_items` tiene 100,000 filas, los índices son críticos
   - Si `categorias` tiene solo 10 filas, un índice puede no ser necesario
   - El tamaño total nos ayuda a planificar el espacio en disco

**Estrategia de análisis:**
- Identificar las tablas más grandes (mayor impacto al optimizar)
- Verificar qué índices ya existen (evitar duplicados)
- Analizar la cardinalidad (índices con baja cardinalidad pueden ser ineficientes)
- Determinar si necesitamos índices adicionales o si debemos eliminar algunos

#### Paso 3: Reescribir la Consulta para Mejorar el Rendimiento

**Optimización 1: Cambiar `!=` por `IN` o `NOT IN`**

```sql
-- Versión optimizada: Usar IN en lugar de !=
SELECT 
    cat.nombre AS categoria,
    c.ciudad AS region,
    COUNT(DISTINCT p.pedido_id) AS total_pedidos,
    COUNT(pi.item_id) AS total_items,
    SUM(pi.subtotal) AS ingresos_totales,
    AVG(pi.subtotal) AS promedio_por_item,
    MIN(p.fecha_pedido) AS primera_venta,
    MAX(p.fecha_pedido) AS ultima_venta
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
INNER JOIN pedido_items pi ON p.pedido_id = pi.pedido_id
INNER JOIN productos pr ON pi.producto_id = pr.producto_id
INNER JOIN categorias cat ON pr.categoria_id = cat.categoria_id
WHERE p.fecha_pedido >= '2024-01-01'
  AND p.estado IN ('pendiente', 'procesando', 'enviado', 'entregado')
GROUP BY cat.nombre, c.ciudad
HAVING SUM(pi.subtotal) > 500
ORDER BY ingresos_totales DESC;
```

**📖 Explicación de la Optimización 1:**

Esta es la primera y más simple optimización que aplicamos:

1. **Cambio de `!=` a `IN`**:
   - **Antes**: `p.estado != 'cancelado'`
   - **Después**: `p.estado IN ('pendiente', 'procesando', 'enviado', 'entregado')`
   
2. **Por qué es mejor**:
   - **Índices**: MySQL puede usar un índice para buscar valores específicos con `IN`, pero no puede hacerlo eficientemente con `!=`
   - **Optimizador**: El optimizador de MySQL puede planificar mejor con `IN` porque sabe exactamente qué valores buscar
   - **Rendimiento**: `IN` puede usar búsquedas de índice, mientras que `!=` típicamente requiere escaneo completo
   
3. **Cuándo usar cada uno**:
   - **Usar `IN`**: Cuando excluyes pocos valores de un conjunto conocido
   - **Usar `!=` o `<>`**: Solo cuando realmente necesitas excluir un valor y no hay alternativa práctica
   
4. **Impacto esperado**:
   - Si hay un índice en `estado`, `IN` puede usarlo eficientemente
   - Reducción del tiempo de filtrado, especialmente en tablas grandes

**Optimización 2: Usar subconsulta para COUNT(DISTINCT)**

```sql
-- Versión optimizada: Evitar COUNT(DISTINCT) cuando sea posible
SELECT 
    cat.nombre AS categoria,
    c.ciudad AS region,
    COUNT(p.pedido_id) AS total_pedidos,
    COUNT(pi.item_id) AS total_items,
    SUM(pi.subtotal) AS ingresos_totales,
    AVG(pi.subtotal) AS promedio_por_item,
    MIN(p.fecha_pedido) AS primera_venta,
    MAX(p.fecha_pedido) AS ultima_venta
FROM (
    SELECT DISTINCT pedido_id, cliente_id, fecha_pedido
    FROM pedidos
    WHERE fecha_pedido >= '2024-01-01'
      AND estado IN ('pendiente', 'procesando', 'enviado', 'entregado')
) p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
INNER JOIN pedido_items pi ON p.pedido_id = pi.pedido_id
INNER JOIN productos pr ON pi.producto_id = pr.producto_id
INNER JOIN categorias cat ON pr.categoria_id = cat.categoria_id
GROUP BY cat.nombre, c.ciudad
HAVING SUM(pi.subtotal) > 500
ORDER BY ingresos_totales DESC;
```

**📖 Explicación de la Optimización 2:**

Esta optimización aborda el problema más costoso de la consulta original:

1. **Eliminación de `COUNT(DISTINCT)`**:
   - **Antes**: `COUNT(DISTINCT p.pedido_id)` dentro del SELECT principal
   - **Después**: Subconsulta que pre-filtra y elimina duplicados, luego `COUNT(p.pedido_id)` simple
   
2. **Por qué funciona mejor**:
   - **Subconsulta con DISTINCT**: La subconsulta `SELECT DISTINCT pedido_id, cliente_id, fecha_pedido FROM pedidos WHERE...` elimina duplicados ANTES de los JOINs
   - **COUNT simple**: Una vez que los duplicados están eliminados, `COUNT(p.pedido_id)` es mucho más rápido que `COUNT(DISTINCT p.pedido_id)`
   - **Menos datos para procesar**: Los JOINs posteriores trabajan con menos filas
   
3. **Orden de operaciones mejorado**:
   - **Antes**: JOIN todas las tablas → Agrupar → Contar DISTINCT (costoso)
   - **Después**: Filtrar y eliminar duplicados → JOIN → Agrupar → Contar (más eficiente)
   
4. **Trade-offs**:
   - **Ventaja**: Mucho más rápido, especialmente con grandes volúmenes de datos
   - **Desventaja**: La consulta es un poco más compleja de leer
   - **Nota**: En algunos casos, el optimizador puede hacer esta transformación automáticamente, pero es mejor ser explícito

5. **Cuándo usar esta técnica**:
   - Cuando `COUNT(DISTINCT)` es lento
   - Cuando puedes pre-filtrar los datos antes de los JOINs
   - Cuando la subconsulta puede usar índices eficientemente

**Optimización 3: Usar CTE (Common Table Expression) para mejor legibilidad y optimización**

```sql
-- Versión optimizada: Usar CTE (MySQL 8.0+)
WITH pedidos_filtrados AS (
    SELECT 
        pedido_id,
        cliente_id,
        fecha_pedido
    FROM pedidos
    WHERE fecha_pedido >= '2024-01-01'
      AND estado IN ('pendiente', 'procesando', 'enviado', 'entregado')
),
items_con_datos AS (
    SELECT 
        pi.pedido_id,
        pi.item_id,
        pi.subtotal,
        pr.categoria_id
    FROM pedido_items pi
    INNER JOIN productos pr ON pi.producto_id = pr.producto_id
)
SELECT 
    cat.nombre AS categoria,
    c.ciudad AS region,
    COUNT(DISTINCT pf.pedido_id) AS total_pedidos,
    COUNT(icd.item_id) AS total_items,
    SUM(icd.subtotal) AS ingresos_totales,
    AVG(icd.subtotal) AS promedio_por_item,
    MIN(pf.fecha_pedido) AS primera_venta,
    MAX(pf.fecha_pedido) AS ultima_venta
FROM pedidos_filtrados pf
INNER JOIN clientes c ON pf.cliente_id = c.cliente_id
INNER JOIN items_con_datos icd ON pf.pedido_id = icd.pedido_id
INNER JOIN categorias cat ON icd.categoria_id = cat.categoria_id
GROUP BY cat.nombre, c.ciudad
HAVING SUM(icd.subtotal) > 500
ORDER BY ingresos_totales DESC;
```

**📖 Explicación de la Optimización 3:**

Esta es la versión más optimizada y legible usando CTEs (Common Table Expressions):

1. **¿Qué son las CTEs?**:
   - **Definición**: Son tablas temporales con nombre que existen solo durante la ejecución de la consulta
   - **Sintaxis**: `WITH nombre_cte AS (SELECT ...) SELECT ... FROM nombre_cte`
   - **Disponibilidad**: MySQL 8.0+ (si usas versión anterior, usa subconsultas)

2. **Ventajas de usar CTEs**:
   
   a) **Legibilidad mejorada**:
      - Divide la consulta compleja en partes lógicas y nombradas
      - `pedidos_filtrados`: Claramente muestra que estamos filtrando pedidos
      - `items_con_datos`: Indica que estamos preparando los items con información adicional
      - Más fácil de entender y mantener
   
   b) **Reutilización**:
      - Las CTEs pueden referenciarse múltiples veces en la consulta principal
      - Evita repetir subconsultas complejas
   
   c) **Optimización del optimizador**:
      - MySQL puede optimizar cada CTE independientemente
      - Puede materializar (guardar temporalmente) los resultados si es beneficioso
      - Puede usar índices de manera más eficiente en cada CTE
   
   d) **Separación de responsabilidades**:
      - `pedidos_filtrados`: Se encarga solo del filtrado de pedidos
      - `items_con_datos`: Se encarga solo de combinar items con productos
      - Consulta principal: Se enfoca en la agregación y agrupación final

3. **Cómo funciona esta optimización**:
   - **Paso 1**: `pedidos_filtrados` filtra y selecciona solo las columnas necesarias de `pedidos`
   - **Paso 2**: `items_con_datos` combina `pedido_items` con `productos` para obtener `categoria_id`
   - **Paso 3**: La consulta principal hace JOINs más simples y eficientes con los CTEs
   - **Resultado**: Menos datos para procesar en cada paso, mejor uso de índices

4. **Beneficios específicos**:
   - **Menos columnas**: Cada CTE selecciona solo las columnas necesarias, reduciendo el tamaño de los datos en memoria
   - **Filtrado temprano**: Los filtros se aplican antes de los JOINs complejos
   - **Índices más efectivos**: Cada CTE puede usar índices de manera más directa
   - **Paralelización potencial**: MySQL puede procesar CTEs en paralelo si es beneficioso

5. **Comparación con versiones anteriores**:
   - **Versión original**: Todo en una consulta grande, difícil de optimizar
   - **Versión con subconsulta**: Mejor, pero menos legible
   - **Versión con CTE**: Mejor rendimiento Y mejor legibilidad (lo mejor de ambos mundos)

6. **Cuándo usar CTEs**:
   - Consultas complejas con múltiples pasos lógicos
   - Cuando necesitas reutilizar el mismo resultado intermedio
   - Cuando quieres mejorar la legibilidad sin sacrificar rendimiento
   - MySQL 8.0 o superior

**Nota importante**: Aunque las CTEs mejoran la legibilidad, el rendimiento real depende de cómo MySQL las optimiza. En algunos casos, el optimizador puede "aplanar" las CTEs y ejecutarlas de manera similar a subconsultas. Sin embargo, la estructura más clara facilita la optimización manual y el mantenimiento.

#### Paso 4: Crear Índices Estratégicos

```sql
-- Índice compuesto para pedidos (estado y fecha)
CREATE INDEX idx_pedidos_estado_fecha ON pedidos(estado, fecha_pedido);

-- Índice para productos con categoría
CREATE INDEX idx_productos_categoria_activo ON productos(categoria_id, activo);

-- Índice para pedido_items con subtotal (para HAVING)
CREATE INDEX idx_pedido_items_subtotal ON pedido_items(pedido_id, subtotal);

-- Índice para clientes por ciudad (para GROUP BY)
CREATE INDEX idx_clientes_ciudad ON clientes(ciudad);

-- Actualizar estadísticas
ANALYZE TABLE pedidos;
ANALYZE TABLE pedido_items;
ANALYZE TABLE productos;
ANALYZE TABLE categorias;
ANALYZE TABLE clientes;
```

**📖 Explicación del Paso 4:**

En este paso, creamos índices específicamente diseñados para optimizar nuestra consulta de reporte:

1. **`idx_pedidos_estado_fecha` (Índice compuesto)**:
   - **Columnas**: `estado, fecha_pedido`
   - **Por qué este orden**: 
     - `estado` primero porque lo usamos en `IN ('pendiente', 'procesando', 'enviado', 'entregado')`
     - `fecha_pedido` segundo porque lo usamos en `>= '2024-01-01'`
   - **Cómo ayuda**: 
     - Permite buscar eficientemente por estado primero
     - Luego filtrar por fecha dentro de cada estado
     - Elimina la necesidad de escaneos completos
   - **Regla general**: En índices compuestos, ordena las columnas de más selectiva a menos selectiva

2. **`idx_productos_categoria_activo` (Índice compuesto)**:
   - **Columnas**: `categoria_id, activo`
   - **Por qué es útil**: 
     - Acelera JOINs con `categorias`
     - Permite filtrar productos activos eficientemente
   - **Beneficio adicional**: Útil para otras consultas que filtren por categoría y estado activo

3. **`idx_pedido_items_subtotal` (Índice compuesto)**:
   - **Columnas**: `pedido_id, subtotal`
   - **Por qué es necesario**: 
     - `HAVING SUM(pi.subtotal) > 500` requiere acceso a `subtotal`
     - Aunque no podemos indexar directamente la función SUM, tener `subtotal` en el índice ayuda
   - **Limitación**: MySQL no puede usar este índice directamente para el HAVING, pero ayuda en otras partes de la consulta

4. **`idx_clientes_ciudad` (Índice simple)**:
   - **Columna**: `ciudad`
   - **Por qué es importante**: 
     - Usamos `c.ciudad` en `GROUP BY cat.nombre, c.ciudad`
     - Un índice en la columna de agrupación puede mejorar significativamente el rendimiento
   - **Beneficio**: Permite agrupar más eficientemente sin ordenar toda la tabla

5. **`ANALYZE TABLE` - Actualización de estadísticas**:
   - **Qué hace**: Recalcula estadísticas importantes:
     - **Cardinalidad**: Cuántos valores únicos hay en cada índice
     - **Distribución**: Cómo están distribuidos los datos
     - **Tamaño**: Tamaño actualizado de tablas e índices
   - **Por qué es crítico**: 
     - Sin estadísticas actualizadas, el optimizador puede tomar malas decisiones
     - Puede elegir no usar un índice nuevo porque las estadísticas están desactualizadas
   - **Cuándo ejecutarlo**: 
     - Después de crear nuevos índices
     - Después de cambios significativos en los datos (INSERT, UPDATE, DELETE masivos)
     - Periódicamente en producción (semanal o mensual, dependiendo del volumen)

6. **Estrategia de indexación**:
   - **Índices compuestos vs simples**: 
     - Compuestos son más eficientes cuando se usan múltiples columnas juntas
     - Simples son más flexibles pero pueden requerir múltiples índices
   - **Balance**: 
     - Más índices = consultas más rápidas PERO escrituras más lentas
     - Menos índices = escrituras más rápidas PERO consultas más lentas
   - **Regla práctica**: Crea índices para columnas usadas en:
     - WHERE clauses
     - JOIN conditions
     - ORDER BY
     - GROUP BY (a veces)

7. **Monitoreo de índices**:
   - Después de crear índices, verifica que se están usando con `EXPLAIN`
   - Si un índice no se usa, puede ser porque:
     - Las estadísticas están desactualizadas (ejecutar `ANALYZE TABLE`)
     - El índice no es apropiado para la consulta
     - La tabla es demasiado pequeña para que el índice sea beneficioso

#### Paso 5: Medir la Mejora en el Tiempo de Ejecución

Ejecutamos la consulta optimizada con `EXPLAIN ANALYZE`:

```sql
EXPLAIN ANALYZE
WITH pedidos_filtrados AS (
    SELECT 
        pedido_id,
        cliente_id,
        fecha_pedido
    FROM pedidos
    WHERE fecha_pedido >= '2024-01-01'
      AND estado IN ('pendiente', 'procesando', 'enviado', 'entregado')
),
items_con_datos AS (
    SELECT 
        pi.pedido_id,
        pi.item_id,
        pi.subtotal,
        pr.categoria_id
    FROM pedido_items pi
    INNER JOIN productos pr ON pi.producto_id = pr.producto_id
)
SELECT 
    cat.nombre AS categoria,
    c.ciudad AS region,
    COUNT(DISTINCT pf.pedido_id) AS total_pedidos,
    COUNT(icd.item_id) AS total_items,
    SUM(icd.subtotal) AS ingresos_totales,
    AVG(icd.subtotal) AS promedio_por_item,
    MIN(pf.fecha_pedido) AS primera_venta,
    MAX(pf.fecha_pedido) AS ultima_venta
FROM pedidos_filtrados pf
INNER JOIN clientes c ON pf.cliente_id = c.cliente_id
INNER JOIN items_con_datos icd ON pf.pedido_id = icd.pedido_id
INNER JOIN categorias cat ON icd.categoria_id = cat.categoria_id
GROUP BY cat.nombre, c.ciudad
HAVING SUM(icd.subtotal) > 500
ORDER BY ingresos_totales DESC;
```

**Tabla comparativa de rendimiento:**

| Métrica | Consulta Original | Consulta Optimizada | Mejora |
|---------|-------------------|---------------------|--------|
| type = ALL | X tablas | 0 tablas | -XX% |
| Using filesort | Sí | No | ✅ Eliminado |
| Using temporary | Sí | No | ✅ Eliminado |
| rows examinadas | X | Y | -XX% |
| Tiempo ejecución | X ms | Y ms | -XX% |

**📖 Explicación del Paso 5:**

Este paso final valida todas nuestras optimizaciones y nos permite medir el impacto real:

1. **`EXPLAIN ANALYZE` - Medición real**:
   - **Diferencia con EXPLAIN**: `EXPLAIN ANALYZE` realmente ejecuta la consulta y mide tiempos reales
   - **Información proporcionada**:
     - Tiempo real de ejecución (no estimado)
     - Número real de filas procesadas
     - Información sobre bucles e iteraciones
     - Costos reales de cada operación
   - **Por qué es mejor**: Los estimados pueden estar equivocados; los tiempos reales son la verdad

2. **Análisis de la tabla comparativa**:
   
   a) **`type = ALL` eliminado**:
      - **Antes**: Escaneos completos de tabla (muy costoso)
      - **Después**: Búsquedas por índice (`ref`, `range`)
      - **Impacto**: Puede reducir el tiempo de minutos a segundos en tablas grandes
   
   b) **`Using filesort` eliminado**:
      - **Antes**: Ordenación en disco (costoso)
      - **Después**: Datos ya ordenados del índice o ordenación más eficiente
      - **Impacto**: Eliminación de I/O de disco para ordenación
   
   c) **`Using temporary` eliminado**:
      - **Antes**: Creación de tablas temporales (memoria y I/O)
      - **Después**: Procesamiento directo sin tablas temporales
      - **Impacto**: Menor uso de memoria y menos I/O
   
   d) **Reducción de filas examinadas**:
      - **Antes**: Podría examinar 10,000+ filas
      - **Después**: Examina solo las filas relevantes (100-500)
      - **Impacto**: Reducción del 90-95% en filas procesadas
   
   e) **Tiempo de ejecución**:
      - **Mejora típica**: 50-90% de reducción
      - **En tablas grandes**: Puede pasar de minutos a milisegundos

3. **Validación de la estrategia**:
   - **Éxito**: Si vemos mejoras significativas, confirmamos que:
     - Identificamos correctamente los problemas
     - Aplicamos las soluciones apropiadas
     - Los índices se están usando eficientemente
   - **Fracaso parcial**: Si las mejoras son menores, puede significar:
     - Hay otros cuellos de botella que no identificamos
     - Los índices no se están usando (verificar con EXPLAIN)
     - La tabla es demasiado pequeña para que los índices marquen diferencia
     - Necesitamos optimizaciones adicionales

4. **Lecciones aprendidas**:
   - **Análisis primero**: Siempre analizar antes de optimizar
   - **Medición**: Medir antes y después para validar mejoras
   - **Índices estratégicos**: No todos los índices son iguales; algunos son mucho más efectivos
   - **Estadísticas actualizadas**: `ANALYZE TABLE` es esencial después de crear índices
   - **Iteración**: La optimización es un proceso iterativo; puede requerir múltiples rondas

5. **Próximos pasos posibles**:
   - Si aún hay problemas de rendimiento:
     - Considerar particionado de tablas grandes
     - Revisar la estructura de la consulta
     - Considerar materializar resultados en tablas de resumen
     - Analizar si necesitamos más índices o índices diferentes
   - Si el rendimiento es aceptable:
     - Documentar las optimizaciones realizadas
     - Monitorear el rendimiento en producción
     - Establecer alertas para detectar degradación

**Métricas de éxito típicas para esta actividad:**
- ✅ Reducción del 70-90% en tiempo de ejecución
- ✅ Eliminación de `type = ALL`
- ✅ Reducción del 80-95% en filas examinadas
- ✅ Uso visible de índices en todas las tablas principales
- ✅ Eliminación o reducción significativa de `Using filesort` y `Using temporary`

---

## Actividad 3: Monitorización de Rendimiento

### 🎯 Objetivo
Aprender a monitorear el rendimiento de un SGBD.

### ⏱️ Duración
25 minutos

### 📝 Tareas
1. Consulta las vistas del sistema para estadísticas
2. Identifica las tablas con más operaciones de lectura
3. Encuentra índices no utilizados
4. Analiza el uso de CPU y memoria
5. Genera un reporte de rendimiento

---

### 🔧 Solución Paso a Paso

#### Paso 1: Consultar las Vistas del Sistema para Estadísticas

```sql
-- 1.1. Estadísticas generales de tablas
SELECT 
    TABLE_NAME AS tabla,
    TABLE_ROWS AS filas_estimadas,
    DATA_LENGTH AS tamaño_datos_bytes,
    INDEX_LENGTH AS tamaño_indices_bytes,
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS tamaño_total_mb,
    AUTO_INCREMENT AS siguiente_auto_increment
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gestion_ventas'
ORDER BY TABLE_ROWS DESC;

-- 1.2. Estadísticas de índices
SELECT 
    TABLE_NAME AS tabla,
    INDEX_NAME AS indice,
    GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS columnas,
    CARDINALITY AS cardinalidad,
    INDEX_TYPE AS tipo_indice,
    ROUND((STAT_VALUE * @@innodb_page_size) / 1024 / 1024, 2) AS tamaño_mb
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'gestion_ventas'
GROUP BY TABLE_NAME, INDEX_NAME
ORDER BY TABLE_NAME, INDEX_NAME;

-- 1.3. Tamaño de tablas e índices (detallado)
SELECT 
    t.TABLE_NAME AS tabla,
    ROUND(t.DATA_LENGTH / 1024 / 1024, 2) AS tamaño_datos_mb,
    ROUND(t.INDEX_LENGTH / 1024 / 1024, 2) AS tamaño_indices_mb,
    ROUND((t.DATA_LENGTH + t.INDEX_LENGTH) / 1024 / 1024, 2) AS tamaño_total_mb,
    t.TABLE_ROWS AS filas_estimadas,
    COUNT(DISTINCT s.INDEX_NAME) AS numero_indices
FROM INFORMATION_SCHEMA.TABLES t
LEFT JOIN INFORMATION_SCHEMA.STATISTICS s 
    ON t.TABLE_SCHEMA = s.TABLE_SCHEMA 
    AND t.TABLE_NAME = s.TABLE_NAME
WHERE t.TABLE_SCHEMA = 'gestion_ventas'
GROUP BY t.TABLE_NAME, t.DATA_LENGTH, t.INDEX_LENGTH, t.TABLE_ROWS
ORDER BY (t.DATA_LENGTH + t.INDEX_LENGTH) DESC;
```

**📖 Explicación del Paso 1:**

Este paso nos proporciona una visión completa del estado de nuestra base de datos desde la perspectiva del sistema:

1. **Estadísticas generales de tablas (Consulta 1.1)**:
   - **`TABLE_ROWS`**: Número estimado de filas. Importante porque:
     - Tablas con muchas filas requieren más atención en optimización
     - Nos ayuda a priorizar qué tablas optimizar primero
     - Puede indicar tablas que necesitan limpieza o archiving
   - **`DATA_LENGTH` y `INDEX_LENGTH`**: Tamaños en bytes. Nos permiten:
     - Identificar tablas que ocupan mucho espacio
     - Calcular la relación datos/índices
     - Planificar el espacio en disco
   - **`AUTO_INCREMENT`**: Próximo valor. Útil para:
     - Entender el crecimiento de las tablas
     - Detectar posibles problemas de desbordamiento

2. **Estadísticas de índices (Consulta 1.2)**:
   - **`CARDINALITY`**: Número de valores únicos. Crítico porque:
     - Alta cardinalidad = índice muy útil (muchos valores únicos)
     - Baja cardinalidad = índice menos útil (pocos valores únicos, como columnas booleanas)
     - Cardinalidad 0 = índice sin datos o estadísticas desactualizadas
   - **`INDEX_TYPE`**: Tipo de índice (BTREE, HASH, etc.)
   - **Tamaño del índice**: Nos ayuda a entender el costo de mantener los índices

3. **Tamaño detallado (Consulta 1.3)**:
   - **Separación datos/índices**: Ver cuánto espacio ocupa cada uno
   - **Número de índices**: Identificar tablas con muchos índices (puede ralentizar escrituras)
   - **Análisis**: Nos permite identificar:
     - Tablas con índices desproporcionadamente grandes
     - Tablas que podrían beneficiarse de más índices
     - Tablas que tienen demasiados índices

4. **Por qué es importante este paso**:
   - **Contexto**: Antes de optimizar, necesitamos entender el estado actual
   - **Priorización**: Tablas grandes requieren más atención
   - **Planificación**: Nos ayuda a planificar espacio y recursos
   - **Baseline**: Establece un punto de referencia para comparar después de optimizaciones

5. **Interpretación de resultados**:
   - **Tabla grande con pocos índices**: Candidata para crear índices
   - **Tabla pequeña con muchos índices**: Puede tener índices innecesarios
   - **Índices con baja cardinalidad**: Pueden no ser muy útiles
   - **Índices grandes**: Ocupan espacio y ralentizan escrituras

#### Paso 2: Identificar las Tablas con Más Operaciones de Lectura

```sql
-- 2.1. Estadísticas de operaciones de lectura/escritura (MySQL 5.7+)
SELECT 
    OBJECT_SCHEMA AS base_datos,
    OBJECT_NAME AS tabla,
    COUNT_FETCH AS lecturas,
    COUNT_INSERT AS inserciones,
    COUNT_UPDATE AS actualizaciones,
    COUNT_DELETE AS eliminaciones
FROM performance_schema.table_io_waits_summary_by_table
WHERE OBJECT_SCHEMA = 'gestion_ventas'
ORDER BY COUNT_FETCH DESC;

-- 2.2. Ver índices y su uso
SHOW INDEX FROM pedidos;
SHOW INDEX FROM pedido_items;
SHOW INDEX FROM productos;

-- 2.3. Estadísticas de uso de índices (si está habilitado performance_schema)
SELECT 
    OBJECT_SCHEMA AS base_datos,
    OBJECT_NAME AS tabla,
    INDEX_NAME AS indice,
    COUNT_FETCH AS lecturas_indice,
    COUNT_INSERT AS inserciones,
    COUNT_UPDATE AS actualizaciones
FROM performance_schema.table_io_waits_summary_by_index_usage
WHERE OBJECT_SCHEMA = 'gestion_ventas'
ORDER BY COUNT_FETCH DESC;
```

**📖 Explicación del Paso 2:**

Este paso identifica qué tablas están siendo más utilizadas y cómo, lo cual es crucial para la optimización:

1. **Performance Schema (Consulta 2.1)**:
   - **`COUNT_FETCH`**: Número de operaciones de lectura (SELECT)
   - **`COUNT_INSERT`, `COUNT_UPDATE`, `COUNT_DELETE`**: Operaciones de escritura
   - **Por qué es importante**:
     - Identifica tablas "calientes" (muy utilizadas)
     - Tablas con muchas lecturas son candidatas prioritarias para índices
     - Tablas con muchas escrituras pueden tener demasiados índices
   - **Nota**: Performance Schema debe estar habilitado en MySQL

2. **`SHOW INDEX` (Consulta 2.2)**:
   - **Información detallada**: Muestra todos los índices de una tabla específica
   - **Columnas mostradas**:
     - Nombre del índice
     - Columnas incluidas
     - Cardinalidad
     - Tipo de índice
   - **Uso**: Verificación rápida de qué índices existen

3. **Estadísticas de uso de índices (Consulta 2.3)**:
   - **`COUNT_FETCH`**: Cuántas veces se usó el índice para lecturas
   - **`COUNT_INSERT`, `COUNT_UPDATE`**: Impacto en escrituras
   - **Análisis**: Permite identificar:
     - Índices muy utilizados (mantener y optimizar)
     - Índices nunca utilizados (candidatos para eliminación)
     - Índices que ralentizan escrituras sin beneficiar lecturas

4. **Estrategia basada en resultados**:
   - **Tabla con muchas lecturas y pocos índices**: Crear índices apropiados
   - **Tabla con muchas escrituras y muchos índices**: Considerar reducir índices
   - **Índice nunca usado**: Candidato para eliminación (ahorra espacio y mejora escrituras)
   - **Índice muy usado**: Asegurar que está optimizado

5. **Balance lectura/escritura**:
   - **Sistema de solo lectura**: Puedes tener muchos índices sin preocuparte
   - **Sistema con muchas escrituras**: Cada índice adicional ralentiza INSERT/UPDATE/DELETE
   - **Sistema balanceado**: Encontrar el equilibrio óptimo

#### Paso 3: Encontrar Índices No Utilizados

```sql
-- 3.1. Índices y su cardinalidad (índices con baja cardinalidad pueden ser problemáticos)
SELECT 
    TABLE_NAME AS tabla,
    INDEX_NAME AS indice,
    GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) AS columnas,
    CARDINALITY AS cardinalidad,
    CASE 
        WHEN CARDINALITY = 0 THEN '⚠️ Sin datos'
        WHEN CARDINALITY < 10 THEN '⚠️ Baja cardinalidad'
        ELSE '✅ OK'
    END AS estado
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'gestion_ventas'
GROUP BY TABLE_NAME, INDEX_NAME, CARDINALITY
ORDER BY TABLE_NAME, CARDINALITY;

-- 3.2. Ver todos los índices de una tabla específica
SHOW INDEX FROM pedidos;

-- 3.3. Identificar índices duplicados o redundantes
SELECT 
    s1.TABLE_NAME AS tabla,
    s1.INDEX_NAME AS indice1,
    s2.INDEX_NAME AS indice2,
    GROUP_CONCAT(DISTINCT s1.COLUMN_NAME ORDER BY s1.SEQ_IN_INDEX) AS columnas_comunes
FROM INFORMATION_SCHEMA.STATISTICS s1
INNER JOIN INFORMATION_SCHEMA.STATISTICS s2
    ON s1.TABLE_SCHEMA = s2.TABLE_SCHEMA
    AND s1.TABLE_NAME = s2.TABLE_NAME
    AND s1.INDEX_NAME < s2.INDEX_NAME
    AND s1.COLUMN_NAME = s2.COLUMN_NAME
WHERE s1.TABLE_SCHEMA = 'gestion_ventas'
GROUP BY s1.TABLE_NAME, s1.INDEX_NAME, s2.INDEX_NAME
HAVING COUNT(DISTINCT s1.COLUMN_NAME) > 0;
```

**📖 Explicación del Paso 3:**

Este paso identifica índices que no están aportando valor y pueden ser eliminados:

1. **Análisis de cardinalidad (Consulta 3.1)**:
   - **Cardinalidad 0**: 
     - Índice sin datos o estadísticas desactualizadas
     - Ejecutar `ANALYZE TABLE` para actualizar
     - Si sigue siendo 0, el índice puede ser innecesario
   - **Baja cardinalidad (<10)**:
     - Pocos valores únicos (ej: columna booleana con solo TRUE/FALSE)
     - El índice puede no ser muy útil
     - Considerar si realmente necesitas el índice
   - **Alta cardinalidad**: 
     - Muchos valores únicos
     - Índice muy útil
     - Mantener y optimizar

2. **`SHOW INDEX` (Consulta 3.2)**:
   - **Verificación manual**: Permite ver todos los índices de una tabla
   - **Análisis visual**: A veces es más fácil ver la información en formato tabla
   - **Uso**: Cuando necesitas información detallada sobre índices específicos

3. **Índices duplicados o redundantes (Consulta 3.3)**:
   - **Problema**: Tener múltiples índices que cubren las mismas columnas
   - **Ejemplo**: 
     - `idx1` en `(columna_a, columna_b)`
     - `idx2` en `(columna_a)`
     - `idx2` es redundante porque `idx1` ya cubre `columna_a`
   - **Impacto**: 
     - Desperdicia espacio
     - Ralentiza escrituras innecesariamente
     - Confunde al optimizador
   - **Solución**: Eliminar índices redundantes, mantener solo el más completo

4. **Estrategia de limpieza**:
   - **Paso 1**: Identificar índices con cardinalidad 0 o muy baja
   - **Paso 2**: Verificar si realmente se usan (Performance Schema)
   - **Paso 3**: Identificar redundancias
   - **Paso 4**: Eliminar índices innecesarios (con cuidado, probar primero)
   - **Paso 5**: Monitorear impacto después de eliminar

5. **Precauciones**:
   - **No eliminar sin verificar**: Un índice puede ser útil para consultas específicas
   - **Probar en desarrollo**: Siempre probar cambios en un entorno de prueba primero
   - **Monitorear después**: Verificar que el rendimiento no se degrade
   - **Backup**: Tener un plan para recrear el índice si es necesario

6. **Beneficios de eliminar índices innecesarios**:
   - **Espacio**: Libera espacio en disco
   - **Escrituras más rápidas**: Menos índices = menos mantenimiento en INSERT/UPDATE/DELETE
   - **Optimizador más eficiente**: Menos opciones = decisiones más rápidas
   - **Mantenimiento**: Menos índices = menos trabajo para ANALYZE TABLE

#### Paso 4: Analizar el Uso de CPU y Memoria

```sql
-- 4.1. Consultas activas y su uso de recursos
SHOW PROCESSLIST;

-- 4.2. Consultas que más tiempo llevan ejecutándose
SELECT 
    ID,
    USER,
    HOST,
    DB,
    COMMAND,
    TIME AS tiempo_segundos,
    STATE,
    LEFT(INFO, 100) AS consulta_preview
FROM INFORMATION_SCHEMA.PROCESSLIST
WHERE COMMAND != 'Sleep'
  AND TIME > 5
ORDER BY TIME DESC;

-- 4.3. Estadísticas de conexiones
SELECT 
    COMMAND,
    COUNT(*) AS cantidad,
    MAX(TIME) AS max_tiempo_segundos,
    AVG(TIME) AS avg_tiempo_segundos
FROM INFORMATION_SCHEMA.PROCESSLIST
WHERE DB = 'gestion_ventas' OR DB IS NULL
GROUP BY COMMAND
ORDER BY cantidad DESC;

-- 4.4. Uso de memoria y buffers (MySQL)
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
SHOW VARIABLES LIKE 'key_buffer_size';
SHOW VARIABLES LIKE 'query_cache_size';
SHOW VARIABLES LIKE 'tmp_table_size';
SHOW VARIABLES LIKE 'max_heap_table_size';

-- 4.5. Estado del servidor
SHOW STATUS LIKE 'Threads_connected';
SHOW STATUS LIKE 'Threads_running';
SHOW STATUS LIKE 'Questions';
SHOW STATUS LIKE 'Slow_queries';
SHOW STATUS LIKE 'Created_tmp_tables';
SHOW STATUS LIKE 'Created_tmp_disk_tables';
```

**📖 Explicación del Paso 4:**

Este paso analiza el uso de recursos del servidor MySQL, lo cual es esencial para identificar problemas de rendimiento:

1. **`SHOW PROCESSLIST` (Consulta 4.1)**:
   - **Qué muestra**: Todas las conexiones y consultas activas en el servidor
   - **Información clave**:
     - `ID`: Identificador de la conexión
     - `USER`: Usuario que ejecuta la consulta
     - `HOST`: Desde dónde se conecta
     - `DB`: Base de datos en uso
     - `COMMAND`: Tipo de comando (Query, Sleep, etc.)
     - `TIME`: Tiempo que lleva ejecutándose
     - `STATE`: Estado actual de la consulta
     - `INFO`: La consulta SQL (primeros 100 caracteres)
   - **Uso**: Identificar consultas que están bloqueando o tomando mucho tiempo

2. **Consultas de larga duración (Consulta 4.2)**:
   - **Filtro `TIME > 5`**: Solo muestra consultas que llevan más de 5 segundos
   - **Por qué es importante**: 
     - Consultas de larga duración pueden indicar problemas
     - Pueden estar bloqueando otras consultas
     - Pueden consumir muchos recursos
   - **Acción**: Investigar estas consultas y optimizarlas

3. **Estadísticas de conexiones (Consulta 4.3)**:
   - **Agrupación por COMMAND**: Muestra cuántas conexiones hay de cada tipo
   - **Métricas**:
     - `cantidad`: Número de conexiones de cada tipo
     - `max_tiempo_segundos`: La consulta más larga de cada tipo
     - `avg_tiempo_segundos`: Tiempo promedio
   - **Análisis**: 
     - Muchas conexiones "Sleep" pueden indicar problemas de conexión
     - Muchas consultas activas pueden indicar carga alta
     - Tiempos altos pueden indicar problemas de rendimiento

4. **Variables de memoria (Consulta 4.4)**:
   - **`innodb_buffer_pool_size`**: Tamaño del buffer pool de InnoDB (memoria principal para datos)
   - **`key_buffer_size`**: Buffer para índices MyISAM (si se usan)
   - **`query_cache_size`**: Tamaño de la caché de consultas (deprecado en MySQL 8.0)
   - **`tmp_table_size`**: Tamaño máximo de tablas temporales en memoria
   - **`max_heap_table_size`**: Tamaño máximo de tablas en memoria
   - **Análisis**: 
     - Valores muy pequeños pueden causar problemas de rendimiento
     - Valores muy grandes pueden desperdiciar memoria
     - Deben ajustarse según los recursos disponibles

5. **Estado del servidor (Consulta 4.5)**:
   - **`Threads_connected`**: Número de conexiones activas
   - **`Threads_running`**: Número de hilos ejecutando consultas
   - **`Questions`**: Número total de consultas ejecutadas
   - **`Slow_queries`**: Número de consultas lentas (requiere slow query log habilitado)
   - **`Created_tmp_tables`**: Número de tablas temporales creadas en memoria
   - **`Created_tmp_disk_tables`**: Número de tablas temporales creadas en disco
   - **Interpretación**:
     - Muchas tablas temporales en disco = problema de rendimiento (memoria insuficiente)
     - Muchas consultas lentas = necesidad de optimización
     - Muchas conexiones = posible problema de conexión o carga alta

6. **Identificación de problemas**:
   - **Alto uso de CPU**: Muchas consultas activas simultáneamente
   - **Alto uso de memoria**: Tablas temporales grandes, buffer pool pequeño
   - **Consultas bloqueadas**: Consultas de larga duración bloqueando otras
   - **I/O alto**: Muchas tablas temporales en disco

7. **Acciones correctivas**:
   - **Consultas lentas**: Optimizar usando técnicas de las actividades anteriores
   - **Memoria insuficiente**: Aumentar `tmp_table_size` o `innodb_buffer_pool_size`
   - **Muchas conexiones**: Revisar configuración de conexiones, usar connection pooling
   - **Tablas temporales en disco**: Optimizar consultas para evitar tablas temporales o aumentar memoria

#### Paso 5: Generar un Reporte de Rendimiento

```sql
-- 5.1. Reporte completo de rendimiento
SELECT 
    '=== REPORTE DE RENDIMIENTO ===' AS seccion,
    '' AS detalle
UNION ALL
SELECT 
    'Tablas ordenadas por tamaño:' AS seccion,
    CONCAT(TABLE_NAME, ' (', ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2), ' MB)') AS detalle
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gestion_ventas'
ORDER BY (DATA_LENGTH + INDEX_LENGTH) DESC
LIMIT 5
UNION ALL
SELECT 
    'Total de índices:' AS seccion,
    COUNT(*) AS detalle
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'gestion_ventas'
  AND INDEX_NAME != 'PRIMARY';

-- 5.2. Reporte detallado en formato tabla
SELECT 
    'TABLA' AS tipo,
    TABLE_NAME AS nombre,
    TABLE_ROWS AS metricas,
    CONCAT(ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2), ' MB') AS tamaño,
    CASE 
        WHEN TABLE_ROWS > 1000 THEN '⚠️ Gran volumen'
        ELSE '✅ OK'
    END AS estado
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gestion_ventas'
UNION ALL
SELECT 
    'ÍNDICE' AS tipo,
    CONCAT(TABLE_NAME, '.', INDEX_NAME) AS nombre,
    CARDINALITY AS metricas,
    '' AS tamaño,
    CASE 
        WHEN CARDINALITY = 0 THEN '❌ Sin datos'
        WHEN CARDINALITY < 10 THEN '⚠️ Baja cardinalidad'
        ELSE '✅ OK'
    END AS estado
FROM (
    SELECT TABLE_NAME, INDEX_NAME, MAX(CARDINALITY) AS CARDINALITY
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE TABLE_SCHEMA = 'gestion_ventas'
    GROUP BY TABLE_NAME, INDEX_NAME
) AS idx_stats
ORDER BY tipo, estado, nombre;

-- 5.3. Recomendaciones de optimización
SELECT 
    'RECOMENDACIÓN' AS tipo,
    CASE 
        WHEN TABLE_ROWS > 1000 AND INDEX_LENGTH = 0 THEN CONCAT('Crear índices en: ', TABLE_NAME)
        WHEN DATA_LENGTH > 10485760 THEN CONCAT('Considerar particionado en: ', TABLE_NAME)
        WHEN TABLE_ROWS = 0 THEN CONCAT('Tabla vacía: ', TABLE_NAME)
        ELSE CONCAT('Sin recomendaciones para: ', TABLE_NAME)
    END AS recomendacion
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gestion_ventas'
  AND (
    (TABLE_ROWS > 1000 AND INDEX_LENGTH = 0)
    OR (DATA_LENGTH > 10485760)
    OR (TABLE_ROWS = 0)
  );
```

---

## 📊 Resumen de Aprendizajes

### Actividad 1: Análisis de Planes de Ejecución
- ✅ Aprendimos a usar `EXPLAIN` y `EXPLAIN ANALYZE` en MySQL
- ✅ Identificamos operaciones costosas (type = ALL, Using filesort, Using temporary)
- ✅ Creamos índices estratégicos para optimizar consultas
- ✅ Medimos mejoras en tiempo de ejecución

### Actividad 2: Optimización de Consultas
- ✅ Identificamos consultas lentas y sus problemas
- ✅ Analizamos estadísticas usando `INFORMATION_SCHEMA`
- ✅ Reescribimos consultas usando CTEs y optimizaciones
- ✅ Creamos índices compuestos y estratégicos
- ✅ Medimos mejoras significativas en rendimiento

### Actividad 3: Monitorización de Rendimiento
- ✅ Consultamos `INFORMATION_SCHEMA` para estadísticas
- ✅ Identificamos tablas con problemas de rendimiento
- ✅ Encontramos índices con baja cardinalidad
- ✅ Analizamos uso de recursos (CPU, memoria) con `SHOW STATUS`
- ✅ Generamos reportes de rendimiento

---

## 🔧 Comandos Útiles Adicionales para MySQL

```sql
-- Actualizar estadísticas manualmente
ANALYZE TABLE nombre_tabla;

-- Optimizar tabla (reorganiza y actualiza estadísticas)
OPTIMIZE TABLE nombre_tabla;

-- Ver configuración del optimizador
SHOW VARIABLES LIKE 'optimizer_switch';
SHOW VARIABLES LIKE 'join_buffer_size';
SHOW VARIABLES LIKE 'sort_buffer_size';

-- Ver consultas lentas (si está habilitado slow query log)
SHOW VARIABLES LIKE 'slow_query_log';
SHOW VARIABLES LIKE 'long_query_time';

-- Ver uso de índices en una consulta específica
EXPLAIN FORMAT=JSON SELECT ...;

-- Ver estadísticas de una tabla específica
SHOW TABLE STATUS LIKE 'nombre_tabla';

-- Ver índices de una tabla
SHOW INDEX FROM nombre_tabla;

-- Ver procesos y consultas activas
SHOW FULL PROCESSLIST;

-- Ver variables de rendimiento
SHOW STATUS LIKE 'Innodb%';
SHOW STATUS LIKE 'Handler%';
```

---

## 📝 Notas Importantes sobre MySQL

1. **EXPLAIN ANALYZE**: Disponible desde MySQL 8.0.18+
2. **CTEs (WITH)**: Disponible desde MySQL 8.0+
3. **CHECK constraints**: Disponible desde MySQL 8.0.16+
4. **Performance Schema**: Debe estar habilitado para algunas estadísticas avanzadas
5. **Índices parciales**: MySQL no soporta índices parciales con WHERE directamente

---

**¡Felicidades! Has completado las tres actividades de refuerzo del Tema 9 usando MySQL.** 🎉
