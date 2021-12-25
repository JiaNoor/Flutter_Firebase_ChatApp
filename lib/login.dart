import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> login() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;
      final String email = emailController.text;
      final String password = passwordController.text;
      try {
        final UserCredential user = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        final DocumentSnapshot snapshot =
            await db.collection("users").doc(user.user?.uid).get();
        final data = snapshot.data() as Map;
        print("User is logged in");
        print(data["username"]);
        print(data["email"]);
      } catch (e) {
        print("error");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(content: Text("$e"));
            });
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Container(
              child: CircleAvatar(
                radius: 60.0,
                backgroundColor: Colors.black,
                // backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ),
          ),
          Center(
            child: SizedBox(
                height: 80,
                width: 350,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Email'),
                    ),
                  ),
                )),
          ),
          Center(
            child: SizedBox(
                height: 80,
                width: 350,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Password'),
                    ),
                  ),
                )),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/register");
              },
              child: Text(
                "Don't have an account, register",
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              )),
          Center(
            child: SizedBox(
              height: 5,
            ),
          ),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    login();
                    Navigator.of(context).pushNamed("/posts");
                  },
                  child: Text("Login"))),
        ],
      ),
    );
  }
}
