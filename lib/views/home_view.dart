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
import 'package:semi_final_lab/views/subjects_view.dart';
import 'package:semi_final_lab/views/users_list_view.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user_model.dart';
import 'add_subject_view.dart';
import 'news/Read_News.dart';
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
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 32.0,
            letterSpacing: 2.0,
          ),
        ),
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
                          image: AssetImage('assets/images/news_bg4.jpg'),
                        ),
                        border: GradientBoxBorder(
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
                            FittedBox(
                              child: Text(
                                newsList[itemIndex]['title'],
                                style: GoogleFonts.amiri(
                                  textStyle: const TextStyle(
                                    fontSize: 46.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                maxLines: 1,
                              ),
                            ),
                            Text(
                              newsList[itemIndex]['subtitle'],
                              style: GoogleFonts.amiri(
                                textStyle: const TextStyle(
                                  fontSize: 32.0,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
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
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Stack(
                children: [
                  Text(
                    'School App',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            Uri url = Uri.parse(
                                'https://www.google.com/maps/place/%D9%83%D9%84%D9%8A%D8%A9+%D9%84%D9%88%D9%85%D9%8A%D9%86%D9%88%D8%B3+%D8%A7%D9%84%D8%AC%D8%A7%D9%85%D8%B9%D9%8A%D8%A9+%D8%A7%D9%84%D8%AA%D9%82%D9%86%D9%8A%D8%A9+-+(Luminus+Technical+University+College+(LTUC%E2%80%AD/@31.897932,35.8731971,17z/data=!4m6!3m5!1s0x151ca7e4aee722d5:0x8693a9183825010b!8m2!3d31.897932!4d35.8688197!15sCiRMdW1pbnVzIHRlY2huaWNhbCBVbml2ZXJzaXR5IGNvbGxlZ2WSARR0ZWNobmljYWxfdW5pdmVyc2l0eeABAA?shorturl=1');
                            if (!await launchUrl(url)) {
                              throw 'Could not launch $url';
                            }
                          },
                          icon: const Icon(
                            Icons.location_on_outlined,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        IconButton(
                          onPressed: () async {
                            Uri url = Uri.parse('http://www.ltuc.com/');
                            if (!await launchUrl(url)) {
                              throw 'Could not launch $url';
                            }
                          },
                          icon: const Icon(
                            Icons.web_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (user != null && user.role == 1)
              ListTile(
                title: Text(
                  'Users List',
                  style: Theme.of(context).textTheme.headline2!,
                ),
                leading: const Icon(
                  Icons.people_alt,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => UsersListView(
                                currentUser: user,
                              )));
                },
              ),
            ListTile(
              title: Text(
                'Library',
                style: Theme.of(context).textTheme.headline2!,
              ),
              leading: const Icon(
                Icons.library_books,
                color: Colors.white,
              ),
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
                title: Text(
                  'Add Subject',
                  style: Theme.of(context).textTheme.headline2!,
                ),
                leading: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
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
            ListTile(
              title: Text(
                'Subjects',
                style: Theme.of(context).textTheme.headline2!,
              ),
              leading: const Icon(
                Icons.list_alt,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChangeNotifierProvider<LibraryViewModel>(
                              create: (_) => LibraryViewModel(),
                              child: const SubjectsView(),
                            )));
              },
            ),
            if (user != null && user.role == 1)
              ListTile(
                title: Text(
                  'Add news',
                  style: Theme.of(context).textTheme.headline2!,
                ),
                leading: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AddNews()));
                },
              ),
            if (user != null && user.role == 1)
              ListTile(
                title: Text(
                  'Edit news',
                  style: Theme.of(context).textTheme.headline2!,
                ),
                leading: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ReadDataNews()));
                },
              ),
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 24.0, color: Colors.red),
              ),
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
