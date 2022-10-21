import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:semi_final_lab/views/news/Read_News.dart';

class AddNews extends StatefulWidget {
  const AddNews({super.key});

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {

  String? importance;

  @override
  Widget build(BuildContext context) {
    TextEditingController newsTitleController = TextEditingController();
    TextEditingController newsSubtitleController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add News'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: DropdownButtonFormField<String>(
              items: const[
                DropdownMenuItem(
                  value: '0xFFFF0000',
                  child: Text('Urgent'),
                ),
                DropdownMenuItem(
                  value: '0xFF00FF00',
                  child: Text('Safe'),
                ),
                DropdownMenuItem(
                  value: '0xFFCCCCCC',
                  child: Text('Negligible'),
                ),
              ],
              onChanged: (String? value) {
                importance = value;
              },
              decoration: const InputDecoration(
                hintText: "Importance",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              CollectionReference studentRef = FirebaseFirestore.instance.collection("News");
              studentRef.add({
                'title': newsTitleController.text,
                'subtitle': newsSubtitleController.text,
                'color': importance,
              });
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added successfully")));
            },
            child: const Text("Add news"),
          ),
        ],
      ),
    );
  }
}
