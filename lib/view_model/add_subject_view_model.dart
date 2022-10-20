import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddSubjectViewModel with ChangeNotifier {
  int currentStep = 0;

  set setCurrentStep(int newValue) {
    currentStep = newValue;
    notifyListeners();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTeachers() async {
    return FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 2).get();
  }

  addSubject(BuildContext context, String name, String teacherId, String startTime, String endTime) async {
    try {
      final CollectionReference<Map<String, dynamic>> subjectRef = FirebaseFirestore.instance.collection('subjects');
      await subjectRef.add({
        'name': name,
        'teacherId': teacherId,
        'startTime': startTime,
        'endTime': endTime,
      }).then((value) async{
        final studentsRef = await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 0).get();
        for (var element in studentsRef.docs) {
          FirebaseFirestore.instance.collection('marks').doc(value.id).collection('students').doc(element.id).set({
            'result':0,
          });
        }
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subject added')));
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something wrong, try again!')));
    }
  }

  String? selectedTeacher;

  set setSelectedTeacher(String? newValue) {
    selectedTeacher = newValue;
    notifyListeners();
  }

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  set setStartTime(TimeOfDay? newValue) {
    startTime = newValue;
    notifyListeners();
  }

  set setEndTime(TimeOfDay? newValue) {
    endTime = newValue;
    notifyListeners();
  }
}
