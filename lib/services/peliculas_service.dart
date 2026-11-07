
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PeliculasService {
  // Dirección del backend según la plataforma.
  static String get url {
    if (kIsWeb) {
      return 'http://localhost/cinelista_api/';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2/cinelista_api/';
    }

    return 'http://localhost/cinelista_api/';
  }

  // Obtener películas populares desde PHP.
  Future<List<dynamic>> obtenerPeliculas() async {
    final respuesta = await http.get(Uri.parse(url));

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);
      return datos['results'];
    } else {
      throw Exception('Error al obtener las películas');
    }
  }

  // Obtener la película destacada: Interstellar.
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

  // Obtener los detalles de una película mediante su ID.
  Future<Map<String, dynamic>> obtenerDetalle(int id) async {
    final respuesta = await http.get(
      Uri.parse('$url?tipo=detalle&id=$id'),
    );

    if (respuesta.statusCode == 200) {
      return jsonDecode(respuesta.body);
    } else {
      throw Exception('Error al obtener los detalles de la película');
    }
  }
}
