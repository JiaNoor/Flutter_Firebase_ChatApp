import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_proj/chat-register.dart';
import 'package:firebase_proj/chats.dart';
import 'package:firebase_proj/login.dart';
import 'package:firebase_proj/posts.dart';
import 'package:firebase_proj/signup.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initiallization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initiallization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(home: HomeScreen(), routes: {
              "/login": (context) => Login(),
              "/register": (context) => Register(),
              "/posts": (context) => Post(),
            });
          }
          return Container();
        });
  }
}
