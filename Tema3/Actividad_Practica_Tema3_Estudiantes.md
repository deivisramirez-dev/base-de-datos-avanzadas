# Actividad Práctica: SQL/XML y Base de Datos Nativa XML

## 📋 Información General

- **Tema:** Bases de Datos para Documentos XML
- **Duración:** 65 minutos
- **Nivel:** Intermedio
- **Objetivo:** Dominar la generación de XML desde datos relacionales y el uso de bases de datos nativas XML

## 🎯 Objetivos de Aprendizaje

Al finalizar esta actividad, serás capaz de:

1. **Generar documentos XML** desde datos relacionales usando funciones SQL/XML
2. **Configurar y utilizar** una base de datos nativa XML (BaseX)
3. **Escribir consultas XQuery** complejas para procesar documentos XML
4. **Comparar rendimientos** entre enfoques relacionales y nativos XML
5. **Analizar ventajas y desventajas** de cada enfoque según el contexto

## 📚 Prerrequisitos

- Conocimientos básicos de SQL
- Familiaridad con estructura XML
- Comprensión de bases de datos relacionales
- Acceso a PostgreSQL o MySQL
- Java instalado (para BaseX)

## 🛠️ Materiales Necesarios

### Software Requerido:
- **PostgreSQL 12+** o **MySQL 8+**
- **BaseX 10.6+** (descargar desde https://basex.org/download/)
- **Java 8+** (requisito para BaseX)
- **Editor de texto** o IDE (VS Code, IntelliJ, etc.)

### Datos de Prueba:
Se proporcionará un script SQL con datos de ejemplo para una librería digital.

## 📖 Descripción de la Actividad

Esta actividad te permitirá experimentar con dos enfoques diferentes para trabajar con datos XML:

1. **Enfoque Relacional:** Generar XML desde datos almacenados en tablas relacionales
2. **Enfoque Nativo:** Almacenar y consultar documentos XML directamente

## 🔧 Parte A: SQL/XML y Generación de XML (30 minutos)

### Objetivo
Aprender a generar documentos XML estructurados desde datos relacionales usando funciones SQL/XML.

### Paso 1: Preparación del Entorno (5 minutos)

1. **Crear base de datos:**
   ```sql
   CREATE DATABASE libreria_xml;
   \c libreria_xml;
   ```

2. **Crear tablas:**
   ```sql
   -- Tabla de autores
   CREATE TABLE autores (
       id SERIAL PRIMARY KEY,
       nombre VARCHAR(100) NOT NULL,
       apellido VARCHAR(100) NOT NULL,
       nacionalidad VARCHAR(50),
       fecha_nacimiento DATE
   );

   -- Tabla de libros
   CREATE TABLE libros (
       id SERIAL PRIMARY KEY,
       titulo VARCHAR(200) NOT NULL,
       isbn VARCHAR(20) UNIQUE,
       precio DECIMAL(10,2),
       paginas INTEGER,
       fecha_publicacion DATE,
       autor_id INTEGER REFERENCES autores(id)
   );

   -- Tabla de categorías
   CREATE TABLE categorias (
       id SERIAL PRIMARY KEY,
       nombre VARCHAR(100) NOT NULL,
       descripcion TEXT
   );

   -- Tabla de relación libro-categoría
   CREATE TABLE libro_categorias (
       libro_id INTEGER REFERENCES libros(id),
       categoria_id INTEGER REFERENCES categorias(id),
       PRIMARY KEY (libro_id, categoria_id)
   );
   ```

### Paso 2: Insertar Datos de Prueba (5 minutos)

```sql
-- Insertar autores
INSERT INTO autores (nombre, apellido, nacionalidad, fecha_nacimiento) VALUES
('Gabriel', 'García Márquez', 'Colombiana', '1927-03-06'),
('Mario', 'Vargas Llosa', 'Peruana', '1936-03-28'),
('Isabel', 'Allende', 'Chilena', '1942-08-02'),
('Jorge Luis', 'Borges', 'Argentina', '1899-08-24');

-- Insertar categorías
INSERT INTO categorias (nombre, descripcion) VALUES
('Literatura', 'Obras de ficción y literatura clásica'),
('Novela', 'Narrativa de ficción'),
('Ensayo', 'Textos de análisis y reflexión'),
('Poesía', 'Composiciones poéticas');

-- Insertar libros
INSERT INTO libros (titulo, isbn, precio, paginas, fecha_publicacion, autor_id) VALUES
('Cien años de soledad', '978-84-376-0494-7', 15.99, 471, '1967-05-30', 1),
('El amor en los tiempos del cólera', '978-84-376-0495-4', 12.99, 348, '1985-03-12', 1),
('La ciudad y los perros', '978-84-376-0496-1', 14.99, 312, '1963-01-01', 2),
('La casa de los espíritus', '978-84-376-0497-8', 16.99, 433, '1982-01-01', 3),
('Ficciones', '978-84-376-0498-5', 11.99, 156, '1944-01-01', 4);

-- Asignar categorías a libros
INSERT INTO libro_categorias VALUES
(1, 1), (1, 2),  -- Cien años de soledad: Literatura, Novela
(2, 1), (2, 2),  -- El amor en los tiempos del cólera: Literatura, Novela
(3, 1), (3, 2),  -- La ciudad y los perros: Literatura, Novela
(4, 1), (4, 2),  -- La casa de los espíritus: Literatura, Novela
(5, 1), (5, 3);  -- Ficciones: Literatura, Ensayo
```

### Paso 3: Generar XML Básico (10 minutos)

**Ejercicio 3.1:** Crear un documento XML con información de un libro específico.

```sql
-- Generar XML para el libro "Cien años de soledad"
SELECT XMLELEMENT(
    NAME "libro",
    XMLATTRIBUTES(
        l.isbn AS "isbn",
        l.precio AS "precio"
    ),
    XMLELEMENT(NAME "titulo", l.titulo),
    XMLELEMENT(NAME "autor", 
        XMLELEMENT(NAME "nombre", a.nombre),
        XMLELEMENT(NAME "apellido", a.apellido),
        XMLELEMENT(NAME "nacionalidad", a.nacionalidad)
    ),
    XMLELEMENT(NAME "detalles",
        XMLELEMENT(NAME "paginas", l.paginas),
        XMLELEMENT(NAME "fecha_publicacion", l.fecha_publicacion)
    )
) AS xml_libro
FROM libros l
JOIN autores a ON l.autor_id = a.id
WHERE l.titulo = 'Cien años de soledad';
```

**Ejercicio 3.2:** Generar XML con múltiples libros usando XMLAGG.

```sql
-- Generar catálogo XML con todos los libros
SELECT XMLELEMENT(
    NAME "catalogo",
    XMLATTRIBUTES(
        COUNT(*) AS "total_libros",
        AVG(l.precio) AS "precio_promedio"
    ),
    XMLAGG(
        XMLELEMENT(
            NAME "libro",
            XMLATTRIBUTES(l.isbn AS "isbn"),
            XMLELEMENT(NAME "titulo", l.titulo),
            XMLELEMENT(NAME "autor", a.nombre || ' ' || a.apellido),
            XMLELEMENT(NAME "precio", l.precio)
        )
        ORDER BY l.titulo
    )
) AS catalogo_xml
FROM libros l
JOIN autores a ON l.autor_id = a.id;
```

### Paso 4: Consultas XML Avanzadas (10 minutos)

**Ejercicio 4.1:** Generar XML con categorías anidadas.

```sql
-- Generar XML con libros agrupados por categoría
SELECT XMLELEMENT(
    NAME "biblioteca",
    XMLAGG(
        XMLELEMENT(
            NAME "categoria",
            XMLATTRIBUTES(c.nombre AS "nombre"),
            XMLELEMENT(NAME "descripcion", c.descripcion),
            XMLAGG(
                XMLELEMENT(
                    NAME "libro",
                    XMLELEMENT(NAME "titulo", l.titulo),
                    XMLELEMENT(NAME "autor", a.nombre || ' ' || a.apellido)
                )
                ORDER BY l.titulo
            )
        )
        ORDER BY c.nombre
    )
) AS biblioteca_xml
FROM categorias c
LEFT JOIN libro_categorias lc ON c.id = lc.categoria_id
LEFT JOIN libros l ON lc.libro_id = l.id
LEFT JOIN autores a ON l.autor_id = a.id
GROUP BY c.id, c.nombre, c.descripcion;
```

## 🗄️ Parte B: Base de Datos Nativa XML (35 minutos)

### Objetivo
Configurar y utilizar BaseX para almacenar y consultar documentos XML nativamente.

### Paso 1: Instalación y Configuración de BaseX (10 minutos)

1. **Descargar BaseX:**
   - Ir a https://basex.org/download/
   - Descargar BaseX 10.6+ para tu sistema operativo

2. **Instalación:**
   ```bash
   # Windows
   Ejecutar: basex-10.6-windows.exe

   # Linux/Mac
   tar -xzf basex-10.6.tar.gz
   cd basex-10.6
   ./bin/basex
   ```

3. **Verificar instalación:**
   ```bash
   basex -c "1 + 1"
   # Debería mostrar: 2
   ```

### Paso 2: Crear Base de Datos y Colecciones (10 minutos)

1. **Iniciar BaseX GUI:**
   ```bash
   basex
   ```

2. **Crear nueva base de datos:**
   ```xquery
   (: Crear base de datos libreria :)
   db:create("libreria")
   ```

3. **Insertar documentos XML:**
   ```xquery
   (: Insertar documento de autor :)
   db:add("libreria", 
   <autor id="1">
       <nombre>Gabriel</nombre>
       <apellido>García Márquez</apellido>
       <nacionalidad>Colombiana</nacionalidad>
       <fecha_nacimiento>1927-03-06</fecha_nacimiento>
       <libros>
           <libro isbn="978-84-376-0494-7">
               <titulo>Cien años de soledad</titulo>
               <precio>15.99</precio>
               <paginas>471</paginas>
               <fecha_publicacion>1967-05-30</fecha_publicacion>
               <categorias>
                   <categoria>Literatura</categoria>
                   <categoria>Novela</categoria>
               </categorias>
           </libro>
           <libro isbn="978-84-376-0495-4">
               <titulo>El amor en los tiempos del cólera</titulo>
               <precio>12.99</precio>
               <paginas>348</paginas>
               <fecha_publicacion>1985-03-12</fecha_publicacion>
               <categorias>
                   <categoria>Literatura</categoria>
                   <categoria>Novela</categoria>
               </categorias>
           </libro>
       </libros>
   </autor>, "garcia_marquez.xml")
   ```

### Paso 3: Consultas XQuery Básicas (10 minutos)

**Ejercicio 3.1:** Consulta simple de libros.

```xquery
(: Buscar todos los libros :)
for $libro in collection("libreria")//libro
return $libro/titulo
```

**Ejercicio 3.2:** Consulta con filtros.

```xquery
(: Buscar libros con precio mayor a 14 euros :)
for $libro in collection("libreria")//libro
where $libro/precio > 14
return 
    <libro_caro>
        <titulo>{$libro/titulo/text()}</titulo>
        <precio>{$libro/precio/text()}</precio>
        <autor>{$libro/../nombre/text()} {$libro/../apellido/text()}</autor>
    </libro_caro>
```

**Ejercicio 3.3:** Consulta con agregación.

```xquery
(: Estadísticas por autor :)
for $autor in collection("libreria")//autor
let $libros := $autor/libros/libro
return
    <estadisticas_autor>
        <nombre>{$autor/nombre/text()} {$autor/apellido/text()}</nombre>
        <total_libros>{count($libros)}</total_libros>
        <precio_promedio>{avg($libros/precio)}</precio_promedio>
        <precio_maximo>{max($libros/precio)}</precio_maximo>
        <precio_minimo>{min($libros/precio)}</precio_minimo>
    </estadisticas_autor>
```

### Paso 4: Consultas XQuery Avanzadas (5 minutos)

**Ejercicio 4.1:** Consulta compleja con joins implícitos.

```xquery
(: Buscar libros de autores colombianos :)
for $autor in collection("libreria")//autor
where $autor/nacionalidad = "Colombiana"
for $libro in $autor/libros/libro
return
    <libro_colombiano>
        <titulo>{$libro/titulo/text()}</titulo>
        <autor>{$autor/nombre/text()} {$autor/apellido/text()}</autor>
        <nacionalidad>{$autor/nacionalidad/text()}</nacionalidad>
        <precio>{$libro/precio/text()}</precio>
    </libro_colombiano>
```

## 📊 Análisis Comparativo

### Ejercicio Final: Comparación de Rendimiento (10 minutos)

1. **Medir tiempo de consulta en PostgreSQL:**
   ```sql
   EXPLAIN ANALYZE
   SELECT XMLELEMENT(NAME "libro", l.titulo, l.precio)
   FROM libros l
   WHERE l.precio > 14;
   ```

2. **Medir tiempo de consulta en BaseX:**
   ```xquery
   (: Consulta equivalente en BaseX :)
   for $libro in collection("libreria")//libro
   where $libro/precio > 14
   return <libro>{$libro/titulo}{$libro/precio}</libro>
   ```

3. **Anotar resultados y comparar:**
   - Tiempo de ejecución
   - Facilidad de escritura
   - Legibilidad del código
   - Flexibilidad de consultas

## 📝 Entregables

Al finalizar la actividad, debes entregar:

1. **Scripts SQL** con todas las consultas de generación XML
2. **Archivos XQuery** con las consultas de BaseX
3. **Documento XML** generado desde PostgreSQL
4. **Resultados de consultas** de BaseX
5. **Análisis comparativo** con conclusiones sobre:
   - Rendimiento de cada enfoque
   - Facilidad de implementación
   - Casos de uso ideales para cada tecnología

## 🎯 Criterios de Evaluación

- **Completitud (40%):** Todas las consultas funcionan correctamente
- **Calidad del código (30%):** Código limpio y bien estructurado
- **Análisis crítico (20%):** Conclusiones fundamentadas sobre ventajas/desventajas
- **Documentación (10%):** Comentarios claros y explicaciones

## 💡 Consejos y Recomendaciones

1. **Para PostgreSQL:** Usa `EXPLAIN ANALYZE` para optimizar consultas
2. **Para BaseX:** Aprovecha los índices automáticos para mejorar rendimiento
3. **Documentación:** Comenta tu código para facilitar el entendimiento
4. **Pruebas:** Verifica que los resultados XML sean válidos
5. **Comparación:** Sé objetivo en el análisis de ventajas y desventajas

## 🔗 Recursos Adicionales

- [Documentación PostgreSQL XML](https://www.postgresql.org/docs/current/datatype-xml.html)
- [Tutorial BaseX](https://docs.basex.org/wiki/Tutorial)
- [Especificación XQuery](https://www.w3.org/TR/xquery-31/)
- [Validador XML](https://www.xmlvalidation.com/)

---

**¡Buena suerte con la actividad!** 🚀

Recuerda que el objetivo es entender cuándo usar cada enfoque según las necesidades específicas de tu proyecto.
