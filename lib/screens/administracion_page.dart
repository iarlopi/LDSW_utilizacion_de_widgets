
import 'package:flutter/material.dart';
import '../services/peliculas_catalogo_service.dart';
import '../services/auth_service.dart';

const Color fondoAdmin = Color(0xFF263746);
const Color tarjetaAdmin = Color(0xFF536779);
const Color azulAdmin = Color(0xFF0875C9);
const Color textoAdmin = Color(0xFFF2F5F8);
const Color textoSecundarioAdmin = Color(0xFFB8C5D1);

class AdministracionPage extends StatefulWidget {
  const AdministracionPage({super.key});

  @override
  State<AdministracionPage> createState() => _AdministracionPageState();
}

class _AdministracionPageState extends State<AdministracionPage> {
  final PeliculasCatalogoService _servicio =
      PeliculasCatalogoService();

  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _anioController = TextEditingController();
  final _directorController = TextEditingController();
  final _generoController = TextEditingController();
  final _sinopsisController = TextEditingController();
  final _imagenUrlController = TextEditingController();

  bool _guardando = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _anioController.dispose();
    _directorController.dispose();
    _generoController.dispose();
    _sinopsisController.dispose();
    _imagenUrlController.dispose();
    super.dispose();
  }

  // Registrar una película en Firestore.
  Future<void> _agregarPelicula() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      await _servicio.agregarPelicula(
        titulo: _tituloController.text,
        anio: int.parse(_anioController.text),
        director: _directorController.text,
        genero: _generoController.text,
        sinopsis: _sinopsisController.text,
        imagenUrl: _imagenUrlController.text,
      );

      if (!mounted) return;

      _formKey.currentState!.reset();

      _tituloController.clear();
      _anioController.clear();
      _directorController.clear();
      _generoController.clear();
      _sinopsisController.clear();
      _imagenUrlController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Película agregada correctamente.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo agregar la película: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  // Eliminar una película después de confirmar la operación.
  Future<void> _eliminarPelicula(
    String id,
    String titulo,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: tarjetaAdmin,
          title: const Text(
            'Eliminar película',
            style: TextStyle(color: textoAdmin),
          ),
          content: Text(
            '¿Deseas eliminar "$titulo" del catálogo?',
            style: const TextStyle(color: textoSecundarioAdmin),
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
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    try {
      await _servicio.eliminarPelicula(id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Película eliminada del catálogo.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo eliminar la película: $error'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // Campo de texto reutilizable para el formulario.
  Widget _campoTexto({
    required String etiqueta,
    required TextEditingController controller,
    required String mensaje,
    int maxLineas = 1,
    TextInputType tipo = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLineas,
        keyboardType: tipo,
        style: const TextStyle(color: textoAdmin),
        decoration: InputDecoration(
          labelText: etiqueta,
          labelStyle: const TextStyle(
            color: textoSecundarioAdmin,
          ),
          filled: true,
          fillColor: tarjetaAdmin,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              color: textoSecundarioAdmin,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              color: Color(0xFF54B4FF),
              width: 2,
            ),
          ),
        ),
        validator: (valor) {
          if (valor == null || valor.trim().isEmpty) {
            return mensaje;
          }
          return null;
        },
      ),
    );
  }

  // Mostrar las películas registradas en Firestore.
  Widget _listaPeliculas() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _servicio.obtenerPeliculasCatalogo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Text(
            'No se pudieron cargar las películas: ${snapshot.error}',
            style: const TextStyle(color: Colors.redAccent),
          );
        }

        final peliculas = snapshot.data ?? [];

        if (peliculas.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Todavía no hay películas registradas.',
              style: TextStyle(color: textoSecundarioAdmin),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Column(
          children: peliculas.map((pelicula) {
            final id = pelicula['id']?.toString() ?? '';
            final titulo =
                pelicula['titulo']?.toString() ?? 'Sin título';
            final anio = pelicula['anio']?.toString() ?? '';

            return Card(
              color: tarjetaAdmin,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    width: 48,
                    height: 68,
                    child: Image.network(
                      pelicula['imagenUrl']?.toString() ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.movie_outlined,
                          color: textoSecundarioAdmin,
                        );
                      },
                    ),
                  ),
                ),
                title: Text(
                  titulo,
                  style: const TextStyle(
                    color: textoAdmin,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  anio,
                  style: const TextStyle(
                    color: textoSecundarioAdmin,
                  ),
                ),
                trailing: IconButton(
                  tooltip: 'Eliminar película',
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () =>
                      _eliminarPelicula(id, titulo),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Verificar que el usuario tenga permisos de administrador.
    if (!AuthService().esAdministrador) {
      return Scaffold(
        backgroundColor: fondoAdmin,
        appBar: AppBar(
          backgroundColor: fondoAdmin,
          foregroundColor: textoAdmin,
          title: const Text('Acceso restringido'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'No tienes permisos para acceder a esta sección.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textoAdmin,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: fondoAdmin,
      appBar: AppBar(
        backgroundColor: fondoAdmin,
        foregroundColor: textoAdmin,
        title: const Text('Administración'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Registrar película',
                style: TextStyle(
                  color: textoAdmin,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Completa los datos para agregar una película al catálogo.',
                style: TextStyle(
                  color: textoSecundarioAdmin,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _campoTexto(
                      etiqueta: 'Título',
                      controller: _tituloController,
                      mensaje: 'Introduce el título.',
                    ),
                    _campoTexto(
                      etiqueta: 'Año de estreno',
                      controller: _anioController,
                      mensaje: 'Introduce el año.',
                      tipo: TextInputType.number,
                    ),
                    _campoTexto(
                      etiqueta: 'Director',
                      controller: _directorController,
                      mensaje: 'Introduce el director.',
                    ),
                    _campoTexto(
                      etiqueta: 'Género cinematográfico',
                      controller: _generoController,
                      mensaje: 'Introduce el género.',
                    ),
                    _campoTexto(
                      etiqueta: 'Sinopsis',
                      controller: _sinopsisController,
                      mensaje: 'Introduce la sinopsis.',
                      maxLineas: 4,
                    ),
                    _campoTexto(
                      etiqueta: 'URL de la imagen',
                      controller: _imagenUrlController,
                      mensaje: 'Introduce la URL de la imagen.',
                      tipo: TextInputType.url,
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            _guardando ? null : _agregarPelicula,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azulAdmin,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
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
                            : const Icon(Icons.add),
                        label: Text(
                          _guardando
                              ? 'Guardando...'
                              : 'Agregar película',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Divider(color: textoSecundarioAdmin),
              const SizedBox(height: 18),
              const Text(
                'Películas registradas',
                style: TextStyle(
                  color: textoAdmin,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              _listaPeliculas(),
            ],
          ),
        ),
      ),
    );
  }
}
