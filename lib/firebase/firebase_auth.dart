// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createAcount(String email, String password) async {
    try {
      UserCredential userCrdential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print(userCrdential.user);
      return (userCrdential.user?.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak');
        return 1;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email');
        return 2;
      }
    } catch (e) {
      print(e);
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
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
        return 1;
      } else if (e.code == 'wrong-password') {
        print('Error: Contraseña Incorrecta');
        return 2;
      }
    }
  }
}
