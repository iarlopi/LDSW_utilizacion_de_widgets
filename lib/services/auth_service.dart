import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener el usuario que tiene la sesión activa.
  User? get usuarioActual => _auth.currentUser;

  // Escuchar los cambios en el estado de autenticación.
  Stream<User?> get cambiosAutenticacion =>
      _auth.authStateChanges();

  // Registrar un usuario nuevo.
  Future<UserCredential> registrarUsuario({
    required String correo,
    required String contrasena,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: correo.trim(),
      password: contrasena,
    );
  }

  // Iniciar sesión.
  Future<UserCredential> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: correo.trim(),
      password: contrasena,
    );
  }

  // Cerrar sesión.
  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }
}