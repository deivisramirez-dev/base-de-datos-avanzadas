-- =====================================================
-- ESQUEMA DE BASE DE DATOS PARA ACTIVIDADES TEMA 9
-- Sistema de Gestión de Ventas y E-commerce
-- =====================================================
-- 
-- PROPÓPOSITO: Este archivo es una DOCUMENTACIÓN del esquema de base de datos.
--            Muestra la estructura completa con comentarios explicativos.
--
-- IMPORTANTE: Este archivo NO está diseñado para ejecutarse directamente.
--             Para crear las tablas, usa el archivo: create_tables.sql
--
-- Este esquema está diseñado para las actividades de refuerzo:
-- - Actividad 1: Análisis de Planes de Ejecución
-- - Actividad 2: Optimización de Consultas
-- - Actividad 3: Monitorización de Rendimiento
--
-- Base de datos: MySQL 8.0+
-- =====================================================

-- NOTA: Las siguientes sentencias son solo para referencia/documentación.
--       El orden de creación puede no ser el óptimo para ejecución.
--       Ver create_tables.sql para el script ejecutable.

-- =====================================================
-- TABLA: categorias
-- Almacena las categorías de productos
-- =====================================================
CREATE TABLE categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    activa BOOLEAN DEFAULT TRUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Categorías de productos del catálogo';

-- =====================================================
-- TABLA: departamentos
-- Almacena información de departamentos
-- NOTA: Se crea antes que empleados porque empleados tiene FK a departamentos
-- =====================================================
CREATE TABLE departamentos (
    departamento_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    presupuesto DECIMAL(12, 2),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Departamentos de la empresa';

-- =====================================================
-- TABLA: productos
-- Almacena información de productos
-- =====================================================
CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    stock INT DEFAULT 0 CHECK (stock >= 0),
    categoria_id INT REFERENCES categorias(categoria_id),
    proveedor VARCHAR(100),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Productos disponibles para venta';

-- =====================================================
-- TABLA: clientes
-- Almacena información de clientes
-- =====================================================
CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    direccion TEXT,
    ciudad VARCHAR(100),
    pais VARCHAR(100) DEFAULT 'España',
    codigo_postal VARCHAR(10),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Información de clientes registrados';

-- =====================================================
-- TABLA: empleados
-- Almacena información de empleados
-- NOTA: Requiere que departamentos exista primero (FK)
-- =====================================================
CREATE TABLE empleados (
    empleado_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_contratacion DATE NOT NULL,
    salario DECIMAL(10, 2) CHECK (salario > 0),
    departamento_id INT REFERENCES departamentos(departamento_id),
    cargo VARCHAR(100),
    activo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Información de empleados de la empresa';

-- =====================================================
-- TABLA: pedidos
-- Almacena información de pedidos
-- =====================================================
CREATE TABLE pedidos (
    pedido_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES clientes(cliente_id),
    empleado_id INT REFERENCES empleados(empleado_id),
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_entrega DATE,
    estado VARCHAR(50) DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'procesando', 'enviado', 'entregado', 'cancelado')),
    total DECIMAL(10, 2) DEFAULT 0,
    metodo_pago VARCHAR(50),
    direccion_entrega TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Pedidos realizados por clientes';

-- =====================================================
-- TABLA: pedido_items
-- Almacena los items de cada pedido
-- NOTA: En MySQL, el subtotal se calcula mediante trigger
-- =====================================================
CREATE TABLE pedido_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL REFERENCES pedidos(pedido_id) ON DELETE CASCADE,
    producto_id INT NOT NULL REFERENCES productos(producto_id),
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL,
    descuento DECIMAL(5, 2) DEFAULT 0 CHECK (descuento >= 0 AND descuento <= 100),
    subtotal DECIMAL(10, 2) NOT NULL
    -- NOTA: El subtotal se calcula mediante trigger trg_calcular_subtotal
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Items individuales de cada pedido';

-- =====================================================
-- TABLA: ventas_diarias
-- Tabla para análisis de rendimiento y estadísticas
-- =====================================================
CREATE TABLE ventas_diarias (
    venta_id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    producto_id INT REFERENCES productos(producto_id),
    cantidad_vendida INT NOT NULL,
    ingresos DECIMAL(10, 2) NOT NULL,
    cliente_id INT REFERENCES clientes(cliente_id),
    region VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Registro diario de ventas para análisis';

-- =====================================================
-- ÍNDICES INICIALES (mínimos para empezar)
-- Los estudiantes crearán más índices en las actividades
-- =====================================================

-- Índices primarios ya creados automáticamente por PRIMARY KEY
-- Índices de foreign keys básicos (mínimos para empezar)
-- NOTA: create_tables.sql incluye índices adicionales para optimización
CREATE INDEX idx_productos_categoria ON productos(categoria_id);
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX idx_pedidos_empleado ON pedidos(empleado_id);
CREATE INDEX idx_pedido_items_pedido ON pedido_items(pedido_id);
CREATE INDEX idx_pedido_items_producto ON pedido_items(producto_id);
CREATE INDEX idx_empleados_departamento ON empleados(departamento_id);

-- =====================================================
-- TRIGGER: Calcular subtotal en pedido_items
-- MySQL no soporta GENERATED ALWAYS AS para cálculos complejos
-- =====================================================
DELIMITER $$

CREATE TRIGGER trg_calcular_subtotal_insert
BEFORE INSERT ON pedido_items
FOR EACH ROW
BEGIN
    SET NEW.subtotal = NEW.cantidad * NEW.precio_unitario * (1 - NEW.descuento/100);
END$$

CREATE TRIGGER trg_calcular_subtotal_update
BEFORE UPDATE ON pedido_items
FOR EACH ROW
BEGIN
    SET NEW.subtotal = NEW.cantidad * NEW.precio_unitario * (1 - NEW.descuento/100);
END$$

DELIMITER ;

-- =====================================================
-- FIN DEL ESQUEMA
-- =====================================================
