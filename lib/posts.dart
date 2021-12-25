import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Post extends StatefulWidget {
  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late var imagePath;
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  CollectionReference postStream =
      FirebaseFirestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
    Future<void> selectImage() async {
      final ImagePicker _picker = ImagePicker();
      //final image = await _picker.pickImage(source: ImageSource.gallery);
      final image = await _picker.pickImage(source: ImageSource.camera);
      // final vidgallery = await _picker.pickVideo(source: ImageSource.gallery);
      // final video = await _picker.pickVideo(source: ImageSource.camera);
      // final List<dynamic>? images = await _picker.pickMultiImage();
      setState(() {
        imagePath = image?.path;
      });
    }

    Future<void> submit() async {
      try {
        String title = titleController.text;
        String description = descriptionController.text;

        firebase_storage.FirebaseStorage storage =
            firebase_storage.FirebaseStorage.instance;

        String imageName = path.basename(imagePath);
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/${imageName}');

        File file = File(imagePath);
        await ref.putFile(file);
        String downloadURL = await ref.getDownloadURL();
        print("file is uploaded successfully");
        FirebaseFirestore db = FirebaseFirestore.instance;
        await db.collection("posts").add(
            {"title": title, "description": description, "url": downloadURL});
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid)),
              hintText: 'Enter Title'),
        ),
        TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid)),
              hintText: 'Enter description'),
        ),
        ElevatedButton(
            onPressed: () {
              selectImage();
            },
            child: Text("Select Image")),
        ElevatedButton(
            onPressed: () {
              submit();
            },
            child: Text("Submit")),
        Expanded(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: postStream.snapshots(),
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

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map data = document.data()! as Map;
                    return Posts(data);
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ],
    ));
  }
}

Widget Posts(Map data) {
  return SizedBox(
    height: 250,
    child: Center(
      child: Container(
        height: 170,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Image.network(
              data["url"],
              height: 100,
              width: 100,
            ),
            Text(data["title"]),
            Text(data["description"])
          ],
        ),
      ),
    ),
  );
}
