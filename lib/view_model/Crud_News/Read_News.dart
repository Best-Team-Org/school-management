import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReadDataNews extends StatefulWidget {
  const ReadDataNews({super.key});

  @override
  State<ReadDataNews> createState() => _ReadDataNewsState();
}

class _ReadDataNewsState extends State<ReadDataNews> {
  final CollectionReference News =
      FirebaseFirestore.instance.collection("News");
//--------------------------------------------------------------------------------------------------update start
  final TextEditingController TitelController = TextEditingController();
  final TextEditingController SubtitleController = TextEditingController();
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      TitelController.text = documentSnapshot['Titel'];
      SubtitleController.text = documentSnapshot['Subtitle'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: TitelController,
                  decoration: const InputDecoration(labelText: 'Titel'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: SubtitleController,
                  decoration: const InputDecoration(
                    labelText: 'Subtitle',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String Titel = TitelController.text;
                    final String Subtitle = SubtitleController.text;
                    if (Subtitle != null) {
                      await News.doc(documentSnapshot!.id)
                          .update({"Titel": Titel, "Subtitle": Subtitle});
                      TitelController.text = '';
                      SubtitleController.text = '';
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
        stream: News.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                final docId = streamSnapshot.data!.docs[index].id;
                return Card(
                  child: ListTile(
                    title: Text(documentSnapshot['Titel']),
                    subtitle: Text(documentSnapshot['Subtitle']),
                    trailing: IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('News')
                            .doc(docId)
                            .delete();
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
