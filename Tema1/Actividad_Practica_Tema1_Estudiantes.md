# Actividad Práctica: Diseño de Sistema de Gestión Universitaria

## 📋 Información General
- **Tema:** Introducción a los Diferentes Sistemas de Bases de Datos
- **Duración:** 2-3 horas
- **Modalidad:** Individual o en equipos de 2-3 personas
- **Objetivos:** Aplicar conceptos de modelado de bases de datos, abstracción, MER y diagramas E-R

---

## 🎯 Objetivos de Aprendizaje

Al finalizar esta actividad, el estudiante será capaz de:

1. **Aplicar técnicas de abstracción** para identificar entidades y relaciones del mundo real
2. **Diseñar un modelo entidad-relación (MER)** completo y bien estructurado
3. **Crear diagramas E-R** usando notación estándar
4. **Justificar decisiones de diseño** basándose en conceptos teóricos
5. **Evaluar diferentes tipos de bases de datos** para el caso de uso propuesto

---

## 🏫 Contexto del Caso de Uso

### Sistema de Gestión Universitaria "EduTech"

La Universidad Tecnológica "EduTech" necesita implementar un sistema integral de gestión académica que permita administrar todos los aspectos de la vida universitaria. La universidad cuenta con:

- **15,000 estudiantes** distribuidos en 8 facultades
- **800 profesores** de tiempo completo y medio tiempo
- **120 programas académicos** (pregrado y posgrado)
- **3 campus** ubicados en diferentes ciudades
- **Sistema de créditos académicos** y calificaciones
- **Gestión de horarios** y aulas
- **Sistema de biblioteca** con préstamos y reservas

### Requerimientos Funcionales Identificados

#### 1. Gestión de Personas
- Registro y gestión de estudiantes, profesores y personal administrativo
- Información personal, académica y de contacto
- Historial académico completo de estudiantes
- Experiencia y especialización de profesores

#### 2. Gestión Académica
- Catálogo de materias y programas
- Asignación de materias a profesores
- Inscripción de estudiantes a materias
- Gestión de horarios y aulas
- Sistema de calificaciones y créditos

#### 3. Gestión de Recursos
- Inventario de aulas, laboratorios y equipos
- Gestión de biblioteca y recursos digitales
- Sistema de préstamos y reservas
- Control de acceso a instalaciones

#### 4. Gestión Administrativa
- Procesos de admisión y matrícula
- Generación de reportes académicos
- Gestión de pagos y becas
- Comunicación institucional

---

## 📝 Actividades a Desarrollar

### Fase 1: Análisis y Abstracción (45 minutos)

#### 1.1 Identificación de Entidades
Identifica y lista todas las entidades principales del sistema. Para cada entidad, especifica:
- **Nombre de la entidad**
- **Descripción de su propósito**
- **Justificación de por qué es una entidad independiente**

#### 1.2 Identificación de Atributos
Para cada entidad identificada, define:
- **Atributos clave** (identificadores únicos)
- **Atributos descriptivos** (características de la entidad)
- **Atributos derivados** (calculados a partir de otros)
- **Tipo de dato** para cada atributo

#### 1.3 Identificación de Relaciones
Identifica todas las relaciones entre entidades:
- **Tipo de relación** (1:1, 1:N, N:M)
- **Cardinalidad** exacta
- **Atributos de la relación** (si los tiene)
- **Restricciones de integridad**

### Fase 2: Diseño del Modelo E-R (60 minutos)

#### 2.1 Diagrama Entidad-Relación
Crea un diagrama E-R completo que incluya:
- **Todas las entidades** con sus atributos
- **Todas las relaciones** con cardinalidades
- **Claves primarias** y **claves foráneas**
- **Restricciones de integridad**
- **Notación estándar** (rectángulos para entidades, rombos para relaciones)

#### 2.2 Normalización del Modelo
Aplica las reglas de normalización:
- **Primera Forma Normal (1FN)**
- **Segunda Forma Normal (2FN)**
- **Tercera Forma Normal (3FN)**
- Justifica cada paso de normalización

### Fase 3: Evaluación de Tecnologías (30 minutos)

#### 3.1 Análisis de Requerimientos
Analiza los requerimientos del sistema y determina:
- **Volumen de datos** estimado
- **Tipos de consultas** más frecuentes
- **Requerimientos de rendimiento**
- **Necesidades de escalabilidad**

#### 3.2 Selección de Tecnología
Evalúa y justifica la selección de:
- **Tipo de base de datos** (Relacional, NoSQL, Híbrida)
- **SGBD específico** (MySQL, PostgreSQL, MongoDB, etc.)
- **Arquitectura** (Centralizada, Distribuida, En la nube)
- **Justificación técnica** para cada decisión

### Fase 4: Documentación y Presentación (15 minutos)

#### 4.1 Documentación Técnica
Prepara un documento que incluya:
- **Diagrama E-R final**
- **Diccionario de datos** con todas las entidades y atributos
- **Justificación de decisiones de diseño**
- **Recomendaciones de implementación**

#### 4.2 Presentación
Prepara una presentación de 10 minutos que cubra:
- **Resumen del análisis**
- **Diagrama E-R principal**
- **Decisiones de tecnología**
- **Desafíos identificados y soluciones propuestas**

---

## 📊 Criterios de Evaluación

### Criterios Técnicos (70%)
- **Completitud del modelo E-R** (20 puntos)
- **Correcta aplicación de conceptos** (20 puntos)
- **Justificación de decisiones** (15 puntos)
- **Calidad del diagrama** (15 puntos)

### Criterios de Presentación (30%)
- **Claridad en la exposición** (10 puntos)
- **Uso de terminología técnica** (10 puntos)
- **Respuestas a preguntas** (10 puntos)

---

## 🛠️ Herramientas Recomendadas

### Para Diagramas E-R
- **Lucidchart** (gratuito con cuenta educativa)
- **Draw.io** (gratuito)
- **MySQL Workbench** (gratuito)
- **Visio** (si está disponible)

### Para Documentación
- **Google Docs** o **Microsoft Word**
- **Markdown** (recomendado)
- **LaTeX** (opcional, para documentación avanzada)

---

## 📚 Recursos de Apoyo

### Conceptos Teóricos
- Modelo Entidad-Relación (MER)
- Normalización de bases de datos
- Tipos de relaciones y cardinalidades
- Claves primarias y foráneas
- Restricciones de integridad

### Referencias Adicionales
- Elmasri, R. & Navathe, S. (2016). *Fundamentals of Database Systems*
- Connolly, T. & Begg, C. (2015). *Database Systems: A Practical Approach*
- Documentación oficial de SGBD seleccionados

---

## ❓ Preguntas Guía

### Para el Análisis
1. ¿Qué entidades son fundamentales para el funcionamiento del sistema?
2. ¿Cómo se relacionan los estudiantes con las materias y profesores?
3. ¿Qué información es necesaria para generar reportes académicos?
4. ¿Cómo se maneja la información histórica (calificaciones pasadas)?

### Para el Diseño
1. ¿Qué atributos son únicos para cada entidad?
2. ¿Cómo se evita la redundancia de datos?
3. ¿Qué restricciones de negocio deben implementarse?
4. ¿Cómo se garantiza la integridad de los datos?

### Para la Tecnología
1. ¿Qué tipo de consultas serán más frecuentes?
2. ¿Cuál es el volumen de datos esperado?
3. ¿Se requiere escalabilidad horizontal o vertical?
4. ¿Qué nivel de consistencia se necesita?

---

## 📋 Entregables

### Documento Principal
- **Análisis completo** del sistema (2-3 páginas)
- **Diagrama E-R** en formato digital
- **Diccionario de datos** detallado
- **Justificación de decisiones** técnicas

### Presentación
- **Slides** con diagramas y conclusiones
- **Tiempo:** 10 minutos + 5 minutos de preguntas
- **Formato:** PowerPoint, Google Slides, o similar

### Código (Opcional)
- **Scripts SQL** para crear las tablas
- **Consultas de ejemplo** para validar el diseño
- **Documentación** del esquema de base de datos

---

## 🎯 Expectativas de Calidad

### Excelente (90-100%)
- Modelo E-R completo y bien normalizado
- Justificación sólida de decisiones técnicas
- Presentación clara y profesional
- Uso correcto de terminología técnica

### Bueno (80-89%)
- Modelo E-R funcional con algunas mejoras posibles
- Justificación adecuada de decisiones
- Presentación clara
- Uso apropiado de terminología

### Satisfactorio (70-79%)
- Modelo E-R básico funcional
- Justificación parcial de decisiones
- Presentación aceptable
- Uso básico de terminología

---



**¡Éxito en tu actividad práctica! 🚀**

*Recuerda que el objetivo es aplicar los conceptos teóricos en un caso real, no solo memorizar definiciones.*
