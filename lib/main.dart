
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/peliculas_service.dart';
import 'services/auth_service.dart';
import 'services/peliculas_guardadas_service.dart';
import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'screens/registro_page.dart';
import 'screens/administracion_page.dart';
import 'services/peliculas_catalogo_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CineListaApp());
}

const Color fondo = Color(0xFF263746);
const Color fondoTarjeta = Color(0xFF536779);
const Color azul = Color(0xFF0875C9);
const Color textoClaro = Color(0xFFF2F5F8);
const Color textoSecundario = Color(0xFFB8C5D1);

// Aplicación principal.
class CineListaApp extends StatelessWidget {
  const CineListaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CineLista',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: fondo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: azul,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      home: const AuthGate(),
    );
  }
}

// Controla la navegación según el estado de autenticación.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.cambiosAutenticacion,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: fondo,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          return const CineListaPage();
        }

        return const WelcomeScreen();
      },
    );
  }
}

// Pantalla de bienvenida.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=1200&q=85',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: fondo);
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.85),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.movie_creation_outlined,
                      size: 82,
                      color: Color(0xFF54B4FF),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'CineLista',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      '¡Bienvenid@s!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tu próxima película favorita te espera',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Opciones de autenticación.
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: azul,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text('Iniciar sesión'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegistroPage(),
                              ),
                            );
                          },
                          child: const Text('Crear una cuenta'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Pantalla del catálogo de películas.
class CineListaPage extends StatefulWidget {
  const CineListaPage({super.key});

  @override
  State<CineListaPage> createState() => _CineListaPageState();
}

class _CineListaPageState extends State<CineListaPage> {
  final PeliculasService _servicioPeliculas = PeliculasService();
  final AuthService _authService = AuthService();
  final PeliculasCatalogoService _servicioCatalogo =
      PeliculasCatalogoService();

  late Future<List<dynamic>> _peliculas;
  late Future<Map<String, dynamic>> _destacada;
  late Stream<List<Map<String, dynamic>>> _peliculasCatalogo;
  int _indiceSeleccionado = 0;
  int? _generoInicial;

  @override
  void initState() {
    super.initState();
    _peliculas = _servicioPeliculas.obtenerPeliculas();
    _destacada = _obtenerDestacadaDelDia();
    _peliculasCatalogo =
        _servicioCatalogo.obtenerPeliculasCatalogo();
  }

  // Selecciona una película popular distinta según el día actual.
  // La selección permanece estable durante todo el día.
  Future<Map<String, dynamic>> _obtenerDestacadaDelDia() async {
    final peliculas = await _peliculas;

    final candidatas = peliculas
        .whereType<Map>()
        .where((pelicula) => pelicula['id'] is num)
        .map((pelicula) => Map<String, dynamic>.from(pelicula))
        .toList();

    if (candidatas.isEmpty) {
      throw Exception('No hay películas disponibles para destacar.');
    }

    // Ordenar por ID evita que el orden de respuesta de TMDB cambie
    // la selección durante el mismo día.
    candidatas.sort(
      (a, b) => (a['id'] as num).compareTo(b['id'] as num),
    );

    final hoy = DateTime.now();
    final fechaHoy = DateTime(hoy.year, hoy.month, hoy.day);
    final diasDesdeReferencia =
        fechaHoy.difference(DateTime(2020, 1, 1)).inDays;
    final indice = diasDesdeReferencia % candidatas.length;
    final idSeleccionado = (candidatas[indice]['id'] as num).toInt();

    // Recupera el detalle completo, incluido el director y los géneros.
    return _servicioPeliculas.obtenerDetalle(idSeleccionado);
  }

  Future<void> _cerrarSesion() async {
    try {
      await _authService.cerrarSesion();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo cerrar la sesión.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: _indiceSeleccionado == 1
          ? BuscarPage(key: ValueKey(_generoInicial), generoInicial: _generoInicial)
          : _indiceSeleccionado == 2
              ? const MiListaPage()
              : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre y descripción de la aplicación.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'CineLista',
                      style: TextStyle(
                        color: textoClaro,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'Menú principal',
                    icon: const Icon(
                      Icons.menu,
                      color: textoClaro,
                    ),
                    onSelected: (opcion) {
                      switch (opcion) {
                        case 'catalogo':
                          Navigator.popUntil(context, (route) => route.isFirst);
                          break;

                        case 'administracion':
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => const AdministracionPage(),
                            ),
                          );
                          break;

                        case 'salir':
                          _cerrarSesion();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: 'catalogo',
                        child: Row(
                          children: [
                            Icon(Icons.movie_outlined),
                            SizedBox(width: 10),
                            Text('Catálogo'),
                          ],
                        ),    
                      ),
                      if (_authService.esAdministrador)
                        const PopupMenuItem<String>(
                          value: 'administracion',
                          child: Row(
                            children: [
                              Icon(Icons.admin_panel_settings_outlined),
                              SizedBox(width: 10),
                              Text('Administración'),
                            ],
                          ),
                        ),
                      const PopupMenuItem<String>(
                        value: 'salir',
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 10),
                            Text('Cerrar sesión'),
                          ],
                        ),
                      ),          
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Explora tu próximo descubrimiento',
                style: TextStyle(
                  color: textoSecundario,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 22),

              // Acceso rápido a la búsqueda.
              InkWell(
                onTap: () {
                  setState(() {
                    _indiceSeleccionado = 1;
                    _generoInicial = null;
                  });
                },
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: textoSecundario),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: textoSecundario),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Buscar películas',
                          style: TextStyle(
                            color: textoSecundario,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Destacada',
                style: TextStyle(
                  color: textoClaro,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Película destacada obtenida desde TMDB.
              FutureBuilder<Map<String, dynamic>>(
                future: _destacada,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SizedBox(
                      height: 220,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return const SizedBox(
                      height: 170,
                      child: Center(
                        child: Text(
                          'No se pudo cargar la película destacada.',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    );
                  }

                  final pelicula = snapshot.data!;
                  final titulo =
                      pelicula['title']?.toString() ?? 'Sin título';

                  final fecha =
                      pelicula['release_date']?.toString() ?? '';

                  final anio = fecha.length >= 4
                      ? fecha.substring(0, 4)
                      : 'Año no disponible';

                  final duracion =
                      pelicula['runtime']?.toString() ?? '';

                  final generos =
                      (pelicula['genres'] as List<dynamic>?)
                              ?.map((genero) => genero['name'].toString())
                              .join(' • ') ??
                          '';

                  final posterPath =
                      pelicula['poster_path']?.toString();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Póster y etiqueta de recomendación.
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 220,
                              color: fondoTarjeta,
                              child: posterPath != null &&
                                      posterPath.isNotEmpty
                                  ? Image.network(
                                      'https://image.tmdb.org/t/p/w500$posterPath',
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(
                                            Icons.movie_creation_outlined,
                                            size: 65,
                                            color: Color(0xFFB9C8D5),
                                          ),
                                        );
                                      },
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.movie_creation_outlined,
                                        size: 65,
                                        color: Color(0xFFB9C8D5),
                                      ),
                                    ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: azul,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  'RECOMENDADA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Título y datos dinámicos.
                      Text(
                        titulo,
                        style: const TextStyle(
                          color: textoClaro,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$anio • $generos • $duracion min',
                        style: const TextStyle(
                          color: textoSecundario,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 12),

              // Botón para abrir los detalles de la película destacada.
              Center(
                child: SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azul,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        final pelicula = await _destacada;

                        if (!context.mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PeliculaDetallePage(pelicula: pelicula),
                          ),
                        );
                      } catch (error) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No se pudieron cargar los detalles de la película.',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Ver detalle',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Por género',
                style: TextStyle(
                  color: textoClaro,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Filtros de género: abren Buscar con el género seleccionado.
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: [
                  _genero('Acción', 28),
                  _genero('Aventura', 12),
                  _genero('Animación', 16),
                  _genero('Comedia', 35),
                  _genero('Ciencia ficción', 878),
                  _genero('Drama', 18),
                  _genero('Terror', 27),
                  _genero('Romance', 10749),
                  _genero('Suspense', 53),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                'Populares',
                style: TextStyle(
                  color: textoClaro,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Películas populares obtenidas desde TMDB.
              FutureBuilder<List<dynamic>>(
                future: _peliculas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Text(
                      'No se pudieron cargar las películas: ${snapshot.error}',
                      style: const TextStyle(
                        color: Colors.redAccent,
                      ),
                    );
                  }

                  final peliculas = snapshot.data ?? [];

                  if (peliculas.isEmpty) {
                    return const Text(
                      'No hay películas disponibles.',
                      style: TextStyle(color: textoClaro),
                    );
                  }

                  // Contenedor que ocupa todo el ancho disponible.
                  return SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 20,
                      children: peliculas.take(2).map((pelicula) {
                        final titulo =
                            pelicula['title']?.toString() ?? 'Sin título';

                        final fecha =
                            pelicula['release_date']?.toString() ?? '';

                        final anio = fecha.length >= 4
                            ? fecha.substring(0, 4)
                            : 'Año no disponible';

                        return SizedBox(
                          width: 190,
                          child: PeliculaPopular(
                            titulo: titulo,
                            datos: anio,
                            posterPath:
                                pelicula['poster_path']?.toString(),
                            onTap: () async {
                              final id = pelicula['id'];

                              if (id is! num) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'No se encontró el identificador de la película.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              try {
                                final detalle = await _servicioPeliculas
                                    .obtenerDetalle(id.toInt());

                                if (!context.mounted) return;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PeliculaDetallePage(
                                      pelicula: detalle,
                                    ),
                                  ),
                                );
                              } catch (error) {
                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'No se pudieron cargar los detalles de la película.',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              const Text(
                'Catálogo CineLista',
                style: TextStyle(
                  color: textoClaro,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Películas registradas desde Administración en Firestore.
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _peliculasCatalogo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Text(
                      'No se pudo cargar el catálogo: ${snapshot.error}',
                      style: const TextStyle(color: Colors.redAccent),
                    );
                  }

                  final peliculasCatalogo = snapshot.data ?? [];

                  if (peliculasCatalogo.isEmpty) {
                    return const Text(
                      'Todavía no hay películas registradas en CineLista.',
                      style: TextStyle(color: textoSecundario),
                    );
                  }

                  return SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 20,
                      children: peliculasCatalogo.map((pelicula) {
                        final titulo =
                            pelicula['titulo']?.toString() ?? 'Sin título';
                        final anio = pelicula['anio']?.toString() ?? '';
                        final imagenUrl =
                            pelicula['imagenUrl']?.toString() ?? '';

                        return SizedBox(
                          width: 190,
                          child: PeliculaCatalogoCard(
                            titulo: titulo,
                            anio: anio,
                            imagenUrl: imagenUrl,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PeliculaCatalogoDetallePage(
                                    pelicula: pelicula,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // Navegación inferior.
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF718394)),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: fondo,
          selectedItemColor: const Color(0xFF54B4FF),
          unselectedItemColor: textoClaro,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: _indiceSeleccionado,
          onTap: (indice) {
            setState(() => _indiceSeleccionado = indice);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Buscar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: 'Mi lista',
            ),
          ],
        ),
      ),
    );
  }

  // Etiqueta de género que abre la pantalla de búsqueda filtrada.
  Widget _genero(String nombre, int idGenero) {
    return ActionChip(
      label: Text(nombre),
      backgroundColor: const Color(0xFFE7EDF2),
      labelStyle: const TextStyle(
        color: Color(0xFF263746),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      onPressed: () {
        setState(() {
          _generoInicial = idGenero;
          _indiceSeleccionado = 1;
        });
      },
    );
  }
}

// Tarjeta de película popular.
class PeliculaPopular extends StatelessWidget {
  final String titulo;
  final String datos;
  final String? posterPath;
  final VoidCallback onTap;

  const PeliculaPopular({
    super.key,
    required this.titulo,
    required this.datos,
    this.posterPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: double.infinity,
              height: 280,
              child: posterPath != null && posterPath!.isNotEmpty
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500$posterPath',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return _posterPredeterminado();
                      },
                    )
                  : _posterPredeterminado(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            titulo,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: textoClaro,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            datos,
            style: const TextStyle(
              color: textoSecundario,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _posterPredeterminado() {
    return Container(
      color: fondoTarjeta,
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          size: 40,
          color: Color(0xFFB9C8D5),
        ),
      ),
    );
  }
}

// Pantalla con la información completa de una película.
class PeliculaDetallePage extends StatefulWidget {
  final Map<String, dynamic> pelicula;
  final bool estaGuardada;
  final String? idDocumentoGuardado;

  const PeliculaDetallePage({
    super.key,
    required this.pelicula,
    this.estaGuardada = false,
    this.idDocumentoGuardado,
  });

  @override
  State<PeliculaDetallePage> createState() => _PeliculaDetallePageState();
}

class _PeliculaDetallePageState extends State<PeliculaDetallePage> {
  final PeliculasGuardadasService _servicioGuardadas =
      PeliculasGuardadasService();

  bool _guardando = false;

  Future<void> _guardarPelicula() async {
    if (widget.estaGuardada) {
      await _quitarDeMiLista();
      return;
    }

    final id = widget.pelicula['id'];

    if (id is! num) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontró el identificador de la película.'),
        ),
      );
      return;
    }

    setState(() => _guardando = true);

    try {
      final calificacion = widget.pelicula['vote_average'];
      final director = _obtenerDirector(widget.pelicula);
      final genero = _obtenerGeneros(widget.pelicula);

      await _servicioGuardadas.guardarPelicula(
        tmdbId: id.toInt(),
        titulo: widget.pelicula['title']?.toString() ?? 'Sin título',
        fechaLanzamiento: widget.pelicula['release_date']?.toString(),
        posterPath: widget.pelicula['poster_path']?.toString(),
        sinopsis: widget.pelicula['overview']?.toString(),
        calificacion: calificacion is num ? calificacion.toDouble() : null,
        director: director,
        genero: genero,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Película guardada en tu lista.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar la película: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  Future<void> _quitarDeMiLista() async {
    final documentoId = widget.idDocumentoGuardado;
    if (documentoId == null || documentoId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontró el registro guardado de esta película.'),
        ),
      );
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: fondoTarjeta,
        title: const Text(
          'Quitar película',
          style: TextStyle(color: textoClaro),
        ),
        content: Text(
          '¿Quieres quitar "${widget.pelicula['title'] ?? 'esta película'}" de tu lista?',
          style: const TextStyle(color: textoClaro),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Quitar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    setState(() => _guardando = true);
    try {
      await _servicioGuardadas.eliminarPelicula(documentoId);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película eliminada de tu lista.')),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo quitar la película: $error')),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final pelicula = widget.pelicula;
    final titulo = pelicula['title']?.toString() ?? 'Sin título';
    final fecha = pelicula['release_date']?.toString() ?? '';
    final anio =
        fecha.length >= 4 ? fecha.substring(0, 4) : 'No disponible';
    final duracion = pelicula['runtime']?.toString() ?? '';
    final sinopsis = pelicula['overview']?.toString() ?? '';
    final calificacion = pelicula['vote_average'] is num
        ? (pelicula['vote_average'] as num).toStringAsFixed(1)
        : 'No disponible';

    final generos = _obtenerGeneros(pelicula).isNotEmpty
        ? _obtenerGeneros(pelicula)
        : 'No disponibles';
    final director = _obtenerDirector(pelicula).isNotEmpty
        ? _obtenerDirector(pelicula)
        : 'No disponible';

    final posterPath = pelicula['poster_path']?.toString();

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        foregroundColor: textoClaro,
        title: const Text('Detalle de película'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 360,
                    width: 240,
                    child: posterPath != null && posterPath.isNotEmpty
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w500$posterPath',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return _posterDetallePredeterminado();
                            },
                          )
                        : _posterDetallePredeterminado(),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                titulo,
                style: const TextStyle(
                  color: textoClaro,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$anio • $generos${duracion.isNotEmpty ? ' • $duracion min' : ''}',
                style: const TextStyle(
                  color: textoSecundario,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              _datoDetalle('Director', director),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Color(0xFFFFC857),
                    size: 21,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$calificacion / 10',
                    style: const TextStyle(
                      color: textoClaro,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _guardando ? null : _guardarPelicula,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azul,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: _guardando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          widget.estaGuardada
                              ? Icons.bookmark_remove_outlined
                              : Icons.bookmark_add_outlined,
                        ),
                  label: Text(
                    _guardando
                        ? (widget.estaGuardada ? 'Quitando...' : 'Guardando...')
                        : (widget.estaGuardada
                            ? 'Quitar de mi lista'
                            : 'Guardar en mi lista'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Sinopsis',
                style: TextStyle(
                  color: textoClaro,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                sinopsis.isNotEmpty
                    ? sinopsis
                    : 'Sin sinopsis disponible.',
                style: const TextStyle(
                  color: textoSecundario,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _obtenerDirector(Map<String, dynamic> pelicula) {
    final directorGuardado = pelicula['director']?.toString();
    if (directorGuardado != null && directorGuardado.isNotEmpty) {
      return directorGuardado;
    }

    final credits = pelicula['credits'];
    if (credits is! Map) return '';
    final crew = credits['crew'];
    if (crew is! List) return '';

    for (final persona in crew) {
      if (persona is Map && persona['job'] == 'Director') {
        return persona['name']?.toString() ?? '';
      }
    }
    return '';
  }

  String _obtenerGeneros(Map<String, dynamic> pelicula) {
    final generoGuardado = pelicula['genero']?.toString();
    if (generoGuardado != null && generoGuardado.isNotEmpty) {
      return generoGuardado;
    }

    final generos = pelicula['genres'];
    if (generos is! List) return '';

    return generos
        .whereType<Map>()
        .map((genero) => genero['name']?.toString() ?? '')
        .where((nombre) => nombre.isNotEmpty)
        .join(' • ');
  }

  Widget _datoDetalle(String etiqueta, String valor) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: textoSecundario, fontSize: 14),
        children: [
          TextSpan(
            text: '$etiqueta: ',
            style: const TextStyle(
              color: textoClaro,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: valor),
        ],
      ),
    );
  }

  Widget _posterDetallePredeterminado() {
    return Container(
      color: fondoTarjeta,
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          size: 65,
          color: Color(0xFFB9C8D5),
        ),
      ),
    );
  }
}

// Tarjeta para las películas registradas en el catálogo de CineLista.
class PeliculaCatalogoCard extends StatelessWidget {
  final String titulo;
  final String anio;
  final String imagenUrl;
  final VoidCallback onTap;

  const PeliculaCatalogoCard({
    super.key,
    required this.titulo,
    required this.anio,
    required this.imagenUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: double.infinity,
              height: 280,
              child: imagenUrl.isNotEmpty
                  ? Image.network(
                      imagenUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return _posterPredeterminado();
                      },
                    )
                  : _posterPredeterminado(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            titulo,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: textoClaro,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            anio,
            style: const TextStyle(
              color: textoSecundario,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _posterPredeterminado() {
    return Container(
      color: fondoTarjeta,
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          size: 40,
          color: Color(0xFFB9C8D5),
        ),
      ),
    );
  }
}

// Detalle de una película registrada en Firestore.
class PeliculaCatalogoDetallePage extends StatefulWidget {
  final Map<String, dynamic> pelicula;
  final bool estaGuardada;
  final String? idDocumentoGuardado;

  const PeliculaCatalogoDetallePage({
    super.key,
    required this.pelicula,
    this.estaGuardada = false,
    this.idDocumentoGuardado,
  });

  @override
  State<PeliculaCatalogoDetallePage> createState() =>
      _PeliculaCatalogoDetallePageState();
}

class _PeliculaCatalogoDetallePageState
    extends State<PeliculaCatalogoDetallePage> {
  final PeliculasGuardadasService _servicioGuardadas =
      PeliculasGuardadasService();
  bool _guardando = false;

  Future<void> _guardarPelicula() async {
    if (widget.estaGuardada) {
      await _quitarDeMiLista();
      return;
    }

    final peliculaId = widget.pelicula['id']?.toString() ?? '';
    if (peliculaId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontró el identificador de la película.'),
        ),
      );
      return;
    }

    setState(() => _guardando = true);
    try {
      await _servicioGuardadas.guardarPeliculaCatalogo(
        peliculaId: peliculaId,
        titulo: widget.pelicula['titulo']?.toString() ?? 'Sin título',
        anio: widget.pelicula['anio']?.toString() ?? '',
        director: widget.pelicula['director']?.toString() ?? '',
        genero: widget.pelicula['genero']?.toString() ?? '',
        sinopsis: widget.pelicula['sinopsis']?.toString() ?? '',
        imagenUrl: widget.pelicula['imagenUrl']?.toString() ?? '',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Película guardada en tu lista.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar la película: $error')),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _quitarDeMiLista() async {
    final documentoId = widget.idDocumentoGuardado;
    if (documentoId == null || documentoId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontró el registro guardado de esta película.'),
        ),
      );
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: fondoTarjeta,
        title: const Text(
          'Quitar película',
          style: TextStyle(color: textoClaro),
        ),
        content: Text(
          '¿Quieres quitar "${widget.pelicula['titulo'] ?? 'esta película'}" de tu lista?',
          style: const TextStyle(color: textoClaro),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Quitar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    setState(() => _guardando = true);
    try {
      await _servicioGuardadas.eliminarPelicula(documentoId);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película eliminada de tu lista.')),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo quitar la película: $error')),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final pelicula = widget.pelicula;
    final titulo = pelicula['titulo']?.toString() ?? 'Sin título';
    final anio = pelicula['anio']?.toString() ?? 'No disponible';
    final director = pelicula['director']?.toString() ?? 'No disponible';
    final genero = pelicula['genero']?.toString() ?? 'No disponible';
    final sinopsis = pelicula['sinopsis']?.toString() ?? '';
    final imagenUrl = pelicula['imagenUrl']?.toString() ?? '';

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        foregroundColor: textoClaro,
        title: const Text('Detalle de película'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 360,
                    width: 240,
                    child: imagenUrl.isNotEmpty
                        ? Image.network(
                            imagenUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return _posterDetallePredeterminado();
                            },
                          )
                        : _posterDetallePredeterminado(),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                titulo,
                style: const TextStyle(
                  color: textoClaro,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _datoDetalle('Año', anio),
              _datoDetalle('Director', director),
              _datoDetalle('Género', genero),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _guardando ? null : _guardarPelicula,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azul,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: _guardando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          widget.estaGuardada
                              ? Icons.bookmark_remove_outlined
                              : Icons.bookmark_add_outlined,
                        ),
                  label: Text(
                    _guardando
                        ? (widget.estaGuardada ? 'Quitando...' : 'Guardando...')
                        : (widget.estaGuardada
                            ? 'Quitar de mi lista'
                            : 'Guardar en mi lista'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Sinopsis',
                style: TextStyle(
                  color: textoClaro,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                sinopsis.isNotEmpty ? sinopsis : 'Sin sinopsis disponible.',
                style: const TextStyle(
                  color: textoSecundario,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _datoDetalle(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: textoSecundario, fontSize: 14),
          children: [
            TextSpan(
              text: '$etiqueta: ',
              style: const TextStyle(
                color: textoClaro,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: valor),
          ],
        ),
      ),
    );
  }

  Widget _posterDetallePredeterminado() {
    return Container(
      color: fondoTarjeta,
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          size: 65,
          color: Color(0xFFB9C8D5),
        ),
      ),
    );
  }
}



// Pantalla de búsqueda por título y género.
class BuscarPage extends StatefulWidget {
  final int? generoInicial;

  const BuscarPage({super.key, this.generoInicial});

  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  final PeliculasService _servicio = PeliculasService();
  final TextEditingController _controlador = TextEditingController();

  Future<List<dynamic>>? _resultados;
  int? _generoSeleccionado;

  static const Map<int, String> _generos = {
    28: 'Acción',
    12: 'Aventura',
    16: 'Animación',
    35: 'Comedia',
    878: 'Ciencia ficción',
    18: 'Drama',
    27: 'Terror',
    10749: 'Romance',
    53: 'Suspense',
  };

  @override
  void initState() {
    super.initState();
    _generoSeleccionado = widget.generoInicial;
    if (_generoSeleccionado != null) {
      _resultados =
          _servicio.obtenerPeliculasPorGenero(_generoSeleccionado!);
    }
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _buscar() {
    final consulta = _controlador.text.trim();
    if (consulta.isEmpty) {
      setState(() {
        _resultados = null;
        _generoSeleccionado = null;
      });
      return;
    }

    setState(() {
      _generoSeleccionado = null;
      _resultados = _servicio.buscarPeliculas(consulta);
    });
  }

  void _cargarPorGenero(int idGenero) {
    _controlador.clear();
    setState(() {
      _generoSeleccionado = idGenero;
      _resultados = _servicio.obtenerPeliculasPorGenero(idGenero);
    });
  }

  Future<void> _abrirDetalle(dynamic pelicula) async {
    final id = pelicula['id'];
    if (id is! num) return;

    try {
      final detalle = await _servicio.obtenerDetalle(id.toInt());
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PeliculaDetallePage(pelicula: detalle),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudieron cargar los detalles de la película.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nombreGenero = _generoSeleccionado == null
        ? null
        : _generos[_generoSeleccionado!];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buscar películas',
              style: TextStyle(
                color: textoClaro,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Encuentra películas por título o explora por género.',
              style: TextStyle(color: textoSecundario, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controlador,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _buscar(),
                    style: const TextStyle(color: textoClaro),
                    decoration: InputDecoration(
                      hintText: 'Escribe el título de una película',
                      hintStyle: const TextStyle(color: textoSecundario),
                      prefixIcon: const Icon(Icons.search, color: textoSecundario),
                      filled: true,
                      fillColor: fondoTarjeta,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _buscar,
                  icon: const Icon(Icons.search),
                  style: IconButton.styleFrom(backgroundColor: azul),
                  tooltip: 'Buscar',
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Explorar por género',
              style: TextStyle(
                color: textoClaro,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _generos.entries.map((entrada) {
                final seleccionado = _generoSeleccionado == entrada.key;
                return ChoiceChip(
                  label: Text(entrada.value),
                  selected: seleccionado,
                  onSelected: (_) => _cargarPorGenero(entrada.key),
                  selectedColor: azul,
                  backgroundColor: fondoTarjeta,
                  labelStyle: TextStyle(
                    color: seleccionado ? Colors.white : textoClaro,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            if (nombreGenero != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Resultados: $nombreGenero',
                  style: const TextStyle(
                    color: textoClaro,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Expanded(
              child: _resultados == null
                  ? const Center(
                      child: Text(
                        'Busca una película o selecciona un género.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textoSecundario),
                      ),
                    )
                  : FutureBuilder<List<dynamic>>(
                      future: _resultados,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              'No se pudieron cargar los resultados. Inténtalo de nuevo.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          );
                        }
                        final peliculas = snapshot.data ?? [];
                        if (peliculas.isEmpty) {
                          return const Center(
                            child: Text(
                              'No se encontraron películas.',
                              style: TextStyle(color: textoSecundario),
                            ),
                          );
                        }
                        return GridView.builder(
                          padding: const EdgeInsets.only(bottom: 12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.57,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: peliculas.length,
                          itemBuilder: (context, index) {
                            final pelicula = peliculas[index];
                            final titulo =
                                pelicula['title']?.toString() ?? 'Sin título';
                            final fecha =
                                pelicula['release_date']?.toString() ?? '';
                            final anio = fecha.length >= 4
                                ? fecha.substring(0, 4)
                                : 'Año no disponible';
                            final poster =
                                pelicula['poster_path']?.toString() ?? '';

                            return InkWell(
                              onTap: () => _abrirDetalle(pelicula),
                              borderRadius: BorderRadius.circular(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: poster.isNotEmpty
                                            ? Image.network(
                                                'https://image.tmdb.org/t/p/w500$poster',
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    _posterBusqueda(),
                                              )
                                            : _posterBusqueda(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    titulo,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: textoClaro,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    anio,
                                    style: const TextStyle(
                                      color: textoSecundario,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _posterBusqueda() {
    return Container(
      color: fondoTarjeta,
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: textoSecundario,
          size: 48,
        ),
      ),
    );
  }
}

// Pantalla con las películas guardadas por el usuario actual.
class MiListaPage extends StatelessWidget {
  const MiListaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final servicio = PeliculasGuardadasService();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mi lista',
              style: TextStyle(
                color: textoClaro,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tus películas guardadas',
              style: TextStyle(color: textoSecundario, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: servicio.obtenerPeliculasGuardadas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'No se pudo cargar tu lista: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    );
                  }

                  final peliculas = snapshot.data ?? [];
                  if (peliculas.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            size: 64,
                            color: textoSecundario,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Todavía no has guardado películas.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textoClaro,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Explora el catálogo y guarda tus favoritas.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: textoSecundario),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: peliculas.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final pelicula = peliculas[index];
                      final titulo =
                          pelicula['titulo']?.toString() ?? 'Sin título';
                      final fecha =
                          pelicula['fechaLanzamiento']?.toString() ?? '';
                      final anio = fecha.length >= 4
                          ? fecha.substring(0, 4)
                          : 'Año no disponible';
                      final posterPath =
                          pelicula['posterPath']?.toString() ?? '';
                      final imagenUrl =
                          pelicula['imagenUrl']?.toString() ?? '';
                      final origen = pelicula['origen']?.toString() ?? 'tmdb';
                      final peliculaId = pelicula['id']?.toString() ?? '';

                      return Card(
                        color: fondoTarjeta,
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox(
                              width: 60,
                              height: 88,
                              child: origen == 'catalogo' && imagenUrl.isNotEmpty
                                  ? Image.network(
                                      imagenUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          _posterListaPredeterminado(),
                                    )
                                  : posterPath.isNotEmpty
                                      ? Image.network(
                                          'https://image.tmdb.org/t/p/w185$posterPath',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              _posterListaPredeterminado(),
                                        )
                                      : _posterListaPredeterminado(),
                            ),
                          ),
                          title: Text(
                            titulo,
                            style: const TextStyle(
                              color: textoClaro,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            anio,
                            style: const TextStyle(color: textoSecundario),
                          ),
                          onTap: () {
                            if (origen == 'catalogo') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PeliculaCatalogoDetallePage(
                                    estaGuardada: true,
                                    idDocumentoGuardado: peliculaId,
                                    pelicula: {
                                      'id': pelicula['peliculaCatalogoId'],
                                      'titulo': titulo,
                                      'anio': fecha,
                                      'director': pelicula['director'] ?? '',
                                      'genero': pelicula['genero'] ?? '',
                                      'sinopsis': pelicula['sinopsis'] ?? '',
                                      'imagenUrl': imagenUrl,
                                    },
                                  ),
                                ),
                              );
                            } else {
                              final tmdbId = pelicula['tmdbId'];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PeliculaDetallePage(
                                    estaGuardada: true,
                                    idDocumentoGuardado: peliculaId,
                                    pelicula: {
                                      'id': tmdbId,
                                      'title': titulo,
                                      'release_date': fecha,
                                      'poster_path': posterPath,
                                      'overview': pelicula['sinopsis'] ?? '',
                                      'vote_average': pelicula['calificacion'],
                                      'director': pelicula['director'] ?? '',
                                      'genero': pelicula['genero'] ?? '',
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                          trailing: IconButton(
                            tooltip: 'Quitar de mi lista',
                            icon: const Icon(
                              Icons.delete_outline,
                              color: textoClaro,
                            ),
                            onPressed: peliculaId.isEmpty
                                ? null
                                : () async {
                                    final confirmar = await showDialog<bool>(
                                      context: context,
                                      builder: (dialogContext) => AlertDialog(
                                        backgroundColor: fondoTarjeta,
                                        title: const Text(
                                          'Quitar película',
                                          style: TextStyle(color: textoClaro),
                                        ),
                                        content: Text(
                                          '¿Quieres quitar "$titulo" de tu lista?',
                                          style: const TextStyle(
                                            color: textoClaro,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(dialogContext, false),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(dialogContext, true),
                                            child: const Text('Quitar'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmar != true) return;
                                    try {
                                      await servicio.eliminarPelicula(peliculaId);
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Película eliminada de tu lista.',
                                          ),
                                        ),
                                      );
                                    } catch (error) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'No se pudo quitar la película: $error',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _posterListaPredeterminado() {
    return Container(
      color: fondo,
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: textoSecundario,
          size: 30,
        ),
      ),
    );
  }
}
