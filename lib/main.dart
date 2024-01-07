import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_app/pages/auth_screen.dart';
import 'package:flutter/material.dart';

var kColorSchame = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 198, 233, 245),
);

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
      theme: ThemeData().copyWith(colorScheme: kColorSchame),
      home: Center(
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const SplashScreen();
            }
            if (snapshot.hasData) {
              return const ChatScreen();
            }
            return const AuthScreen();
          },
        ),
      ),
    );
  }
}
