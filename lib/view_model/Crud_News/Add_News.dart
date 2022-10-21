import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:semi_final_lab/view_model/Crud_News/Read_News.dart';

class add_news extends StatefulWidget {
  const add_news({super.key});

  @override
  State<add_news> createState() => _add_newsState();
}

class _add_newsState extends State<add_news> {
  @override
  Widget build(BuildContext context) {
    TextEditingController newsTitleController = TextEditingController();
    TextEditingController newsSubtitleController = TextEditingController();
    // TextEditingController emageController = TextEditingController();
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            const Center(
              child: Text("What's new ?"),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: newsTitleController,
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: newsSubtitleController,
                decoration: const InputDecoration(
                  hintText: "subtitle",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            // TextField(controller: emageController,),
            ElevatedButton(
              onPressed: () {
                CollectionReference studentRef =
                    FirebaseFirestore.instance.collection("News");

                studentRef.add({
                  'Titel': newsTitleController.text,
                  'Subtitle': newsSubtitleController.text,
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("add successfully")));
              },
              child: const Text("Add news"),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ReadDataNews();
                    },
                  ));
                },
                child: Text("View the updates")),
          ],
        ),
      ),
    );
  }
}
