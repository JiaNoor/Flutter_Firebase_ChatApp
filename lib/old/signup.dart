import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> register() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;
      final String username = usernameController.text;
      final String email = emailController.text;
      final String password = passwordController.text;
      try {
        final UserCredential user = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await db
            .collection("users")
            .doc(user.user?.uid)
            .set({"email": email, "username": username});
        print("User is registered");
      } catch (e) {
        print("error");
      }
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SafeArea(
            child: Column(
          children: [
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your username'),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your email'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your password'),
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      register();
                      Navigator.of(context).pushNamed("/login");
                    },
                    child: Text("Signup")))
          ],
        )),
      ),
    );
  }
}
