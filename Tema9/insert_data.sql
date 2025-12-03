-- =====================================================
-- SCRIPT DE INSERCIÓN DE DATOS
-- Sistema de Gestión de Ventas
-- =====================================================
-- 
-- Este script inserta datos de ejemplo para las
-- actividades de refuerzo del Tema 9
-- =====================================================

-- =====================================================
-- INSERTAR CATEGORÍAS
-- =====================================================
INSERT INTO categorias (nombre, descripcion, activa) VALUES
('Electrónica', 'Dispositivos electrónicos y gadgets', TRUE),
('Ropa', 'Prendas de vestir para todas las edades', TRUE),
('Hogar', 'Artículos para el hogar y decoración', TRUE),
('Deportes', 'Equipamiento deportivo y fitness', TRUE),
('Libros', 'Libros físicos y digitales', TRUE),
('Juguetes', 'Juguetes y juegos para niños', TRUE),
('Alimentación', 'Productos alimenticios', TRUE),
('Belleza', 'Productos de belleza y cuidado personal', TRUE),
('Automoción', 'Repuestos y accesorios para vehículos', TRUE),
('Jardín', 'Herramientas y plantas para jardín', TRUE);

-- =====================================================
-- INSERTAR DEPARTAMENTOS
-- =====================================================
INSERT INTO departamentos (nombre, descripcion, presupuesto) VALUES
('Ventas', 'Departamento de ventas y atención al cliente', 500000.00),
('Marketing', 'Departamento de marketing y publicidad', 300000.00),
('IT', 'Departamento de tecnología e informática', 400000.00),
('Recursos Humanos', 'Gestión de personal', 200000.00),
('Finanzas', 'Departamento financiero y contabilidad', 350000.00),
('Logística', 'Gestión de almacén y distribución', 450000.00),
('Atención al Cliente', 'Soporte y atención al cliente', 250000.00);

-- =====================================================
-- INSERTAR EMPLEADOS
-- =====================================================
INSERT INTO empleados (nombre, apellido, email, telefono, fecha_contratacion, salario, departamento_id, cargo, activo) VALUES
('Juan', 'García', 'juan.garcia@empresa.com', '600123456', '2020-01-15', 35000.00, 1, 'Vendedor Senior', TRUE),
('María', 'López', 'maria.lopez@empresa.com', '600234567', '2019-03-20', 42000.00, 1, 'Jefe de Ventas', TRUE),
('Carlos', 'Martínez', 'carlos.martinez@empresa.com', '600345678', '2021-06-10', 38000.00, 2, 'Especialista en Marketing', TRUE),
('Ana', 'Sánchez', 'ana.sanchez@empresa.com', '600456789', '2020-09-05', 45000.00, 3, 'Desarrollador Senior', TRUE),
('Pedro', 'Rodríguez', 'pedro.rodriguez@empresa.com', '600567890', '2022-02-14', 32000.00, 3, 'Desarrollador', TRUE),
('Laura', 'Fernández', 'laura.fernandez@empresa.com', '600678901', '2018-11-30', 40000.00, 4, 'Gerente de RRHH', TRUE),
('Miguel', 'González', 'miguel.gonzalez@empresa.com', '600789012', '2021-04-22', 36000.00, 5, 'Contador', TRUE),
('Sofía', 'Pérez', 'sofia.perez@empresa.com', '600890123', '2020-07-18', 34000.00, 6, 'Coordinador de Logística', TRUE),
('Diego', 'Torres', 'diego.torres@empresa.com', '600901234', '2022-01-08', 30000.00, 7, 'Agente de Soporte', TRUE),
('Elena', 'Ruiz', 'elena.ruiz@empresa.com', '600012345', '2019-12-03', 41000.00, 2, 'Diseñadora Gráfica', TRUE);

-- =====================================================
-- INSERTAR PRODUCTOS
-- =====================================================
INSERT INTO productos (nombre, descripcion, precio, stock, categoria_id, proveedor, activo) VALUES
-- Electrónica
('Smartphone Pro Max', 'Teléfono inteligente de última generación', 899.99, 50, 1, 'TechCorp', TRUE),
('Laptop Ultra', 'Portátil de alto rendimiento', 1299.99, 30, 1, 'TechCorp', TRUE),
('Tablet 10 pulgadas', 'Tablet ideal para trabajo y entretenimiento', 399.99, 75, 1, 'TechCorp', TRUE),
('Auriculares Inalámbricos', 'Auriculares con cancelación de ruido', 199.99, 100, 1, 'SoundTech', TRUE),
('Smartwatch', 'Reloj inteligente con monitor de salud', 299.99, 60, 1, 'TechCorp', TRUE),
-- Ropa
('Camiseta Algodón', 'Camiseta 100% algodón orgánico', 19.99, 200, 2, 'FashionStyle', TRUE),
('Pantalón Vaquero', 'Jeans clásicos de corte regular', 49.99, 150, 2, 'FashionStyle', TRUE),
('Chaqueta Deportiva', 'Chaqueta transpirable para deporte', 79.99, 80, 2, 'SportWear', TRUE),
('Zapatillas Running', 'Zapatillas para correr de alta calidad', 89.99, 120, 2, 'SportWear', TRUE),
('Abrigo Invierno', 'Abrigo cálido para invierno', 129.99, 60, 2, 'FashionStyle', TRUE),
-- Hogar
('Sofá 3 Plazas', 'Sofá cómodo y elegante', 599.99, 25, 3, 'HomeDesign', TRUE),
('Mesa Comedor', 'Mesa de comedor para 6 personas', 449.99, 20, 3, 'HomeDesign', TRUE),
('Lámpara LED', 'Lámpara LED con control de intensidad', 39.99, 100, 3, 'LightHome', TRUE),
('Cafetera Express', 'Cafetera espresso automática', 199.99, 40, 3, 'KitchenPro', TRUE),
('Aspiradora Robot', 'Aspiradora robot inteligente', 349.99, 35, 3, 'HomeTech', TRUE),
-- Deportes
('Pelota Fútbol', 'Pelota oficial de fútbol', 29.99, 80, 4, 'SportPro', TRUE),
('Raqueta Tenis', 'Raqueta profesional de tenis', 89.99, 50, 4, 'SportPro', TRUE),
('Bicicleta Montaña', 'Bicicleta de montaña 21 velocidades', 499.99, 15, 4, 'BikeMaster', TRUE),
('Pesas Ajustables', 'Set de pesas ajustables 20kg', 79.99, 45, 4, 'FitnessGear', TRUE),
('Colchoneta Yoga', 'Colchoneta antideslizante para yoga', 24.99, 90, 4, 'FitnessGear', TRUE),
-- Libros
('Novela Best Seller', 'Novela más vendida del año', 15.99, 200, 5, 'BookHouse', TRUE),
('Guía Programación', 'Guía completa de programación', 29.99, 100, 5, 'TechBooks', TRUE),
('Biografía Famoso', 'Biografía de personaje histórico', 19.99, 150, 5, 'BookHouse', TRUE),
('Libro Cocina', 'Recetario de cocina internacional', 24.99, 80, 5, 'CulinaryBooks', TRUE),
('Manual Técnico', 'Manual técnico especializado', 34.99, 60, 5, 'TechBooks', TRUE);

-- =====================================================
-- INSERTAR CLIENTES
-- =====================================================
INSERT INTO clientes (nombre, apellido, email, telefono, direccion, ciudad, pais, codigo_postal, activo) VALUES
('Alejandro', 'Morales', 'alejandro.morales@email.com', '611111111', 'Calle Mayor 1', 'Madrid', 'España', '28001', TRUE),
('Beatriz', 'Jiménez', 'beatriz.jimenez@email.com', '622222222', 'Avenida Libertad 25', 'Barcelona', 'España', '08001', TRUE),
('Cristina', 'Hernández', 'cristina.hernandez@email.com', '633333333', 'Plaza España 10', 'Valencia', 'España', '46001', TRUE),
('David', 'Moreno', 'david.moreno@email.com', '644444444', 'Calle Sol 5', 'Sevilla', 'España', '41001', TRUE),
('Eva', 'Álvarez', 'eva.alvarez@email.com', '655555555', 'Avenida Principal 100', 'Bilbao', 'España', '48001', TRUE),
('Francisco', 'Romero', 'francisco.romero@email.com', '666666666', 'Calle Nueva 15', 'Málaga', 'España', '29001', TRUE),
('Gloria', 'Navarro', 'gloria.navarro@email.com', '677777777', 'Plaza Mayor 8', 'Zaragoza', 'España', '50001', TRUE),
('Héctor', 'Díaz', 'hector.diaz@email.com', '688888888', 'Avenida Central 50', 'Murcia', 'España', '30001', TRUE),
('Isabel', 'Serrano', 'isabel.serrano@email.com', '699999999', 'Calle Real 20', 'Palma', 'España', '07001', TRUE),
('Javier', 'Méndez', 'javier.mendez@email.com', '610101010', 'Plaza del Sol 3', 'Las Palmas', 'España', '35001', TRUE),
('Karla', 'Vargas', 'karla.vargas@email.com', '611111112', 'Calle Luna 12', 'Madrid', 'España', '28002', TRUE),
('Luis', 'Castro', 'luis.castro@email.com', '622222223', 'Avenida Mar 45', 'Barcelona', 'España', '08002', TRUE),
('Marta', 'Ortega', 'marta.ortega@email.com', '633333334', 'Calle Estrella 7', 'Valencia', 'España', '46002', TRUE),
('Nicolás', 'Ramos', 'nicolas.ramos@email.com', '644444445', 'Plaza Paz 22', 'Sevilla', 'España', '41002', TRUE),
('Olga', 'Soto', 'olga.soto@email.com', '655555556', 'Avenida Esperanza 30', 'Bilbao', 'España', '48002', TRUE),
('Pablo', 'Delgado', 'pablo.delgado@email.com', '666666667', 'Calle Victoria 18', 'Málaga', 'España', '29002', TRUE),
('Quique', 'Ramírez', 'quique.ramirez@email.com', '677777778', 'Plaza Alegría 5', 'Zaragoza', 'España', '50002', TRUE),
('Rosa', 'Iglesias', 'rosa.iglesias@email.com', '688888889', 'Avenida Felicidad 40', 'Murcia', 'España', '30002', TRUE),
('Sergio', 'Medina', 'sergio.medina@email.com', '699999990', 'Calle Armonía 9', 'Palma', 'España', '07002', TRUE),
('Teresa', 'Cortés', 'teresa.cortes@email.com', '610101011', 'Plaza Unión 14', 'Las Palmas', 'España', '35002', TRUE);

-- =====================================================
-- INSERTAR PEDIDOS
-- =====================================================
-- Generar pedidos con diferentes fechas y estados
INSERT INTO pedidos (cliente_id, empleado_id, fecha_pedido, fecha_entrega, estado, total, metodo_pago, direccion_entrega) VALUES
(1, 1, '2024-01-15 10:30:00', '2024-01-20', 'entregado', 0, 'tarjeta', 'Calle Mayor 1, Madrid'),
(2, 1, '2024-01-16 14:20:00', '2024-01-21', 'entregado', 0, 'paypal', 'Avenida Libertad 25, Barcelona'),
(3, 2, '2024-01-17 09:15:00', NULL, 'procesando', 0, 'tarjeta', 'Plaza España 10, Valencia'),
(4, 1, '2024-01-18 16:45:00', '2024-01-23', 'enviado', 0, 'transferencia', 'Calle Sol 5, Sevilla'),
(5, 2, '2024-01-19 11:30:00', NULL, 'pendiente', 0, 'tarjeta', 'Avenida Principal 100, Bilbao'),
(6, 1, '2024-01-20 13:00:00', '2024-01-25', 'entregado', 0, 'paypal', 'Calle Nueva 15, Málaga'),
(7, 2, '2024-01-21 15:20:00', NULL, 'procesando', 0, 'tarjeta', 'Plaza Mayor 8, Zaragoza'),
(8, 1, '2024-01-22 10:10:00', '2024-01-27', 'enviado', 0, 'transferencia', 'Avenida Central 50, Murcia'),
(9, 2, '2024-01-23 12:40:00', NULL, 'pendiente', 0, 'tarjeta', 'Calle Real 20, Palma'),
(10, 1, '2024-01-24 14:50:00', '2024-01-29', 'entregado', 0, 'paypal', 'Plaza del Sol 3, Las Palmas'),
(11, 2, '2024-02-01 09:00:00', '2024-02-06', 'entregado', 0, 'tarjeta', 'Calle Luna 12, Madrid'),
(12, 1, '2024-02-02 11:15:00', NULL, 'procesando', 0, 'paypal', 'Avenida Mar 45, Barcelona'),
(13, 2, '2024-02-03 13:30:00', '2024-02-08', 'enviado', 0, 'tarjeta', 'Calle Estrella 7, Valencia'),
(14, 1, '2024-02-04 15:45:00', NULL, 'pendiente', 0, 'transferencia', 'Plaza Paz 22, Sevilla'),
(15, 2, '2024-02-05 10:20:00', '2024-02-10', 'entregado', 0, 'tarjeta', 'Avenida Esperanza 30, Bilbao'),
(16, 1, '2024-02-06 12:00:00', NULL, 'procesando', 0, 'paypal', 'Calle Victoria 18, Málaga'),
(17, 2, '2024-02-07 14:30:00', '2024-02-12', 'enviado', 0, 'tarjeta', 'Plaza Alegría 5, Zaragoza'),
(18, 1, '2024-02-08 16:00:00', NULL, 'pendiente', 0, 'transferencia', 'Avenida Felicidad 40, Murcia'),
(19, 2, '2024-02-09 09:30:00', '2024-02-14', 'entregado', 0, 'tarjeta', 'Calle Armonía 9, Palma'),
(20, 1, '2024-02-10 11:45:00', NULL, 'procesando', 0, 'paypal', 'Plaza Unión 14, Las Palmas'),
(1, 2, '2024-02-11 13:20:00', '2024-02-16', 'entregado', 0, 'tarjeta', 'Calle Mayor 1, Madrid'),
(2, 1, '2024-02-12 15:10:00', NULL, 'procesando', 0, 'paypal', 'Avenida Libertad 25, Barcelona'),
(3, 2, '2024-02-13 10:00:00', '2024-02-18', 'enviado', 0, 'tarjeta', 'Plaza España 10, Valencia'),
(4, 1, '2024-02-14 12:30:00', NULL, 'pendiente', 0, 'transferencia', 'Calle Sol 5, Sevilla'),
(5, 2, '2024-02-15 14:40:00', '2024-02-20', 'entregado', 0, 'tarjeta', 'Avenida Principal 100, Bilbao');

-- =====================================================
-- INSERTAR ITEMS DE PEDIDOS
-- NOTA: El subtotal se calculará automáticamente mediante trigger
-- =====================================================
INSERT INTO pedido_items (pedido_id, producto_id, cantidad, precio_unitario, descuento, subtotal) VALUES
-- Pedido 1
(1, 1, 1, 899.99, 0, 0),
(1, 4, 1, 199.99, 5, 0),
-- Pedido 2
(2, 2, 1, 1299.99, 10, 0),
(2, 3, 1, 399.99, 0, 0),
-- Pedido 3
(3, 6, 3, 19.99, 0, 0),
(3, 7, 2, 49.99, 0, 0),
(3, 8, 1, 79.99, 15, 0),
-- Pedido 4
(4, 11, 1, 599.99, 0, 0),
(4, 12, 1, 449.99, 5, 0),
-- Pedido 5
(5, 16, 2, 29.99, 0, 0),
(5, 17, 1, 89.99, 0, 0),
(5, 18, 1, 499.99, 10, 0),
-- Pedido 6
(6, 21, 5, 15.99, 0, 0),
(6, 22, 2, 29.99, 0, 0),
-- Pedido 7
(7, 5, 1, 299.99, 0, 0),
(7, 4, 2, 199.99, 10, 0),
-- Pedido 8
(8, 9, 1, 89.99, 0, 0),
(8, 10, 1, 129.99, 0, 0),
-- Pedido 9
(9, 13, 3, 39.99, 0, 0),
(9, 14, 1, 199.99, 5, 0),
-- Pedido 10
(10, 15, 1, 349.99, 0, 0),
(10, 13, 2, 39.99, 0, 0),
-- Pedido 11
(11, 1, 1, 899.99, 15, 0),
(11, 5, 1, 299.99, 0, 0),
-- Pedido 12
(12, 6, 5, 19.99, 0, 0),
(12, 7, 3, 49.99, 0, 0),
(12, 8, 2, 79.99, 0, 0),
-- Pedido 13
(13, 19, 1, 79.99, 0, 0),
(13, 20, 2, 24.99, 0, 0),
-- Pedido 14
(14, 23, 3, 19.99, 0, 0),
(14, 24, 1, 24.99, 0, 0),
-- Pedido 15
(15, 2, 1, 1299.99, 12, 0),
(15, 3, 1, 399.99, 0, 0),
-- Pedido 16
(16, 11, 1, 599.99, 8, 0),
(16, 12, 1, 449.99, 0, 0),
-- Pedido 17
(17, 16, 4, 29.99, 0, 0),
(17, 17, 2, 89.99, 0, 0),
-- Pedido 18
(18, 21, 10, 15.99, 20, 0),
(18, 22, 3, 29.99, 0, 0),
-- Pedido 19
(19, 1, 1, 899.99, 0, 0),
(19, 4, 1, 199.99, 0, 0),
(19, 5, 1, 299.99, 0, 0),
-- Pedido 20
(20, 6, 8, 19.99, 0, 0),
(20, 7, 4, 49.99, 0, 0),
(20, 8, 2, 79.99, 0, 0),
-- Pedido 21
(21, 2, 1, 1299.99, 0, 0),
(21, 3, 1, 399.99, 0, 0),
-- Pedido 22
(22, 13, 5, 39.99, 0, 0),
(22, 14, 1, 199.99, 0, 0),
-- Pedido 23
(23, 18, 1, 499.99, 15, 0),
(23, 19, 1, 79.99, 0, 0),
-- Pedido 24
(24, 23, 6, 19.99, 0, 0),
(24, 24, 2, 24.99, 0, 0),
-- Pedido 25
(25, 1, 1, 899.99, 10, 0),
(25, 4, 1, 199.99, 0, 0),
(25, 5, 1, 299.99, 0, 0);

-- =====================================================
-- ACTUALIZAR TOTALES DE PEDIDOS
-- =====================================================
UPDATE pedidos p
SET total = (
    SELECT IFNULL(SUM(pi.subtotal), 0)
    FROM pedido_items pi
    WHERE pi.pedido_id = p.pedido_id
);

-- =====================================================
-- INSERTAR VENTAS DIARIAS (para análisis de rendimiento)
-- =====================================================
INSERT INTO ventas_diarias (fecha, producto_id, cantidad_vendida, ingresos, cliente_id, region) VALUES
('2024-01-15', 1, 1, 899.99, 1, 'Madrid'),
('2024-01-15', 4, 1, 189.99, 1, 'Madrid'),
('2024-01-16', 2, 1, 1169.99, 2, 'Barcelona'),
('2024-01-16', 3, 1, 399.99, 2, 'Barcelona'),
('2024-01-17', 6, 3, 59.97, 3, 'Valencia'),
('2024-01-17', 7, 2, 99.98, 3, 'Valencia'),
('2024-01-17', 8, 1, 67.99, 3, 'Valencia'),
('2024-01-18', 11, 1, 599.99, 4, 'Sevilla'),
('2024-01-18', 12, 1, 427.49, 4, 'Sevilla'),
('2024-01-19', 16, 2, 59.98, 5, 'Bilbao'),
('2024-01-19', 17, 1, 89.99, 5, 'Bilbao'),
('2024-01-19', 18, 1, 449.99, 5, 'Bilbao'),
('2024-01-20', 21, 5, 79.95, 6, 'Málaga'),
('2024-01-20', 22, 2, 59.98, 6, 'Málaga'),
('2024-01-21', 5, 1, 299.99, 7, 'Zaragoza'),
('2024-01-21', 4, 2, 359.98, 7, 'Zaragoza'),
('2024-01-22', 9, 1, 89.99, 8, 'Murcia'),
('2024-01-22', 10, 1, 129.99, 8, 'Murcia'),
('2024-01-23', 13, 3, 119.97, 9, 'Palma'),
('2024-01-23', 14, 1, 189.99, 9, 'Palma'),
('2024-01-24', 15, 1, 349.99, 10, 'Las Palmas'),
('2024-01-24', 13, 2, 79.98, 10, 'Las Palmas'),
('2024-02-01', 1, 1, 764.99, 11, 'Madrid'),
('2024-02-01', 5, 1, 299.99, 11, 'Madrid'),
('2024-02-02', 6, 5, 99.95, 12, 'Barcelona'),
('2024-02-02', 7, 3, 149.97, 12, 'Barcelona'),
('2024-02-02', 8, 2, 159.98, 12, 'Barcelona'),
('2024-02-03', 19, 1, 79.99, 13, 'Valencia'),
('2024-02-03', 20, 2, 49.98, 13, 'Valencia'),
('2024-02-04', 23, 3, 59.97, 14, 'Sevilla'),
('2024-02-04', 24, 1, 24.99, 14, 'Sevilla'),
('2024-02-05', 2, 1, 1143.99, 15, 'Bilbao'),
('2024-02-05', 3, 1, 399.99, 15, 'Bilbao'),
('2024-02-06', 11, 1, 551.99, 16, 'Málaga'),
('2024-02-06', 12, 1, 449.99, 16, 'Málaga'),
('2024-02-07', 16, 4, 119.96, 17, 'Zaragoza'),
('2024-02-07', 17, 2, 179.98, 17, 'Zaragoza'),
('2024-02-08', 21, 10, 127.92, 18, 'Murcia'),
('2024-02-08', 22, 3, 89.97, 18, 'Murcia'),
('2024-02-09', 1, 1, 899.99, 19, 'Palma'),
('2024-02-09', 4, 1, 199.99, 19, 'Palma'),
('2024-02-09', 5, 1, 299.99, 19, 'Palma'),
('2024-02-10', 6, 8, 159.92, 20, 'Las Palmas'),
('2024-02-10', 7, 4, 199.96, 20, 'Las Palmas'),
('2024-02-10', 8, 2, 159.98, 20, 'Las Palmas');

-- =====================================================
-- ACTUALIZAR ESTADÍSTICAS (MySQL)
-- =====================================================
-- Analizar todas las tablas para actualizar estadísticas
-- Nota: El trigger calculará automáticamente el subtotal
ANALYZE TABLE categorias;
ANALYZE TABLE productos;
ANALYZE TABLE clientes;
ANALYZE TABLE empleados;
ANALYZE TABLE departamentos;
ANALYZE TABLE pedidos;
ANALYZE TABLE pedido_items;
ANALYZE TABLE ventas_diarias;

-- =====================================================
-- FIN DEL SCRIPT DE INSERCIÓN
-- =====================================================

