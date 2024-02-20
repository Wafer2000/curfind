// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> createAcount(String email, String password) async {
    try {
      UserCredential userCrdential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(userCrdential.user);
      return (userCrdential.user?.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak');
        return 'weak-password';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email');
        return 'email-already-in-use';
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final a = userCredential.user;
      if (a?.uid != null) {
        return a?.uid;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Error: El usuario no existe');
        return 'user-not-found';
      } else if (e.code == 'wrong-password') {
        print('Error: Contraseña Incorrecta');
        return 'wrong-password';
      }
    }
    return null;
  }
}
