import 'dart:io';
//import 'dart:js';
import 'package:path/path.dart' as paths;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'login.dart';

class RegisterChat extends StatefulWidget {
  const RegisterChat({Key? key}) : super(key: key);

  @override
  _RegisterChatState createState() => _RegisterChatState();
}

class _RegisterChatState extends State<RegisterChat> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var imagePath;

  bool cir = false;
  CollectionReference userStream =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    Future<void> selectImage() async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.pickImage(source: ImageSource.gallery);

      // imagePath = image!.path;
      setState(() {
        imagePath = image?.path;
        print('imagepath $imagePath');
      });
    }

    Future<void> register() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;
      final String username = usernameController.text;
      final String email = emailController.text;
      final String password = passwordController.text;

      try {
        final UserCredential user = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        firebase_storage.FirebaseStorage storage =
            firebase_storage.FirebaseStorage.instance;

        String imageName = paths.basename(imagePath);

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('Users/$imageName');

        File file = File(imagePath);
        await ref.putFile(file);
        String downloadURL = await ref.getDownloadURL();
        print("file is uploaded successfully");

        await db
            .collection("users")
            .add({"email": email, "username": username, "url": downloadURL});
        setState(() {
          cir = true;
        });
        print("User is registered");
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: userStream.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.teal,
              ));
            }
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color(0xff1d1e26),
                  Color(0xff252041),
                ])),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign Up",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(
                        height: 15,
                      ),
                      TextButton(
                          onPressed: () {
                            selectImage();
                          },
                          child: Text("Select Your Profile Picture")),
                      SizedBox(height: 15),
                      textitem("Email", emailController, false, context),
                      SizedBox(height: 15),
                      textitem("Username", usernameController, false, context),
                      SizedBox(height: 15),
                      textitem("Password", passwordController, true, context),
                      SizedBox(height: 15),
                      InkWell(
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white),
                          child: Center(
                            child: cir
                                ? CircularProgressIndicator()
                                : Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        onTap: () {
                          register();
                          Navigator.of(context).pushNamed("/login");
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Or",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        height: 40,
                        width: MediaQuery.of(context).size.width - 70,
                        child: Card(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Connect With Google",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          "If you already have an Account? Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
              ),
            );
          }),
    );
  }
}

Widget textitem(String labeltext, TextEditingController controller,
    bool obscureText, context) {
  return Container(
    height: 55,
    width: MediaQuery.of(context).size.width - 70,
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: labeltext,
        labelStyle: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1.5,
            color: Colors.blue,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
      ),
    ),
  );
}

// Widget regbutton(bool circular, context) {
//   return InkWell(
//     child: Container(
//       height: 50,
//       width: MediaQuery.of(context).size.width - 200,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30), color: Colors.white),
//       child: Center(
//         child: circular
//             ? CircularProgressIndicator()
//             : Text(
//                 "Sign Up",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//       ),
//     ),
//     onTap: () {
//       register();
//     },
//   );
// }
