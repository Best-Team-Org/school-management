import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:semi_final_lab/res/colors.dart';
import 'package:semi_final_lab/view_model/home_view_model.dart';
import 'package:semi_final_lab/views/home_view.dart';

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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SplashViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
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
      builder: (BuildContext context, HomeViewModel homeProvider, SplashViewModel splashProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Semi Final',
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData(
            fontFamily: 'ChenileDeluxeTwo',
            canvasColor: const Color(0xFF202020),
            cardColor: Colors.orange.shade200,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: CustomColors.primaryColor,
            ),
            textTheme:const TextTheme(
              headline1: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                letterSpacing: 2.0,
              ),
              headline2: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                letterSpacing: 2.0,
              ),
              headline3: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                letterSpacing: 2.0,
              ),
              headline4: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                letterSpacing: 2.0,
              ),
              headline5: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                letterSpacing: 2.0,
              ),
            ),
          ),
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
