import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubjectsView extends StatelessWidget {
  const SubjectsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects',style: TextStyle(
          fontSize: 32.0,
          letterSpacing: 2.0,
        ),),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('subjects').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            List subjects = snapshot.data!.docs;
            return ListView.separated(
              itemCount: subjects.length,
              itemBuilder: (BuildContext context,int index){
                return ListTile(
                  title: Text(subjects[index]['name'],style: Theme.of(context).textTheme.headline2,),
                  subtitle: Text('${subjects[index]['startTime']} - ${subjects[index]['endTime']}',style: Theme.of(context).textTheme.headline3,),
                );
              },
              separatorBuilder: (BuildContext context,int index){
                return const Divider(color: Colors.white,);
              },

            );
          }
          return const Center(
            child: Text('Check your connection'),
          );
        },
      ),
    );
  }
}
