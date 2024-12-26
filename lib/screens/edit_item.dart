import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class EditItem extends StatefulWidget {
  const EditItem({super.key,required this.groceryItem});

  final GroceryItem groceryItem;

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isSening = false;

  void _editItem(String id) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSening = true;
      });
      _formKey.currentState!.save();
      final url = Uri.https(
          'flutter-prep-3c03b-default-rtdb.asia-southeast1.firebasedatabase.app',
          'shopping-list/${id}.json');
      Response? response;
      response = await http.patch(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'name': _enteredName,
              'quantity': _enteredQuantity,
              'category': _selectedCategory.name,
            },
          ), // Encode the data as JSON
        );
      
      if (!context.mounted) {
          return;
        }
      _sendDataToMainScreen(id);
    }
  }

  void _sendDataToMainScreen(String id) {
    Navigator.of(context).pop(
      GroceryItem(
        id: id,
        name: _enteredName,
        quantity: _enteredQuantity,
        category: _selectedCategory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.groceryItem.name,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredName = newValue!;
                  print("fffffffffff ${_enteredName}");
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Quantity"),
                      ),
                      initialValue: widget.groceryItem.quantity.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be valid, positive number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: widget.groceryItem.category,
                      items: [
                        ...categories.entries.map(
                          (value) => DropdownMenuItem(
                            value: value.value,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.square,
                                  color: value.value.color,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(value.value.name),
                              ],
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSening
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: _isSening ? null :() {_editItem(widget.groceryItem.id);},
                    child: _isSening
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Edit Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}