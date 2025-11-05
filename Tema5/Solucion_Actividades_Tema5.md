# Soluciones Completas - Actividades de Refuerzo Tema 5
## Bases de Datos Distribuidas

---

## Actividad 2: Diseño de Sistema Distribuido

### 📋 Información de la Actividad

- **Duración:** 30-45 minutos
- **Objetivo:** Diseñar un sistema de bases de datos distribuido para una empresa multinacional
- **Modalidad:** Individual o en equipos de 2-3 personas

---

### 🎯 Escenario

Una empresa multinacional tiene oficinas en 3 continentes (Europa, América, Asia) y necesita implementar un sistema de bases de datos distribuido que cumpla con los siguientes requisitos:

- **Acceso rápido a datos locales:** Los empleados de cada región deben acceder rápidamente a los datos de su región
- **Disponibilidad ante fallos:** El sistema debe continuar operando aunque un nodo falle
- **Consistencia de datos globales:** Los datos críticos deben estar sincronizados entre regiones

### 📊 Contexto del Sistema

La empresa maneja los siguientes tipos de datos:

1. **Datos de Empleados:**
   - Información personal (nombre, email, teléfono)
   - Información laboral (departamento, salario, cargo)
   - Historial de evaluación

2. **Datos de Productos:**
   - Información del producto (nombre, descripción, precio)
   - Inventario por región
   - Pedidos y ventas

3. **Datos de Clientes:**
   - Información de contacto
   - Historial de compras
   - Preferencias y segmentación

4. **Datos Financieros:**
   - Transacciones
   - Reportes contables
   - Presupuestos por región

---

### ✅ Solución Completa

#### Tarea 1: Identificación del Tipo de Fragmentación

**Análisis:**

Para este escenario, se recomienda una **fragmentación horizontal mixta con replicación selectiva**.

**Estrategia de Fragmentación:**

1. **Fragmentación Horizontal por Región:**
   - **Tabla `productos`:** Fragmentada horizontalmente por región
     - `productos_europa` (Nodo Europa)
     - `productos_america` (Nodo América)
     - `productos_asia` (Nodo Asia)
   - **Tabla `empleados`:** Fragmentada horizontalmente por región
     - `empleados_europa` (Nodo Europa)
     - `empleados_america` (Nodo América)
     - `empleados_asia` (Nodo Asia)

2. **Fragmentación Vertical para Datos de Empleados:**
   - **Nodo Local (cada región):**
     - `empleados_basicos` (id, nombre, email, telefono, departamento, region)
     - **Nodo Central (América - HQ):**
     - `empleados_completos` (id, salario, evaluacion, fecha_contratacion)

3. **Datos No Fragmentados (Pequeños Volúmenes):**
   - Tablas de configuración (catálogos, parámetros)
   - Tablas de referencia (departamentos, categorías)

**Justificación:**

- **Fragmentación horizontal:** Los datos de cada región se acceden principalmente desde esa región, reduciendo latencia
- **Fragmentación vertical:** Separa datos sensibles (salarios) de datos frecuentes (contacto)
- **Datos centralizados:** Catálogos pequeños que se actualizan poco se mantienen en un solo lugar

**Código de Implementación:**

```sql
-- ============================================
-- CONFIGURACIÓN DE FRAGMENTACIÓN HORIZONTAL
-- ============================================

-- NODO EUROPA
CREATE TABLE productos_europa AS
SELECT * FROM productos 
WHERE region = 'Europa';

CREATE TABLE empleados_europa AS
SELECT * FROM empleados 
WHERE region = 'Europa';

CREATE TABLE clientes_europa AS
SELECT * FROM clientes 
WHERE region = 'Europa';

-- NODO AMÉRICA
CREATE TABLE productos_america AS
SELECT * FROM productos 
WHERE region = 'America';

CREATE TABLE empleados_america AS
SELECT * FROM empleados 
WHERE region = 'America';

CREATE TABLE clientes_america AS
SELECT * FROM clientes 
WHERE region = 'America';

-- NODO ASIA
CREATE TABLE productos_asia AS
SELECT * FROM productos 
WHERE region = 'Asia';

CREATE TABLE empleados_asia AS
SELECT * FROM empleados 
WHERE region = 'Asia';

CREATE TABLE clientes_asia AS
SELECT * FROM clientes 
WHERE region = 'Asia';

-- ============================================
-- CONFIGURACIÓN DE FRAGMENTACIÓN VERTICAL
-- ============================================

-- NODO LOCAL (cada región tiene su propia copia)
CREATE TABLE empleados_basicos_europa AS
SELECT id, nombre, email, telefono, departamento_id, region
FROM empleados_europa;

CREATE TABLE empleados_basicos_america AS
SELECT id, nombre, email, telefono, departamento_id, region
FROM empleados_america;

CREATE TABLE empleados_basicos_asia AS
SELECT id, nombre, email, telefono, departamento_id, region
FROM empleados_asia;

-- NODO CENTRAL (solo en América - HQ)
CREATE TABLE empleados_completos AS
SELECT id, salario, evaluacion_anual, fecha_contratacion, 
       nivel_seguridad, beneficios
FROM empleados_europa
UNION ALL
SELECT id, salario, evaluacion_anual, fecha_contratacion,
       nivel_seguridad, beneficios
FROM empleados_america
UNION ALL
SELECT id, salario, evaluacion_anual, fecha_contratacion,
       nivel_seguridad, beneficios
FROM empleados_asia;

-- ============================================
-- VISTAS DISTRIBUIDAS PARA TRANSPARENCIA
-- ============================================

-- Vista lógica para productos (transparencia de fragmentación)
CREATE VIEW productos_completos AS
SELECT * FROM productos_europa@nodo_europa
UNION ALL
SELECT * FROM productos_america@nodo_america
UNION ALL
SELECT * FROM productos_asia@nodo_asia;

-- Vista lógica para empleados completos
CREATE VIEW empleados_completos_view AS
SELECT 
    e.id, e.nombre, e.email, e.telefono, e.departamento_id, e.region,
    c.salario, c.evaluacion_anual, c.fecha_contratacion
FROM (
    SELECT * FROM empleados_basicos_europa@nodo_europa
    UNION ALL
    SELECT * FROM empleados_basicos_america@nodo_america
    UNION ALL
    SELECT * FROM empleados_basicos_asia@nodo_asia
) e
LEFT JOIN empleados_completos@nodo_america c ON e.id = c.id;
```

---

#### Tarea 2: Estrategia de Replicación

**Análisis de Requerimientos:**

- **Datos críticos:** Requieren alta disponibilidad → Replicación
- **Datos sensibles:** Información financiera → Replicación con cifrado
- **Datos de solo lectura:** Catálogos → Replicación completa

**Estrategia de Replicación:**

1. **Replicación Master-Slave para Datos Críticos:**
   - **Datos Financieros:** Master en América (HQ), réplicas en Europa y Asia (solo lectura)
   - **Catálogos:** Master en América, réplicas en todas las regiones

2. **Replicación Master-Master para Datos de Productos:**
   - Cada región es master de sus productos
   - Réplicas en otras regiones para consultas cruzadas

3. **Sin Replicación:**
   - Datos locales de empleados (solo fragmentación vertical)
   - Logs y datos temporales

**Configuración de Replicación:**

```sql
-- ============================================
-- CONFIGURACIÓN DE RÉPLICAS PARA DATOS FINANCIEROS
-- ============================================

-- MASTER (Nodo América - HQ)
-- Tabla de transacciones financieras
CREATE TABLE transacciones_financieras (
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    tipo VARCHAR(50),
    monto DECIMAL(15,2),
    region VARCHAR(50),
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Configuración de replicación MASTER-SLAVE
-- (PostgreSQL ejemplo)
-- Master: postgresql.conf
wal_level = replica
max_wal_senders = 3
max_replication_slots = 3

-- Slave (Europa y Asia): Solo lectura
-- recovery.conf
standby_mode = 'on'
primary_conninfo = 'host=america_hq port=5432 user=replicator'

-- ============================================
-- CONFIGURACIÓN DE RÉPLICAS PARA CATÁLOGOS
-- ============================================

-- Master (América): Tabla de categorías de productos
CREATE TABLE categorias_productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    activa BOOLEAN DEFAULT true
);

-- Réplicas en todos los nodos (solo lectura)
-- Configuración similar a transacciones financieras

-- ============================================
-- CONFIGURACIÓN DE RÉPLICAS MASTER-MASTER
-- ============================================

-- Para productos: Cada región tiene su master
-- Europa puede escribir en productos_europa
-- América puede escribir en productos_america
-- Asia puede escribir en productos_asia

-- Configuración de replicación bidireccional
-- (Requiere configuración avanzada en PostgreSQL o uso de herramientas especializadas)

-- ============================================
-- ESTRATEGIA DE RESOLUCIÓN DE CONFLICTOS
-- ============================================

-- Para réplicas master-master, definir política de resolución:
-- 1. Último timestamp gana (Last Write Wins)
-- 2. Región con prioridad más alta gana
-- 3. Merge manual para casos especiales

CREATE FUNCTION resolve_conflict(
    p_record_id INTEGER,
    p_region VARCHAR(50),
    p_timestamp TIMESTAMP
) RETURNS BOOLEAN AS $$
DECLARE
    v_priority INTEGER;
    v_existing_timestamp TIMESTAMP;
BEGIN
    -- Prioridad: América > Europa > Asia
    SELECT CASE 
        WHEN p_region = 'America' THEN 3
        WHEN p_region = 'Europa' THEN 2
        WHEN p_region = 'Asia' THEN 1
        ELSE 0
    END INTO v_priority;
    
    SELECT updated_at INTO v_existing_timestamp
    FROM productos_completos
    WHERE id = p_record_id;
    
    -- Si la región tiene mayor prioridad O mismo timestamp pero más reciente
    IF v_priority > current_priority OR 
       (v_priority = current_priority AND p_timestamp > v_existing_timestamp) THEN
        RETURN TRUE; -- Aceptar cambio
    ELSE
        RETURN FALSE; -- Rechazar cambio
    END IF;
END;
$$ LANGUAGE plpgsql;
```

**Diagrama de Replicación:**

```
                    [MASTER]
                   América (HQ)
                  /     |     \
                 /      |      \
          [SLAVE]    [SLAVE]  [SLAVE]
         Europa    América   Asia
         (lectura) (escritura) (lectura)
         
         Datos Financieros: Master-Slave
         
         ──────────────────────────────────
         
    [MASTER]      [MASTER]      [MASTER]
    Europa        América       Asia
      |              |             |
      ├──────────────┴─────────────┤
      │      Réplicas (lectura)     │
      │    para consultas cruzadas   │
      
      Productos: Master-Master por región
```

---

#### Tarea 3: Estrategia de Transparencia

**Grados de Transparencia Implementados:**

1. **Transparencia de Fragmentación:**
   - Los usuarios acceden a `productos_completos` sin conocer la fragmentación
   - Vista lógica oculta la fragmentación horizontal

2. **Transparencia de Réplica:**
   - Sistema automáticamente selecciona la réplica más cercana para lecturas
   - Actualizaciones se propagan automáticamente

3. **Transparencia de Ubicación:**
   - Los usuarios no necesitan conocer en qué nodo están los datos
   - Database links se manejan automáticamente

**Implementación de Transparencia:**

```sql
-- ============================================
-- VISTAS PARA TRANSPARENCIA DE FRAGMENTACIÓN
-- ============================================

-- Vista unificada para productos
CREATE VIEW productos AS
SELECT * FROM productos_europa@nodo_europa
UNION ALL
SELECT * FROM productos_america@nodo_america
UNION ALL
SELECT * FROM productos_asia@nodo_asia;

-- Vista unificada para empleados
CREATE VIEW empleados AS
SELECT 
    e.id, e.nombre, e.email, e.telefono, 
    e.departamento_id, e.region,
    c.salario, c.evaluacion_anual, c.fecha_contratacion
FROM (
    SELECT * FROM empleados_basicos_europa@nodo_europa
    UNION ALL
    SELECT * FROM empleados_basicos_america@nodo_america
    UNION ALL
    SELECT * FROM empleados_basicos_asia@nodo_asia
) e
LEFT JOIN empleados_completos@nodo_america c ON e.id = c.id;

-- ============================================
-- FUNCIÓN PARA SELECCIÓN AUTOMÁTICA DE RÉPLICA
-- ============================================

CREATE OR REPLACE FUNCTION get_nearest_replica(
    p_table_name VARCHAR,
    p_region VARCHAR
) RETURNS VARCHAR AS $$
DECLARE
    v_replica_node VARCHAR;
BEGIN
    -- Seleccionar réplica más cercana basada en región
    SELECT CASE 
        WHEN p_region = 'Europa' THEN 'nodo_europa'
        WHEN p_region = 'America' THEN 'nodo_america'
        WHEN p_region = 'Asia' THEN 'nodo_asia'
        ELSE 'nodo_america' -- Default: HQ
    END INTO v_replica_node;
    
    RETURN v_replica_node;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- PROCEDIMIENTO PARA CONSULTAS TRANSPARENTES
-- ============================================

CREATE OR REPLACE FUNCTION query_distributed(
    p_query TEXT,
    p_region VARCHAR DEFAULT 'America'
) RETURNS TABLE(result JSON) AS $$
DECLARE
    v_node VARCHAR;
    v_executed_query TEXT;
BEGIN
    -- Determinar nodo más cercano
    v_node := get_nearest_replica('', p_region);
    
    -- Ejecutar consulta en nodo apropiado
    -- (Esto requiere configuración específica del SGBD)
    EXECUTE p_query;
    
    RETURN QUERY SELECT json_build_object('result', 'success');
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- TRIGGERS PARA TRANSPARENCIA DE RÉPLICA
-- ============================================

-- Trigger para propagar actualizaciones automáticamente
CREATE OR REPLACE FUNCTION propagate_update()
RETURNS TRIGGER AS $$
BEGIN
    -- Actualizar en master
    -- Luego propagar a réplicas
    -- (Implementación depende del SGBD)
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER productos_update_trigger
AFTER UPDATE ON productos
FOR EACH ROW
EXECUTE FUNCTION propagate_update();
```

**Ejemplo de Uso para Usuarios:**

```sql
-- Los usuarios solo necesitan hacer:
SELECT * FROM productos WHERE categoria = 'Electrónica';

-- El sistema automáticamente:
-- 1. Determina qué fragmentos contienen los datos
-- 2. Selecciona las réplicas más cercanas
-- 3. Combina los resultados
-- 4. Devuelve resultado unificado

-- Sin que el usuario sepa que:
-- - Los datos están fragmentados en 3 nodos
-- - Hay réplicas en múltiples ubicaciones
-- - La consulta se ejecuta en paralelo
```

---

#### Tarea 4: Plan de Recuperación ante Fallos

**Estrategia de Recuperación:**

1. **Detección de Fallos:**
   - Heartbeat cada 5 segundos entre nodos
   - Timeout de 15 segundos para considerar fallo
   - Verificación cruzada con otros nodos

2. **Reconfiguración Automática:**
   - Failover automático a réplicas
   - Redirección de tráfico
   - Actualización de routing tables

3. **Recuperación:**
   - Sincronización de datos desde réplicas
   - Replay de transacciones desde logs
   - Validación de integridad

**Implementación del Plan:**

```sql
-- ============================================
-- SISTEMA DE DETECCIÓN DE FALLOS
-- ============================================

-- Tabla de estado de nodos
CREATE TABLE nodos_estado (
    nodo_id VARCHAR(50) PRIMARY KEY,
    region VARCHAR(50),
    estado VARCHAR(20), -- 'activo', 'inactivo', 'degradado'
    ultimo_heartbeat TIMESTAMP,
    latencia_ms INTEGER,
    capacidad_carga INTEGER
);

-- Procedimiento de heartbeat
CREATE OR REPLACE FUNCTION heartbeat_check()
RETURNS VOID AS $$
DECLARE
    v_nodo RECORD;
    v_timeout INTERVAL := '15 seconds';
BEGIN
    -- Verificar cada nodo
    FOR v_nodo IN SELECT * FROM nodos_estado LOOP
        IF NOW() - v_nodo.ultimo_heartbeat > v_timeout THEN
            -- Marcar nodo como inactivo
            UPDATE nodos_estado 
            SET estado = 'inactivo'
            WHERE nodo_id = v_nodo.nodo_id;
            
            -- Iniciar procedimiento de failover
            PERFORM initiate_failover(v_nodo.nodo_id);
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Ejecutar heartbeat cada 5 segundos
-- (Requiere configuración de cron job o scheduler)

-- ============================================
-- PROCEDIMIENTO DE FAILOVER
-- ============================================

CREATE OR REPLACE FUNCTION initiate_failover(
    p_failed_node VARCHAR
) RETURNS VOID AS $$
DECLARE
    v_replica_node VARCHAR;
    v_region VARCHAR;
BEGIN
    -- Obtener región del nodo fallido
    SELECT region INTO v_region
    FROM nodos_estado
    WHERE nodo_id = p_failed_node;
    
    -- Seleccionar réplica disponible
    SELECT nodo_id INTO v_replica_node
    FROM nodos_estado
    WHERE region = v_region 
      AND estado = 'activo'
      AND nodo_id != p_failed_node
    ORDER BY capacidad_carga DESC
    LIMIT 1;
    
    IF v_replica_node IS NULL THEN
        RAISE EXCEPTION 'No hay réplicas disponibles para failover';
    END IF;
    
    -- Actualizar routing
    UPDATE routing_table
    SET nodo_activo = v_replica_node
    WHERE nodo_original = p_failed_node;
    
    -- Promover réplica a master
    -- (Depende de configuración específica del SGBD)
    PERFORM promote_replica_to_master(v_replica_node);
    
    -- Log del evento
    INSERT INTO eventos_sistema (tipo, descripcion, timestamp)
    VALUES ('failover', 
            'Failover iniciado: ' || p_failed_node || ' -> ' || v_replica_node,
            NOW());
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- SISTEMA DE RECUPERACIÓN
-- ============================================

CREATE OR REPLACE FUNCTION recover_node(
    p_node_id VARCHAR
) RETURNS VOID AS $$
DECLARE
    v_last_checkpoint TIMESTAMP;
    v_replica_node VARCHAR;
BEGIN
    -- Obtener último checkpoint
    SELECT MAX(checkpoint_time) INTO v_last_checkpoint
    FROM checkpoints
    WHERE nodo_id = p_node_id;
    
    -- Obtener réplica más actualizada
    SELECT nodo_id INTO v_replica_node
    FROM nodos_estado
    WHERE region = (SELECT region FROM nodos_estado WHERE nodo_id = p_node_id)
      AND estado = 'activo'
      AND nodo_id != p_node_id
    ORDER BY ultimo_heartbeat DESC
    LIMIT 1;
    
    -- Sincronizar datos desde réplica
    PERFORM sync_from_replica(p_node_id, v_replica_node, v_last_checkpoint);
    
    -- Replay de transacciones desde logs
    PERFORM replay_transactions(p_node_id, v_last_checkpoint);
    
    -- Validar integridad
    PERFORM validate_data_integrity(p_node_id);
    
    -- Marcar nodo como recuperado
    UPDATE nodos_estado
    SET estado = 'activo',
        ultimo_heartbeat = NOW()
    WHERE nodo_id = p_node_id;
    
    -- Log del evento
    INSERT INTO eventos_sistema (tipo, descripcion, timestamp)
    VALUES ('recovery', 
            'Nodo recuperado: ' || p_node_id,
            NOW());
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- SISTEMA DE CHECKPOINTING
-- ============================================

CREATE TABLE checkpoints (
    checkpoint_id SERIAL PRIMARY KEY,
    nodo_id VARCHAR(50),
    checkpoint_time TIMESTAMP,
    lsn VARCHAR(100), -- Log Sequence Number
    datos_size BIGINT,
    estado VARCHAR(20)
);

-- Procedimiento de checkpoint
CREATE OR REPLACE FUNCTION create_checkpoint(
    p_node_id VARCHAR
) RETURNS VOID AS $$
BEGIN
    -- Crear checkpoint cada hora
    INSERT INTO checkpoints (nodo_id, checkpoint_time, lsn, estado)
    VALUES (
        p_node_id,
        NOW(),
        (SELECT pg_current_wal_lsn()), -- PostgreSQL específico
        'completado'
    );
    
    -- Limpiar checkpoints antiguos (mantener últimos 7 días)
    DELETE FROM checkpoints
    WHERE checkpoint_time < NOW() - INTERVAL '7 days';
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- SISTEMA DE SINCRONIZACIÓN
-- ============================================

CREATE OR REPLACE FUNCTION sync_from_replica(
    p_target_node VARCHAR,
    p_source_node VARCHAR,
    p_since TIMESTAMP
) RETURNS VOID AS $$
BEGIN
    -- Sincronizar datos desde réplica
    -- (Implementación específica del SGBD)
    
    -- Ejemplo para PostgreSQL:
    -- 1. Usar pg_basebackup para copia base
    -- 2. Aplicar WAL logs desde p_since
    -- 3. Verificar integridad
    
    -- Para este ejemplo, mostramos la lógica:
    RAISE NOTICE 'Sincronizando nodo % desde nodo % desde %', 
                 p_target_node, p_source_node, p_since;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- VALIDACIÓN DE INTEGRIDAD
-- ============================================

CREATE OR REPLACE FUNCTION validate_data_integrity(
    p_node_id VARCHAR
) RETURNS BOOLEAN AS $$
DECLARE
    v_checksum_expected BIGINT;
    v_checksum_actual BIGINT;
BEGIN
    -- Calcular checksum de datos críticos
    SELECT SUM(hashtext(id::text || nombre || monto::text))
    INTO v_checksum_expected
    FROM transacciones_financieras@nodo_america; -- Master
    
    SELECT SUM(hashtext(id::text || nombre || monto::text))
    INTO v_checksum_actual
    FROM transacciones_financieras@nodo_america; -- Nodo recuperado
    
    IF v_checksum_expected = v_checksum_actual THEN
        RETURN TRUE;
    ELSE
        RAISE EXCEPTION 'Integridad de datos no válida en nodo %', p_node_id;
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;
```

**Flujo de Recuperación:**

```
┌─────────────────────────────────────────┐
│  1. DETECCIÓN DE FALLO                  │
│     - Heartbeat timeout                 │
│     - Verificación cruzada              │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  2. RECONFIGURACIÓN                     │
│     - Seleccionar réplica disponible    │
│     - Actualizar routing table          │
│     - Promover réplica a master         │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  3. OPERACIÓN DEGRADADA                 │
│     - Sistema sigue funcionando         │
│     - Réplica asume funciones           │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  4. RECUPERACIÓN DEL NODO               │
│     - Sincronizar desde réplica         │
│     - Replay de transacciones           │
│     - Validar integridad                │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  5. REINTEGRACIÓN                       │
│     - Nodo vuelve a operación normal     │
│     - Balanceo de carga restaurado       │
└─────────────────────────────────────────┘
```

---

### 📊 Resumen de la Solución

**Arquitectura Final:**

```
        ┌─────────────────────────────────────┐
        │      Cliente / Aplicación            │
        └──────────────┬───────────────────────┘
                       │
        ┌──────────────┴───────────────┐
        │   Coordinador Global         │
        │   (Transparencia)            │
        └──────────────┬───────────────┘
                       │
        ┌──────────────┼───────────────┐
        │              │               │
    ┌───▼───┐      ┌───▼───┐      ┌───▼───┐
    │Europa │      │América│      │ Asia  │
    │ Nodo  │      │ Nodo  │      │ Nodo  │
    └───┬───┘      └───┬───┘      └───┬───┘
        │              │               │
    ┌───▼───┐      ┌───▼───┐      ┌───▼───┐
    │Réplica│      │Réplica│      │Réplica│
    │Europa │      │América│      │ Asia  │
    └───────┘      └───────┘      └───────┘
```

**Decisiones Clave:**

1. ✅ **Fragmentación Horizontal:** Reduce latencia para acceso local
2. ✅ **Fragmentación Vertical:** Separa datos sensibles de datos frecuentes
3. ✅ **Replicación Selectiva:** Solo para datos críticos y catálogos
4. ✅ **Transparencia Completa:** Usuarios no conocen la distribución
5. ✅ **Failover Automático:** Alta disponibilidad garantizada

---

## Actividad 3: Análisis de Coste de Consultas

### 📋 Información de la Actividad

- **Duración:** 20-30 minutos
- **Objetivo:** Analizar el coste de transmisión en consultas distribuidas
- **Modalidad:** Individual

---

### 🎯 Ejercicio

Dada una consulta distribuida que requiere datos de 3 nodos:

- **Tabla A:** 10,000 registros, 1 KB c/u (Nodo 1)
- **Tabla B:** 5,000 registros, 2 KB c/u (Nodo 2)
- **Tabla C:** 20,000 registros, 0.5 KB c/u (Nodo 3)

**Calcular:**
1. El tamaño total de datos a transmitir si se envía todo
2. El tamaño si se filtra primero (reducción del 80%)
3. El tiempo de transmisión con ancho de banda de 100 Mbps

---

### ✅ Solución Completa

#### Paso 1: Cálculo del Tamaño Total sin Filtrado

**Datos proporcionados:**

- **Tabla A (Nodo 1):**
  - Registros: 10,000
  - Tamaño por registro: 1 KB
  - Tamaño total: 10,000 × 1 KB = 10,000 KB = 10 MB

- **Tabla B (Nodo 2):**
  - Registros: 5,000
  - Tamaño por registro: 2 KB
  - Tamaño total: 5,000 × 2 KB = 10,000 KB = 10 MB

- **Tabla C (Nodo 3):**
  - Registros: 20,000
  - Tamaño por registro: 0.5 KB
  - Tamaño total: 20,000 × 0.5 KB = 10,000 KB = 10 MB

**Cálculo:**

```
Tamaño Total = Tabla A + Tabla B + Tabla C
Tamaño Total = 10 MB + 10 MB + 10 MB
Tamaño Total = 30 MB = 30,000 KB = 30,720,000 bytes
```

**Resultado:**
- **Tamaño total sin filtrado: 30 MB**

---

#### Paso 2: Cálculo del Tamaño con Filtrado (80% de reducción)

**Aplicando filtrado que reduce el 80% de los datos:**

Esto significa que solo se transmite el **20%** de los datos originales.

**Cálculo:**

```
Tamaño con Filtrado = Tamaño Total × (1 - 0.80)
Tamaño con Filtrado = 30 MB × 0.20
Tamaño con Filtrado = 6 MB = 6,000 KB = 6,144,000 bytes
```

**Desglose por tabla:**

- **Tabla A filtrada:** 10 MB × 0.20 = 2 MB
- **Tabla B filtrada:** 10 MB × 0.20 = 2 MB
- **Tabla C filtrada:** 10 MB × 0.20 = 2 MB
- **Total:** 6 MB

**Resultado:**
- **Tamaño total con filtrado: 6 MB**
- **Reducción:** 24 MB (80% menos datos)

---

#### Paso 3: Cálculo del Tiempo de Transmisión

**Datos:**
- Ancho de banda: 100 Mbps (Megabits por segundo)
- Tamaño sin filtrado: 30 MB
- Tamaño con filtrado: 6 MB

**Conversión de unidades:**

```
100 Mbps = 100 Megabits por segundo
1 Byte = 8 bits
1 MB = 8 Megabits

Ancho de banda en MB/s = 100 Mbps ÷ 8 = 12.5 MB/s
```

**Cálculo del tiempo:**

**a) Sin filtrado:**
```
Tiempo = Tamaño / Velocidad
Tiempo = 30 MB / 12.5 MB/s
Tiempo = 2.4 segundos
```

**b) Con filtrado:**
```
Tiempo = Tamaño / Velocidad
Tiempo = 6 MB / 12.5 MB/s
Tiempo = 0.48 segundos
```

**Mejora de rendimiento:**
```
Mejora = Tiempo sin filtrado / Tiempo con filtrado
Mejora = 2.4 s / 0.48 s = 5x más rápido
```

**Resultado:**
- **Tiempo sin filtrado: 2.4 segundos**
- **Tiempo con filtrado: 0.48 segundos**
- **Mejora: 5 veces más rápido**

---

### 📊 Análisis Comparativo

#### Tabla Comparativa

| Métrica | Sin Filtrado | Con Filtrado | Mejora |
|---------|--------------|--------------|--------|
| **Tamaño de datos** | 30 MB | 6 MB | 80% reducción |
| **Tiempo de transmisión** | 2.4 s | 0.48 s | 5x más rápido |
| **Ancho de banda usado** | 30 MB | 6 MB | 80% menos |
| **Latencia de red** | Alta | Baja | Significativa |

#### Impacto Adicional

**Consideraciones adicionales:**

1. **Latencia de red:**
   - Latencia entre nodos: ~10 ms por salto
   - 3 nodos = 3 saltos = 30 ms adicionales
   - **Tiempo total sin filtrado:** 2.4 s + 0.03 s = 2.43 s
   - **Tiempo total con filtrado:** 0.48 s + 0.03 s = 0.51 s

2. **Procesamiento local:**
   - Filtrado en cada nodo antes de transmitir
   - Tiempo de procesamiento: ~50 ms por nodo
   - **Tiempo total con procesamiento:** 0.51 s + 0.15 s = 0.66 s
   - **Aún 3.7x más rápido que sin filtrado**

3. **Costo de almacenamiento:**
   - Sin filtrado: 30 MB en memoria temporal
   - Con filtrado: 6 MB en memoria temporal
   - **Reducción de memoria: 80%**

---

### 💻 Código de Implementación

#### Script de Análisis de Coste

```python
#!/usr/bin/env python3
"""
Script de Análisis de Coste de Consultas Distribuidas
Tema 5: Bases de Datos Distribuidas
"""

def calcular_tamaño_total(tablas):
    """
    Calcula el tamaño total de datos a transmitir
    
    Args:
        tablas: Lista de tuplas (registros, tamaño_por_registro_kb, nodo)
    
    Returns:
        Tamaño total en MB
    """
    total_kb = 0
    for registros, tamaño_kb, nodo in tablas:
        tamaño_tabla_kb = registros * tamaño_kb
        total_kb += tamaño_tabla_kb
        print(f"Tabla en Nodo {nodo}: {registros:,} registros × {tamaño_kb} KB = {tamaño_tabla_kb:,} KB = {tamaño_tabla_kb/1024:.2f} MB")
    
    total_mb = total_kb / 1024
    print(f"\nTamaño Total: {total_kb:,} KB = {total_mb:.2f} MB")
    return total_mb

def calcular_tamaño_filtrado(tamaño_total, porcentaje_reduccion):
    """
    Calcula el tamaño después de aplicar filtrado
    
    Args:
        tamaño_total: Tamaño total en MB
        porcentaje_reduccion: Porcentaje de reducción (0-100)
    
    Returns:
        Tamaño filtrado en MB
    """
    factor_reduccion = porcentaje_reduccion / 100
    tamaño_filtrado = tamaño_total * (1 - factor_reduccion)
    reduccion = tamaño_total - tamaño_filtrado
    
    print(f"\nAplicando filtrado ({porcentaje_reduccion}% de reducción):")
    print(f"Tamaño Original: {tamaño_total:.2f} MB")
    print(f"Tamaño Filtrado: {tamaño_filtrado:.2f} MB")
    print(f"Reducción: {reduccion:.2f} MB ({porcentaje_reduccion}%)")
    
    return tamaño_filtrado

def calcular_tiempo_transmision(tamaño_mb, ancho_banda_mbps, latencia_ms=0):
    """
    Calcula el tiempo de transmisión
    
    Args:
        tamaño_mb: Tamaño en MB
        ancho_banda_mbps: Ancho de banda en Mbps
        latencia_ms: Latencia adicional en milisegundos
    
    Returns:
        Tiempo total en segundos
    """
    # Conversión de Mbps a MB/s
    ancho_banda_mb_s = ancho_banda_mbps / 8
    
    # Tiempo de transmisión
    tiempo_transmision = tamaño_mb / ancho_banda_mb_s
    
    # Latencia adicional
    tiempo_latencia = latencia_ms / 1000
    
    tiempo_total = tiempo_transmision + tiempo_latencia
    
    print(f"\nAncho de banda: {ancho_banda_mbps} Mbps = {ancho_banda_mb_s:.2f} MB/s")
    print(f"Tiempo de transmisión: {tamaño_mb:.2f} MB / {ancho_banda_mb_s:.2f} MB/s = {tiempo_transmision:.3f} s")
    if latencia_ms > 0:
        print(f"Latencia adicional: {latencia_ms} ms = {tiempo_latencia:.3f} s")
    print(f"Tiempo Total: {tiempo_total:.3f} s")
    
    return tiempo_total

def analizar_consulta_distribuida():
    """
    Análisis completo de coste de consulta distribuida
    """
    print("=" * 60)
    print("ANÁLISIS DE COSTE DE CONSULTA DISTRIBUIDA")
    print("=" * 60)
    
    # Datos del ejercicio
    tablas = [
        (10000, 1, 1),    # Tabla A: 10,000 registros, 1 KB c/u, Nodo 1
        (5000, 2, 2),     # Tabla B: 5,000 registros, 2 KB c/u, Nodo 2
        (20000, 0.5, 3)   # Tabla C: 20,000 registros, 0.5 KB c/u, Nodo 3
    ]
    
    ancho_banda_mbps = 100
    porcentaje_reduccion = 80
    latencia_ms = 30  # 10 ms por nodo × 3 nodos
    
    # Paso 1: Calcular tamaño total
    print("\n1. CÁLCULO DEL TAMAÑO TOTAL SIN FILTRADO")
    print("-" * 60)
    tamaño_total = calcular_tamaño_total(tablas)
    
    # Paso 2: Calcular tamaño con filtrado
    print("\n2. CÁLCULO DEL TAMAÑO CON FILTRADO")
    print("-" * 60)
    tamaño_filtrado = calcular_tamaño_filtrado(tamaño_total, porcentaje_reduccion)
    
    # Paso 3: Calcular tiempos de transmisión
    print("\n3. CÁLCULO DEL TIEMPO DE TRANSMISIÓN")
    print("-" * 60)
    
    print("\n3.1. SIN FILTRADO:")
    tiempo_sin_filtrado = calcular_tiempo_transmision(tamaño_total, ancho_banda_mbps, latencia_ms)
    
    print("\n3.2. CON FILTRADO:")
    tiempo_con_filtrado = calcular_tiempo_transmision(tamaño_filtrado, ancho_banda_mbps, latencia_ms)
    
    # Análisis comparativo
    print("\n" + "=" * 60)
    print("ANÁLISIS COMPARATIVO")
    print("=" * 60)
    
    mejora_tiempo = tiempo_sin_filtrado / tiempo_con_filtrado
    reduccion_tamaño = ((tamaño_total - tamaño_filtrado) / tamaño_total) * 100
    
    print(f"\nMétricas:")
    print(f"  • Reducción de tamaño: {reduccion_tamaño:.1f}%")
    print(f"  • Mejora de tiempo: {mejora_tiempo:.2f}x más rápido")
    print(f"  • Ahorro de tiempo: {tiempo_sin_filtrado - tiempo_con_filtrado:.3f} s")
    print(f"  • Ahorro de ancho de banda: {tamaño_total - tamaño_filtrado:.2f} MB")
    
    # Recomendaciones
    print("\n" + "=" * 60)
    print("RECOMENDACIONES")
    print("=" * 60)
    print("\n1. SIEMPRE aplicar filtros en el nodo remoto antes de transmitir")
    print("2. Usar WHERE, JOIN, y proyecciones para reducir datos")
    print("3. Transmitir solo columnas necesarias (SELECT específico)")
    print("4. Considerar compresión de datos para reducir aún más el tamaño")
    print("5. Usar índices en nodos remotos para acelerar filtrado")
    
    return {
        'tamaño_total_mb': tamaño_total,
        'tamaño_filtrado_mb': tamaño_filtrado,
        'tiempo_sin_filtrado_s': tiempo_sin_filtrado,
        'tiempo_con_filtrado_s': tiempo_con_filtrado,
        'mejora_tiempo': mejora_tiempo,
        'reduccion_tamaño': reduccion_tamaño
    }

if __name__ == "__main__":
    resultados = analizar_consulta_distribuida()
    
    print("\n" + "=" * 60)
    print("RESUMEN DE RESULTADOS")
    print("=" * 60)
    print(f"""
Tamaño sin filtrado:     {resultados['tamaño_total_mb']:.2f} MB
Tamaño con filtrado:     {resultados['tamaño_filtrado_mb']:.2f} MB
Tiempo sin filtrado:     {resultados['tiempo_sin_filtrado_s']:.3f} s
Tiempo con filtrado:     {resultados['tiempo_con_filtrado_s']:.3f} s
Mejora de rendimiento:   {resultados['mejora_tiempo']:.2f}x
""")
```

#### Ejecución del Script

```bash
# Guardar el script como analisis_coste_consultas.py
python analisis_coste_consultas.py
```

**Salida esperada:**

```
============================================================
ANÁLISIS DE COSTE DE CONSULTA DISTRIBUIDA
============================================================

1. CÁLCULO DEL TAMAÑO TOTAL SIN FILTRADO
------------------------------------------------------------
Tabla en Nodo 1: 10,000 registros × 1 KB = 10,000 KB = 9.77 MB
Tabla en Nodo 2: 5,000 registros × 2 KB = 10,000 KB = 9.77 MB
Tabla en Nodo 3: 20,000 registros × 0.5 KB = 10,000 KB = 9.77 MB

Tamaño Total: 30,000 KB = 29.30 MB

2. CÁLCULO DEL TAMAÑO CON FILTRADO
------------------------------------------------------------
Aplicando filtrado (80% de reducción):
Tamaño Original: 29.30 MB
Tamaño Filtrado: 5.86 MB
Reducción: 23.44 MB (80%)

3. CÁLCULO DEL TIEMPO DE TRANSMISIÓN
------------------------------------------------------------

3.1. SIN FILTRADO:
Ancho de banda: 100 Mbps = 12.50 MB/s
Tiempo de transmisión: 29.30 MB / 12.50 MB/s = 2.344 s
Latencia adicional: 30 ms = 0.030 s
Tiempo Total: 2.374 s

3.2. CON FILTRADO:
Ancho de banda: 100 Mbps = 12.50 MB/s
Tiempo de transmisión: 5.86 MB / 12.50 MB/s = 0.469 s
Latencia adicional: 30 ms = 0.030 s
Tiempo Total: 0.499 s

============================================================
ANÁLISIS COMPARATIVO
============================================================

Métricas:
  • Reducción de tamaño: 80.0%
  • Mejora de tiempo: 4.76x más rápido
  • Ahorro de tiempo: 1.875 s
  • Ahorro de ancho de banda: 23.44 MB
```

---

#### Ejemplos de Consultas Optimizadas

```sql
-- ============================================
-- CONSULTA NO OPTIMIZADA (envía todo)
-- ============================================
SELECT * 
FROM tabla_a@nodo1
UNION ALL
SELECT * 
FROM tabla_b@nodo2
UNION ALL
SELECT * 
FROM tabla_c@nodo3;
-- Tamaño transmitido: 30 MB
-- Tiempo: ~2.4 segundos

-- ============================================
-- CONSULTA OPTIMIZADA (filtra antes de transmitir)
-- ============================================
SELECT id, nombre, precio, categoria
FROM (
    SELECT id, nombre, precio, categoria 
    FROM tabla_a@nodo1 
    WHERE categoria = 'Electrónica' AND precio BETWEEN 100 AND 500
) UNION ALL
SELECT id, nombre, precio, categoria
FROM (
    SELECT id, nombre, precio, categoria 
    FROM tabla_b@nodo2 
    WHERE categoria = 'Electrónica' AND precio BETWEEN 100 AND 500
) UNION ALL
SELECT id, nombre, precio, categoria
FROM (
    SELECT id, nombre, precio, categoria 
    FROM tabla_c@nodo3 
    WHERE categoria = 'Electrónica' AND precio BETWEEN 100 AND 500
);
-- Tamaño transmitido: ~6 MB (80% reducción)
-- Tiempo: ~0.48 segundos
-- Mejora: 5x más rápido

-- ============================================
-- CONSULTA AÚN MÁS OPTIMIZADA (solo columnas necesarias)
-- ============================================
SELECT id, nombre, precio
FROM (
    SELECT id, nombre, precio 
    FROM tabla_a@nodo1 
    WHERE categoria = 'Electrónica' 
      AND precio BETWEEN 100 AND 500
      AND stock > 0
    LIMIT 1000
) UNION ALL
SELECT id, nombre, precio
FROM (
    SELECT id, nombre, precio 
    FROM tabla_b@nodo2 
    WHERE categoria = 'Electrónica' 
      AND precio BETWEEN 100 AND 500
      AND stock > 0
    LIMIT 1000
) UNION ALL
SELECT id, nombre, precio
FROM (
    SELECT id, nombre, precio 
    FROM tabla_c@nodo3 
    WHERE categoria = 'Electrónica' 
      AND precio BETWEEN 100 AND 500
      AND stock > 0
    LIMIT 1000
);
-- Tamaño transmitido: ~3 MB (90% reducción)
-- Tiempo: ~0.24 segundos
-- Mejora: 10x más rápido
```

---

### 📈 Gráficas de Comparación

#### Comparación Visual de Tiempos

```
Tiempo de Transmisión (segundos)

Sin Filtrado:    ████████████████████████ 2.4 s
Con Filtrado:    ████                      0.48 s
─────────────────────────────────────────────
Mejora:          5x más rápido
```

#### Comparación de Tamaños

```
Tamaño de Datos Transmitidos (MB)

Sin Filtrado:    ████████████████████████████████ 30 MB
Con Filtrado:    ██████                            6 MB
───────────────────────────────────────────────────
Reducción:       80% menos datos
```

---

### 🎓 Conclusiones

1. **Filtrado es crítico:** Reducir datos antes de transmitir reduce significativamente el tiempo de consulta
2. **Impacto de latencia:** Aunque pequeño comparado con transmisión, la latencia acumula
3. **Proyección de columnas:** Seleccionar solo columnas necesarias reduce aún más el tamaño
4. **Límites (LIMIT):** Usar límites cuando sea posible reduce dramáticamente el tamaño
5. **Índices remotos:** Los índices en nodos remotos aceleran el filtrado local

**Mejores prácticas:**
- ✅ Siempre aplicar WHERE en nodo remoto
- ✅ Seleccionar solo columnas necesarias
- ✅ Usar LIMIT cuando sea apropiado
- ✅ Procesar datos localmente antes de transmitir
- ✅ Considerar compresión para datos grandes

---

## 📚 Referencias Adicionales

### Herramientas Recomendadas

1. **PostgreSQL:**
   - `EXPLAIN ANALYZE` para ver planes de ejecución
   - `pg_stat_statements` para análisis de consultas
   - `pg_basebackup` para replicación

2. **Oracle:**
   - Database Links para consultas distribuidas
   - `EXPLAIN PLAN` para análisis de costes
   - Oracle RAC para alta disponibilidad

3. **SQL Server:**
   - Replication Wizard para configurar réplicas
   - `sys.dm_exec_query_stats` para análisis
   - Always On Availability Groups

### Scripts de Utilidad

Los scripts proporcionados en este documento pueden adaptarse a diferentes SGBD y escenarios específicos. Se recomienda:

1. Modificar los parámetros según el entorno real
2. Ajustar las funciones según el SGBD específico
3. Agregar logging y monitoreo según necesidades
4. Implementar alertas para fallos y recuperación

---

**¡Éxito en la implementación de sistemas distribuidos! 🚀**

