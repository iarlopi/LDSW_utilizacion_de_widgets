# LDSW - Utilización de widgets en Flutter

## 1. Descripción del proyecto

CineLista es una interfaz móvil de catálogo de películas desarrollada con Flutter y Dart. Su diseño está inspirado en aplicaciones de cine y plataformas de entretenimiento, con una paleta de colores oscuros y elementos visuales organizados para facilitar la consulta de películas.

El objetivo de esta actividad es practicar el uso de los widgets básicos de Flutter: `Text`, `Row`, `Column`, `Stack` y `Container`.

## 2. Widgets utilizados

### Text

**Función:** mostrar textos en la interfaz, como títulos, descripciones, etiquetas y nombres de películas.

**Dónde se utiliza:**
- Nombre de la aplicación: `CineLista`.
- Título de la sección: `Destacada`.
- Nombre de la película: `Interstellar`.
- Información de la película, como año, género y duración.
- Etiquetas de los géneros y títulos de las películas populares.

**Ejemplo de código:**

```dart
const Text(
  'CineLista',
  style: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w900,
  ),
)
```

### Row

**Función:** organizar varios widgets horizontalmente, uno junto a otro.

**Dónde se utiliza:**
- En el buscador, para colocar el icono de búsqueda y el texto.
- En la sección de géneros, para mostrar las etiquetas en una misma fila.
- En la sección de películas populares, para colocar dos tarjetas lado a lado.

**Ejemplo de código:**

```dart
Row(
  children: [
    _genero('Sci-Fi'),
    const Spacer(),
    _genero('Terror'),
    const Spacer(),
    _genero('Thriller'),
  ],
)
```

### Column

**Función:** organizar widgets verticalmente.

**Dónde se utiliza:**
- En la estructura principal de la pantalla, para distribuir las secciones de CineLista.
- En la información de la película destacada, para colocar el título y los datos en líneas separadas.
- En cada tarjeta de película popular, para organizar el póster, el título y la descripción.

**Ejemplo de código:**

```dart
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Interstellar'),
    SizedBox(height: 4),
    Text('2014 • Ciencia ficción • 169 min'),
  ],
)
```

### Stack

**Función:** superponer widgets, permitiendo colocar elementos en distintas posiciones dentro de una misma área.

**Dónde se utiliza:**
- En la película destacada, para superponer la etiqueta `RECOMENDADA` sobre el póster.
- En las tarjetas de películas populares, para colocar un icono de cine sobre el fondo del póster.

**Ejemplo de código:**

```dart
Stack(
  children: [
    Container(
      height: 170,
      color: fondoTarjeta,
    ),
    Positioned(
      top: 10,
      left: 10,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: azul,
        child: const Text('RECOMENDADA'),
      ),
    ),
  ],
)
```

### Container

**Función:** definir áreas visuales y controlar propiedades como dimensiones, color de fondo, relleno interior, bordes y esquinas redondeadas.

**Dónde se utiliza:**
- En el buscador, para definir el contorno y el espacio interior.
- En el área de la película destacada, para establecer el fondo del póster.
- En las etiquetas de los géneros.
- En el botón `Ver detalle`.
- En los fondos de las tarjetas de películas populares.

**Ejemplo de código:**

```dart
Container(
  width: double.infinity,
  padding: const EdgeInsets.symmetric(vertical: 12),
  decoration: BoxDecoration(
    color: azul,
    borderRadius: BorderRadius.circular(6),
  ),
  child: const Text('Ver detalle'),
)
```

## 3. Resumen de los widgets

| Widget | Uso principal en CineLista |
|---|---|
| `Text` | Mostrar títulos, descripciones y etiquetas. |
| `Row` | Distribuir elementos horizontalmente. |
| `Column` | Organizar el contenido verticalmente. |
| `Stack` | Superponer etiquetas e iconos sobre los pósteres. |
| `Container` | Definir fondos, dimensiones, bordes y espaciado. |

## 4. Tecnologías utilizadas

- Flutter.
- Dart.
- Visual Studio Code.
- Git y GitHub para el control de versiones.

## 5. Ejecución del proyecto

Para ejecutar la aplicación en Google Chrome desde el terminal, utiliza:

```bash
flutter run -d chrome
```

El archivo principal de la aplicación es `lib/main.dart`.

## 6. Conclusión

La actividad permite comprender cómo combinar los widgets básicos de Flutter para construir una interfaz organizada y visualmente coherente. En CineLista, estos widgets trabajan conjuntamente para presentar la información de películas mediante secciones, tarjetas y elementos superpuestos.