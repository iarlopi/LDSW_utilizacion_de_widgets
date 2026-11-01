
import 'package:flutter/material.dart';
import 'services/peliculas_service.dart';

void main() {
  runApp(const CineListaApp());
}

const Color fondo = Color(0xFF263746);
const Color fondoTarjeta = Color(0xFF536779);
const Color azul = Color(0xFF0875C9);
const Color textoClaro = Color(0xFFF2F5F8);
const Color textoSecundario = Color(0xFFB8C5D1);

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
                      'Hello World',
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CineListaPage(),
                          ),
                        );
                      },
                      child: const Text('Entrar al catálogo'),
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
      home: const WelcomeScreen(),
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

  late Future<List<dynamic>> _peliculas;
  late Future<Map<String, dynamic>> _destacada;

  @override
  void initState() {
    super.initState();
    _peliculas = _servicioPeliculas.obtenerPeliculas();
    _destacada = _servicioPeliculas.obtenerDestacada();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre y descripción de la aplicación.
              const Text(
                'CineLista',
                style: TextStyle(
                  color: textoClaro,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
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

              // Caja de búsqueda.
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
              SizedBox(
                width: double.infinity,
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

              // Géneros distribuidos horizontalmente.
              Row(
                children: [
                  _genero('Sci-Fi'),
                  const Spacer(),
                  _genero('Terror'),
                  const Spacer(),
                  _genero('Thriller'),
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
          currentIndex: 0,
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

  // Etiquetas de género.
  static Widget _genero(String nombre) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE7EDF2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        nombre,
        style: const TextStyle(
          color: Color(0xFF263746),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Tarjeta de película popular.
class PeliculaPopular extends StatelessWidget {
  final String titulo;
  final String datos;
  final String? posterPath;

  const PeliculaPopular({
    super.key,
    required this.titulo,
    required this.datos,
    this.posterPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
class PeliculaDetallePage extends StatelessWidget {
  final Map<String, dynamic> pelicula;

  const PeliculaDetallePage({
    super.key,
    required this.pelicula,
  });

  @override
  Widget build(BuildContext context) {
    final titulo = pelicula['title']?.toString() ?? 'Sin título';
    final fecha = pelicula['release_date']?.toString() ?? '';
    final anio = fecha.length >= 4 ? fecha.substring(0, 4) : 'No disponible';
    final duracion = pelicula['runtime']?.toString() ?? '';
    final sinopsis = pelicula['overview']?.toString() ?? '';
    final calificacion = pelicula['vote_average'] is num
        ? (pelicula['vote_average'] as num).toStringAsFixed(1)
        : 'No disponible';

    final generos = (pelicula['genres'] as List<dynamic>?)
            ?.map((genero) => genero['name'].toString())
            .join(' • ') ??
        'No disponibles';

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
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFFFC857), size: 21),
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
