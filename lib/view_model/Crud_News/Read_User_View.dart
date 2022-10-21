import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReadUserView extends StatelessWidget {
  const ReadUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference News =
        FirebaseFirestore.instance.collection("News");
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
                      ),
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
