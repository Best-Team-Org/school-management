import 'package:cloud_firestore/cloud_firestore.dart';

class UsersListViewModel{


  final Stream<QuerySnapshot<Map<String, dynamic>>> users = FirebaseFirestore.instance.collection('users').snapshots();


  Future<void> makeAdmin(String id)async{
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'role':1,
    });
  }

  Future<void> makeTeacher(String id)async{
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'role':2,
    });
  }

}