import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_proj/new/home.dart';
import 'package:firebase_proj/new/login.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser != null) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
