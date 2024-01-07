import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLogin = true;
  final formKey = GlobalKey<FormState>();
  var enteredEmail = '';
  var enteredPassword = '';

  submit() {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      return;
    }

    formKey.currentState!.save();

    if (isLogin) {
      final userData = firebase.signInWithEmailAndPassword(
          email: enteredEmail, password: enteredPassword);
    } else {
      try {
        final userData = firebase.createUserWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);
      } on FirebaseAuthException catch (error) {
        if (error.code == 'email-already-in-use') {
          //.. (obsługa błędu)
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 100, bottom: 30),
                width: 200,
                child: Image.asset('assets/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        //
                        TextFormField(
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'please enter a valid email address.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            label: Text('Email address'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          onSaved: (newValue) => enteredEmail = newValue!,
                        ),
                        //
                        const SizedBox(height: 20),
                        //
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password must be at least 6 characters long.';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text('Password'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          obscureText: true,
                          onSaved: (newValue) => enteredPassword = newValue!,
                        ),
                        //
                        const SizedBox(height: 20),
                        //
                        ElevatedButton(
                          onPressed: submit,
                          child: Text(isLogin ? 'Login' : 'Signup'),
                        ),
                        //
                        const SizedBox(height: 20),
                        //
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(isLogin
                              ? 'Create an account'
                              : 'I have an acount'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ], //
          ), //
        ), //
      ),
    );
  }
}
