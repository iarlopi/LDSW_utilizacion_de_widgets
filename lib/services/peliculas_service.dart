import 'dart:convert';
import 'package:http/http.dart' as http;

class PeliculasService {
  // Dirección del backend PHP
  static const String url =
      'http://localhost/cinelista_api/';

  // Obtener películas populares desde PHP
  Future<List<dynamic>> obtenerPeliculas() async {
    final respuesta = await http.get(Uri.parse(url));

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);

      return datos['results'];
    } else {
      throw Exception('Error al obtener las películas');
    }
  }

  // Obtener los detalles de la película destacada: Interstellar
  Future<Map<String, dynamic>> obtenerDestacada() async {
    final respuesta = await http.get(
      Uri.parse('$url?tipo=destacada'),
    );

    if (respuesta.statusCode == 200) {
      return jsonDecode(respuesta.body);
    } else {
      throw Exception('Error al obtener la película destacada');
    }
  }
}