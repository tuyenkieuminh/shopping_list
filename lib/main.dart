import 'package:flutter/material.dart';
import 'package:shopping_list/themes/dark_theme.dart';
import 'package:shopping_list/screens/grocery_list.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: const GroceryList(),
    );
  }
}
