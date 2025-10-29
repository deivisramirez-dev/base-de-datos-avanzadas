# Guía Completa para Profesor: Actividad Práctica Tema 1

## 📋 Información General de la Actividad

- **Tema:** Introducción a los Diferentes Sistemas de Bases de Datos
- **Actividad:** Diseño de Sistema de Gestión Universitaria "EduTech"
- **Duración:** 2-3 horas
- **Modalidad:** Individual o en equipos de 2-3 personas
- **Nivel:** Intermedio-Avanzado

---

## 🎯 Objetivos Pedagógicos

### Objetivos Principales
1. **Aplicar técnicas de abstracción** para identificar entidades y relaciones del mundo real
2. **Diseñar un modelo entidad-relación (MER)** completo y bien estructurado
3. **Crear diagramas E-R** usando notación estándar
4. **Justificar decisiones de diseño** basándose en conceptos teóricos
5. **Evaluar diferentes tipos de bases de datos** para el caso de uso propuesto

### Competencias Desarrolladas
- ✅ **Pensamiento analítico** - Descomponer problemas complejos
- ✅ **Diseño de sistemas** - Crear arquitecturas de datos
- ✅ **Comunicación técnica** - Explicar decisiones de diseño
- ✅ **Evaluación crítica** - Comparar tecnologías
- ✅ **Trabajo en equipo** - Colaborar en proyectos complejos

---

## 🏫 Contexto del Caso de Uso: Sistema EduTech

### Descripción del Sistema
La Universidad Tecnológica "EduTech" es una institución ficticia que representa un caso de uso realista y complejo. Los estudiantes deben diseñar un sistema integral que maneje:

- **15,000 estudiantes** distribuidos en 8 facultades
- **800 profesores** de tiempo completo y medio tiempo
- **120 programas académicos** (pregrado y posgrado)
- **3 campus** ubicados en diferentes ciudades
- **Sistema de créditos académicos** y calificaciones
- **Gestión de horarios** y aulas
- **Sistema de biblioteca** con préstamos y reservas

### Por Qué Este Caso de Uso
1. **Complejidad Realista** - Suficientemente complejo para aplicar todos los conceptos
2. **Familiaridad** - Los estudiantes conocen el contexto universitario
3. **Escalabilidad** - Permite discutir diferentes tipos de bases de datos
4. **Integridad** - Requiere manejo de restricciones complejas
5. **Reportes** - Necesita consultas avanzadas y vistas

---

## 📚 Conceptos Teóricos Aplicados

### 1. Modelo Entidad-Relación (MER)
- **Entidades:** Estudiantes, Profesores, Programas, Materias, etc.
- **Atributos:** Claves primarias, descriptivos, derivados
- **Relaciones:** 1:1, 1:N, N:M con cardinalidades específicas
- **Restricciones:** Integridad referencial, dominio, entidad

### 2. Normalización
- **Primera Forma Normal (1FN)** - Eliminar grupos repetitivos
- **Segunda Forma Normal (2FN)** - Eliminar dependencias parciales
- **Tercera Forma Normal (3FN)** - Eliminar dependencias transitivas
- **Forma Normal de Boyce-Codd (BCNF)** - Para casos especiales

### 3. Tipos de Bases de Datos
- **Relacionales** - PostgreSQL, MySQL, SQL Server
- **NoSQL** - MongoDB, Cassandra, Redis
- **Híbridas** - Sistemas que combinan ambos enfoques

---

## 🗂️ Solución Esperada: Entidades Principales

### Entidades Identificadas (12 principales)

#### 1. **ESTUDIANTE**
- **Propósito:** Almacenar información de todos los estudiantes
- **Atributos clave:** estudiante_id, codigo_estudiante, cedula
- **Atributos descriptivos:** nombres, apellidos, email, telefono
- **Relaciones:** Pertenece a Programa, tiene Inscripciones, hace Préstamos

#### 2. **PROFESOR**
- **Propósito:** Gestionar información del personal docente
- **Atributos clave:** profesor_id, codigo_profesor, cedula
- **Atributos descriptivos:** nombres, apellidos, titulo_academico, especialidad
- **Relaciones:** Dirige Programa, enseña Materias, tiene Horarios

#### 3. **PROGRAMA**
- **Propósito:** Definir programas académicos ofrecidos
- **Atributos clave:** programa_id, codigo_programa
- **Atributos descriptivos:** nombre_programa, duracion_semestres, creditos_totales
- **Relaciones:** Pertenece a Facultad, tiene Estudiantes, contiene Materias

#### 4. **FACULTAD**
- **Propósito:** Organizar programas por áreas académicas
- **Atributos clave:** facultad_id, codigo_facultad
- **Atributos descriptivos:** nombre_facultad, descripcion
- **Relaciones:** Pertenece a Campus, contiene Programas

#### 5. **CAMPUS**
- **Propósito:** Gestionar ubicaciones físicas de la universidad
- **Atributos clave:** campus_id, codigo_campus
- **Atributos descriptivos:** nombre_campus, direccion, ciudad
- **Relaciones:** Contiene Facultades, tiene Aulas

#### 6. **MATERIA**
- **Propósito:** Definir materias/cursos académicos
- **Atributos clave:** materia_id, codigo_materia
- **Atributos descriptivos:** nombre_materia, creditos, horas_teoria, horas_practica
- **Relaciones:** Pertenece a Programa, tiene Horarios, tiene Inscripciones

#### 7. **AULA**
- **Propósito:** Gestionar espacios físicos para clases
- **Atributos clave:** aula_id, codigo_aula
- **Atributos descriptivos:** nombre_aula, capacidad, tipo_aula, equipamiento
- **Relaciones:** Pertenece a Campus, tiene Horarios

#### 8. **HORARIO**
- **Propósito:** Programar clases en tiempo y espacio
- **Atributos clave:** horario_id
- **Atributos descriptivos:** dia_semana, hora_inicio, hora_fin, semestre, año
- **Relaciones:** Conecta Materia, Profesor y Aula

#### 9. **INSCRIPCION**
- **Propósito:** Registrar matrícula de estudiantes en materias
- **Atributos clave:** inscripcion_id
- **Atributos descriptivos:** semestre, año, fecha_inscripcion, estado
- **Relaciones:** Conecta Estudiante, Materia y Horario

#### 10. **CALIFICACION**
- **Propósito:** Registrar evaluaciones y notas
- **Atributos clave:** calificacion_id
- **Atributos descriptivos:** tipo_evaluacion, nota, porcentaje, fecha_evaluacion
- **Relaciones:** Pertenece a Inscripción

#### 11. **LIBRO**
- **Propósito:** Gestionar catálogo de biblioteca
- **Atributos clave:** libro_id, isbn
- **Atributos descriptivos:** titulo, autor, editorial, ejemplares_totales
- **Relaciones:** Tiene Préstamos

#### 12. **PRESTAMO**
- **Propósito:** Controlar préstamos de libros
- **Atributos clave:** prestamo_id
- **Atributos descriptivos:** fecha_prestamo, fecha_vencimiento, fecha_devolucion, estado
- **Relaciones:** Conecta Estudiante y Libro

---

## 🔗 Relaciones Principales

### Relaciones 1:N (Uno a Muchos)
1. **Campus → Facultad** (1:N)
2. **Facultad → Programa** (1:N)
3. **Programa → Estudiante** (1:N)
4. **Programa → Materia** (1:N)
5. **Campus → Aula** (1:N)
6. **Materia → Horario** (1:N)
7. **Profesor → Horario** (1:N)
8. **Aula → Horario** (1:N)
9. **Estudiante → Inscripción** (1:N)
10. **Materia → Inscripción** (1:N)
11. **Horario → Inscripción** (1:N)
12. **Inscripción → Calificación** (1:N)
13. **Libro → Préstamo** (1:N)
14. **Estudiante → Préstamo** (1:N)

### Relaciones N:M (Muchos a Muchos)
1. **Estudiante ↔ Materia** (a través de Inscripción)
2. **Profesor ↔ Materia** (a través de Horario)
3. **Estudiante ↔ Libro** (a través de Préstamo)

### Relaciones 1:1 (Uno a Uno)
1. **Programa → Profesor** (director_programa_id)
2. **Facultad → Profesor** (decano_id)

---

## 📊 Normalización Aplicada

### Primera Forma Normal (1FN)
**Problema identificado:** Grupos repetitivos en algunas entidades
**Solución:** Separar en entidades independientes

**Ejemplo:**
- **Antes:** Estudiante con múltiples materias en un campo
- **Después:** Entidad Inscripción separada

### Segunda Forma Normal (2FN)
**Problema identificado:** Dependencias parciales en claves compuestas
**Solución:** Mover atributos dependientes a entidades separadas

**Ejemplo:**
- **Antes:** Horario con información de materia mezclada
- **Después:** Horario solo con referencias, información de materia en entidad Materia

### Tercera Forma Normal (3FN)
**Problema identificado:** Dependencias transitivas
**Solución:** Eliminar dependencias indirectas

**Ejemplo:**
- **Antes:** Estudiante con información de programa mezclada
- **Después:** Estudiante con referencia a Programa, información de programa en entidad Programa

---

## 🛠️ Tecnologías Recomendadas

### Base de Datos Relacional (Recomendada)
**SGBD:** PostgreSQL 14+
**Justificación:**
- ✅ **ACID completo** - Transacciones confiables
- ✅ **Escalabilidad** - Maneja 15,000+ estudiantes
- ✅ **Consultas complejas** - SQL avanzado para reportes
- ✅ **Integridad referencial** - Restricciones automáticas
- ✅ **Estándares** - SQL estándar, portabilidad

### Alternativas NoSQL (Para discusión)
**MongoDB** - Para documentos no estructurados
**Cassandra** - Para alta disponibilidad
**Redis** - Para caché y sesiones

### Arquitectura Recomendada
**Centralizada** - Una base de datos principal
**Justificación:** Facilita integridad y reportes consolidados

---

## 📈 Consultas de Ejemplo Esperadas

### 1. Consultas Básicas
```sql
-- Estudiantes por programa
SELECT p.nombre_programa, COUNT(e.estudiante_id) as total
FROM programa p LEFT JOIN estudiante e ON p.programa_id = e.programa_id
GROUP BY p.programa_id, p.nombre_programa;

-- Profesores por facultad
SELECT f.nombre_facultad, COUNT(pr.profesor_id) as total
FROM facultad f LEFT JOIN profesor pr ON f.facultad_id = pr.facultad_id
GROUP BY f.facultad_id, f.nombre_facultad;
```

### 2. Consultas Académicas
```sql
-- Calificaciones por estudiante
SELECT e.codigo_estudiante, e.nombres, m.nombre_materia, AVG(c.nota) as promedio
FROM estudiante e
JOIN inscripcion i ON e.estudiante_id = i.estudiante_id
JOIN materia m ON i.materia_id = m.materia_id
JOIN calificacion c ON i.inscripcion_id = c.inscripcion_id
GROUP BY e.estudiante_id, e.codigo_estudiante, e.nombres, m.materia_id, m.nombre_materia;
```

### 3. Consultas de Biblioteca
```sql
-- Libros más prestados
SELECT l.titulo, l.autor, COUNT(p.prestamo_id) as total_prestamos
FROM libro l LEFT JOIN prestamo p ON l.libro_id = p.libro_id
GROUP BY l.libro_id, l.titulo, l.autor
ORDER BY total_prestamos DESC;
```

---

## 🎯 Criterios de Evaluación Detallados

### Criterios Técnicos (70%)

#### Completitud del Modelo E-R (20 puntos)
- **Excelente (18-20):** Todas las entidades principales identificadas, relaciones completas
- **Bueno (15-17):** Entidades principales identificadas, algunas relaciones faltantes
- **Satisfactorio (12-14):** Entidades básicas identificadas, relaciones básicas
- **Deficiente (0-11):** Entidades incompletas, relaciones incorrectas

#### Correcta Aplicación de Conceptos (20 puntos)
- **Excelente (18-20):** Normalización correcta, restricciones apropiadas
- **Bueno (15-17):** Normalización mayormente correcta, algunas restricciones faltantes
- **Satisfactorio (12-14):** Normalización básica, restricciones básicas
- **Deficiente (0-11):** Normalización incorrecta, restricciones inadecuadas

#### Justificación de Decisiones (15 puntos)
- **Excelente (13-15):** Justificaciones técnicas sólidas, consideración de alternativas
- **Bueno (11-12):** Justificaciones adecuadas, algunas alternativas consideradas
- **Satisfactorio (9-10):** Justificaciones básicas, pocas alternativas
- **Deficiente (0-8):** Justificaciones insuficientes, sin consideración de alternativas

#### Calidad del Diagrama (15 puntos)
- **Excelente (13-15):** Notación estándar, diagrama claro y completo
- **Bueno (11-12):** Notación mayormente correcta, diagrama claro
- **Satisfactorio (9-10):** Notación básica, diagrama funcional
- **Deficiente (0-8):** Notación incorrecta, diagrama confuso

### Criterios de Presentación (30%)

#### Claridad en la Exposición (10 puntos)
- **Excelente (9-10):** Exposición clara, estructura lógica
- **Bueno (7-8):** Exposición clara, estructura adecuada
- **Satisfactorio (5-6):** Exposición básica, estructura funcional
- **Deficiente (0-4):** Exposición confusa, estructura deficiente

#### Uso de Terminología Técnica (10 puntos)
- **Excelente (9-10):** Terminología precisa y apropiada
- **Bueno (7-8):** Terminología mayormente correcta
- **Satisfactorio (5-6):** Terminología básica
- **Deficiente (0-4):** Terminología incorrecta o ausente

#### Respuestas a Preguntas (10 puntos)
- **Excelente (9-10):** Respuestas precisas y fundamentadas
- **Bueno (7-8):** Respuestas adecuadas
- **Satisfactorio (5-6):** Respuestas básicas
- **Deficiente (0-4):** Respuestas incorrectas o ausentes

---

## 🚨 Problemas Comunes y Soluciones

### Problema 1: Entidades Mal Identificadas
**Síntoma:** Estudiantes crean entidades innecesarias o omiten entidades importantes
**Solución:** 
- Revisar el proceso de abstracción
- Enfatizar la diferencia entre entidad y atributo
- Usar ejemplos del mundo real

### Problema 2: Relaciones Incorrectas
**Síntoma:** Cardinalidades incorrectas, relaciones mal definidas
**Solución:**
- Practicar con ejemplos simples primero
- Verificar cada relación con casos específicos
- Usar diagramas de ejemplo

### Problema 3: Normalización Inadecuada
**Síntoma:** Redundancia de datos, dependencias incorrectas
**Solución:**
- Explicar cada forma normal con ejemplos
- Mostrar el proceso paso a paso
- Practicar con casos específicos

### Problema 4: Justificaciones Débiles
**Síntoma:** Decisiones sin fundamento técnico
**Solución:**
- Enfatizar la importancia de la justificación
- Proporcionar criterios de evaluación
- Dar ejemplos de justificaciones sólidas

---

## 💡 Consejos para el Docente

### Antes de la Actividad
1. **Preparar ejemplos** de diagramas E-R bien diseñados
2. **Revisar conceptos** de normalización con ejemplos
3. **Preparar preguntas** para guiar a los estudiantes
4. **Configurar herramientas** de diagramación

### Durante la Actividad
1. **Circular por el aula** para resolver dudas individuales
2. **Hacer preguntas guía** para estimular el pensamiento
3. **Proporcionar feedback** inmediato sobre decisiones
4. **Fomentar la discusión** entre equipos

### Después de la Actividad
1. **Revisar entregables** con criterios claros
2. **Proporcionar feedback** constructivo
3. **Identificar conceptos** que necesitan refuerzo
4. **Planificar actividades** de seguimiento

---

## 🔧 Herramientas Recomendadas

### Para Diagramas E-R
1. **Lucidchart** - Gratuito con cuenta educativa, interfaz intuitiva
2. **Draw.io** - Completamente gratuito, integración con Google Drive
3. **MySQL Workbench** - Gratuito, específico para bases de datos
4. **Visio** - Si está disponible, profesional pero de pago

### Para Documentación
1. **Google Docs** - Colaborativo, fácil de usar
2. **Microsoft Word** - Profesional, formato estándar
3. **Markdown** - Ligero, versionado con Git
4. **LaTeX** - Para documentación técnica avanzada

### Para Implementación
1. **PostgreSQL** - Base de datos recomendada
2. **pgAdmin** - Interfaz gráfica para PostgreSQL
3. **DBeaver** - Cliente universal de bases de datos
4. **VS Code** - Editor con extensiones para SQL

---

## 📚 Recursos de Apoyo

### Libros de Referencia
1. **Elmasri, R. & Navathe, S. (2016).** *Fundamentals of Database Systems*
2. **Connolly, T. & Begg, C. (2015).** *Database Systems: A Practical Approach*
3. **Silberschatz, A. (2019).** *Database System Concepts*

### Recursos Online
1. **PostgreSQL Documentation** - https://www.postgresql.org/docs/
2. **MySQL Workbench** - https://dev.mysql.com/doc/workbench/en/
3. **Lucidchart Tutorials** - https://www.lucidchart.com/pages/

### Videos Educativos
1. **Database Design Tutorial** - YouTube
2. **Entity Relationship Diagrams** - Coursera
3. **Database Normalization** - Khan Academy

---

## 🎓 Expectativas de Aprendizaje

### Al Finalizar la Actividad, los Estudiantes Deberían:

#### Conocimientos
- ✅ Identificar entidades y relaciones en sistemas complejos
- ✅ Aplicar reglas de normalización correctamente
- ✅ Diseñar diagramas E-R usando notación estándar
- ✅ Justificar decisiones de diseño técnicamente
- ✅ Evaluar diferentes tipos de bases de datos

#### Habilidades
- ✅ Analizar requerimientos de sistemas
- ✅ Diseñar modelos de datos escalables
- ✅ Comunicar decisiones técnicas
- ✅ Trabajar en equipo efectivamente
- ✅ Presentar soluciones profesionalmente

#### Actitudes
- ✅ Pensamiento crítico en diseño
- ✅ Consideración de alternativas
- ✅ Atención al detalle
- ✅ Colaboración constructiva
- ✅ Responsabilidad en el trabajo

---

## 📋 Checklist de Evaluación

### Para el Docente
- [ ] ¿Se identificaron todas las entidades principales?
- [ ] ¿Las relaciones tienen cardinalidades correctas?
- [ ] ¿Se aplicó normalización adecuadamente?
- [ ] ¿Las justificaciones son técnicas y sólidas?
- [ ] ¿El diagrama usa notación estándar?
- [ ] ¿La presentación es clara y profesional?
- [ ] ¿Se consideraron alternativas tecnológicas?
- [ ] ¿Las consultas de ejemplo son apropiadas?

### Para los Estudiantes
- [ ] ¿Entiendo el problema del sistema?
- [ ] ¿Identifiqué todas las entidades necesarias?
- [ ] ¿Definí las relaciones correctamente?
- [ ] ¿Apliqué normalización paso a paso?
- [ ] ¿Justifiqué mis decisiones técnicas?
- [ ] ¿Creé un diagrama claro y completo?
- [ ] ¿Preparé una presentación efectiva?
- [ ] ¿Consideré alternativas tecnológicas?

---

## 🚀 Extensiones Opcionales

### Para Estudiantes Avanzados
1. **Implementación física** - Crear las tablas en PostgreSQL
2. **Consultas avanzadas** - Escribir consultas complejas
3. **Optimización** - Diseñar índices y vistas
4. **Seguridad** - Implementar roles y permisos
5. **Backup y recuperación** - Estrategias de respaldo

### Para Equipos Grandes
1. **División por módulos** - Cada equipo diseña un módulo
2. **Integración** - Combinar módulos en un sistema completo
3. **Presentación conjunta** - Cada equipo presenta su módulo
4. **Evaluación cruzada** - Equipos evalúan trabajo de otros

---

## 📊 Métricas de Éxito

### Indicadores Cuantitativos
- **Tiempo de completación** - 2-3 horas promedio
- **Entidades identificadas** - 10-12 entidades principales
- **Relaciones definidas** - 15-20 relaciones
- **Nivel de normalización** - 3FN o BCNF
- **Calidad del diagrama** - Notación estándar completa

### Indicadores Cualitativos
- **Comprensión del problema** - Análisis adecuado
- **Creatividad en soluciones** - Enfoques innovadores
- **Colaboración en equipo** - Trabajo efectivo
- **Comunicación técnica** - Explicaciones claras
- **Pensamiento crítico** - Evaluación de alternativas

---

**¡La actividad está diseñada para ser desafiante pero alcanzable!** 🎉

El objetivo es que los estudiantes apliquen conceptos teóricos en un caso real, desarrollando habilidades de diseño de sistemas que serán valiosas en su carrera profesional.
