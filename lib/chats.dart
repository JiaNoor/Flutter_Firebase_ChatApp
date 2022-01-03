import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference userStream =
      FirebaseFirestore.instance.collection('users');
  final TextEditingController usernameController = TextEditingController();
  var temp = [];
  var len = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20.0, bottom: 20.0),
            child: Text(
              'ChatApp',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff1d1e26),
                Color.fromARGB(255, 74, 66, 119)
              ]),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 20.0,
                  spreadRadius: 1.0,
                )
              ]),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
      ),
      body: Column(children: [
        TextField(
            controller: usernameController,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        usernameController.toString();
                        temp.add(usernameController);
                        len = temp.length;
                        print(temp.length);
                      });
                    }),
                border: OutlineInputBorder(
                    borderSide: BorderSide(style: BorderStyle.solid)),
                hintText: 'Search by Username')),
        Expanded(
          child: Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: userStream.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    return ListView.builder(
                      itemCount: temp.length,
                      itemBuilder: (context, index) {
                        return ListBody(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map data = document.data()! as Map;
                            String id = document.id;
                            data["id"] = id;
                            return chats(data);
                          }).toList(),
                        );
                      },
                    );
                  })),
        )
      ]),
    );
  }
}

Widget chats(var data) {
  return ListTile(
    leading: CircleAvatar(
      radius: 20.0,
      backgroundColor: Colors.transparent,
      backgroundImage: NetworkImage(
        data['url'],
      ),
    ),
    title: Text(data['username']),
    subtitle: Row(
      children: [
        Icon(
          Icons.check,
        ),
        Text('msg'),
      ],
    ),
    trailing: Text(
      "12:00",
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 10,
      ),
    ),
  );
}
// ListView(
//                   children:
//                       snapshot.data!.docs.map((DocumentSnapshot document) {
//                     Map data = document.data()! as Map;
//                     String id = document.id;
//                     data["id"] = id;
//                     return chats(data);
//                   }).toList(),
//                 );
// FirebaseFirestore.instance
//   .collection('countries')
//   .where('countryName', isEqualTo: "theCountryNameUserClickedOn")
//   .get()
// streamSnapshot.data.docs[index]['text']