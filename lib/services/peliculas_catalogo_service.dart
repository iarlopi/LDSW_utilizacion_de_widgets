
import 'package:cloud_firestore/cloud_firestore.dart';

class PeliculasCatalogoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Referencia a la colección del catálogo.
  CollectionReference<Map<String, dynamic>> get _coleccion =>
      _firestore.collection('peliculas_catalogo');

  // Obtener todas las películas del catálogo.
  Stream<List<Map<String, dynamic>>> obtenerPeliculasCatalogo() {
    return _coleccion
        .orderBy('fechaCreacion', descending: true)
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

  // Registrar una nueva película.
  Future<void> agregarPelicula({
    required String titulo,
    required int anio,
    required String director,
    required String genero,
    required String sinopsis,
    required String imagenUrl,
  }) async {
    await _coleccion.add({
      'titulo': titulo.trim(),
      'anio': anio,
      'director': director.trim(),
      'genero': genero.trim(),
      'sinopsis': sinopsis.trim(),
      'imagenUrl': imagenUrl.trim(),
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }

  // Eliminar una película del catálogo.
  Future<void> eliminarPelicula(String id) async {
    await _coleccion.doc(id).delete();
  }
}
