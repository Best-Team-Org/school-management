import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semi_final_lab/view_model/home_view_model.dart';
import 'package:semi_final_lab/views/auth/login_view.dart';
import 'package:semi_final_lab/views/users_list_view.dart';

import '../models/user_model.dart';
import 'news_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<HomeViewModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Semi Final App'),
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                );
              },
            ),
            ListTile(
              title: const Text('News'),
              leading: const Icon(Icons.newspaper),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => NewsView(
                            role: user!.role,
                          )),
                );
              },
            ),
            if(user != null && user.role == 1)
            ListTile(
              title: const Text('Users List'),
              leading: const Icon(Icons.people_alt),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) =>  UsersListView(currentUser: user!,)));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: user != null && user.role == 1
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
