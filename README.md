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

## 7. Creación de la pantalla de bienvenida (Home Screen)

### 7.1. Objetivo

Crear una pantalla de bienvenida para CineLista que muestre una imagen de fondo, el nombre de la aplicación, un icono relacionado con el cine y el mensaje "Hello World", utilizando widgets de Flutter.

### 7.2. Elementos implementados

La pantalla de bienvenida se estableció como la pantalla inicial de la aplicación. Incluye los siguientes elementos:

- **Imagen de fondo:** se utiliza `Image.network` para cargar una imagen relacionada con una sala de cine desde Internet.
- **Nombre de la aplicación:** se muestra el título `CineLista`.
- **Mensaje de bienvenida:** se incorpora el texto `Hello World`, solicitado en la actividad.
- **Icono:** se utiliza `Icon` con `Icons.movie_creation_outlined` para representar el cine.
- **Texto descriptivo:** se añade el mensaje "Tu próxima película favorita te espera".
- **Botón de navegación:** el botón "Entrar al catálogo" permite acceder a la pantalla del catálogo existente.

### 7.3. Widgets y componentes utilizados

- **`Scaffold`:** proporciona la estructura básica de la pantalla.
- **`Stack`:** permite superponer la imagen de fondo, una capa oscura y el contenido principal.
- **`Image.network`:** carga la imagen de fondo desde una dirección web.
- **`Container`:** incorpora un degradado oscuro que facilita la lectura del texto.
- **`SafeArea`:** ayuda a mantener el contenido dentro del área segura de la pantalla.
- **`Center`:** centra el contenido.
- **`Padding`:** establece el espacio alrededor de los elementos.
- **`Column`:** organiza verticalmente el icono, los textos y el botón.
- **`Text`:** muestra el nombre de la aplicación y los mensajes.
- **`Icon`:** muestra el icono relacionado con el cine.
- **`ElevatedButton`:** presenta el botón de acceso al catálogo.
- **`Navigator.push` y `MaterialPageRoute`:** permiten navegar desde la pantalla de bienvenida hasta el catálogo.

### 7.4. Pruebas realizadas

La aplicación se ejecutó en Google Chrome para comprobar el funcionamiento de la pantalla de bienvenida. Se verificó que la imagen de fondo, el icono, el nombre CineLista y el mensaje "Hello World" se mostraran correctamente.

También se comprobó que el botón "Entrar al catálogo" permitiera acceder a la pantalla del catálogo desarrollada previamente.

### 7.5. Resultado

Se implementó una pantalla de bienvenida funcional que cumple los requisitos de la actividad y permite acceder al catálogo existente sin perder la interfaz desarrollada anteriormente.

## 8. Widgets adicionales de la pantalla de bienvenida

Además de los widgets documentados en la sección 2, la pantalla de bienvenida incorpora otros componentes para organizar el contenido y facilitar la navegación.

| Widget o componente | Uso en la pantalla de bienvenida |
|---|---|
| `Image.network` | Cargar la imagen de fondo desde Internet. |
| `Icon` | Mostrar el icono de cine. |
| `Scaffold` | Estructurar la pantalla. |
| `SafeArea` | Respetar el área segura de visualización. |
| `Center` | Centrar el contenido. |
| `Padding` | Aplicar espaciado alrededor del contenido. |
| `ElevatedButton` | Mostrar el botón para entrar al catálogo. |
| `Navigator.push` | Abrir la pantalla del catálogo. |
| `MaterialPageRoute` | Definir la ruta de navegación hacia el catálogo. |

Estos componentes complementan los widgets básicos documentados anteriormente y permiten construir una pantalla de bienvenida visualmente organizada e integrada con el resto de CineLista.