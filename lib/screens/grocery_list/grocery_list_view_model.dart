import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/service/firebase_service.dart';

class GroceryListViewModel {
  final FirebaseService _firebaseService = FirebaseService();

  Stream<QuerySnapshot> get itemStream {
    return _firebaseService.itemStream;
  }

  Future<String?> deleteItem(String id) async {
    return await _firebaseService.deleteItem(id);
  }

  Future<String?> signOut() async {
    return await _firebaseService.signOut();
  }
}
