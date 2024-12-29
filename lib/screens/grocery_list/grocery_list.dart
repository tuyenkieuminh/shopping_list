import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/edit_item/edit_item.dart';
import 'package:shopping_list/screens/grocery_list/grocery_list_view_model.dart';
import 'package:shopping_list/screens/new_item/new_item.dart';

final _firestore = FirebaseFirestore.instance;
final _fireauth = FirebaseAuth.instance;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final GroceryListViewModel _viewModel = GroceryListViewModel();

  // Future<List<GroceryItem>> _loadItem() async {
  //   final data = await _firestore
  //       .collection("user_shopping_list")
  //       .doc(_fireauth.currentUser!.uid)
  //       .collection("items")
  //       .get();

  //   if (data.size == 0) {
  //     return [];
  //   }

  //   final List<GroceryItem> loadedItems = [];
  //   for (var item in data.docs) {
  //     var category = categories.entries
  //         .firstWhere((element) => item['category'] == element.value.name);
  //     loadedItems.add(
  //       GroceryItem(
  //         id: item.id,
  //         name: item['name'],
  //         quantity: item['quantity'],
  //         category: category.value,
  //       ),
  //     );
  //   }
  //   return loadedItems;
  // }

  void _navigateToNewItemScreen() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
  }

  void _deleteItem(String id) async {
    await _viewModel.deleteItem(id);
  }

  void _navigateToEditItemScreen(GroceryItem grocery_item) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditItem(
          groceryItem: grocery_item,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Grocery'),
        actions: [
          IconButton(
            onPressed: () {
              _viewModel.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _viewModel.itemStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

          if (snapshot.data!.size == 0) {
            return const Center(
              child: Text("You have no item yet"),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                final category = categories.entries
                  .firstWhere((element) => data['category'] == element.value.name);
                return GestureDetector(
                  child: Dismissible(
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteItem(document.id);
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
                        color: category.value.color,
                      ),
                      title: Text(data['name']),
                      trailing: Text(data['quantity'].toString()),
                    ),
                  ),
                  onTap: () {
                    _navigateToEditItemScreen(GroceryItem(id: document.id, name: data['name'], quantity: data['quantity'], category: category.value));
                  },
                );
              } 
            ).toList().cast(),
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
