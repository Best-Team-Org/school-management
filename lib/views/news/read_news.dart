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
                  style: Theme.of(context).textTheme.headline2,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: Theme.of(context).textTheme.headline2,
                  ),
                ),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: subtitleController,
                  style: Theme.of(context).textTheme.headline2,
                  decoration: InputDecoration(labelText: 'Subtitle', labelStyle: Theme.of(context).textTheme.headline2,),
                ),
                DropdownButtonFormField<String>(
                  style: Theme.of(context).textTheme.headline2,
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
                  decoration:  InputDecoration(
                    labelText: 'Importance',
                       labelStyle: Theme.of(context).textTheme.headline2,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update',style: TextStyle(fontSize: 32.0,),),
                  onPressed: () async {

                    final String title = titleController.text;
                    final String subtitle = subtitleController.text;
                    await news.doc(documentSnapshot!.id).update({
                      "title": title,
                      "subtitle": subtitle,
                      "color": importance,
                    });
                    titleController.text = '';
                    subtitleController.text = '';
                    if(mounted){
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
      appBar: AppBar(
          title: const Text(
        'Edit News',
        style: TextStyle(
          fontSize: 32.0,
          letterSpacing: 2.0,
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
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
                      title: Text(
                        documentSnapshot['title'],
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(
                        documentSnapshot['subtitle'],
                        style: Theme.of(context).textTheme.headline5,
                      ),
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
      ),
    );
  }
}
