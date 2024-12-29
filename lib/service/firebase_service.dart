import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_list/models/category.dart';

class FirebaseService {
  FirebaseService._privateConstructor();
  static final _instance = FirebaseService._privateConstructor();

  factory FirebaseService(){
    return _instance;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _fireauth = FirebaseAuth.instance;

  Stream<QuerySnapshot> get itemStream {
    return _firestore.collection("user_shopping_list")
        .doc(_fireauth.currentUser!.uid)
        .collection("items").snapshots();
  }

  Future<String?> deleteItem(String id) async {
    try {
      await _firestore
        .collection("user_shopping_list")
        .doc(_fireauth.currentUser!.uid)
        .collection("items")
        .doc(id)
        .delete();
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
    return null;
  }

  Future<String?> updateItem(String _enteredName, int _enteredQuantity, Category _selectedCategory, String id) async {
    final updateData = {
      'name': _enteredName,
      'quantity': _enteredQuantity,
      'category': _selectedCategory.name,
    };

    try {
      await _firestore
        .collection("user_shopping_list")
        .doc(_fireauth.currentUser!.uid)
        .collection("items")
        .doc(id)
        .update(updateData);
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
    return null;
  }

  Future<String?> signOut() async {
    try {
      await _fireauth.signOut();
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
    return null;
  }

  Future<String?> addItem(String _enteredName, int _enteredQuantity, Category _selectedCategory) async {
    final newItem = {
      'name': _enteredName,
      'quantity': _enteredQuantity,
      'category': _selectedCategory.name,
    };
    
    try {
      await _firestore
        .collection("user_shopping_list")
        .doc(_fireauth.currentUser!.uid)
        .collection("items")
        .add(newItem);
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
    return null;
  }

  Future<String?> login(String email, String password) async {
    try {
      await _fireauth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
    return null;
  }

  Future<String?> register(String email, String password) async {
    try {
      await _fireauth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
    return null;
  }
}