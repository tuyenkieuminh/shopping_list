import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/service/firebase_service.dart';

class NewItemViewModel {
  final FirebaseService _firebaseService = FirebaseService();

  Future<String?> saveItem(String name, int quantity, Category selectedCategory) async {
    return await _firebaseService.addItem(name, quantity, selectedCategory);
  }
}