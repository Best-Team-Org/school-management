import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:semi_final_lab/view_model/home_view_model.dart';
import 'package:semi_final_lab/view_model/auth/login_view_model.dart';
import 'package:semi_final_lab/views/home_view.dart';

import '../../models/user_model.dart';
import '../../res/colors.dart';
import 'signup_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late LoginViewModel _viewModel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> userData = {};

  @override
  void initState() {
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _viewModel = LoginViewModel();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Center(
                child: RichText(
                  softWrap: false,
                  text: const TextSpan(
                    text: 'Lt',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.primaryColor,
                    ),
                    children: [
                      TextSpan(
                        text: 'uc Stu',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32.0,
                        ),
                      ),
                      TextSpan(
                        text: 'dents',
                        style: TextStyle(
                          color: CustomColors.primaryColor,
                          fontSize: 32.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 32.0,
                    color: CustomColors.primaryColor,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Image.asset(
                'assets/images/ltuc.png',
                width: 100.0,
                height: 100.0,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  RegExp emailRegEx = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  if (!emailRegEx.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  userData['email'] = value!;
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
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
              TextButton(
                onPressed: () {
                  /// TODO: forgot password screen
                  showDialog(
                      context: context,
                      builder: (context) {
                        String? email;
                        final GlobalKey<FormState> formKey = GlobalKey<FormState>();
                        return AlertDialog(
                          title: const Text('Forget Password'),
                          content: Form(
                            key: formKey,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Enter your email',
                                border: OutlineInputBorder(),
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
                                email = value!;
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Check your email')),
                                    );
                                  }
                                },
                                child: const Text('Send'),),
                          ],
                        );
                      });
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(
                    color: CustomColors.primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.primaryColor,
                  fixedSize: const Size(double.infinity, 50.0),
                ),
                child: const Text('Login'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    UserModel? user = await _viewModel.login(userData['email']!, userData['password']!, context);
                    if (user != null && mounted) {
                      Provider.of<HomeViewModel>(context, listen: false).setUser = user;
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
                    }
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Does not have account?'),
                  TextButton(
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignupView()));
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 32.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Expanded(
                    child: Divider(
                      thickness: 4.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Or Login With'),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 4.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 32.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: ()async{
                      UserModel? user = await _viewModel.loginWithGoogle(context);
                      if (user != null && mounted) {
                        Provider.of<HomeViewModel>(context, listen: false).setUser = user;
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
                      }

                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/images/g_logo.png'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
