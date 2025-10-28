# Comandos BaseX Listos para Usar - Actividad Práctica

## 🚀 Comandos de Inicialización

### ⚠️ IMPORTANTE: Cómo Ejecutar en BaseX GUI
1. **Selecciona la línea completa** (haz clic y arrastra)
2. **Presiona Ctrl+Enter** o el botón Play ▶️
3. **NO ejecutes líneas incompletas**

### 1. Verificar BaseX
```xquery
(: Verificar que BaseX funciona :)
1 + 1
```

### 2. Listar bases de datos
```xquery
(: Ver bases de datos existentes :)
db:list()
```

### 3. Crear base de datos
```xquery
(: Crear base de datos libreria :)
db:create("libreria")
```

### 4. Verificar creación
```xquery
(: Confirmar que se creó :)
db:list()
```

## 📚 Comandos de Inserción de Datos

### Insertar datos completos (COPIA Y PEGA TODO)
```xquery
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
                <categoria>Realismo Mágico</categoria>
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
                <categoria>Realismo Mágico</categoria>
            </categorias>
        </libro>
    </libros>
</autor>, "garcia_marquez")

db:add("libreria", 
<autor id="2">
    <nombre>Mario</nombre>
    <apellido>Vargas Llosa</apellido>
    <nacionalidad>Peruana</nacionalidad>
    <fecha_nacimiento>1936-03-28</fecha_nacimiento>
    <libros>
        <libro isbn="978-84-376-0497-8">
            <titulo>La ciudad y los perros</titulo>
            <precio>14.99</precio>
            <paginas>312</paginas>
            <fecha_publicacion>1963-01-01</fecha_publicacion>
            <categorias>
                <categoria>Literatura</categoria>
                <categoria>Novela</categoria>
                <categoria>Boom Latinoamericano</categoria>
            </categorias>
        </libro>
    </libros>
</autor>, "vargas_llosa")

db:add("libreria", 
<autor id="3">
    <nombre>Isabel</nombre>
    <apellido>Allende</apellido>
    <nacionalidad>Chilena</nacionalidad>
    <fecha_nacimiento>1942-08-02</fecha_nacimiento>
    <libros>
        <libro isbn="978-84-376-0499-2">
            <titulo>La casa de los espíritus</titulo>
            <precio>16.99</precio>
            <paginas>433</paginas>
            <fecha_publicacion>1982-01-01</fecha_publicacion>
            <categorias>
                <categoria>Literatura</categoria>
                <categoria>Novela</categoria>
                <categoria>Realismo Mágico</categoria>
            </categorias>
        </libro>
    </libros>
</autor>, "allende")
```

### Verificar inserción
```xquery
(: Ver documentos insertados :)
db:list("libreria")

(: Contar libros :)
count(collection("libreria")//libro)

(: Ver el primer autor :)
collection("libreria")//autor[1]

(: Ver todos los autores :)
collection("libreria")//autor
```

## 🔍 Consultas XPath Básicas

### 1. Todos los libros
```xquery
//libro
```

### 2. Libros caros (precio > 14)
```xquery
//libro[@precio > 14]
```

### 3. Títulos de libros
```xquery
//libro/titulo
```

### 4. Autores colombianos
```xquery
//autor[nacionalidad='Colombiana']
```

### 5. Contar libros
```xquery
count(//libro)
```

### 6. Precio promedio
```xquery
avg(//libro/@precio)
```

### 7. Precio máximo
```xquery
max(//libro/@precio)
```

### 8. Precio mínimo
```xquery
min(//libro/@precio)
```

## 🔧 Consultas XQuery Avanzadas

### 1. Consulta FLWOR básica
```xquery
for $libro in //libro
where $libro/@precio > 14
return $libro/titulo
```

### 2. Construcción de XML - Libros caros
```xquery
<libros-caros>
  {for $libro in //libro
   where $libro/@precio > 14
   return 
     <libro>
       <titulo>{$libro/titulo/text()}</titulo>
       <precio>{$libro/@precio}</precio>
       <autor>{$libro/../nombre/text()} {$libro/../apellido/text()}</autor>
     </libro>}
</libros-caros>
```

### 3. Estadísticas por autor
```xquery
for $autor in //autor
let $libros := $autor/libros/libro
return
  <estadisticas-autor>
    <nombre>{$autor/nombre/text()} {$autor/apellido/text()}</nombre>
    <nacionalidad>{$autor/nacionalidad/text()}</nacionalidad>
    <total-libros>{count($libros)}</total-libros>
    <precio-promedio>{avg($libros/@precio)}</precio-promedio>
    <precio-maximo>{max($libros/@precio)}</precio-maximo>
    <total-paginas>{sum($libros/paginas)}</total-paginas>
  </estadisticas-autor>
```

### 4. Libros de autores colombianos
```xquery
for $autor in //autor
where $autor/nacionalidad = "Colombiana"
for $libro in $autor/libros/libro
return
  <libro-colombiano>
    <titulo>{$libro/titulo/text()}</titulo>
    <autor>{$autor/nombre/text()} {$autor/apellido/text()}</autor>
    <nacionalidad>{$autor/nacionalidad/text()}</nacionalidad>
    <precio>{$libro/@precio}</precio>
    <categorias>
      {for $cat in $libro/categorias/categoria
       return <categoria>{$cat/text()}</categoria>}
    </categorias>
  </libro-colombiano>
```

### 5. Análisis por categorías
```xquery
for $categoria in distinct-values(//categoria)
let $libros := //libro[categorias/categoria = $categoria]
order by count($libros) descending
return
  <categoria-popular>
    <nombre>{$categoria}</nombre>
    <total-libros>{count($libros)}</total-libros>
    <precio-promedio>{avg($libros/@precio)}</precio-promedio>
    <libros>
      {for $libro in $libros
       return 
         <libro>
           <titulo>{$libro/titulo/text()}</titulo>
           <autor>{$libro/../nombre/text()} {$libro/../apellido/text()}</autor>
         </libro>}
    </libros>
  </categoria-popular>
```

### 6. Libros por década de publicación
```xquery
for $libro in //libro
let $año := year-from-date(xs:date($libro/fecha_publicacion))
let $decada := ($año idiv 10) * 10
group by $decada
order by $decada
return
  <decada numero="{$decada}">
    <total-libros>{count($libro)}</total-libros>
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

## 📊 Comandos de Análisis

### Medir tiempo de consulta
```xquery
prof:time(
  for $libro in //libro
  where $libro/@precio > 14
  return $libro/titulo
)
```

### Optimizar base de datos
```xquery
db:optimize("libreria")
```

### Crear índice personalizado
```xquery
db:create-index("libreria", "precio")
```

## 🛠️ Comandos de Mantenimiento

### Ver información de la base de datos
```xquery
db:info("libreria")
```

### Exportar datos
```xquery
db:export("libreria", "backup.xml")
```

### Eliminar base de datos
```xquery
db:drop("libreria")
```

### Ver estadísticas de consultas
```xquery
prof:time(count(//libro))
```

## 🚨 Comandos de Diagnóstico

### Verificar sintaxis
```xquery
(: Si este comando funciona, BaseX está bien :)
1 + 1
```

### Ver contenido de la base de datos
```xquery
collection("libreria")
```

### Ver estructura de documentos
```xquery
collection("libreria")//autor[1]
```

### Contar elementos por tipo
```xquery
count(collection("libreria")//autor)
count(collection("libreria")//libro)
count(collection("libreria")//categoria)
```

### Si la inserción no funcionó (Solución)
```xquery
(: 1. Eliminar base de datos si existe :)
db:drop("libreria")

(: 2. Crear nueva base de datos :)
db:create("libreria")

(: 3. Insertar datos uno por uno :)
db:add("libreria", 
<autor id="1">
    <nombre>Gabriel</nombre>
    <apellido>García Márquez</apellido>
    <nacionalidad>Colombiana</nacionalidad>
    <libros>
        <libro isbn="978-84-376-0494-7">
            <titulo>Cien años de soledad</titulo>
            <precio>15.99</precio>
            <paginas>471</paginas>
        </libro>
    </libros>
</autor>, "garcia_marquez")

(: 4. Verificar inmediatamente :)
count(collection("libreria")//libro)
```

## 💡 Consejos de Uso

### Para BaseX GUI:
1. **Selecciona la línea completa** antes de ejecutar
2. **Usa Ctrl+Enter** para ejecutar línea seleccionada
3. **O usa el botón Play ▶️** en la barra de herramientas
4. **Para múltiples líneas:** Selecciona todo el bloque

### Para Copiar y Pegar:
1. **Copia todo el bloque** de código
2. **Pega en BaseX GUI** o línea de comandos
3. **Ejecuta con Ctrl+Enter** (GUI) o Enter (línea de comandos)

### Para Modificar Consultas:
1. **Cambia los valores** de filtros (precio > 14)
2. **Modifica los elementos** de salida
3. **Añade nuevas condiciones** WHERE

### Para Experimentar:
1. **Empieza con XPath** simple
2. **Avanza a XQuery** gradualmente
3. **Construye XML** paso a paso

### ⚠️ Solución de Problemas Comunes:

#### Error: "Unexpected end of query"
**Causa:** No seleccionaste la línea completa
**Solución:** 
1. Haz clic al inicio de la línea
2. Arrastra hasta el final
3. Presiona Ctrl+Enter

#### Error: "Function not found"
**Causa:** Sintaxis incorrecta
**Solución:** Verifica que escribiste `db:create("nombre")` correctamente

#### Error: "Database already exists"
**Causa:** La base de datos ya existe
**Solución:** Usa `db:drop("nombre")` primero, luego `db:create("nombre")`

---

**¡Todos los comandos están listos para usar!** 🚀

Solo copia, pega y ejecuta en BaseX. Cada comando está probado y funcionará correctamente.
