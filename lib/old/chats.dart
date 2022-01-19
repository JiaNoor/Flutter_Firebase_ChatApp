// import 'package:firebase_proj/chatroom.dart';
// import 'package:firebase_proj/controllers/authentications.dart';
// import 'package:firebase_proj/helper.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:path/path.dart' as path;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   CollectionReference userStream =
//       FirebaseFirestore.instance.collection('users');
//   final TextEditingController usernameController = TextEditingController();
//   var temp = [];
//   var len = 0;
//   bool isLoading = false;
//   Map<String, dynamic>? userMap;

  // void onSearch() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;

  //     await firestore
  //         .collection("users")
  //         .where("username", isEqualTo: usernameController.text)
  //         .get()
  //         .then((value) {
  //       setState(() {
  //         userMap = value.docs[0].data();
  //         temp.add(userMap);
  //         isLoading = false;
  //       });
  //     });
  //     print(userMap);
  //   } catch (e) {
  //     showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(content: Text("$e"));
  //         });
  //   }
  // }

//   void createChatRoom(
//       String chatRoomId, chatRoomMap, String user1, String user2) {
//     //getChatRoomId(user1, user2);
//     List<String> users = [user1, user2];
//     Map<String, dynamic> chatRoomMap = {
//       "user": users,
//       "chatRoomId": chatRoomId
//     };
//     FirebaseFirestore.instance
//         .collection("ChatRoom")
//         .doc(chatRoomId)
//         .set(chatRoomMap)
//         .catchError((e) {
//       print("$e");
//     });
//   }

//   String chatRoomId(String user1, String user2) {
//     if (user1[0].toLowerCase().codeUnits[0] >
//         user2.toLowerCase().codeUnits[0]) {
//       return "$user1$user2";
//     } else {
//       return "$user2$user1";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      // appBar: PreferredSize(
      //   child: Container(
      //     padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      //     child: Padding(
      //       padding: const EdgeInsets.only(left: 30.0, top: 20.0, bottom: 20.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Text(
      //             'ChatApp',
      //             style: TextStyle(
      //                 fontSize: 20.0,
      //                 fontWeight: FontWeight.w500,
      //                 color: Colors.white),
      //           ),
      //           IconButton(
      //               onPressed: () {
      //                 Navigator.of(context).pushNamed("/login");
      //               },
      //               icon: Icon(Icons.logout_outlined),
      //               color: Colors.white)
      //         ],
      //       ),
      //     ),
      //     decoration: BoxDecoration(
      //         gradient: LinearGradient(colors: [
      //           Color(0xff1d1e26),
      //           Color.fromARGB(255, 74, 66, 119)
      //         ]),
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.grey,
      //             blurRadius: 20.0,
      //             spreadRadius: 1.0,
      //           )
      //         ]),
      //   ),
      //   preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
      // ),
      // body: Column(children: [
      //   TextField(
      //       controller: usernameController,
      //       decoration: InputDecoration(
      //           suffixIcon: IconButton(
      //             icon: Icon(Icons.search),
      //             onPressed: onSearch,
      //           ),
      //           border: OutlineInputBorder(
      //               borderSide: BorderSide(style: BorderStyle.solid)),
      //           hintText: 'Search by Username')),
      //   userMap != null
      //       ? Expanded(
      //           child: ListView.builder(
      //               itemCount: temp.length,
      //               itemBuilder: (context, index) {
      //                 return ListTile(
      //                   onTap: () {
      //                     String roomId = chatRoomId(
      //                         auth.currentUser!.displayName!,
      //                         userMap!['username']);

      //                     Navigator.of(context).push(
      //                       MaterialPageRoute(
      //                         builder: (_) => ChatRoom(
      //                           chatRoomId: roomId,
      //                           userMap: userMap!,
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                   leading: CircleAvatar(
      //                     radius: 20.0,
      //                     backgroundColor: Colors.transparent,
      //                     backgroundImage: NetworkImage(
      //                       temp[index]['url'],
      //                     ),
      //                   ),
      //                   title: Text(temp[index]['username']),
      //                   subtitle: Row(
      //                     children: [
      //                       Icon(
      //                         Icons.check,
      //                       ),
      //                       Text('msg'),
      //                     ],
      //                   ),
      //                   trailing: Text(
      //                     "12:00",
      //                     style: TextStyle(
      //                       color: Colors.grey[600],
      //                       fontSize: 10,
      //                     ),
      //                   ),
      //                 );
      //               }))
      //       : Container(),
      // ]),
//     );
//   }
// }

// // Widget chats(var userMap) {
// //   return Expanded(
// //     child: ListTile(
// //       leading: CircleAvatar(
// //         radius: 20.0,
// //         backgroundColor: Colors.transparent,
// //         backgroundImage: NetworkImage(
// //           userMap['url'],
// //         ),
// //       ),
// //       title: Text(userMap['username']),
// //       subtitle: Row(
// //         children: [
// //           Icon(
// //             Icons.check,
// //           ),
// //           Text('msg'),
// //         ],
// //       ),
// //       trailing: Text(
// //         "12:00",
// //         style: TextStyle(
// //           color: Colors.grey[600],
// //           fontSize: 10,
// //         ),
// //       ),
// //     ),
// //   );
// // }
// // ListView(
// //                   children:
// //                       snapshot.data!.docs.map((DocumentSnapshot document) {
// //                     Map data = document.data()! as Map;
// //                     String id = document.id;
// //                     data["id"] = id;
// //                     return chats(data);
// //                   }).toList(),
// //                 );
// // FirebaseFirestore.instance
// //   .collection('countries')
// //   .where('countryName', isEqualTo: "theCountryNameUserClickedOn")
// //   .get()
// // streamSnapshot.data.docs[index]['text']