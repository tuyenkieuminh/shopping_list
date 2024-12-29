
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/service/firebase_service.dart';

class EditItemViewModel {
  final FirebaseService _firebaseService = FirebaseService();

  Future<String?> editItem(String _enteredName, int _enteredQuantity, Category _selectedCategory, String id) async {
    return await _firebaseService.updateItem(_enteredName, _enteredQuantity, _selectedCategory, id);
  }
}