import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _enteredEmail = '';
  var _enteredPassword = '';
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    final isValid = _formKey.currentState!.validate();

    if(!isValid) {
      return;
    }

    _formKey.currentState!.save();

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/shopping_list_logo.png',
            ),
            const SizedBox(
              height: 15,
            ),
            Card(
              child: Form(
                key: _formKey,
                  child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.contains('@') == false) {
                        return 'Please enter valid email.';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _enteredEmail = newValue!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.length < 6) {
                        return 'Password need to be at least 6 characters.';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _enteredPassword = newValue!;
                    },
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
