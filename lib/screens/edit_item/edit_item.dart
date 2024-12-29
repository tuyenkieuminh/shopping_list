import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/edit_item/edit_item_view_model.dart';

final _firestore = FirebaseFirestore.instance;
final _fireauth = FirebaseAuth.instance;

class EditItem extends StatefulWidget {
  const EditItem({super.key,required this.groceryItem});

  final GroceryItem groceryItem;

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final EditItemViewModel _viewModel = EditItemViewModel();
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
      
      await _viewModel.editItem(_enteredName, _enteredQuantity, _selectedCategory, id);

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop();  
    }
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
                      onSaved: (newValue) {
                        _selectedCategory = newValue!;
                      },
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