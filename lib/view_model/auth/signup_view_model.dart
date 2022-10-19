import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:semi_final_lab/models/user_model.dart';

class SignupViewModel {
  Future<UserModel?> signup(String email, String password, String username, BuildContext context) async {
    UserModel? userModel;
    showDialog(context: context, builder: (context){
      return const Center(child: CircularProgressIndicator(),);
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;
      userModel = UserModel(
        id: user.uid,
        email: email,
        username: username,
        role: 0,
      );
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(userModel.toJson());

      return userModel;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something wrong, try again!')));
    }finally{
      Navigator.pop(context);
    }
    return null;
  }
}
