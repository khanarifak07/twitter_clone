import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/services/database/database_service.dart';
import 'package:twitter_clone/Utilities/utilities.dart';

class AuthProviders extends ChangeNotifier {
  //
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  //Firebase Auth Exceptions
  String handleFirebaseAuthExceptions(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'invalid-credential':
        return 'Invalid credentials';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'email-already-in-use':
        return 'The email is already in use by another account.';
      case 'weak-password':
        return 'The password provided is too weak';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  //check for empty fields
  bool areFieldsEmpty() {
    return nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passCtrl.text.isEmpty ||
        confirmPassCtrl.text.isEmpty;
  }

  //Check for confirm password
  bool checkPassword() {
    if (passCtrl.text == confirmPassCtrl.text) {
      return true;
    } else {
      return false;
    }
  }

  //clear controllers
  void clearControllers() {
    nameCtrl.clear();
    emailCtrl.clear();
    passCtrl.clear();
    confirmPassCtrl.clear();
  }

  //set loading
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  //Login
  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
        Utilities.showSnackBar(context, 'Please enter email and password',
            seconds: 1);
      } else {
        setLoading(true);
        //
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        //
        if (context.mounted) {
          Utilities.showSnackBar(context, 'Successfully Logged In');
        }
        // Clear the controllers
        clearControllers();
      }
    } on FirebaseAuthException catch (e) {
      // Log the error code to see what is actually being returned
      log("FirebaseAuthException code: ${e.code}");
      if (context.mounted) {
        Utilities.showSnackBar(context, handleFirebaseAuthExceptions(e));
      }
    } finally {
      setLoading(false);
    }
  }

  //Register
  Future<void> registerUser(String name, String email, String password,
      String confirmPassword, BuildContext context) async {
    try {
      if (areFieldsEmpty()) {
        Utilities.showSnackBar(context, 'Please fill the details to register');
      } else {
        if (checkPassword()) {
          //
          setLoading(true);
          //
          await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          //
          if (context.mounted) {
            Utilities.showSnackBar(context, 'User registered successfully');
          }
          //save user data to firebase
          DatabaseService.saveUserInfoInFirebase(email: email, name: name);
          //
          clearControllers();
        } else {
          Utilities.showSnackBar(context, 'Password Mismatch');
        }
      }
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth Exceptions : ${e.code}');
      if (context.mounted) {
        Utilities.showSnackBar(context, handleFirebaseAuthExceptions(e));
      }
    } finally {
      setLoading(false);
    }
  }

  //Logout
  Future<void> logout() async {
    try {
      //
      setLoading(true);
      //
      Future.delayed(const Duration(seconds: 2), () async {
        await _auth.signOut();
        //
        setLoading(false);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  //
  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }
}
