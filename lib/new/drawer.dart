import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var data;

  final List<String> items = [
    'Logout',
    'Cart',
    'Favourite',
    'About',
  ];

  List<IconData> icons = [
    Icons.logout,
    Icons.shopping_cart,
    Icons.favorite,
    Icons.more,
  ];

  Future<dynamic> getData() async {
    final DocumentReference document =
        firestore.collection('users').doc(auth.currentUser!.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // var data =
    //     firestore.collection('users').doc(auth.currentUser!.uid).get() as Map;
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              accountName: Text(
                "${data['username']}",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              accountEmail: Text(
                "user@gmail.com",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              currentAccountPicture: Center(
                child: CircleAvatar(
                  radius: 55.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage("${data['url']}"),
                ),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {},
                  leading: Icon(
                    icons[index],
                  ),
                  title: Text(items[index]),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

// Widget draw(context) {
 
//   return SingleChildScrollView(
//     child: Column(
//       children: [
//         UserAccountsDrawerHeader(
//           decoration: BoxDecoration(
//             color: Colors.white,
//           ),
//           accountName: Text(
//             "${auth.currentUser!.displayName!}",
//             style: TextStyle(
//               color: Colors.black,
//             ),
//           ),
//           accountEmail: Text(
//             "user@gmail.com",
//             style: TextStyle(
//               color: Colors.black,
//             ),
//           ),
//           currentAccountPicture: Center(
//             child: CircleAvatar(
//               radius: 55.0,
//               backgroundColor: Colors.transparent,
//               backgroundImage: AssetImage('assets/images/profile.png'),
//             ),
//           ),
//         ),
//         ListView.builder(
//           physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               onTap: () {},
//               leading: Icon(
//                 icons[index],
//               ),
//               title: Text(items[index]),
//             );
//           },
//         )
//       ],
//     ),
//   );
// }
