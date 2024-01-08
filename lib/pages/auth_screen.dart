import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firebase = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;

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
  File? selectedImage;
  var isAuthenticating = false;
  var enteredUsername = '';

  submit() async {
    final isValid = formKey.currentState!.validate();

    if (!isValid || !isLogin && selectedImage == null) {
      // error message ...
      return;
    }

    formKey.currentState!.save();

    try {
      setState(() {
        isAuthenticating = true;
      });

      if (isLogin) {
        final userData = await firebase.signInWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);
      } else {
        final userData = await firebase.createUserWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userData.user!.uid}.jpg');
        await storageRef.putFile(selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        print(imageUrl);

        await db.collection('users').doc(userData.user!.uid).set({
          'username': enteredUsername,
          'email': enteredEmail,
          'image_url': imageUrl,
        });
      }

//
//
//
//
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40, bottom: 10),
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
                        if (!isLogin)
                          UserImagePicker(
                            onPickImage: (pickedImage) {
                              selectedImage = pickedImage;
                            },
                          ),
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
                        const SizedBox(height: 20),
                        if(!isLogin)
                        TextFormField(
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length < 4) {
                              return 'please enter at least 4 characters.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            label: Text('Username'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          onSaved: (newValue) => enteredUsername = newValue!,
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
                        if (isAuthenticating) const CircularProgressIndicator(),
                        //
                        if (!isAuthenticating)
                          ElevatedButton(
                            onPressed: submit,
                            child: Text(isLogin ? 'Login' : 'Signup'),
                          ),
                        //
                        const SizedBox(height: 20),
                        //
                        if (!isAuthenticating)
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
