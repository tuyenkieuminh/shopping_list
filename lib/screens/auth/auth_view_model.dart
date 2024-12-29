import 'package:shopping_list/service/firebase_service.dart';

class AuthViewModel {
  final FirebaseService _firebaseService = FirebaseService();

  Future<String?> login(String email, String password) async {
    return await _firebaseService.login(email, password);
  }

  Future<String?> register(String email, String password) async {
    return await _firebaseService.register(email, password);
  }
}
