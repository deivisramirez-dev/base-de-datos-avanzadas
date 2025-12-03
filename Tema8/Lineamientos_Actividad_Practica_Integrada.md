# Actividad Práctica Integrada: Sistema Bancario
## Temas: Indexación, Transacciones y Recuperación

---

## 📖 Enunciado y Contexto de la Actividad

### Escenario del Sistema

Después de un largo proceso de selección de personal has sido contratado como Administrador de Bases de Datos (DBA) en un banco que necesita implementar un nuevo sistema de gestión de cuentas y transacciones. El banco ha decidido migrar de su sistema legacy a una solución moderna basada en MySQL.

**Situación actual:**
- El banco maneja aproximadamente 10,000 clientes activos
- Se procesan alrededor de 5,000 transacciones diarias
- El sistema actual tiene problemas de rendimiento en consultas frecuentes
- Se han reportado inconsistencias en transferencias cuando hay fallos del sistema
- No existe un sistema robusto de recuperación ante desastres

**Requisitos del nuevo sistema:**
1. **Rendimiento:** Las consultas de saldo y búsqueda de cuentas deben ser instantáneas
2. **Confiabilidad:** Todas las transacciones deben garantizar integridad de datos (ACID)
3. **Recuperación:** El sistema debe poder recuperarse automáticamente ante fallos
4. **Escalabilidad:** Debe soportar el crecimiento futuro del banco

**Tu misión:** Diseñar e implementar la base de datos del nuevo sistema aplicando los conceptos de **indexación**, **transacciones** y **recuperación** de manera integrada.

---
## 📋 Objetivo de la Actividad

Implementar y analizar un sistema bancario que integre tres conceptos fundamentales:
1. **Indexación y Asociación** (Tema 6): Optimizar consultas mediante índices
2. **Procesamiento Transaccional** (Tema 7): Garantizar propiedades ACID
3. **Sistemas de Recuperación** (Tema 8): Manejar fallos y recuperación

---

## 🛠️ Herramientas Necesarias

### Software Requerido:
- **MySQL 8.0+**
- **Cliente SQL**: MySQL Workbench o línea de comandos (`mysql`)
- **Editor de texto**: Para crear scripts SQL

### Instalación Rápida:
```bash
# Verificar instalación de MySQL
mysql --version

# Conectar a MySQL
mysql -u root -p

# O desde MySQL Workbench: crear nueva conexión
```

---
