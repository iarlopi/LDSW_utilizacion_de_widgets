
import 'package:flutter/material.dart';

void main() {
  runApp(const CineListaApp());
}

const Color fondo = Color(0xFF263746);
const Color fondoTarjeta = Color(0xFF536779);
const Color azul = Color(0xFF0875C9);
const Color textoClaro = Color(0xFFF2F5F8);
const Color textoSecundario = Color(0xFFB8C5D1);

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
      home: const CineListaPage(),
    );
  }
}

class CineListaPage extends StatelessWidget {
  const CineListaPage({super.key});

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
              // TEXT: nombre y descripción de la aplicación.
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

              // CONTAINER: caja de búsqueda.
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

              // STACK: superpone el icono y una etiqueta al póster.
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 170,
                    decoration: BoxDecoration(
                      color: fondoTarjeta,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
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

              const SizedBox(height: 12),

              // COLUMN: título y datos de la película.
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interstellar',
                    style: TextStyle(
                      color: textoClaro,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '2014 • Ciencia ficción • 169 min',
                    style: TextStyle(
                      color: textoSecundario,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // CONTAINER y TEXT: botón visual de detalle.
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: azul,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Ver detalle',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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

              // ROW: géneros distribuidos horizontalmente.
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

              // ROW: dos tarjetas de películas populares.
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PeliculaPopular(
                      titulo: 'Coco',
                      datos: '2017 • Animación',
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: PeliculaPopular(
                      titulo: 'Parásitos',
                      datos: '2019 • Thriller',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // Navegación inferior inspirada en el wireframe.
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF718394)),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: fondo,
          selectedItemColor: Color(0xFF54B4FF),
          unselectedItemColor: textoClaro,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: 0,
          items: [
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

  // Container y Text para cada etiqueta de género.
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

class PeliculaPopular extends StatelessWidget {
  final String titulo;
  final String datos;

  const PeliculaPopular({
    super.key,
    required this.titulo,
    required this.datos,
  });

  @override
  Widget build(BuildContext context) {
    // COLUMN: póster, título y datos.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // STACK: icono centrado sobre el fondo del póster.
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 105,
              decoration: BoxDecoration(
                color: fondoTarjeta,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const Positioned.fill(
              child: Center(
                child: Icon(
                  Icons.movie_creation_outlined,
                  size: 34,
                  color: Color(0xFFB9C8D5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          titulo,
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
}
