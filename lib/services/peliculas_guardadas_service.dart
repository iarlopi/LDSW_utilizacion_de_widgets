
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PeliculasGuardadasService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>>? get _coleccionUsuario {
    final usuario = _auth.currentUser;

    if (usuario == null) return null;

    return _firestore
        .collection('usuarios')
        .doc(usuario.uid)
        .collection('peliculas_guardadas');
  }

  // Guardar una película procedente de TMDB.
  Future<void> guardarPelicula({
    required int tmdbId,
    required String titulo,
    String? fechaLanzamiento,
    String? posterPath,
    String? sinopsis,
    double? calificacion,
    String? director,
    String? genero,
  }) async {
    final coleccion = _coleccionUsuario;

    if (coleccion == null) {
      throw Exception('Debes iniciar sesión para guardar películas.');
    }

    await coleccion.doc('tmdb_$tmdbId').set({
      'origen': 'tmdb',
      'tmdbId': tmdbId,
      'titulo': titulo,
      'fechaLanzamiento': fechaLanzamiento,
      'posterPath': posterPath,
      'imagenUrl': null,
      'sinopsis': sinopsis,
      'calificacion': calificacion,
      'director': director,
      'genero': genero,
      'guardadaEn': FieldValue.serverTimestamp(),
    });
  }

  // Guardar una película registrada en el catálogo CineLista.
  Future<void> guardarPeliculaCatalogo({
    required String peliculaId,
    required String titulo,
    required String anio,
    required String director,
    required String genero,
    required String sinopsis,
    required String imagenUrl,
  }) async {
    final coleccion = _coleccionUsuario;

    if (coleccion == null) {
      throw Exception('Debes iniciar sesión para guardar películas.');
    }

    await coleccion.doc('catalogo_$peliculaId').set({
      'origen': 'catalogo',
      'peliculaCatalogoId': peliculaId,
      'titulo': titulo,
      'fechaLanzamiento': anio,
      'director': director,
      'genero': genero,
      'sinopsis': sinopsis,
      'imagenUrl': imagenUrl,
      'posterPath': null,
      'guardadaEn': FieldValue.serverTimestamp(),
    });
  }

  // Obtener las películas guardadas por el usuario actual.
  Stream<List<Map<String, dynamic>>> obtenerPeliculasGuardadas() {
    final coleccion = _coleccionUsuario;

    if (coleccion == null) {
      return Stream.value([]);
    }

    return coleccion
        .orderBy('guardadaEn', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((documento) {
        return {
          'id': documento.id,
          ...documento.data(),
        };
      }).toList();
    });
  }

  // Eliminar una película de la lista personal.
  Future<void> eliminarPelicula(String peliculaId) async {
    final coleccion = _coleccionUsuario;

    if (coleccion == null) {
      throw Exception('Debes iniciar sesión para modificar tu lista.');
    }

    await coleccion.doc(peliculaId).delete();
  }
}
