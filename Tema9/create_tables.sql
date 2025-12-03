-- =====================================================
-- SCRIPT DE CREACIÓN DE BASE DE DATOS Y TABLAS - MySQL
-- Sistema de Gestión de Ventas
-- =====================================================
-- 
-- Este script crea la base de datos y todas las tablas
-- necesarias para las actividades de refuerzo del Tema 9
-- Compatible con MySQL 8.0+
-- =====================================================

-- =====================================================
-- CREAR BASE DE DATOS
-- =====================================================
CREATE DATABASE IF NOT EXISTS gestion_ventas 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Usar la base de datos creada
USE gestion_ventas;

-- =====================================================
-- ELIMINAR TABLAS SI EXISTEN
-- =====================================================
-- Eliminar tablas si existen (en orden inverso por dependencias)
-- MySQL no soporta CASCADE en DROP TABLE, se eliminan automáticamente
DROP TABLE IF EXISTS ventas_diarias;
DROP TABLE IF EXISTS pedido_items;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS departamentos;
DROP TABLE IF EXISTS clientes;

-- =====================================================
-- TABLA: categorias
-- =====================================================
CREATE TABLE categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    activa BOOLEAN DEFAULT TRUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_categorias_activa (activa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Categorías de productos del catálogo';

-- =====================================================
-- TABLA: departamentos
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
-- =====================================================
CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    categoria_id INT,
    proveedor VARCHAR(100),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_precio_positivo CHECK (precio > 0),
    CONSTRAINT chk_stock_positivo CHECK (stock >= 0),
    CONSTRAINT fk_productos_categoria FOREIGN KEY (categoria_id) 
        REFERENCES categorias(categoria_id) ON DELETE SET NULL,
    INDEX idx_productos_categoria (categoria_id),
    INDEX idx_productos_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Productos disponibles para venta';

-- =====================================================
-- TABLA: clientes
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
    activo BOOLEAN DEFAULT TRUE,
    INDEX idx_clientes_ciudad (ciudad),
    INDEX idx_clientes_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Información de clientes registrados';

-- =====================================================
-- TABLA: empleados
-- =====================================================
CREATE TABLE empleados (
    empleado_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_contratacion DATE NOT NULL,
    salario DECIMAL(10, 2),
    departamento_id INT,
    cargo VARCHAR(100),
    activo BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_salario_positivo CHECK (salario > 0),
    CONSTRAINT fk_empleados_departamento FOREIGN KEY (departamento_id) 
        REFERENCES departamentos(departamento_id) ON DELETE SET NULL,
    INDEX idx_empleados_departamento (departamento_id),
    INDEX idx_empleados_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Información de empleados de la empresa';

-- =====================================================
-- TABLA: pedidos
-- =====================================================
CREATE TABLE pedidos (
    pedido_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    empleado_id INT,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_entrega DATE,
    estado VARCHAR(50) DEFAULT 'pendiente',
    total DECIMAL(10, 2) DEFAULT 0,
    metodo_pago VARCHAR(50),
    direccion_entrega TEXT,
    CONSTRAINT chk_estado_valido CHECK (estado IN ('pendiente', 'procesando', 'enviado', 'entregado', 'cancelado')),
    CONSTRAINT fk_pedidos_cliente FOREIGN KEY (cliente_id) 
        REFERENCES clientes(cliente_id) ON DELETE RESTRICT,
    CONSTRAINT fk_pedidos_empleado FOREIGN KEY (empleado_id) 
        REFERENCES empleados(empleado_id) ON DELETE SET NULL,
    INDEX idx_pedidos_cliente (cliente_id),
    INDEX idx_pedidos_empleado (empleado_id),
    INDEX idx_pedidos_fecha (fecha_pedido),
    INDEX idx_pedidos_estado (estado),
    INDEX idx_pedidos_fecha_estado (fecha_pedido, estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Pedidos realizados por clientes';

-- =====================================================
-- TABLA: pedido_items
-- =====================================================
CREATE TABLE pedido_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    descuento DECIMAL(5, 2) DEFAULT 0,
    subtotal DECIMAL(10, 2) NOT NULL,
    CONSTRAINT chk_cantidad_positiva CHECK (cantidad > 0),
    CONSTRAINT chk_descuento_valido CHECK (descuento >= 0 AND descuento <= 100),
    CONSTRAINT fk_pedido_items_pedido FOREIGN KEY (pedido_id) 
        REFERENCES pedidos(pedido_id) ON DELETE CASCADE,
    CONSTRAINT fk_pedido_items_producto FOREIGN KEY (producto_id) 
        REFERENCES productos(producto_id) ON DELETE RESTRICT,
    INDEX idx_pedido_items_pedido (pedido_id),
    INDEX idx_pedido_items_producto (producto_id),
    INDEX idx_pedido_items_subtotal (pedido_id, subtotal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Items individuales de cada pedido';

-- =====================================================
-- TABLA: ventas_diarias
-- =====================================================
CREATE TABLE ventas_diarias (
    venta_id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    producto_id INT,
    cantidad_vendida INT NOT NULL,
    ingresos DECIMAL(10, 2) NOT NULL,
    cliente_id INT,
    region VARCHAR(100),
    CONSTRAINT fk_ventas_producto FOREIGN KEY (producto_id) 
        REFERENCES productos(producto_id) ON DELETE SET NULL,
    CONSTRAINT fk_ventas_cliente FOREIGN KEY (cliente_id) 
        REFERENCES clientes(cliente_id) ON DELETE SET NULL,
    INDEX idx_ventas_diarias_fecha (fecha),
    INDEX idx_ventas_diarias_producto (producto_id),
    INDEX idx_ventas_diarias_cliente (cliente_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Registro diario de ventas para análisis';

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
-- FIN DEL SCRIPT
-- =====================================================
