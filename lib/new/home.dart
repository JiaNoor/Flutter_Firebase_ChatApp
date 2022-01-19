//import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_proj/new/chatroom.dart';
import 'package:firebase_proj/new/functions.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class HomeScreen extends StatefulWidget {
  //const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var temp = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set({"status": status}, SetOptions(merge: true));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  //@override
  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      setState(() {
        isLoading = true;
      });

      await firestore
          .collection("users")
          .where("username", isEqualTo: searchController.text)
          .get()
          .then((value) {
        setState(() {
          userMap = value.docs[0].data();
          if (temp.any((element) =>
                  DeepCollectionEquality().equals(element, userMap)) ==
              false) {
            temp.add(userMap);
            firestore
                .collection('users')
                .doc(auth.currentUser!.uid)
                .collection('contacts')
                .add(userMap!);
            print(temp);
          } else {
            print("already contain");
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(content: Text("Check below"));
                });
          }
          isLoading = false;
        });
      });
      print(userMap);
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(content: Text("$e"));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 6.0, bottom: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ChatApp',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Akronim',
                      color: Colors.white),
                ),
                IconButton(
                    onPressed: () => logOut(context),
                    icon: Icon(Icons.logout_outlined),
                    color: Colors.white)
              ],
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_5.gif"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(children: [
          TextField(
              controller: searchController,
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(Icons.add),
                    iconSize: 30.0,
                    color: Color.fromARGB(255, 78, 78, 87),
                    onPressed: () {},
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    iconSize: 30.0,
                    color: Color.fromARGB(255, 78, 78, 87),
                    onPressed: onSearch,
                  ),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(style: BorderStyle.solid, width: 3.0)),
                  hintText: 'Search by Username',
                  hintStyle: TextStyle(
                      color: Color.fromARGB(255, 78, 78, 87),
                      fontSize: 18,
                      fontWeight: FontWeight.w500))),
          temp != null
              ? Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('users')
                      .doc(auth.currentUser!.uid)
                      .collection('contacts')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          return ListTile(
                            onTap: () {
                              String roomId = chatRoomId(
                                  auth.currentUser!.displayName!,
                                  map['username']);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatRoom(
                                    chatRoomId: roomId,
                                    userMap: map,
                                  ),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                map['url'],
                              ),
                            ),
                            title: Text(
                              map['username'],
                              style: TextStyle(
                                  color: Color.fromARGB(255, 75, 51, 119),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            subtitle: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                ),
                                Text(map['email']),
                              ],
                            ),
                            trailing: Icon(
                              Icons.notification_add,
                              color: Colors.grey,
                            ),
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ))
              : Container(),
        ]),
      ),
    );
  }
}
