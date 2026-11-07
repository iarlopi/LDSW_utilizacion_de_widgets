**# LDSW - Utilización de widgets en Flutter**



**## 1. Descripción del proyecto**



CineLista es una aplicación móvil de catálogo de películas desarrollada con Flutter y Dart. Su diseño está inspirado en aplicaciones de cine y plataformas de entretenimiento, con una paleta de colores oscuros y elementos visuales organizados para facilitar la consulta de películas.



El proyecto permite practicar el uso de los widgets básicos de Flutter, implementar la navegación entre pantallas y realizar peticiones HTTP para obtener información desde Internet.



Para la consulta de películas se utiliza la API de **\*\*The Movie Database (TMDB)\*\***, mediante un backend desarrollado en PHP que recibe las solicitudes de la aplicación y consulta los datos del servicio externo.



**## 2. Widgets utilizados**



**### Text**



**\*\*Función:\*\*** mostrar textos en la interfaz, como títulos, descripciones, etiquetas y nombres de películas.



**\*\*Dónde se utiliza:\*\***

\- Nombre de la aplicación: \`CineLista\`.

\- Título de la sección: \`Destacada\`.

\- Nombre de la película: \`Interstellar\`.

\- Información de la película, como año, género y duración.

\- Etiquetas de los géneros y títulos de las películas populares.



**\*\*Ejemplo de código:\*\***



\`\`\`dart

const Text(

  'CineLista',

  style: TextStyle(

    fontSize: 30,

    fontWeight: FontWeight.w900,

  ),

)

\`\`\`



**### Row**



**\*\*Función:\*\*** organizar varios widgets horizontalmente, uno junto a otro.



**\*\*Dónde se utiliza:\*\***

\- En el buscador, para colocar el icono de búsqueda y el texto.

\- En la sección de géneros, para mostrar las etiquetas en una misma fila.

\- En la sección de películas populares, para colocar dos tarjetas lado a lado.



**\*\*Ejemplo de código:\*\***



\`\`\`dart

Row(

  children: [

    \_genero('Sci-Fi'),

    const Spacer(),

    \_genero('Terror'),

    const Spacer(),

    \_genero('Thriller'),

  ],

)

\`\`\`



**### Column**



**\*\*Función:\*\*** organizar widgets verticalmente.



**\*\*Dónde se utiliza:\*\***

\- En la estructura principal de la pantalla, para distribuir las secciones de CineLista.

\- En la información de la película destacada, para colocar el título y los datos en líneas separadas.

\- En cada tarjeta de película popular, para organizar el póster, el título y la descripción.



**\*\*Ejemplo de código:\*\***



\`\`\`dart

const Column(

  crossAxisAlignment: CrossAxisAlignment.start,

  children: [

    Text('Interstellar'),

    SizedBox(height: 4),

    Text('2014 • Ciencia ficción • 169 min'),

  ],

)

\`\`\`



**### Stack**



**\*\*Función:\*\*** superponer widgets, permitiendo colocar elementos en distintas posiciones dentro de una misma área.



**\*\*Dónde se utiliza:\*\***

\- En la película destacada, para superponer la etiqueta \`RECOMENDADA\` sobre el póster.

\- En las tarjetas de películas populares, para colocar elementos visuales sobre el fondo del póster.



**\*\*Ejemplo de código:\*\***



\`\`\`dart

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

\`\`\`



**### Container**



**\*\*Función:\*\*** definir áreas visuales y controlar propiedades como dimensiones, color de fondo, relleno interior, bordes y esquinas redondeadas.



**\*\*Dónde se utiliza:\*\***

\- En el buscador, para definir el contorno y el espacio interior.

\- En el área de la película destacada.

\- En las etiquetas de los géneros.

\- En el botón \`Ver detalle\`.

\- En los fondos de las tarjetas de películas populares.



**\*\*Ejemplo de código:\*\***



\`\`\`dart

Container(

  width: double.infinity,

  padding: const EdgeInsets.symmetric(vertical: 12),

  decoration: BoxDecoration(

    color: azul,

    borderRadius: BorderRadius.circular(6),

  ),

  child: const Text('Ver detalle'),

)

\`\`\`



**## 3. Resumen de los widgets**



\| Widget | Uso principal en CineLista |

\|---|---|

\| \`Text\` | Mostrar títulos, descripciones y etiquetas. |

\| \`Row\` | Distribuir elementos horizontalmente. |

\| \`Column\` | Organizar el contenido verticalmente. |

\| \`Stack\` | Superponer etiquetas e iconos sobre los pósteres. |

\| \`Container\` | Definir fondos, dimensiones, bordes y espaciado. |



**## 4. Tecnologías utilizadas**



\- Flutter y Dart para el desarrollo de la aplicación.

\- Visual Studio Code como entorno de desarrollo.

\- Paquete \`http\` para realizar solicitudes HTTP desde Dart.

\- PHP para desarrollar el backend que conecta la aplicación con TMDB.

\- XAMPP para ejecutar el servidor Apache localmente.

\- API de The Movie Database (TMDB) para obtener información de películas.

\- Git y GitHub para el control de versiones.
- Firebase Core para inicializar Firebase en la aplicación Flutter.
- Firebase Authentication para el registro, inicio y cierre de sesión de usuarios.
- Cloud Firestore para almacenar las películas guardadas por cada usuario.



**## 5. Ejecución del proyecto**



Para ejecutar la aplicación en Google Chrome desde el terminal, utiliza:



\`\`\`bash

flutter pub get

flutter run -d chrome

\`\`\`



El archivo principal de la aplicación es \`lib/main.dart\`.



El servicio encargado de las peticiones HTTP se encuentra en:



\`lib/services/peliculas_service.dart\`



**### 5.1. Configuración del backend**



La aplicación utiliza un backend PHP que debe ejecutarse localmente mediante XAMPP.



Los archivos del backend se encuentran en la carpeta:



\`C:\xampp\htdocs\cinelista_api\\\`



La estructura utilizada es:



\`\`\`text

cinelista_api/

├── config.php

├── index.php

└── api/

    └── peliculas.php

\`\`\`



Para utilizar el backend:



1\. Iniciar Apache desde el panel de control de XAMPP.

2\. Configurar el token de acceso de TMDB en \`config.php\`.

3\. Mantener el token en el servidor y evitar publicarlo en GitHub.

4\. Comprobar que el backend responde desde el navegador mediante:



\`\`\`text

http\://localhost/cinelista_api/

\`\`\`



**\*\*Nota:\*\*** el backend PHP y el servidor Apache deben estar activos para que la aplicación pueda consultar los datos de películas desde el entorno local.



**## 6. Integración de peticiones HTTP y API de TMDB**



**### 6.1. Objetivo**



Implementar peticiones HTTP en CineLista para obtener información de películas desde Internet y mostrarla dinámicamente en la aplicación.



La integración permite consultar películas populares, obtener información de una película destacada y recuperar los detalles de una película seleccionada.



**### 6.2. Selección de la API**



La actividad proponía distintas alternativas de APIs, entre ellas Marvel Developer API.



Sin embargo, debido a la disponibilidad de acceso para desarrolladores, se seleccionó **\*\*The Movie Database (TMDB)\*\*** como alternativa. Esta API está directamente relacionada con la temática de CineLista y permite consultar información de películas.



Documentación y recursos:

\- [Documentación oficial de Flutter: Obtener datos desde Internet]\(https\://docs.flutter.dev/cookbook/networking/fetch-data).

\- [Paquete HTTP para Dart y Flutter]\(https\://pub.dev/packages/http).

\- [The Movie Database (TMDB)]\(https\://www\.themoviedb.org/).



**### 6.3. Arquitectura de la integración**



La comunicación se realiza mediante la siguiente estructura:



1\. **\*\*Aplicación Flutter:\*\*** solicita información al backend utilizando el paquete \`http\`.

2\. **\*\*Backend PHP:\*\*** recibe las solicitudes y realiza las consultas correspondientes a TMDB.

3\. **\*\*API de TMDB:\*\*** proporciona los datos de las películas en formato JSON.

4\. **\*\*Respuesta al cliente:\*\*** PHP devuelve la información a Flutter, donde se procesa y presenta en la interfaz.



Esta estructura permite mantener el token de acceso a TMDB en el servidor, sin incluirlo directamente en el código de la aplicación.



**### 6.4. Implementación del servicio HTTP**



Se creó el archivo \`lib/services/peliculas_service.dart\`, encargado de centralizar las solicitudes HTTP.



El servicio implementa tres métodos principales:



\| Método | Función |

\|---|---|

\| \`obtenerPeliculas()\` | Recupera la lista de películas populares. |

\| \`obtenerDestacada()\` | Obtiene la información de la película destacada. |

\| \`obtenerDetalle(int id)\` | Recupera los detalles de una película mediante su identificador. |



Se utiliza el método HTTP GET para solicitar los datos al backend. Las respuestas se procesan mediante \`jsonDecode\` para convertir el contenido JSON en estructuras de datos que Flutter puede utilizar.



**### 6.5. Funcionalidades implementadas**



La integración con TMDB permite:



\- Cargar películas populares desde Internet.

\- Obtener la información de la película destacada, Interstellar.

\- Mostrar información como título, fecha de estreno, géneros, duración, valoración y sinopsis, según los datos disponibles.

\- Seleccionar una película popular para consultar su información detallada.

\- Navegar a una pantalla de detalle con los datos recuperados desde el backend.



**### 6.6. Pruebas realizadas**



Se realizaron pruebas para verificar el funcionamiento de la integración:



\- Se comprobó que el backend PHP respondiera correctamente.

\- Se verificó la recepción de datos JSON desde TMDB.

\- Se comprobó la carga de películas populares en la aplicación.

\- Se verificó la recuperación de los datos de Interstellar.

\- Se probó la selección de películas populares y la navegación hacia sus respectivas pantallas de detalle.

\- Se ejecutó \`flutter analyze\` para comprobar que el código no presentara problemas detectados por el analizador de Flutter.



Los resultados confirmaron que las peticiones HTTP funcionan correctamente y que la información recuperada se muestra en la aplicación.



**## 7. Creación de la pantalla de bienvenida (Home Screen)**



**### 7.1. Objetivo**



Crear una pantalla de bienvenida para CineLista que muestre una imagen de fondo, el nombre de la aplicación, un icono relacionado con el cine y un mensaje de bienvenida, utilizando widgets de Flutter.



**### 7.2. Elementos implementados**



La pantalla de bienvenida se estableció como la pantalla inicial de la aplicación. Incluye los siguientes elementos:



\- **\*\*Imagen de fondo:\*\*** se utiliza \`Image.network\` para cargar una imagen relacionada con una sala de cine desde Internet.

\- **\*\*Nombre de la aplicación:\*\*** se muestra el título \`CineLista\`.

\- **\*\*Mensaje de bienvenida:\*\*** se incorpora el texto \`¡Bienvenid\@s!\`.

\- **\*\*Icono:\*\*** se utiliza \`Icon\` con \`Icons.movie_creation_outlined\` para representar el cine.

\- **\*\*Texto descriptivo:\*\*** se añade el mensaje "Tu próxima película favorita te espera".

\- **\*\*Botón de navegación:\*\*** el botón "Entrar al catálogo" permite acceder a la pantalla del catálogo.



**### 7.3. Widgets y componentes utilizados**



\- **\*\*\`Scaffold\`:\*\*** proporciona la estructura básica de la pantalla.

\- **\*\*\`Stack\`:\*\*** permite superponer la imagen de fondo, una capa oscura y el contenido principal.

\- **\*\*\`Image.network\`:\*\*** carga la imagen de fondo desde una dirección web.

\- **\*\*\`Container\`:\*\*** incorpora un degradado oscuro que facilita la lectura del texto.

\- **\*\*\`SafeArea\`:\*\*** ayuda a mantener el contenido dentro del área segura de la pantalla.

\- **\*\*\`Center\`:\*\*** centra el contenido.

\- **\*\*\`Padding\`:\*\*** establece el espacio alrededor de los elementos.

\- **\*\*\`Column\`:\*\*** organiza verticalmente el icono, los textos y el botón.

\- **\*\*\`Text\`:\*\*** muestra el nombre de la aplicación y los mensajes.

\- **\*\*\`Icon\`:\*\*** muestra el icono relacionado con el cine.

\- **\*\*\`ElevatedButton\`:\*\*** presenta el botón de acceso al catálogo.

\- **\*\*\`Navigator.push\` y \`MaterialPageRoute\`:\*\*** permiten navegar desde la pantalla de bienvenida hasta el catálogo.



**### 7.4. Pruebas realizadas**



La aplicación se ejecutó en Google Chrome para comprobar el funcionamiento de la pantalla de bienvenida. Se verificó que la imagen de fondo, el icono, el nombre CineLista y el mensaje "¡Bienvenid\@s!" se mostraran correctamente.



También se comprobó que el botón "Entrar al catálogo" permitiera acceder a la pantalla del catálogo.



**### 7.5. Resultado**



Se implementó una pantalla de bienvenida funcional que permite acceder al catálogo y mantiene la integración con las funcionalidades desarrolladas anteriormente.



**## 8. Widgets adicionales de la pantalla de bienvenida**



Además de los widgets documentados en la sección 2, la pantalla de bienvenida incorpora otros componentes para organizar el contenido y facilitar la navegación.



\| Widget o componente | Uso en la pantalla de bienvenida |

\|---|---|

\| \`Image.network\` | Cargar la imagen de fondo desde Internet. |

\| \`Icon\` | Mostrar el icono de cine. |

\| \`Scaffold\` | Estructurar la pantalla. |

\| \`SafeArea\` | Respetar el área segura de visualización. |

\| \`Center\` | Centrar el contenido. |

\| \`Padding\` | Aplicar espaciado alrededor del contenido. |

\| \`ElevatedButton\` | Mostrar el botón para entrar al catálogo. |

\| \`Navigator.push\` | Abrir la pantalla del catálogo. |

\| \`MaterialPageRoute\` | Definir la ruta de navegación hacia el catálogo. |



Estos componentes complementan los widgets básicos documentados anteriormente y permiten construir una pantalla de bienvenida visualmente organizada e integrada con el resto de CineLista.



**## 9. Conclusión**



El desarrollo de CineLista permitió aplicar los principales widgets de Flutter para construir una interfaz organizada y visualmente coherente.



Además, se incorporó una integración con servicios externos mediante peticiones HTTP, utilizando el paquete \`http\`, un backend PHP y la API de TMDB para recuperar información real de películas.



Con estas implementaciones, la aplicación combina la construcción de interfaces móviles, la navegación entre pantallas y el consumo de datos desde Internet, cumpliendo con los objetivos de las actividades desarrolladas.

Posteriormente, se integró Firebase con Flutter para ampliar las capacidades de la aplicación. Se implementó Firebase Authentication para permitir el registro, inicio y cierre de sesión de los usuarios, y Cloud Firestore para almacenar películas desde la aplicación. Los registros se organizan por usuario autenticado, utilizando su UID y el identificador de cada película de TMDB.

Con esta integración, CineLista incorpora tanto la consulta de información externa mediante TMDB como el almacenamiento de datos propios en Firebase. También se verificó que las películas guardadas desde la aplicación aparecieran correctamente en Cloud Firestore.

**## 10. Integración de Firebase y Flutter**

**### 10.1. Objetivo**

Integrar Firebase con CineLista, desarrollada en Flutter, para incorporar servicios de autenticación y almacenamiento de datos en la nube. Esta integración permite identificar a los usuarios de la aplicación y guardar información de películas mediante Cloud Firestore.

**### 10.2. Configuración de Firebase**

Se creó el proyecto \`cinelista-app\` en Firebase Console y se configuró para utilizarse desde la aplicación Flutter.

Para realizar la integración se utilizaron Firebase CLI y FlutterFire CLI. La configuración generó los archivos necesarios para conectar las plataformas seleccionadas con el proyecto de Firebase:

- \`lib/firebase_options.dart\`: contiene las opciones de configuración utilizadas por Flutter.
- \`android/app/google-services.json\`: archivo de configuración de Firebase para Android.
- \`firebase.json\`: archivo de configuración asociado al proyecto Firebase.

También se añadieron las dependencias necesarias al proyecto mediante Flutter:

\`\`\`bash
flutter pub add firebase_core cloud_firestore
flutter pub add firebase_auth
\`\`\`

La inicialización de Firebase se realiza antes de ejecutar la aplicación, mediante \`Firebase.initializeApp()\` y las opciones generadas por FlutterFire.

**### 10.3. Firebase Authentication**

Se integró Firebase Authentication para gestionar el acceso de los usuarios a CineLista mediante correo electrónico y contraseña.

Se implementaron las siguientes funcionalidades:

- Registro de usuarios.
- Validación de los campos del formulario y confirmación de contraseña.
- Inicio de sesión con correo electrónico y contraseña.
- Cierre de sesión.
- Seguimiento del estado de autenticación para mostrar la pantalla de bienvenida o el catálogo según corresponda.

La lógica de autenticación se centralizó en el archivo \`lib/services/auth_service.dart\`. Las interfaces de registro e inicio de sesión se implementaron en:

- \`lib/screens/registro_page.dart\`
- \`lib/screens/login_page.dart\`

**### 10.4. Configuración de Cloud Firestore**

Se creó una base de datos de Cloud Firestore en el proyecto de Firebase. La base de datos se configuró en modo de producción y se establecieron reglas de seguridad para que cada usuario autenticado pueda consultar y modificar únicamente los documentos asociados a su propio UID.

Las reglas aplicadas son:

\`\`\`javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    match /usuarios/{userId}/peliculas_guardadas/{peliculaId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;
    }

  }
}
\`\`\`

**### 10.5. Implementación del almacenamiento de películas**

Se creó el archivo \`lib/services/peliculas_guardadas_service.dart\`, que centraliza la operación para guardar películas en Cloud Firestore.

El servicio realiza las siguientes acciones:

1. Obtiene el usuario que ha iniciado sesión mediante Firebase Authentication.
2. Utiliza el UID del usuario para identificar su espacio de almacenamiento.
3. Guarda los datos de la película en la subcolección \`peliculas_guardadas\`.
4. Utiliza el identificador de TMDB como ID del documento, de modo que volver a guardar la misma película actualiza el documento en lugar de crear otro con un identificador diferente.
5. Registra la fecha de almacenamiento mediante \`FieldValue.serverTimestamp()\`.

Los datos almacenados incluyen:

- Identificador de TMDB (\`tmdbId\`).
- Título (\`titulo\`).
- Fecha de lanzamiento (\`fechaLanzamiento\`).
- Ruta del póster (\`posterPath\`).
- Sinopsis (\`sinopsis\`).
- Calificación (\`calificacion\`).
- Fecha de guardado (\`guardadaEn\`).

**### 10.6. Estructura de almacenamiento**

Los documentos se organizan por usuario, utilizando la siguiente estructura:

\`\`\`text
usuarios/
  UID_del_usuario/
    peliculas_guardadas/
      ID_de_pelicula/
\`\`\`

De esta manera, cada usuario dispone de una subcolección propia para almacenar las películas que guarda desde CineLista.

**### 10.7. Funcionalidad integrada en la aplicación**

Se incorporó el botón \`Guardar en mi lista\` en la pantalla de detalles de una película. Al seleccionarlo, la aplicación utiliza el servicio de Firestore para almacenar la información de la película asociada al usuario autenticado.

Durante la operación se muestra un indicador de carga y, cuando el almacenamiento finaliza correctamente, se presenta el mensaje \`Película guardada en tu lista\`.

Esta implementación permite agregar datos a Firebase directamente desde la aplicación Flutter.

**### 10.8. Pruebas realizadas**

Se realizaron las siguientes pruebas para verificar la integración:

- Se comprobó la inicialización de Firebase al ejecutar CineLista.
- Se registró un usuario mediante el formulario de la aplicación y se verificó su aparición en Firebase Authentication.
- Se comprobó el inicio y cierre de sesión utilizando las credenciales registradas.
- Se abrió el detalle de una película y se utilizó el botón \`Guardar en mi lista\`.
- Se verificó que la aplicación mostrara el mensaje de confirmación del almacenamiento.
- Se comprobó en Cloud Firestore la creación del documento correspondiente al usuario y a la película seleccionada.
- Se ejecutó \`flutter analyze\` y se obtuvo el resultado \`No issues found\`.

Las pruebas confirmaron que CineLista puede conectarse con Firebase y agregar datos a Cloud Firestore desde la aplicación.

**### 10.9. Control de versiones**

Los cambios correspondientes a la integración de Firebase se registraron mediante Git y se publicaron en GitHub.

- Repositorio: [LDSW_utilizacion_de_widgets](https://github.com/iarlopi/LDSW_utilizacion_de_widgets)
- Rama: \`main\`.
- Commit: \`664420c\`.
- Mensaje: \`Integracion de Firebase y Cloud Firestore\`.

Los archivos de configuración y código necesarios para la integración se incorporaron al repositorio. Las credenciales privadas de TMDB y los archivos de variables de entorno se mantienen excluidos mediante \`.gitignore\`.
