import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/firebase_options.dart';
import 'package:shopping_list/screens/auth.dart';
import 'package:shopping_list/screens/splash.dart';
import 'package:shopping_list/themes/dark_theme.dart';
import 'package:shopping_list/screens/grocery_list.dart';

final _fireauth = FirebaseAuth.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: StreamBuilder(stream: _fireauth.authStateChanges(), builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreeen();
        }
        
        if(snapshot.data == null) {
          return const AuthScreen();
        }

        return const GroceryList();
      }),
    );
  }
}
