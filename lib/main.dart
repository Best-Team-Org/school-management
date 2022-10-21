import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:semi_final_lab/services/book_provider.dart';
import 'package:semi_final_lab/services/themes.dart';
import 'package:semi_final_lab/view_model/home_view_model.dart';
import 'package:semi_final_lab/views/home_view.dart';

import 'db/db_helper.dart';
import 'view_model/splash_view_model.dart';
import 'views/auth/login_view.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DBHelper.initDb();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SplashViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Themes(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Provider.of<HomeViewModel>(context, listen: false).setUser = null;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeViewModel, SplashViewModel>(
      builder: (BuildContext context, HomeViewModel homeProvider,
          SplashViewModel splashProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Semi Final',
          theme: ThemeData(),
          home: !splashProvider.isSplashEnd
              ? const SplashView()
              : homeProvider.user == null
                  ? const LoginView()
                  : const HomeView(),
        );
      },
    );
  }
}
