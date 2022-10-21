import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semi_final_lab/view_model/auth/signup_view_model.dart';

import '../../models/user_model.dart';
import '../../res/colors.dart';
import '../../view_model/home_view_model.dart';
import '../home_view.dart';
import 'login_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final SignupViewModel _viewModel = SignupViewModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> userData = {};

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 96.0),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/ltuc.png',
                          width: 100.0,
                          height: 100.0,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                              text: 'Lt',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: CustomColors.primaryColor,
                              ),
                              children: [
                                TextSpan(
                                  text: 'uc Stu',
                                  style: TextStyle(color: Colors.white, fontSize: 30),
                                ),
                                TextSpan(
                                  text: 'dents',
                                  style: TextStyle(color: CustomColors.primaryColor, fontSize: 30),
                                ),
                              ]),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    Column(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Username',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.white,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            TextFormField(
                              style: Theme.of(context).textTheme.headline3,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.white12,
                                filled: true,
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username';
                                }
                                if (value.length < 3) {
                                  return 'Username can\'t be less than 3 letters';
                                }
                                return null;
                              },
                              onSaved: (String? value) {
                                userData['username'] = value!;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.white,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            TextFormField( style: Theme.of(context).textTheme.headline3,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.white12,
                                filled: true,
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email';
                                }
                                RegExp emailRegEx =
                                    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                if (!emailRegEx.hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              onSaved: (String? value) {
                                userData['email'] = value!;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.white,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            TextFormField(style: Theme.of(context).textTheme.headline3,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.white12,
                                filled: true,
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 char';
                                }
                                return null;
                              },
                              onSaved: (String? value) {
                                userData['password'] = value!;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Your role',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.white,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            DropdownButtonFormField<int>(style: Theme.of(context).textTheme.headline3,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.white12,
                                filled: true,
                              ),
                              items: const[
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text('Student'),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text('Teacher'),
                                ),
                              ],
                              onChanged: (int? value) {},
                              validator: (int? value) {
                                if (value == null) {
                                  return 'Please choose your role';
                                }
                                return null;
                              },
                              onSaved: (int? value) {
                                userData['role'] = value;
                              },

                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          UserModel? user = await _viewModel.signup(
                            userData['email']!,
                            userData['password']!,
                            userData['username']!,
                            context,
                            userData['role'],
                          );
                          if (user != null && mounted) {
                            Provider.of<HomeViewModel>(context, listen: false).setUser = user;
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const<BoxShadow>[
                            BoxShadow(
                              color: Colors.black38,
                              offset:  Offset(2, 4),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xfffbb448),
                              Color(0xfff7892b),
                            ],
                          ),
                        ),
                        child: const Text(
                          'Register Now',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Already have an account ?',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginView()));
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xfff79c4f),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40.0,
            left: 0,
            child: TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginView()));
              },
              icon: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              ),
              label: const Text(
                'Back',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
