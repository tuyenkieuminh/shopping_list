import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GroceryListViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _fireauth = FirebaseAuth.instance;

  Stream<QuerySnapshot> get itemStream {
    return _firestore.collection("user_shopping_list")
        .doc(_fireauth.currentUser!.uid)
        .collection("items").snapshots();
  }

  Future<void> deleteItem(String id) async {
    await _firestore
        .collection("user_shopping_list")
        .doc(_fireauth.currentUser!.uid)
        .collection("items")
        .doc(id)
        .delete();
  }

  Future<void> updateItem(GroceryItem groceryItem) async {
    final updateData = {
      'name': groceryItem.name,
      'quantity': groceryItem.quantity,
      'category': groceryItem.category,
    };

    await _firestore
        .collection("user_shopping_list")
        .doc(_fireauth.currentUser!.uid)
        .collection("items")
        .doc(groceryItem.id)
        .update(updateData);
  }

  Future<void> signOut() async {
    await _fireauth.signOut();
  }

  Future<void> addItem(GroceryItem groceryItem) async {
    await _firestore
        .collection("user_shopping_list")
        .doc(_fireauth.currentUser!.uid)
        .collection("items")
        .add({
      'name': groceryItem.name,
      'quantity': groceryItem.quantity,
      'category': groceryItem.category,
    });
  }
}
