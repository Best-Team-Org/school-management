import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:semi_final_lab/view_model/users_list_view_model.dart';

import '../models/user_model.dart';

class UsersListView extends StatelessWidget {
  UsersListView({Key? key, required this.currentUser}) : super(key: key);

  final UserModel currentUser;

  final UsersListViewModel _viewModel = UsersListViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List',style: TextStyle(
          fontSize: 32.0,
          letterSpacing: 2.0,
        ),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _viewModel.users,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List users = snapshot.data!.docs;
            return ListView.separated(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final user = users[index];
                if(user.id == currentUser.id){
                  return Container();
                }
                return ListTile(
                  title: Text('${user['username']}',style: Theme.of(context).textTheme.headline2,),
                  subtitle: Text('${user['email']}',style: Theme.of(context).textTheme.headline3,),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(user['role'] == 0
                          ? Icons.person
                          : user['role'] == 1
                              ? Icons.admin_panel_settings_outlined
                              : Icons.account_box_outlined,color: Colors.white,),
                    ],
                  ),
                  trailing: currentUser.role != 1
                      ? null
                      : IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Edit user'),
                                    content: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _viewModel.makeAdmin(user.id);
                                          },
                                          child: const Text('Make Admin'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            _viewModel.makeTeacher(user.id);
                                          },
                                          child: const Text('Make Teacher'),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(Icons.edit,color: Colors.white,),
                        ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                final user = users[index];
                if(user.id == currentUser.id){
                  return Container();
                }
                return const Divider(color: Colors.white,);
              },
            );
          }
          return const Center(
            child: Text('Check your connection'),
          );
        },
      ),
    );
  }
}
