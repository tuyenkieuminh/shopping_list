import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> authenticate({
    required String email,
    required String password,
    required bool isLogin,
  }) async {
    try {
      if (isLogin) {
        return await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        return await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }
}
