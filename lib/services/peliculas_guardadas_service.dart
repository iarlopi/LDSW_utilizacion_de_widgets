
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PeliculasGuardadasService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> guardarPelicula({
    required int tmdbId,
    required String titulo,
    String? fechaLanzamiento,
    String? posterPath,
    String? sinopsis,
    double? calificacion,
  }) async {
    final usuario = _auth.currentUser;

    if (usuario == null) {
      throw Exception('Debes iniciar sesión para guardar películas.');
    }

    await _firestore
        .collection('usuarios')
        .doc(usuario.uid)
        .collection('peliculas_guardadas')
        .doc(tmdbId.toString())
        .set({
      'tmdbId': tmdbId,
      'titulo': titulo,
      'fechaLanzamiento': fechaLanzamiento,
      'posterPath': posterPath,
      'sinopsis': sinopsis,
      'calificacion': calificacion,
      'guardadaEn': FieldValue.serverTimestamp(),
    });
  }
}
