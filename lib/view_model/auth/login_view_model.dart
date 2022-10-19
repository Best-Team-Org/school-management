import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:semi_final_lab/models/user_model.dart';

class LoginViewModel {

  Future<UserModel?> login(String email, String password,BuildContext context) async {
    UserModel? userModel;
    showDialog(context: context, builder: (context){
      return const Center(child: CircularProgressIndicator(),);
    });
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      userModel = UserModel(
        id: userData.id,
        email: userData.get('email'),
        username: userData.get('username'),
        role: userData.get('role'),
      );
      return userModel;
    }on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something wrong, try again!')));
    }
    finally{
      Navigator.pop(context);
    }
    return null;
  }

  Future loginWithGoogle(BuildContext context)async{
    UserModel? userModel;
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User user = userCredential.user!;
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if(!userData.exists){
        String? username = googleUser?.displayName;
        userModel = UserModel(
          id: user.uid,
          email: user.email,
          username: username,
          role: 0,
        );
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(userModel.toJson());
      }
      userModel = UserModel(
        id: userData.id,
        email: userData.get('email'),
        username: userData.get('username'),
        role: userData.get('role'),
      );
      return userModel;
    }on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something wrong, try again!')));
    }
    return null;

  }


}
