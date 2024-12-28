import 'package:flutter/material.dart';

class SplashScreeen extends StatelessWidget {
  const SplashScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/shopping_list_logo.png'),
      ),
    );
  }
}