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
        title: const Text('Add News',style:  TextStyle(
          fontSize: 32.0,
          letterSpacing: 2.0,
        ),),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
           Center(
            child: Text("What's new ?",style: Theme.of(context).textTheme.headline1,),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: newsTitleController,
              style: Theme.of(context).textTheme.headline2,
              decoration:  InputDecoration(
                hintText: "Title",
                hintStyle: Theme.of(context).textTheme.headline3,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide:const BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: newsSubtitleController,
              style: Theme.of(context).textTheme.headline2,
              decoration:  InputDecoration(
                hintText: "Subtitle",
                hintStyle: Theme.of(context).textTheme.headline3,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide:const BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: DropdownButtonFormField<String>(
              style: Theme.of(context).textTheme.headline2,
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
              decoration:  InputDecoration(
                hintText: "Importance",
                hintStyle: Theme.of(context).textTheme.headline3,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide:const BorderSide(color: Colors.white),
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
            child: const Text("Add news",style: TextStyle(fontSize: 32.0,),),
          ),
        ],
      ),
    );
  }
}
