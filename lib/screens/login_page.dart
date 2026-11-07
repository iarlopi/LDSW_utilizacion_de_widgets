
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'registro_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _cargando = false;
  bool _mostrarContrasena = false;

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      await _authService.iniciarSesion(
        correo: _correoController.text,
        contrasena: _contrasenaController.text,
      );
      if (!mounted) return;

      Navigator.of(context).popUntil((route) => route.isFirst);

    } on Exception catch (error) {
      if (!mounted) return;

      String mensaje = 'No se pudo iniciar sesión. Inténtalo nuevamente.';

      if (error.toString().contains('user-not-found') ||
          error.toString().contains('invalid-credential')) {
        mensaje = 'Correo o contraseña incorrectos.';
      } else if (error.toString().contains('wrong-password')) {
        mensaje = 'La contraseña es incorrecta.';
      } else if (error.toString().contains('invalid-email')) {
        mensaje = 'El correo electrónico no es válido.';
      } else if (error.toString().contains('too-many-requests')) {
        mensaje = 'Demasiados intentos. Inténtalo más tarde.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF263746),
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        backgroundColor: const Color(0xFF263746),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  size: 75,
                  color: Color(0xFF54B4FF),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Bienvenido a CineLista',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    labelStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Introduce tu correo electrónico.';
                    }
                    if (!RegExp(
                      r'^[^@]+@[^@]+\.[^@]+$',
                    ).hasMatch(valor.trim())) {
                      return 'Introduce un correo válido.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                TextFormField(
                  controller: _contrasenaController,
                  obscureText: !_mostrarContrasena,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _mostrarContrasena
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _mostrarContrasena = !_mostrarContrasena;
                        });
                      },
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Introduce tu contraseña.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                ElevatedButton(
                  onPressed: _cargando ? null : _iniciarSesion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0875C9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _cargando
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Iniciar sesión',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),

                const SizedBox(height: 18),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistroPage(),
                      ),
                    );
                  },
                  child: const Text(
                    '¿No tienes cuenta? Regístrate',
                    style: TextStyle(color: Color(0xFF54B4FF)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
