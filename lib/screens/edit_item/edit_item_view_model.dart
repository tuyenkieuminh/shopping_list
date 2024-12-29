
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_list/models/category.dart';

class EditItemViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _fireauth = FirebaseAuth.instance;

  Future<void> editItem(String _enteredName, int _enteredQuantity, Category _selectedCategory, String id) async {
    final newItem = {
        'name': _enteredName,
        'quantity': _enteredQuantity,
        'category': _selectedCategory.name,
      };

      await _firestore
        .collection("user_shopping_list")
        .doc(_fireauth.currentUser!.uid)
        .collection("items")
        .doc(id)
        .update(newItem);
  }
}