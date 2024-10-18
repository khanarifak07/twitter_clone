import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/home_page.dart';
import 'package:twitter_clone/services/auth/auth_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Add debug print statements to see what happens during navigation
          log("AuthGate: connectionState = ${snapshot.connectionState}");
          log("AuthGate: hasData = ${snapshot.hasData}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.data != null) {
            return const HomePage();
          } else {
            return const Login();
          }
        });
  }
}
