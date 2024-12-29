import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_list/models/category.dart';

class NewItemViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _fireauth = FirebaseAuth.instance;

  Future<void> saveItem(String name, int quantity, Category selectedCategory) async {
    final newItem = {
      'name': name,
      'quantity': quantity,
      'category': selectedCategory.name,
    };

    await _firestore
        .collection("user_shopping_list")
        .doc(_fireauth.currentUser!.uid)
        .collection("items")
        .add(newItem);
  }
}