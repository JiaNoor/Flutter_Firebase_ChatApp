import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_proj/controllers/authentications.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
//import 'package:firebase_proj/new/home.dart';

class ChatRoom extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  ChatRoom({required this.chatRoomId, required this.userMap});

  final TextEditingController message = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  File? imageFile;
  Future getImage() async {
    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await firestore
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": auth.currentUser!.displayName,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });
    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  void onSendMessage() async {
    if (message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": auth.currentUser!.displayName,
        "message": message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      message.clear();
      await firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.pink[800],
          leadingWidth: 45,
          leading: StreamBuilder<DocumentSnapshot>(
              stream:
                  firestore.collection("users").doc(userMap['uid']).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Center(
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Color.fromARGB(0, 46, 39, 39),
                      backgroundImage: NetworkImage(
                        userMap['url'],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
          title: StreamBuilder<DocumentSnapshot>(
            stream:
                firestore.collection("users").doc(userMap['uid']).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(userMap['username'],
                          style: TextStyle(fontFamily: 'Neonderthaw')),
                      Text(
                        snapshot.data!['status'],
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          actions: [
            CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Text("J",
                    style: TextStyle(fontSize: 20, color: Colors.white)))
          ]),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_8.gif"),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height / 1.25,
                width: size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('chatroom')
                      .doc(chatRoomId)
                      .collection('chats')
                      .orderBy("time", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        reverse: true,
                        //controller: ScrollController(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          return messages(size, map, context);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Container(
                height: size.height / 10,
                width: size.width,
                alignment: Alignment.center,
                child: Container(
                  height: size.height / 12,
                  width: size.width / 1.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: size.height / 17,
                        width: size.width / 1.3,
                        child: TextField(
                          controller: message,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  getImage();
                                },
                                icon: Icon(Icons.photo),
                              ),
                              hintText: "Send Message",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.send), onPressed: onSendMessage),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == "text"
        ? Container(
            width: size.width,
            alignment: map['sendby'] == auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              margin: map['sendby'] == auth.currentUser!.displayName
                  ? EdgeInsets.only(left: 95)
                  : EdgeInsets.only(right: 95),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: map['sendby'] == auth.currentUser!.displayName
                      ? Colors.teal[700]
                      : Colors.blueGrey),
              child: IntrinsicWidth(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        map['message'],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      map["time"] != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${DateFormat('K:mm:ss').format((map["time"]).toDate())}",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ]),
              ),
            ),
          )
        : Container(
            height: size.height / 2.23,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: map['sendby'] == auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShowImage(
                      imageUrl: map['message'],
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    margin: map['sendby'] == auth.currentUser!.displayName
                        ? EdgeInsets.only(left: size.width * 0.5)
                        : EdgeInsets.only(right: size.width * 0.5),
                    height: size.height / 2.5,
                    width: size.width / 2,
                    decoration: BoxDecoration(border: Border.all()),
                    alignment: map['message'] != "" ? null : Alignment.center,
                    child: map['message'] != ""
                        ? Image.network(
                            map['message'],
                            fit: BoxFit.cover,
                          )
                        : CircularProgressIndicator(),
                  ),
                  map["time"] != null
                      ? Container(
                          alignment:
                              map['sendby'] == auth.currentUser!.displayName
                                  ? Alignment.bottomRight
                                  : Alignment.bottomLeft,
                          child: Text(
                            "${DateFormat('K:mm:ss').format((map["time"]).toDate())}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
