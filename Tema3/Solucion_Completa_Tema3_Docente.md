# Solución Completa: SQL/XML y Base de Datos Nativa XML

## 📋 Información para el Docente

- **Tema:** Bases de Datos para Documentos XML
- **Duración:** 65 minutos
- **Nivel:** Intermedio
- **Archivo estudiante:** `Actividad_Practica_Tema3_Estudiantes.md`

## 🎯 Objetivos de Aprendizaje Evaluados

1. ✅ Generar documentos XML desde datos relacionales usando funciones SQL/XML
2. ✅ Configurar y utilizar una base de datos nativa XML (BaseX)
3. ✅ Escribir consultas XQuery complejas para procesar documentos XML
4. ✅ Comparar rendimientos entre enfoques relacionales y nativos XML
5. ✅ Analizar ventajas y desventajas de cada enfoque según el contexto

## 📚 Soluciones Completas

## 🔧 Parte A: SQL/XML y Generación de XML

### Paso 1: Preparación del Entorno

**Script completo de creación de base de datos:**

```sql
-- Crear base de datos
CREATE DATABASE libreria_xml;
\c libreria_xml;

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

-- Crear índices para optimizar consultas XML
CREATE INDEX idx_libros_autor ON libros(autor_id);
CREATE INDEX idx_libros_precio ON libros(precio);
CREATE INDEX idx_libro_categorias_libro ON libro_categorias(libro_id);
CREATE INDEX idx_libro_categorias_categoria ON libro_categorias(categoria_id);
```

### Paso 2: Datos de Prueba Completos

```sql
-- Insertar autores
INSERT INTO autores (nombre, apellido, nacionalidad, fecha_nacimiento) VALUES
('Gabriel', 'García Márquez', 'Colombiana', '1927-03-06'),
('Mario', 'Vargas Llosa', 'Peruana', '1936-03-28'),
('Isabel', 'Allende', 'Chilena', '1942-08-02'),
('Jorge Luis', 'Borges', 'Argentina', '1899-08-24'),
('Julio', 'Cortázar', 'Argentina', '1914-08-26'),
('Pablo', 'Neruda', 'Chilena', '1904-07-12');

-- Insertar categorías
INSERT INTO categorias (nombre, descripcion) VALUES
('Literatura', 'Obras de ficción y literatura clásica'),
('Novela', 'Narrativa de ficción'),
('Ensayo', 'Textos de análisis y reflexión'),
('Poesía', 'Composiciones poéticas'),
('Realismo Mágico', 'Género literario latinoamericano'),
('Boom Latinoamericano', 'Movimiento literario de los años 60-70');

-- Insertar libros
INSERT INTO libros (titulo, isbn, precio, paginas, fecha_publicacion, autor_id) VALUES
('Cien años de soledad', '978-84-376-0494-7', 15.99, 471, '1967-05-30', 1),
('El amor en los tiempos del cólera', '978-84-376-0495-4', 12.99, 348, '1985-03-12', 1),
('Crónica de una muerte anunciada', '978-84-376-0496-1', 10.99, 120, '1981-01-01', 1),
('La ciudad y los perros', '978-84-376-0497-8', 14.99, 312, '1963-01-01', 2),
('La casa verde', '978-84-376-0498-5', 16.99, 433, '1966-01-01', 2),
('La casa de los espíritus', '978-84-376-0499-2', 16.99, 433, '1982-01-01', 3),
('Eva Luna', '978-84-376-0500-5', 13.99, 280, '1987-01-01', 3),
('Ficciones', '978-84-376-0501-2', 11.99, 156, '1944-01-01', 4),
('El Aleph', '978-84-376-0502-9', 12.99, 180, '1949-01-01', 4),
('Rayuela', '978-84-376-0503-6', 17.99, 736, '1963-01-01', 5),
('Veinte poemas de amor', '978-84-376-0504-3', 9.99, 80, '1924-01-01', 6);

-- Asignar categorías a libros
INSERT INTO libro_categorias VALUES
-- Gabriel García Márquez
(1, 1), (1, 2), (1, 5), (1, 6),  -- Cien años de soledad
(2, 1), (2, 2), (2, 5),          -- El amor en los tiempos del cólera
(3, 1), (3, 2), (3, 5),          -- Crónica de una muerte anunciada
-- Mario Vargas Llosa
(4, 1), (4, 2), (4, 6),          -- La ciudad y los perros
(5, 1), (5, 2), (5, 6),          -- La casa verde
-- Isabel Allende
(6, 1), (6, 2), (6, 5),          -- La casa de los espíritus
(7, 1), (7, 2), (7, 5),          -- Eva Luna
-- Jorge Luis Borges
(8, 1), (8, 3),                   -- Ficciones
(9, 1), (9, 3),                   -- El Aleph
-- Julio Cortázar
(10, 1), (10, 2), (10, 6),       -- Rayuela
-- Pablo Neruda
(11, 1), (11, 4);                 -- Veinte poemas de amor
```

### Paso 3: Soluciones de Generación XML

**Ejercicio 3.1 - Solución:**

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

-- Resultado esperado:
-- <libro isbn="978-84-376-0494-7" precio="15.99">
--   <titulo>Cien años de soledad</titulo>
--   <autor>
--     <nombre>Gabriel</nombre>
--     <apellido>García Márquez</apellido>
--     <nacionalidad>Colombiana</nacionalidad>
--   </autor>
--   <detalles>
--     <paginas>471</paginas>
--     <fecha_publicacion>1967-05-30</fecha_publicacion>
--   </detalles>
-- </libro>
```

**Ejercicio 3.2 - Solución:**

```sql
-- Generar catálogo XML con todos los libros
SELECT XMLELEMENT(
    NAME "catalogo",
    XMLATTRIBUTES(
        COUNT(*) AS "total_libros",
        ROUND(AVG(l.precio), 2) AS "precio_promedio"
    ),
    XMLAGG(
        XMLELEMENT(
            NAME "libro",
            XMLATTRIBUTES(l.isbn AS "isbn"),
            XMLELEMENT(NAME "titulo", l.titulo),
            XMLELEMENT(NAME "autor", a.nombre || ' ' || a.apellido),
            XMLELEMENT(NAME "precio", l.precio),
            XMLELEMENT(NAME "nacionalidad", a.nacionalidad)
        )
        ORDER BY l.titulo
    )
) AS catalogo_xml
FROM libros l
JOIN autores a ON l.autor_id = a.id;

-- Resultado esperado: XML con todos los libros ordenados alfabéticamente
```

**Ejercicio 4.1 - Solución:**

```sql
-- Generar XML con libros agrupados por categoría
SELECT XMLELEMENT(
    NAME "biblioteca",
    XMLATTRIBUTES(
        COUNT(DISTINCT c.id) AS "total_categorias",
        COUNT(l.id) AS "total_libros"
    ),
    XMLAGG(
        XMLELEMENT(
            NAME "categoria",
            XMLATTRIBUTES(c.nombre AS "nombre"),
            XMLELEMENT(NAME "descripcion", c.descripcion),
            XMLELEMENT(NAME "total_libros", COUNT(l.id)),
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

## 🗄️ Parte B: Base de Datos Nativa XML

### Paso 1: Configuración BaseX

**Comandos de instalación y verificación:**

```bash
# Verificar Java
java -version
# Debería mostrar Java 8 o superior

# Iniciar BaseX
basex

# Comandos básicos en BaseX
db:create("libreria")
db:list()
```

### Paso 2: Documentos XML Completos

**Documento completo de Gabriel García Márquez:**

```xml
<autor id="1">
    <nombre>Gabriel</nombre>
    <apellido>García Márquez</apellido>
    <nacionalidad>Colombiana</nacionalidad>
    <fecha_nacimiento>1927-03-06</fecha_nacimiento>
    <biografia>
        <lugar_nacimiento>Aracataca, Colombia</lugar_nacimiento>
        <premios>
            <premio año="1982">Premio Nobel de Literatura</premio>
        </premios>
    </biografia>
    <libros>
        <libro isbn="978-84-376-0494-7">
            <titulo>Cien años de soledad</titulo>
            <precio>15.99</precio>
            <paginas>471</paginas>
            <fecha_publicacion>1967-05-30</fecha_publicacion>
            <categorias>
                <categoria>Literatura</categoria>
                <categoria>Novela</categoria>
                <categoria>Realismo Mágico</categoria>
                <categoria>Boom Latinoamericano</categoria>
            </categorias>
            <sinopsis>La historia de la familia Buendía a lo largo de siete generaciones en el pueblo ficticio de Macondo.</sinopsis>
        </libro>
        <libro isbn="978-84-376-0495-4">
            <titulo>El amor en los tiempos del cólera</titulo>
            <precio>12.99</precio>
            <paginas>348</paginas>
            <fecha_publicacion>1985-03-12</fecha_publicacion>
            <categorias>
                <categoria>Literatura</categoria>
                <categoria>Novela</categoria>
                <categoria>Realismo Mágico</categoria>
            </categorias>
            <sinopsis>Historia de amor entre Fermina Daza y Florentino Ariza que abarca más de cincuenta años.</sinopsis>
        </libro>
        <libro isbn="978-84-376-0496-1">
            <titulo>Crónica de una muerte anunciada</titulo>
            <precio>10.99</precio>
            <paginas>120</paginas>
            <fecha_publicacion>1981-01-01</fecha_publicacion>
            <categorias>
                <categoria>Literatura</categoria>
                <categoria>Novela</categoria>
                <categoria>Realismo Mágico</categoria>
            </categorias>
            <sinopsis>Reconstrucción periodística del asesinato de Santiago Nasar.</sinopsis>
        </libro>
    </libros>
</autor>
```

**Comando para insertar en BaseX:**

```xquery
db:add("libreria", 
<autor id="1">
    <!-- Contenido XML completo aquí -->
</autor>, "garcia_marquez.xml")
```

### Paso 3: Soluciones XQuery

**Ejercicio 3.1 - Solución:**

```xquery
(: Buscar todos los libros :)
for $libro in collection("libreria")//libro
return 
    <libro>
        <titulo>{$libro/titulo/text()}</titulo>
        <precio>{$libro/precio/text()}</precio>
        <autor>{$libro/../nombre/text()} {$libro/../apellido/text()}</autor>
    </libro>

(: Resultado esperado: Lista de todos los libros con título, precio y autor :)
```

**Ejercicio 3.2 - Solución:**

```xquery
(: Buscar libros con precio mayor a 14 euros :)
for $libro in collection("libreria")//libro
where $libro/precio > 14
return 
    <libro_caro>
        <titulo>{$libro/titulo/text()}</titulo>
        <precio>{$libro/precio/text()}</precio>
        <autor>{$libro/../nombre/text()} {$libro/../apellido/text()}</autor>
        <nacionalidad>{$libro/../nacionalidad/text()}</nacionalidad>
    </libro_caro>

(: Resultado esperado: Libros caros con información completa :)
```

**Ejercicio 3.3 - Solución:**

```xquery
(: Estadísticas por autor :)
for $autor in collection("libreria")//autor
let $libros := $autor/libros/libro
return
    <estadisticas_autor>
        <nombre>{$autor/nombre/text()} {$autor/apellido/text()}</nombre>
        <nacionalidad>{$autor/nacionalidad/text()}</nacionalidad>
        <total_libros>{count($libros)}</total_libros>
        <precio_promedio>{round(avg($libros/precio) * 100) div 100}</precio_promedio>
        <precio_maximo>{max($libros/precio)}</precio_maximo>
        <precio_minimo>{min($libros/precio)}</precio_minimo>
        <total_paginas>{sum($libros/paginas)}</total_paginas>
    </estadisticas_autor>

(: Resultado esperado: Estadísticas detalladas por cada autor :)
```

**Ejercicio 4.1 - Solución:**

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
        <categorias>
            {for $cat in $libro/categorias/categoria
             return <categoria>{$cat/text()}</categoria>}
        </categorias>
    </libro_colombiano>

(: Resultado esperado: Todos los libros de autores colombianos :)
```

### Consultas XQuery Avanzadas Adicionales

**Consulta 1: Libros por década de publicación**

```xquery
(: Agrupar libros por década :)
for $libro in collection("libreria")//libro
let $año := year-from-date(xs:date($libro/fecha_publicacion))
let $decada := ($año idiv 10) * 10
group by $decada
order by $decada
return
    <decada numero="{$decada}">
        <total_libros>{count($libro)}</total_libros>
        <libros>
            {for $l in $libro
             return 
                <libro>
                    <titulo>{$l/titulo/text()}</titulo>
                    <autor>{$l/../nombre/text()} {$l/../apellido/text()}</autor>
                    <año>{year-from-date(xs:date($l/fecha_publicacion))}</año>
                </libro>}
        </libros>
    </decada>
```

**Consulta 2: Análisis de categorías más populares**

```xquery
(: Encontrar categorías más populares :)
for $categoria in distinct-values(collection("libreria")//categoria)
let $libros := collection("libreria")//libro[categorias/categoria = $categoria]
order by count($libros) descending
return
    <categoria_popular>
        <nombre>{$categoria}</nombre>
        <total_libros>{count($libros)}</total_libros>
        <precio_promedio>{round(avg($libros/precio) * 100) div 100}</precio_promedio>
        <libros>
            {for $libro in $libros
             return 
                <libro>
                    <titulo>{$libro/titulo/text()}</titulo>
                    <autor>{$libro/../nombre/text()} {$libro/../apellido/text()}</autor>
                </libro>}
        </libros>
    </categoria_popular>
```

## 📊 Análisis Comparativo Esperado

### Rendimiento Esperado

**PostgreSQL (con datos de prueba):**
- Consulta simple: ~2-5ms
- Consulta con XMLAGG: ~10-20ms
- Consulta compleja con JOINs: ~15-30ms

**BaseX (con datos de prueba):**
- Consulta simple: ~1-3ms
- Consulta con agregación: ~5-10ms
- Consulta compleja: ~8-15ms

### Ventajas y Desventajas Esperadas

**PostgreSQL + SQL/XML:**
- ✅ **Ventajas:** Integración con datos relacionales, transacciones ACID, herramientas maduras
- ❌ **Desventajas:** Consultas XML complejas, pérdida de estructura XML, rendimiento subóptimo

**BaseX:**
- ✅ **Ventajas:** Consultas XML nativas, alto rendimiento, estructura XML preservada
- ❌ **Desventajas:** Curva de aprendizaje XQuery, menor adopción empresarial

## 🎯 Respuestas Esperadas de los Estudiantes

### Preguntas de Reflexión

1. **¿Cuándo usarías PostgreSQL con SQL/XML?**
   - Cuando ya tienes datos relacionales
   - Cuando necesitas transacciones ACID
   - Cuando el equipo conoce SQL mejor que XQuery

2. **¿Cuándo usarías BaseX?**
   - Cuando trabajas principalmente con documentos XML
   - Cuando necesitas consultas XML complejas
   - Cuando el rendimiento en consultas XML es crítico

3. **¿Qué factores considerarías para elegir entre ambos enfoques?**
   - Tipo de datos (relacionales vs XML)
   - Complejidad de consultas
   - Rendimiento requerido
   - Conocimiento del equipo
   - Integración con sistemas existentes

## 📝 Criterios de Evaluación Detallados

### Completitud (40%)
- ✅ Todas las consultas SQL funcionan correctamente
- ✅ Todas las consultas XQuery ejecutan sin errores
- ✅ Documentos XML generados son válidos
- ✅ Análisis comparativo incluye métricas reales

### Calidad del Código (30%)
- ✅ Código SQL bien estructurado y comentado
- ✅ Consultas XQuery legibles y eficientes
- ✅ Uso apropiado de funciones XML
- ✅ Manejo correcto de datos nulos

### Análisis Crítico (20%)
- ✅ Conclusiones fundamentadas en datos reales
- ✅ Identificación clara de ventajas/desventajas
- ✅ Recomendaciones contextualizadas
- ✅ Comprensión de casos de uso ideales

### Documentación (10%)
- ✅ Comentarios claros en el código
- ✅ Explicaciones de decisiones técnicas
- ✅ Resultados documentados apropiadamente

## 🚨 Posibles Problemas y Soluciones

### Problemas Comunes

1. **Error de sintaxis XML en PostgreSQL:**
   ```sql
   -- Problema: Caracteres especiales
   -- Solución: Usar CDATA o escape de caracteres
   XMLELEMENT(NAME "titulo", 
       XMLCDATA(l.titulo)
   )
   ```

2. **BaseX no encuentra colección:**
   ```xquery
   -- Problema: Colección no existe
   -- Solución: Verificar con db:list()
   db:list()
   ```

3. **Consultas XQuery lentas:**
   ```xquery
   -- Problema: Consultas no optimizadas
   -- Solución: Usar índices y optimizar consultas
   db:optimize("libreria")
   ```

### Soluciones de Emergencia

Si un estudiante tiene problemas:

1. **PostgreSQL:** Verificar que la extensión XML esté habilitada
2. **BaseX:** Reiniciar BaseX y recrear la base de datos
3. **Java:** Verificar versión Java compatible
4. **Permisos:** Verificar permisos de escritura en directorios

## 📈 Extensiones Opcionales

Para estudiantes avanzados:

1. **Implementar índices personalizados en BaseX**
2. **Crear funciones XQuery personalizadas**
3. **Integrar BaseX con aplicaciones web**
4. **Implementar transacciones distribuidas**

---

**¡La actividad está lista para implementar!** 🚀

Recuerda adaptar los datos de prueba según el contexto de tu clase y verificar que todos los estudiantes tengan acceso a las herramientas necesarias.
