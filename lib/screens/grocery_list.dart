import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/edit_item.dart';
import 'package:shopping_list/screens/new_item.dart';

final _firestore = FirebaseFirestore.instance;
final _fireauth = FirebaseAuth.instance;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  late Future<List<GroceryItem>> _loadedItems;
  String? _isError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadedItems = _loadItem();
  }

  Future<List<GroceryItem>> _loadItem() async {
    final data = await _firestore
        .collection("user_shopping_list")
        .doc(_fireauth.currentUser!.uid)
        .collection("items")
        .get();
    // final url = Uri.https(
    //     'flutter-prep-3c03b-default-rtdb.asia-southeast1.firebasedatabase.app',
    //     'shopping-list.json');

    // final response = await http.get(url);
    // if (response.body == 'null') {
    //   return [];
    // }

    // if (response.statusCode >= 400) {
    //   throw Exception('Fail to fetch data. Please try again later.');
    // }

    if (data.size == 0) {
      return [];
    }

    final List<GroceryItem> loadedItems = [];
    for (var item in data.docs) {
      var category = categories.entries
          .firstWhere((element) => item['category'] == element.value.name);
      loadedItems.add(
        GroceryItem(
          id: item.id,
          name: item['name'],
          quantity: item['quantity'],
          category: category.value,
        ),
      );
    }
    return loadedItems;
  }

  void _navigateToNewItemScreen() async {
    final newGroceryItem = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    setState(() {
      _loadedItems = _loadItem();
    });
  }

  void _deleteItem(GroceryItem newGroceryItem) async {
    await _firestore
        .collection("user_shopping_list")
        .doc(_fireauth.currentUser!.uid)
        .collection("items")
        .doc(newGroceryItem.id)
        .delete();

    setState(() {
      _loadedItems = _loadItem();
    });
  }

  void _editItem(GroceryItem groceryItem) async {
    final updateItem = {
      'name': groceryItem.name,
      'quantity': groceryItem.quantity,
      'category': groceryItem.category,
    };

    await _firestore
        .collection("user_shopping_list")
        .doc(_fireauth.currentUser!.uid)
        .collection("items")
        .doc(groceryItem.id)
        .update(updateItem);

    setState(() {
      _loadedItems = _loadItem();
    });
  }

  void _navigateToEditItemScreen(GroceryItem grocery_item) async {
    await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (ctx) => EditItem(
          groceryItem: grocery_item,
        ),
      ),
    );

    setState(() {
      _loadedItems = _loadItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Grocery'),
        actions: [
          IconButton(
            onPressed: () {
              _fireauth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _loadedItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text("You have no item yet"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Dismissible(
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deleteItem(snapshot.data![index]);
                  },
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.delete),
                        ],
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.square,
                      color: snapshot.data![index].category.color,
                    ),
                    title: Text(snapshot.data![index].name),
                    trailing: Text(snapshot.data![index].quantity.toString()),
                  ),
                ),
                onTap: () {
                  _navigateToEditItemScreen(snapshot.data![index]);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToNewItemScreen();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
