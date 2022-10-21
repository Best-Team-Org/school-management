import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReadDataNews extends StatefulWidget {
  const ReadDataNews({super.key});

  @override
  State<ReadDataNews> createState() => _ReadDataNewsState();
}

class _ReadDataNewsState extends State<ReadDataNews> {
  final CollectionReference news = FirebaseFirestore.instance.collection("News");

//--------------------------------------------------------------------------------------------------update start
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();

  String? importance;

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      titleController.text = documentSnapshot['title'];
      subtitleController.text = documentSnapshot['subtitle'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: subtitleController,
                  decoration: const InputDecoration(
                    labelText: 'Subtitle',
                  ),
                ),
                DropdownButtonFormField<String>(
                  items: const [
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
                    labelText: 'Importance',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String title = titleController.text;
                    final String subtitle = subtitleController.text;
                    if (subtitle != null) {
                      await news.doc(documentSnapshot!.id).update({
                        "title": title,
                        "subtitle": subtitle,
                        "color": importance,
                      });
                      titleController.text = '';
                      subtitleController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

//----------------------------------------------------------update end
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: news.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                final docId = streamSnapshot.data!.docs[index].id;
                return Card(
                  child: ListTile(
                    title: Text(documentSnapshot['title']),
                    subtitle: Text(documentSnapshot['subtitle']),
                    trailing: IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance.collection('News').doc(docId).delete();
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      _update(documentSnapshot);
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
