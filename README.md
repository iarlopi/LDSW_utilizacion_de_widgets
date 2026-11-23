# CineLista — Catálogo de películas con Flutter

## 1. Descripción del proyecto

CineLista es una aplicación de catálogo de películas desarrollada con **Flutter y Dart** como parte del proyecto académico de la Licenciatura en Desarrollo de Sistemas Web.

La aplicación permite consultar películas, visualizar información detallada, guardar películas en una lista personal y administrar un catálogo propio. Su diseño está inspirado en plataformas de cine y entretenimiento, con una interfaz de tonos oscuros y una organización visual orientada a facilitar la navegación.

El proyecto integra servicios externos y almacenamiento en la nube mediante:

- **The Movie Database (TMDB):** consulta de información de películas.
- **Backend PHP:** intermediario entre Flutter y TMDB.
- **Firebase Authentication:** registro e inicio de sesión.
- **Cloud Firestore:** almacenamiento de películas y datos de los usuarios.

## 2. Funcionalidades implementadas

### 2.1. Bienvenida y autenticación

- Pantalla de bienvenida con acceso al catálogo.
- Registro de usuarios mediante correo electrónico y contraseña.
- Inicio de sesión.
- Cierre de sesión.
- Control del estado de autenticación mediante Firebase Authentication.

### 2.2. Catálogo de películas

- Consulta de películas populares mediante TMDB.
- Visualización de pósteres y títulos.
- Película destacada con selección diaria a partir de las películas disponibles.
- Consulta de información detallada de cada película.
- Visualización de título, año, director, género, duración, valoración y sinopsis, según los datos disponibles.

### 2.3. Búsqueda y navegación

- Búsqueda de películas por título.
- Filtrado de películas por género.
- Navegación mediante el menú principal.
- Acceso a las secciones Inicio, Buscar y Mi lista.

### 2.4. Mi lista

Cada usuario puede guardar películas en su lista personal.

Las funcionalidades incluyen:

- Guardar películas procedentes de TMDB.
- Guardar películas del catálogo propio de CineLista.
- Consultar las películas guardadas.
- Abrir los detalles de una película guardada.
- Quitar películas de la lista desde su pantalla de detalles.
- Eliminar películas directamente desde Mi lista.

La información se almacena en Cloud Firestore y se asocia al UID del usuario autenticado.

### 2.5. Administración del catálogo

La aplicación incorpora una sección de administración para gestionar el catálogo propio de CineLista.

El administrador puede:

- Agregar películas.
- Eliminar películas.
- Registrar título, año, director, género, sinopsis e imagen.
- Consultar las películas almacenadas en Firestore.

El acceso a esta sección está restringido mediante la identificación del usuario administrador y las reglas de seguridad de Firestore.

## 3. Widgets de Flutter utilizados

Durante el desarrollo se utilizaron diferentes widgets para construir la interfaz y organizar los elementos de la aplicación.

| Widget | Función en CineLista |
|---|---|
| `Text` | Mostrar títulos, descripciones y etiquetas. |
| `Row` | Distribuir elementos horizontalmente. |
| `Column` | Organizar elementos verticalmente. |
| `Stack` | Superponer elementos sobre imágenes y tarjetas. |
| `Container` | Definir fondos, dimensiones, bordes y espaciado. |
| `Image.network` | Cargar imágenes desde Internet. |
| `Icon` | Mostrar iconos de navegación y acciones. |
| `Scaffold` | Proporcionar la estructura de las pantallas. |
| `SafeArea` | Mantener el contenido dentro del área segura. |
| `Padding` | Establecer espacios alrededor de los elementos. |
| `ElevatedButton` | Crear botones de interacción. |
| `Navigator` | Gestionar la navegación entre pantallas. |
| `MaterialPageRoute` | Definir rutas de navegación. |

## 4. Tecnologías y herramientas utilizadas

| Tecnología o herramienta | Uso |
|---|---|
| Flutter | Desarrollo de la aplicación. |
| Dart | Lenguaje de programación. |
| Visual Studio Code | Entorno de desarrollo. |
| Paquete `http` | Solicitudes HTTP. |
| PHP | Desarrollo del backend. |
| XAMPP | Ejecución local de Apache y PHP. |
| TMDB API | Consulta de información de películas. |
| Firebase Core | Inicialización de Firebase. |
| Firebase Authentication | Autenticación de usuarios. |
| Cloud Firestore | Almacenamiento de datos en la nube. |
| Git | Control de versiones. |
| GitHub | Alojamiento del repositorio. |

## 5. Arquitectura de la aplicación

CineLista utiliza dos fuentes principales de información:

1. TMDB, para consultar películas externas.
2. Cloud Firestore, para almacenar el catálogo propio y las películas guardadas por cada usuario.

La comunicación con TMDB se realiza mediante un backend PHP.

### 5.1. Consulta de películas mediante TMDB

El flujo de comunicación es el siguiente:

1. Flutter realiza una solicitud HTTP al backend PHP.
2. El backend recibe la solicitud.
3. PHP consulta la API de TMDB utilizando el token de acceso configurado en el servidor.
4. TMDB devuelve la información en formato JSON.
5. El backend procesa y devuelve la respuesta a Flutter.
6. Flutter interpreta los datos y los presenta en la interfaz.

Esta arquitectura permite mantener el token de acceso a TMDB en el servidor, sin incluirlo directamente en las solicitudes realizadas desde la aplicación.

### 5.2. Integración con Firebase

Firebase proporciona los servicios de autenticación y almacenamiento.

- Authentication identifica al usuario que ha iniciado sesión.
- Firestore almacena las películas del catálogo propio.
- Firestore mantiene una lista personal de películas para cada usuario.
- Las reglas de seguridad controlan las operaciones permitidas según la identidad del usuario.

## 6. Integración de TMDB y peticiones HTTP

Se seleccionó **The Movie Database (TMDB)** como fuente externa de información cinematográfica.

La aplicación utiliza el servicio:

`lib/services/peliculas_service.dart`

Entre las operaciones implementadas se encuentran:

- `obtenerPeliculas()`: consulta las películas populares.
- `obtenerDestacada()`: obtiene la información de la película destacada.
- `obtenerDetalle(int id)`: consulta los detalles de una película.
- `buscarPeliculas(String consulta)`: realiza búsquedas.
- `obtenerPeliculasPorGenero(int idGenero)`: consulta películas por género.

El backend utiliza el parámetro `append_to_response=credits` para recuperar información adicional, como los créditos y el director de una película.

### 6.1. Backend PHP

Los archivos del backend se encuentran en:

`C:\xampp\htdocs\cinelista_api\`

Estructura:

```text
cinelista_api/
├── config.php
├── index.php
└── api/
    └── peliculas.php
```

El archivo `config.php` contiene la configuración privada necesaria para acceder a TMDB.

**Importante:** el token de TMDB no debe publicarse en GitHub ni incluirse directamente en el código de la aplicación.

## 7. Integración de Firebase y Cloud Firestore

Se creó el proyecto `cinelista-app` en Firebase Console.

Para la integración se utilizaron Firebase CLI y FlutterFire CLI.

Dependencias principales:

```bash
flutter pub add firebase_core cloud_firestore
flutter pub add firebase_auth
```

La inicialización de Firebase se realiza mediante `Firebase.initializeApp()` y las opciones de configuración generadas por FlutterFire.

### 7.1. Firebase Authentication

Se implementaron las siguientes funcionalidades:

- Registro de usuarios.
- Inicio de sesión.
- Cierre de sesión.
- Validación de credenciales.
- Seguimiento del estado de autenticación.

La lógica de autenticación se encuentra en:

`lib/services/auth_service.dart`

### 7.2. Estructura de Firestore

La aplicación utiliza las siguientes colecciones principales:

**Películas del catálogo propio:**

```text
peliculas_catalogo/
    ID_de_pelicula/
```

**Películas guardadas por usuario:**

```text
usuarios/
    UID_del_usuario/
        peliculas_guardadas/
            ID_de_pelicula/
```

La colección `peliculas_catalogo` almacena las películas administradas desde la aplicación.

La subcolección `peliculas_guardadas` mantiene las películas guardadas por cada usuario, sin mezclar los datos personales de diferentes cuentas.

### 7.3. Servicios de Firestore

La lógica de almacenamiento se organiza en los siguientes archivos:

- `lib/services/peliculas_guardadas_service.dart`: gestión de películas guardadas por los usuarios.
- `lib/services/peliculas_catalogo_service.dart`: gestión del catálogo propio de CineLista.

Los datos de las películas incluyen información como identificador, título, año o fecha de lanzamiento, director, género, sinopsis, imagen y fecha de almacenamiento, según el origen de la película.

### 7.4. Seguridad y permisos

Las reglas de Cloud Firestore restringen el acceso a los datos.

- Los usuarios autenticados pueden consultar el catálogo.
- Cada usuario puede consultar y modificar únicamente su propia lista.
- Solo el UID configurado como administrador puede agregar o eliminar películas del catálogo propio.

Las reglas deben publicarse desde Firebase Console, en la sección **Firestore Database → Rules**.

Ejemplo de reglas utilizadas:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    match /usuarios/{userId}/peliculas_guardadas/{peliculaId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;
    }

    match /peliculas_catalogo/{peliculaId} {
      allow read: if request.auth != null;

      allow create: if request.auth != null
                    && request.auth.uid == 'UID_DEL_ADMINISTRADOR';

      allow delete: if request.auth != null
                    && request.auth.uid == 'UID_DEL_ADMINISTRADOR';
    }
  }
}
```

**Nota:** sustituir `UID_DEL_ADMINISTRADOR` por el UID real de la cuenta administradora configurada en `AuthService`. No se debe utilizar el texto de ejemplo como valor definitivo.

## 8. Estructura principal del proyecto Flutter

```text
CineLista/
├── android/
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart
│   ├── screens/
│   │   └── administracion_page.dart
│   └── services/
│       ├── auth_service.dart
│       ├── peliculas_service.dart
│       ├── peliculas_guardadas_service.dart
│       └── peliculas_catalogo_service.dart
├── pubspec.yaml
├── firebase.json
└── README.md
```

La estructura representa los archivos principales de la aplicación. También existen otros archivos y directorios de configuración generados por Flutter y Firebase.

## 9. Instalación y ejecución

### 9.1. Requisitos

Para trabajar con el proyecto se necesitan:

- Flutter SDK.
- Dart SDK.
- Visual Studio Code u otro entorno compatible.
- Git.
- Una cuenta y proyecto configurados en Firebase.
- Una cuenta de desarrollador de TMDB.
- XAMPP con Apache y PHP para ejecutar el backend localmente.

### 9.2. Obtener las dependencias

Clonar el repositorio:

```bash
git clone https://github.com/iarlopi/LDSW_utilizacion_de_widgets.git
```

Acceder al directorio del proyecto:

```bash
cd CineLista
```

Instalar las dependencias:

```bash
flutter pub get
```

### 9.3. Configurar Firebase

Configurar el proyecto de Firebase y habilitar:

- Firebase Authentication con correo electrónico y contraseña.
- Cloud Firestore.

Los archivos de configuración deben corresponder al proyecto de Firebase utilizado.

### 9.4. Configurar el backend

1. Copiar el directorio `cinelista_api` a `C:\xampp\htdocs\`.
2. Configurar el token de acceso a TMDB en `config.php`.
3. Iniciar Apache desde el panel de control de XAMPP.
4. Comprobar que el backend responda desde el navegador:

`http://localhost/cinelista_api/`

El backend debe estar activo para consultar las películas desde el entorno local.

### 9.5. Ejecutar la aplicación

Para ejecutar CineLista en Google Chrome:

```bash
flutter run -d chrome
```

Para comprobar el proyecto mediante el analizador de Flutter:

```bash
flutter analyze
```

El archivo principal de la aplicación es:

`lib/main.dart`

## 10. Pruebas realizadas

Durante el desarrollo se realizaron pruebas para comprobar las funcionalidades principales:

- Visualización de la pantalla de bienvenida.
- Registro, inicio y cierre de sesión.
- Consulta de películas populares desde TMDB.
- Visualización de detalles de películas.
- Consulta del director y los géneros.
- Búsqueda de películas y filtrado por género.
- Rotación diaria de la película destacada.
- Guardado de películas en Mi lista.
- Eliminación de películas guardadas.
- Persistencia de los datos en Cloud Firestore.
- Agregado y eliminación de películas desde la administración.
- Restricción del acceso a la administración para usuarios no administradores.
- Navegación entre las secciones principales.
- Ejecución de `flutter analyze`, con resultado `No issues found` después de las últimas modificaciones documentadas.

## 11. Recursos y documentación

- [Documentación oficial de Flutter](https://docs.flutter.dev/)
- [Flutter: Obtener datos desde Internet](https://docs.flutter.dev/cookbook/networking/fetch-data)
- [Paquete HTTP para Dart y Flutter](https://pub.dev/packages/http)
- [The Movie Database (TMDB)](https://www.themoviedb.org/)
- [Documentación de Firebase para Flutter](https://firebase.google.com/docs/flutter/setup)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)

## 12. Conclusión

El desarrollo de CineLista permitió integrar diferentes tecnologías y servicios para construir una aplicación de catálogo de películas con Flutter.

A lo largo del proyecto se aplicaron widgets para desarrollar interfaces, navegación entre pantallas y solicitudes HTTP para consumir información externa.

Además, la integración de Firebase permitió incorporar autenticación de usuarios y almacenamiento en la nube, diferenciando el catálogo propio de las listas personales de cada usuario.

La aplicación reúne funcionalidades de consulta, búsqueda, administración y almacenamiento de películas, combinando Flutter, PHP, TMDB y Firebase en una solución integrada.

---

**Repositorio:** [LDSW_utilizacion_de_widgets](https://github.com/iarlopi/LDSW_utilizacion_de_widgets)

**Rama principal:** `main`