# Solución Completa: Sistema de Gestión Universitaria "EduTech"

## 📋 Información del Proyecto
- **Sistema:** EduTech - Gestión Universitaria
- **Tipo:** Base de Datos Relacional
- **SGBD:** PostgreSQL 14+
- **Volumen:** 15,000 estudiantes, 800 profesores, 120 programas

---

## 🗂️ Diccionario de Datos Completo

### 1. Entidad: ESTUDIANTE
```sql
CREATE TABLE estudiante (
    estudiante_id SERIAL PRIMARY KEY,
    codigo_estudiante VARCHAR(10) UNIQUE NOT NULL,
    cedula VARCHAR(20) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero CHAR(1) CHECK (genero IN ('M', 'F', 'O')),
    telefono VARCHAR(15),
    email VARCHAR(100) UNIQUE NOT NULL,
    direccion TEXT,
    programa_id INTEGER REFERENCES programa(programa_id),
    semestre_actual INTEGER CHECK (semestre_actual > 0),
    estado_academico VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_ingreso DATE NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. Entidad: PROFESOR
```sql
CREATE TABLE profesor (
    profesor_id SERIAL PRIMARY KEY,
    codigo_profesor VARCHAR(10) UNIQUE NOT NULL,
    cedula VARCHAR(20) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero CHAR(1) CHECK (genero IN ('M', 'F', 'O')),
    telefono VARCHAR(15),
    email VARCHAR(100) UNIQUE NOT NULL,
    direccion TEXT,
    titulo_academico VARCHAR(100),
    especialidad VARCHAR(100),
    tipo_contrato VARCHAR(20) CHECK (tipo_contrato IN ('TIEMPO_COMPLETO', 'MEDIO_TIEMPO', 'CATEDRA')),
    salario DECIMAL(10,2),
    fecha_ingreso DATE NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 3. Entidad: PROGRAMA
```sql
CREATE TABLE programa (
    programa_id SERIAL PRIMARY KEY,
    codigo_programa VARCHAR(10) UNIQUE NOT NULL,
    nombre_programa VARCHAR(200) NOT NULL,
    descripcion TEXT,
    tipo_programa VARCHAR(20) CHECK (tipo_programa IN ('PREGRADO', 'POSGRADO', 'DIPLOMADO')),
    duracion_semestres INTEGER CHECK (duracion_semestres > 0),
    creditos_totales INTEGER CHECK (creditos_totales > 0),
    facultad_id INTEGER REFERENCES facultad(facultad_id),
    director_programa_id INTEGER REFERENCES profesor(profesor_id),
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 4. Entidad: FACULTAD
```sql
CREATE TABLE facultad (
    facultad_id SERIAL PRIMARY KEY,
    codigo_facultad VARCHAR(10) UNIQUE NOT NULL,
    nombre_facultad VARCHAR(200) NOT NULL,
    descripcion TEXT,
    decano_id INTEGER REFERENCES profesor(profesor_id),
    campus_id INTEGER REFERENCES campus(campus_id),
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 5. Entidad: CAMPUS
```sql
CREATE TABLE campus (
    campus_id SERIAL PRIMARY KEY,
    codigo_campus VARCHAR(10) UNIQUE NOT NULL,
    nombre_campus VARCHAR(200) NOT NULL,
    direccion TEXT NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 6. Entidad: MATERIA
```sql
CREATE TABLE materia (
    materia_id SERIAL PRIMARY KEY,
    codigo_materia VARCHAR(10) UNIQUE NOT NULL,
    nombre_materia VARCHAR(200) NOT NULL,
    descripcion TEXT,
    creditos INTEGER CHECK (creditos > 0),
    horas_teoria INTEGER CHECK (horas_teoria >= 0),
    horas_practica INTEGER CHECK (horas_practica >= 0),
    programa_id INTEGER REFERENCES programa(programa_id),
    prerequisitos TEXT,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 7. Entidad: AULA
```sql
CREATE TABLE aula (
    aula_id SERIAL PRIMARY KEY,
    codigo_aula VARCHAR(20) UNIQUE NOT NULL,
    nombre_aula VARCHAR(100) NOT NULL,
    capacidad INTEGER CHECK (capacidad > 0),
    tipo_aula VARCHAR(20) CHECK (tipo_aula IN ('TEORIA', 'LABORATORIO', 'AUDITORIO', 'SALON')),
    equipamiento TEXT,
    campus_id INTEGER REFERENCES campus(campus_id),
    estado VARCHAR(20) DEFAULT 'DISPONIBLE',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 8. Entidad: HORARIO
```sql
CREATE TABLE horario (
    horario_id SERIAL PRIMARY KEY,
    materia_id INTEGER REFERENCES materia(materia_id),
    profesor_id INTEGER REFERENCES profesor(profesor_id),
    aula_id INTEGER REFERENCES aula(aula_id),
    dia_semana INTEGER CHECK (dia_semana BETWEEN 1 AND 7), -- 1=Lunes, 7=Domingo
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    semestre VARCHAR(10) NOT NULL,
    año INTEGER NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_hora_fin CHECK (hora_fin > hora_inicio)
);
```

### 9. Entidad: INSCRIPCION
```sql
CREATE TABLE inscripcion (
    inscripcion_id SERIAL PRIMARY KEY,
    estudiante_id INTEGER REFERENCES estudiante(estudiante_id),
    materia_id INTEGER REFERENCES materia(materia_id),
    horario_id INTEGER REFERENCES horario(horario_id),
    semestre VARCHAR(10) NOT NULL,
    año INTEGER NOT NULL,
    fecha_inscripcion DATE DEFAULT CURRENT_DATE,
    estado VARCHAR(20) DEFAULT 'INSCRITO',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_estudiante_materia_semestre UNIQUE (estudiante_id, materia_id, semestre, año)
);
```

### 10. Entidad: CALIFICACION
```sql
CREATE TABLE calificacion (
    calificacion_id SERIAL PRIMARY KEY,
    inscripcion_id INTEGER REFERENCES inscripcion(inscripcion_id),
    tipo_evaluacion VARCHAR(50) NOT NULL,
    nota DECIMAL(4,2) CHECK (nota >= 0 AND nota <= 5.0),
    porcentaje DECIMAL(5,2) CHECK (porcentaje >= 0 AND porcentaje <= 100),
    fecha_evaluacion DATE NOT NULL,
    observaciones TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 11. Entidad: LIBRO
```sql
CREATE TABLE libro (
    libro_id SERIAL PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE,
    titulo VARCHAR(300) NOT NULL,
    autor VARCHAR(200) NOT NULL,
    editorial VARCHAR(100),
    año_publicacion INTEGER,
    categoria VARCHAR(100),
    ejemplares_totales INTEGER CHECK (ejemplares_totales > 0),
    ejemplares_disponibles INTEGER CHECK (ejemplares_disponibles >= 0),
    ubicacion VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'DISPONIBLE',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 12. Entidad: PRESTAMO
```sql
CREATE TABLE prestamo (
    prestamo_id SERIAL PRIMARY KEY,
    estudiante_id INTEGER REFERENCES estudiante(estudiante_id),
    libro_id INTEGER REFERENCES libro(libro_id),
    fecha_prestamo DATE DEFAULT CURRENT_DATE,
    fecha_vencimiento DATE NOT NULL,
    fecha_devolucion DATE,
    estado VARCHAR(20) DEFAULT 'PRESTADO',
    observaciones TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_fecha_vencimiento CHECK (fecha_vencimiento > fecha_prestamo)
);
```

---

## 🔗 Índices para Optimización

```sql
-- Índices para mejorar rendimiento
CREATE INDEX idx_estudiante_codigo ON estudiante(codigo_estudiante);
CREATE INDEX idx_estudiante_email ON estudiante(email);
CREATE INDEX idx_estudiante_programa ON estudiante(programa_id);

CREATE INDEX idx_profesor_codigo ON profesor(codigo_profesor);
CREATE INDEX idx_profesor_email ON profesor(email);

CREATE INDEX idx_materia_codigo ON materia(codigo_materia);
CREATE INDEX idx_materia_programa ON materia(programa_id);

CREATE INDEX idx_horario_materia ON horario(materia_id);
CREATE INDEX idx_horario_profesor ON horario(profesor_id);
CREATE INDEX idx_horario_aula ON horario(aula_id);
CREATE INDEX idx_horario_semestre ON horario(semestre, año);

CREATE INDEX idx_inscripcion_estudiante ON inscripcion(estudiante_id);
CREATE INDEX idx_inscripcion_materia ON inscripcion(materia_id);
CREATE INDEX idx_inscripcion_semestre ON inscripcion(semestre, año);

CREATE INDEX idx_calificacion_inscripcion ON calificacion(inscripcion_id);
CREATE INDEX idx_calificacion_fecha ON calificacion(fecha_evaluacion);

CREATE INDEX idx_prestamo_estudiante ON prestamo(estudiante_id);
CREATE INDEX idx_prestamo_libro ON prestamo(libro_id);
CREATE INDEX idx_prestamo_fecha ON prestamo(fecha_prestamo);
```

---

## 📊 Consultas de Ejemplo

### 1. Consultas Básicas de Información

#### Estudiantes por Programa
```sql
SELECT 
    p.nombre_programa,
    COUNT(e.estudiante_id) as total_estudiantes
FROM programa p
LEFT JOIN estudiante e ON p.programa_id = e.programa_id
WHERE e.estado_academico = 'ACTIVO'
GROUP BY p.programa_id, p.nombre_programa
ORDER BY total_estudiantes DESC;
```

#### Profesores por Facultad
```sql
SELECT 
    f.nombre_facultad,
    COUNT(pr.profesor_id) as total_profesores,
    AVG(pr.salario) as salario_promedio
FROM facultad f
LEFT JOIN programa p ON f.facultad_id = p.facultad_id
LEFT JOIN profesor pr ON p.director_programa_id = pr.profesor_id
GROUP BY f.facultad_id, f.nombre_facultad
ORDER BY total_profesores DESC;
```

### 2. Consultas Académicas

#### Calificaciones por Estudiante
```sql
SELECT 
    e.codigo_estudiante,
    e.nombres || ' ' || e.apellidos as nombre_completo,
    m.nombre_materia,
    AVG(c.nota) as promedio_materia,
    COUNT(c.calificacion_id) as total_evaluaciones
FROM estudiante e
JOIN inscripcion i ON e.estudiante_id = i.estudiante_id
JOIN materia m ON i.materia_id = m.materia_id
JOIN calificacion c ON i.inscripcion_id = c.inscripcion_id
WHERE i.semestre = '2024-1'
GROUP BY e.estudiante_id, e.codigo_estudiante, e.nombres, e.apellidos, m.materia_id, m.nombre_materia
ORDER BY promedio_materia DESC;
```

#### Horarios por Profesor
```sql
SELECT 
    pr.codigo_profesor,
    pr.nombres || ' ' || pr.apellidos as nombre_profesor,
    m.nombre_materia,
    h.dia_semana,
    h.hora_inicio,
    h.hora_fin,
    a.nombre_aula
FROM profesor pr
JOIN horario h ON pr.profesor_id = h.profesor_id
JOIN materia m ON h.materia_id = m.materia_id
JOIN aula a ON h.aula_id = a.aula_id
WHERE h.semestre = '2024-1' AND h.estado = 'ACTIVO'
ORDER BY pr.profesor_id, h.dia_semana, h.hora_inicio;
```

### 3. Consultas de Biblioteca

#### Libros Más Prestados
```sql
SELECT 
    l.titulo,
    l.autor,
    COUNT(p.prestamo_id) as total_prestamos,
    COUNT(CASE WHEN p.estado = 'PRESTADO' THEN 1 END) as prestamos_activos
FROM libro l
LEFT JOIN prestamo p ON l.libro_id = p.libro_id
GROUP BY l.libro_id, l.titulo, l.autor
ORDER BY total_prestamos DESC
LIMIT 10;
```

#### Estudiantes con Préstamos Vencidos
```sql
SELECT 
    e.codigo_estudiante,
    e.nombres || ' ' || e.apellidos as nombre_estudiante,
    l.titulo as libro_prestado,
    p.fecha_prestamo,
    p.fecha_vencimiento,
    CURRENT_DATE - p.fecha_vencimiento as dias_vencido
FROM estudiante e
JOIN prestamo p ON e.estudiante_id = p.estudiante_id
JOIN libro l ON p.libro_id = l.libro_id
WHERE p.estado = 'PRESTADO' 
  AND p.fecha_vencimiento < CURRENT_DATE
ORDER BY dias_vencido DESC;
```

### 4. Consultas Estadísticas

#### Rendimiento Académico por Programa
```sql
SELECT 
    p.nombre_programa,
    COUNT(DISTINCT e.estudiante_id) as total_estudiantes,
    AVG(promedio_estudiante.promedio) as promedio_programa,
    COUNT(CASE WHEN promedio_estudiante.promedio >= 4.0 THEN 1 END) as estudiantes_excelentes,
    COUNT(CASE WHEN promedio_estudiante.promedio < 3.0 THEN 1 END) as estudiantes_reprobados
FROM programa p
JOIN estudiante e ON p.programa_id = e.programa_id
JOIN (
    SELECT 
        i.estudiante_id,
        AVG(c.nota) as promedio
    FROM inscripcion i
    JOIN calificacion c ON i.inscripcion_id = c.inscripcion_id
    WHERE i.semestre = '2024-1'
    GROUP BY i.estudiante_id
) promedio_estudiante ON e.estudiante_id = promedio_estudiante.estudiante_id
GROUP BY p.programa_id, p.nombre_programa
ORDER BY promedio_programa DESC;
```

---

## 🔧 Funciones y Procedimientos Almacenados

### 1. Función para Calcular Promedio de Estudiante
```sql
CREATE OR REPLACE FUNCTION calcular_promedio_estudiante(
    p_estudiante_id INTEGER,
    p_semestre VARCHAR(10)
) RETURNS DECIMAL(4,2) AS $$
DECLARE
    promedio DECIMAL(4,2);
BEGIN
    SELECT AVG(c.nota) INTO promedio
    FROM inscripcion i
    JOIN calificacion c ON i.inscripcion_id = c.inscripcion_id
    WHERE i.estudiante_id = p_estudiante_id
      AND i.semestre = p_semestre;
    
    RETURN COALESCE(promedio, 0);
END;
$$ LANGUAGE plpgsql;
```

### 2. Procedimiento para Registrar Calificación
```sql
CREATE OR REPLACE PROCEDURE registrar_calificacion(
    p_inscripcion_id INTEGER,
    p_tipo_evaluacion VARCHAR(50),
    p_nota DECIMAL(4,2),
    p_porcentaje DECIMAL(5,2),
    p_observaciones TEXT DEFAULT NULL
) AS $$
BEGIN
    INSERT INTO calificacion (
        inscripcion_id,
        tipo_evaluacion,
        nota,
        porcentaje,
        fecha_evaluacion,
        observaciones
    ) VALUES (
        p_inscripcion_id,
        p_tipo_evaluacion,
        p_nota,
        p_porcentaje,
        CURRENT_DATE,
        p_observaciones
    );
    
    -- Actualizar fecha de actualización de la inscripción
    UPDATE inscripcion 
    SET fecha_actualizacion = CURRENT_TIMESTAMP
    WHERE inscripcion_id = p_inscripcion_id;
END;
$$ LANGUAGE plpgsql;
```

### 3. Función para Verificar Disponibilidad de Aula
```sql
CREATE OR REPLACE FUNCTION verificar_disponibilidad_aula(
    p_aula_id INTEGER,
    p_dia_semana INTEGER,
    p_hora_inicio TIME,
    p_hora_fin TIME,
    p_semestre VARCHAR(10),
    p_año INTEGER
) RETURNS BOOLEAN AS $$
DECLARE
    conflicto_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO conflicto_count
    FROM horario h
    WHERE h.aula_id = p_aula_id
      AND h.dia_semana = p_dia_semana
      AND h.semestre = p_semestre
      AND h.año = p_año
      AND h.estado = 'ACTIVO'
      AND (
          (p_hora_inicio >= h.hora_inicio AND p_hora_inicio < h.hora_fin) OR
          (p_hora_fin > h.hora_inicio AND p_hora_fin <= h.hora_fin) OR
          (p_hora_inicio <= h.hora_inicio AND p_hora_fin >= h.hora_fin)
      );
    
    RETURN conflicto_count = 0;
END;
$$ LANGUAGE plpgsql;
```

---

## 📈 Triggers para Integridad de Datos

### 1. Trigger para Actualizar Ejemplares Disponibles
```sql
CREATE OR REPLACE FUNCTION actualizar_ejemplares_disponibles()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Nuevo préstamo
        UPDATE libro 
        SET ejemplares_disponibles = ejemplares_disponibles - 1
        WHERE libro_id = NEW.libro_id;
        
    ELSIF TG_OP = 'UPDATE' THEN
        -- Cambio de estado del préstamo
        IF OLD.estado = 'PRESTADO' AND NEW.estado = 'DEVUELTO' THEN
            UPDATE libro 
            SET ejemplares_disponibles = ejemplares_disponibles + 1
            WHERE libro_id = NEW.libro_id;
        END IF;
        
    ELSIF TG_OP = 'DELETE' THEN
        -- Eliminación de préstamo
        UPDATE libro 
        SET ejemplares_disponibles = ejemplares_disponibles + 1
        WHERE libro_id = OLD.libro_id;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_ejemplares
    AFTER INSERT OR UPDATE OR DELETE ON prestamo
    FOR EACH ROW EXECUTE FUNCTION actualizar_ejemplares_disponibles();
```

### 2. Trigger para Actualizar Fecha de Actualización
```sql
CREATE OR REPLACE FUNCTION actualizar_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.fecha_actualizacion = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar a todas las tablas principales
CREATE TRIGGER trigger_estudiante_timestamp
    BEFORE UPDATE ON estudiante
    FOR EACH ROW EXECUTE FUNCTION actualizar_timestamp();

CREATE TRIGGER trigger_profesor_timestamp
    BEFORE UPDATE ON profesor
    FOR EACH ROW EXECUTE FUNCTION actualizar_timestamp();

CREATE TRIGGER trigger_materia_timestamp
    BEFORE UPDATE ON materia
    FOR EACH ROW EXECUTE FUNCTION actualizar_timestamp();
```

---

## 🎯 Vistas para Reportes

### 1. Vista de Estudiantes Activos
```sql
CREATE VIEW vista_estudiantes_activos AS
SELECT 
    e.estudiante_id,
    e.codigo_estudiante,
    e.nombres,
    e.apellidos,
    e.email,
    p.nombre_programa,
    f.nombre_facultad,
    c.nombre_campus,
    e.semestre_actual,
    e.fecha_ingreso
FROM estudiante e
JOIN programa p ON e.programa_id = p.programa_id
JOIN facultad f ON p.facultad_id = f.facultad_id
JOIN campus c ON f.campus_id = c.campus_id
WHERE e.estado_academico = 'ACTIVO';
```

### 2. Vista de Horarios Completos
```sql
CREATE VIEW vista_horarios_completos AS
SELECT 
    h.horario_id,
    m.nombre_materia,
    pr.nombres || ' ' || pr.apellidos as profesor,
    a.nombre_aula,
    CASE h.dia_semana
        WHEN 1 THEN 'Lunes'
        WHEN 2 THEN 'Martes'
        WHEN 3 THEN 'Miércoles'
        WHEN 4 THEN 'Jueves'
        WHEN 5 THEN 'Viernes'
        WHEN 6 THEN 'Sábado'
        WHEN 7 THEN 'Domingo'
    END as dia_semana,
    h.hora_inicio,
    h.hora_fin,
    h.semestre,
    h.año
FROM horario h
JOIN materia m ON h.materia_id = m.materia_id
JOIN profesor pr ON h.profesor_id = pr.profesor_id
JOIN aula a ON h.aula_id = a.aula_id
WHERE h.estado = 'ACTIVO';
```

### 3. Vista de Rendimiento Académico
```sql
CREATE VIEW vista_rendimiento_academico AS
SELECT 
    e.estudiante_id,
    e.codigo_estudiante,
    e.nombres || ' ' || e.apellidos as nombre_estudiante,
    p.nombre_programa,
    i.semestre,
    i.año,
    AVG(c.nota) as promedio_semestre,
    COUNT(c.calificacion_id) as total_evaluaciones,
    CASE 
        WHEN AVG(c.nota) >= 4.5 THEN 'EXCELENTE'
        WHEN AVG(c.nota) >= 4.0 THEN 'SOBRESALIENTE'
        WHEN AVG(c.nota) >= 3.5 THEN 'BUENO'
        WHEN AVG(c.nota) >= 3.0 THEN 'ACEPTABLE'
        ELSE 'DEFICIENTE'
    END as calificacion_cualitativa
FROM estudiante e
JOIN inscripcion i ON e.estudiante_id = i.estudiante_id
JOIN programa p ON e.programa_id = p.programa_id
JOIN calificacion c ON i.inscripcion_id = c.inscripcion_id
GROUP BY e.estudiante_id, e.codigo_estudiante, e.nombres, e.apellidos, 
         p.nombre_programa, i.semestre, i.año;
```

---

## 📊 Datos de Prueba

### 1. Insertar Campus
```sql
INSERT INTO campus (codigo_campus, nombre_campus, direccion, ciudad, telefono, email) VALUES
('CAMP001', 'Campus Central', 'Calle 100 #15-20', 'Bogotá', '601-1234567', 'central@edutech.edu.co'),
('CAMP002', 'Campus Norte', 'Carrera 50 #80-25', 'Medellín', '604-2345678', 'norte@edutech.edu.co'),
('CAMP003', 'Campus Sur', 'Avenida 30 #45-67', 'Cali', '602-3456789', 'sur@edutech.edu.co');
```

### 2. Insertar Facultades
```sql
INSERT INTO facultad (codigo_facultad, nombre_facultad, descripcion, campus_id) VALUES
('FAC001', 'Facultad de Ingeniería', 'Programas de ingeniería y tecnología', 1),
('FAC002', 'Facultad de Ciencias Administrativas', 'Programas de administración y negocios', 1),
('FAC003', 'Facultad de Ciencias de la Salud', 'Programas de salud y medicina', 2),
('FAC004', 'Facultad de Humanidades', 'Programas de humanidades y ciencias sociales', 3);
```

### 3. Insertar Programas
```sql
INSERT INTO programa (codigo_programa, nombre_programa, descripcion, tipo_programa, duracion_semestres, creditos_totales, facultad_id) VALUES
('PROG001', 'Ingeniería de Sistemas', 'Programa de ingeniería en sistemas y computación', 'PREGRADO', 10, 160, 1),
('PROG002', 'Ingeniería Industrial', 'Programa de ingeniería industrial', 'PREGRADO', 10, 160, 1),
('PROG003', 'Administración de Empresas', 'Programa de administración de empresas', 'PREGRADO', 8, 128, 2),
('PROG004', 'Medicina', 'Programa de medicina', 'PREGRADO', 12, 200, 3),
('PROG005', 'Maestría en Gestión Tecnológica', 'Programa de posgrado en gestión tecnológica', 'POSGRADO', 4, 48, 1);
```

### 4. Insertar Profesores
```sql
INSERT INTO profesor (codigo_profesor, cedula, nombres, apellidos, fecha_nacimiento, genero, email, titulo_academico, especialidad, tipo_contrato, salario, fecha_ingreso) VALUES
('PROF001', '12345678', 'María', 'González', '1975-03-15', 'F', 'maria.gonzalez@edutech.edu.co', 'PhD en Ciencias de la Computación', 'Inteligencia Artificial', 'TIEMPO_COMPLETO', 8000000, '2010-01-15'),
('PROF002', '23456789', 'Carlos', 'Rodríguez', '1980-07-22', 'M', 'carlos.rodriguez@edutech.edu.co', 'MSc en Ingeniería Industrial', 'Logística', 'TIEMPO_COMPLETO', 7500000, '2012-08-01'),
('PROF003', '34567890', 'Ana', 'Martínez', '1978-11-10', 'F', 'ana.martinez@edutech.edu.co', 'PhD en Administración', 'Gestión Estratégica', 'TIEMPO_COMPLETO', 8200000, '2009-02-15'),
('PROF004', '45678901', 'Luis', 'Hernández', '1985-05-08', 'M', 'luis.hernandez@edutech.edu.co', 'MD PhD', 'Cardiología', 'TIEMPO_COMPLETO', 12000000, '2015-01-10');
```

### 5. Insertar Materias
```sql
INSERT INTO materia (codigo_materia, nombre_materia, descripcion, creditos, horas_teoria, horas_practica, programa_id) VALUES
('MAT001', 'Programación I', 'Fundamentos de programación', 4, 3, 2, 1),
('MAT002', 'Estructuras de Datos', 'Algoritmos y estructuras de datos', 4, 3, 2, 1),
('MAT003', 'Bases de Datos', 'Diseño y gestión de bases de datos', 4, 3, 2, 1),
('MAT004', 'Gestión de Proyectos', 'Metodologías de gestión de proyectos', 3, 3, 0, 2),
('MAT005', 'Anatomía Humana', 'Estudio de la anatomía del cuerpo humano', 6, 4, 4, 4),
('MAT006', 'Contabilidad General', 'Principios de contabilidad', 3, 3, 0, 3);
```

### 6. Insertar Aulas
```sql
INSERT INTO aula (codigo_aula, nombre_aula, capacidad, tipo_aula, equipamiento, campus_id) VALUES
('AULA001', 'Aula 101', 40, 'TEORIA', 'Proyector, Pizarra', 1),
('AULA002', 'Laboratorio de Sistemas', 25, 'LABORATORIO', 'Computadores, Proyector', 1),
('AULA003', 'Auditorio Principal', 200, 'AUDITORIO', 'Sistema de sonido, Proyector', 1),
('AULA004', 'Aula 201', 35, 'TEORIA', 'Proyector, Pizarra', 2),
('AULA005', 'Laboratorio de Anatomía', 20, 'LABORATORIO', 'Modelos anatómicos, Proyector', 2);
```

---

## 🔍 Consultas de Validación

### 1. Verificar Integridad de Datos
```sql
-- Verificar que no hay estudiantes sin programa
SELECT COUNT(*) as estudiantes_sin_programa
FROM estudiante 
WHERE programa_id IS NULL;

-- Verificar que no hay materias sin programa
SELECT COUNT(*) as materias_sin_programa
FROM materia 
WHERE programa_id IS NULL;

-- Verificar que no hay horarios sin aula
SELECT COUNT(*) as horarios_sin_aula
FROM horario 
WHERE aula_id IS NULL;
```

### 2. Consultas de Rendimiento
```sql
-- Tiempo de ejecución de consultas complejas
EXPLAIN ANALYZE
SELECT 
    p.nombre_programa,
    COUNT(e.estudiante_id) as total_estudiantes,
    AVG(calcular_promedio_estudiante(e.estudiante_id, '2024-1')) as promedio_programa
FROM programa p
LEFT JOIN estudiante e ON p.programa_id = e.programa_id
GROUP BY p.programa_id, p.nombre_programa;
```

---

## 📋 Script de Creación Completo

```sql
-- Script completo para crear la base de datos EduTech
-- Ejecutar en orden secuencial

-- 1. Crear base de datos
CREATE DATABASE edutech_db;

-- 2. Conectar a la base de datos
\c edutech_db;

-- 3. Crear extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 4. Ejecutar todas las tablas en orden
-- (Ejecutar todos los CREATE TABLE anteriores)

-- 5. Crear índices
-- (Ejecutar todos los CREATE INDEX anteriores)

-- 6. Crear funciones
-- (Ejecutar todas las funciones anteriores)

-- 7. Crear triggers
-- (Ejecutar todos los triggers anteriores)

-- 8. Crear vistas
-- (Ejecutar todas las vistas anteriores)

-- 9. Insertar datos de prueba
-- (Ejecutar todos los INSERT anteriores)

-- 10. Verificar creación
SELECT 
    schemaname,
    tablename,
    tableowner
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY tablename;
```

---

**¡Base de datos completa lista para implementar!** 🚀

Esta solución incluye:
- ✅ **12 tablas principales** con relaciones completas
- ✅ **Índices optimizados** para rendimiento
- ✅ **Funciones y procedimientos** para lógica de negocio
- ✅ **Triggers** para integridad de datos
- ✅ **Vistas** para reportes
- ✅ **Datos de prueba** para validación
- ✅ **Consultas de ejemplo** para diferentes casos de uso
