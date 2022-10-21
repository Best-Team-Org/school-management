import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:semi_final_lab/view_model/add_subject_view_model.dart';
import 'package:semi_final_lab/view_model/home_view_model.dart';
import 'package:semi_final_lab/view_model/library_view_model.dart';
import 'package:semi_final_lab/views/auth/login_view.dart';
import 'package:semi_final_lab/views/users_list_view.dart';
import 'package:gradient_borders/gradient_borders.dart';
import '../models/user_model.dart';
import 'add_subject_view.dart';
import 'news/Read_News.dart';
import 'news_view.dart';
import 'library_view.dart';

import 'news/add_news.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final CollectionReference news = FirebaseFirestore.instance.collection("News");

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<HomeViewModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
            stream: news.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                List newsList = snapshot.data!.docs;
                return CarouselSlider.builder(
                  itemCount: newsList.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/news_bg2.jpg'),
                        ),
                        border:  GradientBoxBorder(
                          gradient: LinearGradient(
                            colors: [
                              Color(int.parse(newsList[itemIndex]['color'])),
                              Color(int.parse(newsList[itemIndex]['color'])).withOpacity(0.1),
                            ],
                          ),
                          width: 4.0,
                        ),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              newsList[itemIndex]['title'],
                              style: GoogleFonts.amiri(
                                textStyle:const TextStyle(
                                  fontSize: 46.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(newsList[itemIndex]['subtitle'],
                              style: GoogleFonts.amiri(
                                textStyle:const TextStyle(
                                  fontSize: 32.0,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),),
                          ],
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 300,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                );
              }
              return const Center(
                child: Text('Check your connection'),
              );
            },
          ),
        ],
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
              title: const Text('Library'),
              leading: const Icon(Icons.library_books),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider<LibraryViewModel>(
                              create: (_) => LibraryViewModel(),
                              child: const LibraryView(),
                            )));
              },
            ),
            if (user != null && user.role == 1)
              ListTile(
                title: const Text('Users List'),
                leading: const Icon(Icons.people_alt),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => UsersListView(
                                currentUser: user,
                              )));
                },
              ),
            if (user != null && user.role == 1)
              ListTile(
                title: const Text('Add Subject'),
                leading: const Icon(Icons.add),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider(
                                create: (_) => AddSubjectViewModel(),
                                child: const AddSubjectView(),
                              )));
                },
              ),
            if (user != null && user.role == 1)
              ListTile(
                title: const Text('Add news'),
                leading: const Icon(Icons.newspaper),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AddNews()));
                },
              ),
            if (user != null && user.role == 1)
              ListTile(
                title: const Text('Edit news'),
                leading: const Icon(Icons.edit),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ReadDataNews()));
                },
              ),
          ],
        ),
      ),
    );
  }
}
