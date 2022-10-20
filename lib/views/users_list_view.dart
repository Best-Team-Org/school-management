import 'package:flutter/material.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({Key? key}) : super
      (key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
      ),
    );
  }
}
