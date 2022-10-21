import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semi_final_lab/models/user_model.dart';
import 'package:semi_final_lab/view_model/splash_view_model.dart';

import '../view_model/home_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Provider.of<HomeViewModel>(context, listen: false).setUser = null;
      }else{
        DocumentSnapshot<Map<String, dynamic>> userInfo = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        UserModel userModel = UserModel(
          id: user.uid,
          username: userInfo.get('username'),
          email: userInfo.get('email'),
          role: userInfo.get('role'),
        );

        if(mounted){
          Provider.of<HomeViewModel>(context, listen: false).setUser = userModel;
        }
      }
      if(mounted){
        Provider.of<SplashViewModel>(context,listen: false).setIsSplashEnd = true;
      }

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon/app_icon.png'),
            const SizedBox(height: 32.0,),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
