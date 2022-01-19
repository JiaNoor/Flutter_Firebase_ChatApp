import 'package:firebase_proj/new/functions.dart';
import 'package:firebase_proj/new/signup.dart';
import 'package:firebase_proj/new/home.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_4.gif"),
            fit: BoxFit.fill,
          ),
        ),
        child: isLoading
            ? Center(
                child: Container(
                  height: size.height / 20,
                  width: size.height / 20,
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: size.width / 0.5,
                      child: IconButton(
                          icon: Icon(Icons.arrow_back_ios), onPressed: () {}),
                    ),
                    SizedBox(
                      height: size.height / 50,
                    ),
                    Container(
                      width: size.width / 1.1,
                      child: Text(
                        "Welcome to MyApp",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.lime[800],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 25,
                    ),
                    Container(
                      color: Colors.red[200],
                      width: size.width / 1.1,
                      child: Text(
                        " Sign In to Contiue!",
                        style: TextStyle(
                          color: Color.fromARGB(255, 83, 1, 77),
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Akronim',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 15,
                    ),
                    Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child:
                          field(size, "email", Icons.account_box, false, email),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child:
                            field(size, "password", Icons.lock, true, password),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 10,
                    ),
                    customButton(size),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => Register()));
                      },
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                            color: Colors.pink[900],
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (email.text.isNotEmpty && password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          logIn(email.text, password.text).then((user) {
            if (user != null) {
              print("Login Sucessfull");
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
            } else {
              print("Login Failed");
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          print("Please fill form correctly");
        }
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.purple[800],
          ),
          alignment: Alignment.center,
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  Widget field(Size size, String hintText, IconData icon, bool obscureText,
      TextEditingController cont) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.purple,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
